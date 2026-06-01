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
--
-- Wired events when both are found:
--
--   EnterTrigger.Touched  -> RoundCompletionRewards.startRound(player)
--                         -> round_started telemetry
--   ExitTrigger.Touched   -> RoundCompletionRewards.completeRound(player)
--                         -> round_completed + reward_granted telemetry
--
-- The reward panel (client) handles claim and run-again from there.
--
-- If the folder or either trigger is missing, this script warns clearly,
-- exits early, and does not block the rest of the server from running.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local RoundCompletionRewards = require(script.Parent:WaitForChild("RoundCompletionRewards"))

local COURSE_FOLDER_NAME = "PolaxoryBackroomsSlice0"
local ENTER_TRIGGER_NAME = "EnterTrigger"
local EXIT_TRIGGER_NAME = "ExitTrigger"
local START_DEBOUNCE_SECONDS = 2
local FINISH_DEBOUNCE_SECONDS = 2

local lastStartByPlayer: { [Player]: number } = {}
local lastFinishByPlayer: { [Player]: number } = {}

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

	print(
		string.format(
			"[Polaxory] Backrooms Slice 0 course bound: %s.%s + %s.%s",
			folder.Name,
			enterTrigger.Name,
			folder.Name,
			exitTrigger.Name
		)
	)
	return true
end

-- If bindCourse returns false the receipt loop just can't be driven by a player
-- until the triggers exist in Studio. The server still runs; the harness in
-- tests/factory_slice_0.spec.luau still proves the loop logic in isolation.
bindCourse()

Players.PlayerRemoving:Connect(function(player: Player)
	lastStartByPlayer[player] = nil
	lastFinishByPlayer[player] = nil
end)
