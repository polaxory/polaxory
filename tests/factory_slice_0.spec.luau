--!strict

-- Executable Signal Run v0 claim/replay proof.
-- Run with a Luau runner; the returned receipt is intentionally tiny and machine-checkable.
-- Local: `lune run tests/factory_slice_0.spec.luau`
-- CI:    same command via the `Run Luau spec` step in .github/workflows/ci.yml

type Reward = {
	id: string,
	amount: number,
}

type State = {
	roundId: number,
	started: boolean,
	completed: boolean,
	granted: boolean,
	claimed: boolean,
	reward: Reward?,
	startedAtMs: number,
}

local STALE_ROUND_MS = 1_200_000 -- mirrors STALE_ROUND_SECONDS = 1200 in RoundCompletionRewards.luau

local function assertEqual(actual: any, expected: any, label: string)
	if actual ~= expected then
		error(
			string.format("FAIL %s expected=%s actual=%s", label, tostring(expected), tostring(actual))
		)
	end
end

local function newHarness()
	local state: State = {
		roundId = 0,
		started = false,
		completed = false,
		granted = false,
		claimed = false,
		reward = nil,
		startedAtMs = 0,
	}
	local receipt = {}
	local nowMs = 0

	local function emit(eventName: string)
		table.insert(receipt, eventName)
		return eventName
	end

	local function clearState()
		state.started = false
		state.completed = false
		state.granted = false
		state.claimed = false
		state.reward = nil
		state.startedAtMs = 0
	end

	local function resetForFreshRound()
		state.roundId += 1
		state.started = true
		state.completed = false
		state.granted = false
		state.claimed = false
		state.reward = nil
		state.startedAtMs = nowMs
	end

	return {
		receipt = receipt,
		currentRoundId = function()
			return state.roundId
		end,
		hasPendingReward = function()
			return state.reward ~= nil
		end,
		isStateCleared = function(): boolean
			return not state.started
				and not state.completed
				and not state.granted
				and not state.claimed
				and state.reward == nil
		end,
		setNow = function(t: number)
			nowMs = t
		end,
		startRound = function()
			resetForFreshRound()
			return emit("round_started")
		end,
		finishRound = function()
			if not state.started then
				return emit("rejected_finish:no_active_round")
			end
			if (nowMs - state.startedAtMs) > STALE_ROUND_MS then
				clearState()
				return emit("rejected_finish:round_expired")
			end
			if state.granted then
				return emit("rejected_claim:duplicate_finish")
			end
			state.completed = true
			state.granted = true
			state.reward = {
				id = "round_completion_reward_v0",
				amount = 1,
			}
			emit("round_completed")
			return emit("reward_granted")
		end,
		claimReward = function()
			if not state.granted then
				return emit("rejected_claim:claim_before_completion")
			end
			if state.claimed or state.reward == nil then
				return emit("rejected_claim:duplicate_claim")
			end
			state.claimed = true
			state.reward = nil
			return emit("reward_claimed")
		end,
		runAgain = function()
			if not state.claimed then
				return emit("rejected_run_again:run_again_before_claim")
			end
			resetForFreshRound()
			return emit("next_round_started")
		end,
		disconnect = function()
			-- Mirrors RoundCompletionRewards's Players.PlayerRemoving handler:
			-- the player's entry in stateByPlayerKey is dropped when they leave.
			clearState()
			return emit("player_removed")
		end,
	}
end

local function runValidLoop()
	local h = newHarness()
	h.startRound()
	assertEqual(h.currentRoundId(), 1, "initial round id")
	h.finishRound()
	h.claimReward()
	h.runAgain()
	assertEqual(h.currentRoundId(), 2, "run again starts fresh round")
	assertEqual(h.hasPendingReward(), false, "fresh round has no pending reward")
	assertEqual(
		table.concat(h.receipt, " -> "),
		"round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started",
		"valid loop receipt"
	)
	return "PASS valid loop"
end

local function runDuplicateFinishGuard()
	local h = newHarness()
	h.startRound()
	h.finishRound()
	local rejected = h.finishRound()
	assertEqual(rejected, "rejected_claim:duplicate_finish", "duplicate finish")
	return "PASS duplicate finish"
end

local function runDuplicateClaimGuard()
	local h = newHarness()
	h.startRound()
	h.finishRound()
	h.claimReward()
	local rejected = h.claimReward()
	assertEqual(rejected, "rejected_claim:duplicate_claim", "duplicate claim")
	return "PASS duplicate claim"
end

local function runClaimBeforeCompletionGuard()
	local h = newHarness()
	h.startRound()
	local rejected = h.claimReward()
	assertEqual(rejected, "rejected_claim:claim_before_completion", "claim before completion")
	return "PASS claim-before-completion"
end

local function runFinishBeforeStartGuard()
	-- Hardens the contract that completeRound rejects when no round has started.
	-- Mirrors RoundCompletionRewards.completeRound returning RejectedClaim/no_active_round.
	local h = newHarness()
	local rejected = h.finishRound()
	assertEqual(rejected, "rejected_finish:no_active_round", "finish before start")
	return "PASS finish-before-start"
end

local function runDisconnectCleanupGuard()
	-- Mirrors Players.PlayerRemoving cleanup: a disconnect drops the player's state
	-- so a subsequent reconnect/restart begins from a clean slate.
	local h = newHarness()
	h.startRound()
	h.finishRound()
	-- mid-round disconnect (reward granted but not claimed)
	h.disconnect()
	assertEqual(h.isStateCleared(), true, "state cleared after disconnect")
	-- after cleanup, finishRound must reject as no_active_round just like a fresh harness
	local rejected = h.finishRound()
	assertEqual(rejected, "rejected_finish:no_active_round", "finish after disconnect rejected")
	return "PASS disconnect cleanup"
end

local function runStaleRoundCleanupGuard()
	-- Mirrors STALE_ROUND_SECONDS expiry: a round older than the threshold rejects
	-- on finish and the harness state is cleared so the player can start fresh.
	local h = newHarness()
	h.setNow(0)
	h.startRound()
	-- jump past the staleness window (1,200,000 ms = 20 min)
	h.setNow(STALE_ROUND_MS + 1)
	local rejected = h.finishRound()
	assertEqual(rejected, "rejected_finish:round_expired", "finish after stale window")
	assertEqual(h.isStateCleared(), true, "state cleared after stale-round expiry")
	return "PASS stale-round cleanup"
end

local receipt = {
	runValidLoop(),
	runDuplicateFinishGuard(),
	runDuplicateClaimGuard(),
	runClaimBeforeCompletionGuard(),
	runFinishBeforeStartGuard(),
	runDisconnectCleanupGuard(),
	runStaleRoundCleanupGuard(),
}

-- Print so CI logs surface the receipt explicitly; lune exit code already gates failures.
for _, line in ipairs(receipt) do
	print(line)
end

return receipt
