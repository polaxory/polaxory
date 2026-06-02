--!strict

-- Polaxory Signal Run v0 — Backrooms Slice 0 course binder.
--
-- This script does NOT build the world. It finds two trigger parts you placed
-- in Studio and wires them to the server's round/reward state machine. The
-- world (corridor geometry, walls, ceiling, lights, atmosphere) is your
-- responsibility in the .rbxl. The receipt loop is ours.
--
-- Expected Studio layout, under `Workspace`:
--
--   PolaxoryBackroomsSlice0 (Folder)
--     EnterTrigger (BasePart)  -- thin floor plate near spawn
--     ExitTrigger  (BasePart)  -- thin floor plate at the far end
--     TimingGate   (BasePart, optional) -- between Enter and Exit; color cycles
--                                          green (open, 3s) and red (closed, 2s).
--                                          Player must touch while green to pass.
--
-- Wired events when found:
--
--   EnterTrigger.Touched  -> RoundCompletionRewards.startRound(player)
--                         -> round_started telemetry
--   ExitTrigger.Touched   -> RoundCompletionRewards.completeRound(player)
--                         -> rejects with gate_not_passed if the player skipped
--                            the gate while it was open
--                         -> round_completed + reward_granted on success
--   TimingGate.Touched    -> if gate is open, RoundCompletionRewards.markGatePassed(player)
--                         -> if gate is closed, RoundCompletionRewards.failRound(player,
--                            "gate_closed") which clears state and fires round_failed
--
-- The reward panel (client) handles claim and run-again from there.
--
-- If the folder or either of the two required triggers is missing, this script
-- warns clearly and exits early. TimingGate is optional but recommended; without
-- it, completeRound will always reject with gate_not_passed.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local RoundCompletionRewards = require(script.Parent:WaitForChild("RoundCompletionRewards"))

local COURSE_FOLDER_NAME = "PolaxoryBackroomsSlice0"
local ENTER_TRIGGER_NAME = "EnterTrigger"
local EXIT_TRIGGER_NAME = "ExitTrigger"
local TIMING_GATE_NAME = "TimingGate"
local START_DEBOUNCE_SECONDS = 2
local FINISH_DEBOUNCE_SECONDS = 2
local GATE_DEBOUNCE_SECONDS = 1
-- Timing Gate v0: 3 seconds open, 2 seconds closed, on a loop. Player learns the rhythm.
local GATE_OPEN_SECONDS = 3
local GATE_CLOSED_SECONDS = 2
local GATE_OPEN_COLOR = Color3.fromRGB(60, 220, 120)
local GATE_CLOSED_COLOR = Color3.fromRGB(220, 80, 60)

local lastStartByPlayer: { [Player]: number } = {}
local lastFinishByPlayer: { [Player]: number } = {}
local lastGateByPlayer: { [Player]: number } = {}
local gateIsOpen = false

local function findPlayerFromTouch(otherPart: BasePart): Player?
	local character = otherPart.Parent
	if character == nil then
		return nil
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid == nil then
		return nil
	end
	return Players:GetPlayerFromCharacter(character)
end

local function shouldFire(now: number, last: number?, debounce: number): boolean
	if last == nil then
		return true
	end
	return (now - last) >= debounce
end

local function attachTouched(
	trigger: BasePart,
	debounceSeconds: number,
	lastTable: { [Player]: number },
	onPlayer: (Player) -> ()
)
	trigger.Touched:Connect(function(otherPart: BasePart)
		local player = findPlayerFromTouch(otherPart)
		if player == nil then
			return
		end
		local now = os.clock()
		if not shouldFire(now, lastTable[player], debounceSeconds) then
			return
		end
		lastTable[player] = now
		onPlayer(player)
	end)
end

local function bindCourse(): boolean
	local folder = Workspace:FindFirstChild(COURSE_FOLDER_NAME)
	if folder == nil then
		warn(
			string.format(
				"[Polaxory] Workspace.%s not found. Build it in Studio with two trigger parts "
					.. "named %s and %s (BaseParts, any geometry). The receipt loop will activate "
					.. "the moment both exist.",
				COURSE_FOLDER_NAME,
				ENTER_TRIGGER_NAME,
				EXIT_TRIGGER_NAME
			)
		)
		return false
	end

	local enterTrigger = folder:FindFirstChild(ENTER_TRIGGER_NAME)
	local exitTrigger = folder:FindFirstChild(EXIT_TRIGGER_NAME)

	if enterTrigger == nil or not enterTrigger:IsA("BasePart") then
		warn(
			string.format(
				"[Polaxory] %s.%s missing or not a BasePart. round_started will not fire "
					.. "until this trigger exists.",
				COURSE_FOLDER_NAME,
				ENTER_TRIGGER_NAME
			)
		)
		return false
	end

	if exitTrigger == nil or not exitTrigger:IsA("BasePart") then
		warn(
			string.format(
				"[Polaxory] %s.%s missing or not a BasePart. round_completed will not fire "
					.. "until this trigger exists.",
				COURSE_FOLDER_NAME,
				EXIT_TRIGGER_NAME
			)
		)
		return false
	end

	attachTouched(enterTrigger, START_DEBOUNCE_SECONDS, lastStartByPlayer, function(player)
		RoundCompletionRewards.startRound(player)
	end)

	attachTouched(exitTrigger, FINISH_DEBOUNCE_SECONDS, lastFinishByPlayer, function(player)
		RoundCompletionRewards.completeRound(player)
	end)

	-- Timing Gate v0 is optional. If absent, the receipt loop won't fire until the
	-- operator adds it (server-side completeRound rejects with gate_not_passed).
	local timingGate = folder:FindFirstChild(TIMING_GATE_NAME)
	if timingGate ~= nil and timingGate:IsA("BasePart") then
		-- Color cycles: green = open (touch passes the gate), red = closed (touch fails the round).
		timingGate.Color = GATE_CLOSED_COLOR
		gateIsOpen = false
		task.spawn(function()
			while true do
				gateIsOpen = true
				timingGate.Color = GATE_OPEN_COLOR
				task.wait(GATE_OPEN_SECONDS)
				gateIsOpen = false
				timingGate.Color = GATE_CLOSED_COLOR
				task.wait(GATE_CLOSED_SECONDS)
			end
		end)
		attachTouched(timingGate, GATE_DEBOUNCE_SECONDS, lastGateByPlayer, function(player)
			if gateIsOpen then
				RoundCompletionRewards.markGatePassed(player)
			else
				RoundCompletionRewards.failRound(player, "gate_closed")
			end
		end)
		print(
			string.format(
				"[Polaxory] Backrooms Slice 0 course bound: %s.%s + %s.%s + %s.%s",
				folder.Name,
				enterTrigger.Name,
				folder.Name,
				exitTrigger.Name,
				folder.Name,
				timingGate.Name
			)
		)
	else
		warn(
			string.format(
				"[Polaxory] %s.%s not found. Timing Gate v0 inactive; completeRound will reject "
					.. "with gate_not_passed until the operator adds this BasePart in Studio.",
				COURSE_FOLDER_NAME,
				TIMING_GATE_NAME
			)
		)
		print(
			string.format(
				"[Polaxory] Backrooms Slice 0 course bound: %s.%s + %s.%s (no gate)",
				folder.Name,
				enterTrigger.Name,
				folder.Name,
				exitTrigger.Name
			)
		)
	end
	return true
end

-- If bindCourse returns false the receipt loop just can't be driven by a player
-- until the triggers exist in Studio. The server still runs; the harness in
-- tests/factory_slice_0.spec.luau still proves the loop logic in isolation.
bindCourse()

Players.PlayerRemoving:Connect(function(player: Player)
	lastStartByPlayer[player] = nil
	lastFinishByPlayer[player] = nil
	lastGateByPlayer[player] = nil
end)
