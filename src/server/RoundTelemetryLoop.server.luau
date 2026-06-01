--!strict
-- Server-side telemetry seam for Polaxory's first playable retention loop.
--
-- This intentionally exposes BindableEvents instead of binding directly to game systems.
-- Round/reward scripts fire these events; persistence/export can evolve later.

local ServerScriptService = game:GetService("ServerScriptService")

local TelemetryBuffer = require(script.Parent:WaitForChild("TelemetryBuffer"))

local BUILD_LABEL = "polaxory-telemetry-loop-v0"
local FOLDER_NAME = "PolaxoryTelemetryEvents"

local buffer = TelemetryBuffer.new(BUILD_LABEL)

local folder = ServerScriptService:FindFirstChild(FOLDER_NAME)
if folder == nil then
	folder = Instance.new("Folder")
	folder.Name = FOLDER_NAME
	folder.Parent = ServerScriptService
end

local function getOrCreateBindableEvent(name: string): BindableEvent
	local existing = folder:FindFirstChild(name)
	if existing ~= nil and existing:IsA("BindableEvent") then
		return existing
	end

	local event = Instance.new("BindableEvent")
	event.Name = name
	event.Parent = folder
	return event
end

local roundStarted = getOrCreateBindableEvent("RoundStarted")
local roundCompleted = getOrCreateBindableEvent("RoundCompleted")
local rewardGranted = getOrCreateBindableEvent("RewardGranted")
local rewardClaimed = getOrCreateBindableEvent("RewardClaimed")
local nextRoundStarted = getOrCreateBindableEvent("NextRoundStarted")
local snapshotRequested = getOrCreateBindableEvent("SnapshotRequested")

local function toSessionKey(payload: any): string?
	if typeof(payload) ~= "table" then
		return nil
	end

	if typeof(payload.sessionKey) == "string" then
		return payload.sessionKey
	end

	return nil
end

local function asNumber(payload: any, key: string): number?
	if typeof(payload) ~= "table" then
		return nil
	end

	local value = payload[key]
	if typeof(value) == "number" then
		return value
	end

	return nil
end

roundStarted.Event:Connect(function(payload: any)
	buffer:record("round_started", {
		sessionKey = toSessionKey(payload),
		metrics = {
			partySize = asNumber(payload, "partySize") or 1,
		},
	})
end)

roundCompleted.Event:Connect(function(payload: any)
	buffer:record("round_completed", {
		sessionKey = toSessionKey(payload),
		metrics = {
			durationSeconds = asNumber(payload, "durationSeconds") or 0,
			resourcesDelivered = asNumber(payload, "resourcesDelivered") or 0,
			workersAssigned = asNumber(payload, "workersAssigned") or 0,
		},
	})
end)

rewardGranted.Event:Connect(function(payload: any)
	buffer:record("reward_granted", {
		sessionKey = toSessionKey(payload),
		metrics = {
			softCurrency = asNumber(payload, "softCurrency") or 0,
			xp = asNumber(payload, "xp") or 0,
		},
	})
end)

rewardClaimed.Event:Connect(function(payload: any)
	buffer:record("reward_claimed", {
		sessionKey = toSessionKey(payload),
		metrics = {
			secondsAfterGrant = asNumber(payload, "secondsAfterGrant") or 0,
		},
	})
end)

nextRoundStarted.Event:Connect(function(payload: any)
	buffer:record("next_round_started", {
		sessionKey = toSessionKey(payload),
		metrics = {
			secondsAfterClaim = asNumber(payload, "secondsAfterClaim") or 0,
		},
	})
end)

snapshotRequested.Event:Connect(function()
	local snapshot = buffer:snapshot()
	print("[PolaxoryTelemetrySnapshot]", snapshot)
end)

print("[PolaxoryTelemetry] loop seam ready:", FOLDER_NAME)
