--!strict

-- Executable Signal Run v0 claim/replay proof.
-- Run with a Luau runner; the returned receipt is intentionally tiny and machine-checkable.

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
}

local function assertEqual(actual: any, expected: any, label: string)
	if actual ~= expected then
		error(string.format("FAIL %s expected=%s actual=%s", label, tostring(expected), tostring(actual)))
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
	}
	local receipt = {}

	local function emit(eventName: string)
		table.insert(receipt, eventName)
		return eventName
	end

	local function resetForFreshRound()
		state.roundId += 1
		state.started = true
		state.completed = false
		state.granted = false
		state.claimed = false
		state.reward = nil
	end

	return {
		receipt = receipt,
		currentRoundId = function()
			return state.roundId
		end,
		hasPendingReward = function()
			return state.reward ~= nil
		end,
		startRound = function()
			resetForFreshRound()
			return emit("round_started")
		end,
		finishRound = function()
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
	assertEqual(table.concat(h.receipt, " -> "), "round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started", "valid loop receipt")
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

local receipt = {
	runValidLoop(),
	runDuplicateFinishGuard(),
	runDuplicateClaimGuard(),
	runClaimBeforeCompletionGuard(),
}

return receipt
