--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local RewardLoopConfig = require(ReplicatedStorage:WaitForChild("RewardLoopConfig"))
local RemoteContracts = require(ReplicatedStorage:WaitForChild("RemoteContracts"))

export type CompletionReward = {
	id: string,
	currency: string,
	amount: number,
	displayName: string,
	progressLabel: string,
	primaryCta: string,
	replayCta: string,
}

type RoundState = {
	sessionKey: string,
	startedAt: number,
	completedAt: number?,
	grantedAt: number?,
	claimedAt: number?,
	pendingReward: CompletionReward?,
}

local TELEMETRY_FOLDER_NAME = "PolaxoryTelemetryEvents"
local REMOTE_FOLDER_NAME = "PolaxoryRemotes"

local RoundCompletionRewards = {}
local stateByPlayerKey: { [string]: RoundState } = {}
local handlersInstalled = false

local function now(): number
	return os.clock()
end

local function playerKey(player: Player): string
	if player.UserId ~= 0 then
		return tostring(player.UserId)
	end
	return player.Name
end

local function makeSessionKey(player: Player): string
	return string.format("%s:%d", playerKey(player), math.floor(now() * 1000))
end

local function cloneReward(): CompletionReward
	local reward = RewardLoopConfig.RoundCompletionReward
	return {
		id = reward.id,
		currency = reward.currency,
		amount = reward.amount,
		displayName = reward.displayName,
		progressLabel = reward.progressLabel,
		primaryCta = reward.primaryCta,
		replayCta = reward.replayCta,
	}
end

local function getTelemetryEvent(name: string): BindableEvent?
	local folder = ServerScriptService:FindFirstChild(TELEMETRY_FOLDER_NAME)
	if folder == nil then
		return nil
	end
	local event = folder:FindFirstChild(name)
	if event ~= nil and event:IsA("BindableEvent") then
		return event
	end
	return nil
end

local function emitTelemetry(name: string, payload: { [string]: any })
	local event = getTelemetryEvent(name)
	if event ~= nil then
		event:Fire(payload)
	end
end

local function getRemoteFolder(): Folder
	local existing = ReplicatedStorage:FindFirstChild(REMOTE_FOLDER_NAME)
	if existing ~= nil and existing:IsA("Folder") then
		return existing
	end

	local folder = Instance.new("Folder")
	folder.Name = REMOTE_FOLDER_NAME
	folder.Parent = ReplicatedStorage
	return folder
end

local function getOrCreateRemote(name: string): RemoteEvent
	local folder = getRemoteFolder()
	local existing = folder:FindFirstChild(name)
	if existing ~= nil and existing:IsA("RemoteEvent") then
		return existing
	end

	local remote = Instance.new("RemoteEvent")
	remote.Name = name
	remote.Parent = folder
	return remote
end

local function fireState(player: Player, payload: { [string]: any })
	local remote = getOrCreateRemote("RoundRewardStateChanged")
	remote:FireClient(player, payload)
end

local function reject(player: Player, state: RoundState?, eventName: string, reason: string)
	local sessionKey = if state ~= nil then state.sessionKey else makeSessionKey(player)
	local payload = {
		event = eventName,
		sessionKey = sessionKey,
		reason = reason,
	}
	fireState(player, payload)
	print(string.format("[Polaxory] %s: %s for %s", eventName, reason, player.Name))
	return payload
end

function RoundCompletionRewards.startRound(player: Player, sessionKey: string?): RoundState
	local state: RoundState = {
		sessionKey = sessionKey or makeSessionKey(player),
		startedAt = now(),
	}
	stateByPlayerKey[playerKey(player)] = state
	emitTelemetry("RoundStarted", {
		sessionKey = state.sessionKey,
		partySize = 1,
	})
	return state
end

function RoundCompletionRewards.completeRound(
	player: Player,
	payload: { [string]: any }?
): { [string]: any }
	local key = playerKey(player)
	local state = stateByPlayerKey[key]
	if state == nil then
		state = RoundCompletionRewards.startRound(
			player,
			if payload ~= nil then payload.sessionKey else nil
		)
	end

	if state.pendingReward ~= nil or state.grantedAt ~= nil then
		return reject(player, state, RewardLoopConfig.Events.RejectedClaim, "duplicate_finish")
	end

	local completedAt = now()
	local reward = cloneReward()
	state.completedAt = completedAt
	state.grantedAt = completedAt
	state.pendingReward = reward

	emitTelemetry("RoundCompleted", {
		sessionKey = state.sessionKey,
		durationSeconds = if payload ~= nil
				and typeof(payload.durationSeconds) == "number"
			then payload.durationSeconds
			else 0,
		resourcesDelivered = if payload ~= nil
				and typeof(payload.resourcesDelivered) == "number"
			then payload.resourcesDelivered
			else 0,
		workersAssigned = if payload ~= nil
				and typeof(payload.workersAssigned) == "number"
			then payload.workersAssigned
			else 0,
	})
	emitTelemetry("RewardGranted", {
		sessionKey = state.sessionKey,
		softCurrency = reward.amount,
		xp = 0,
	})

	local response = {
		event = RewardLoopConfig.Events.RewardGranted,
		sessionKey = state.sessionKey,
		reward = reward,
	}
	fireState(player, response)
	print(
		string.format(
			"[Polaxory] %s: %s +%d for %s",
			RewardLoopConfig.Events.RewardGranted,
			reward.currency,
			reward.amount,
			player.Name
		)
	)
	return response
end

function RoundCompletionRewards.claimPendingReward(
	player: Player,
	_payload: { [string]: any }?
): { [string]: any }
	local state = stateByPlayerKey[playerKey(player)]
	if state == nil or state.grantedAt == nil then
		return reject(
			player,
			state,
			RewardLoopConfig.Events.RejectedClaim,
			"claim_before_completion"
		)
	end

	if state.claimedAt ~= nil or state.pendingReward == nil then
		return reject(player, state, RewardLoopConfig.Events.RejectedClaim, "duplicate_claim")
	end

	local claimedAt = now()
	local reward = state.pendingReward
	state.claimedAt = claimedAt
	state.pendingReward = nil

	emitTelemetry("RewardClaimed", {
		sessionKey = state.sessionKey,
		secondsAfterGrant = claimedAt - (state.grantedAt or claimedAt),
	})

	local response = {
		event = RewardLoopConfig.Events.RewardClaimed,
		sessionKey = state.sessionKey,
		reward = reward,
	}
	fireState(player, response)
	print(
		string.format(
			"[Polaxory] %s: %s for %s",
			RewardLoopConfig.Events.RewardClaimed,
			state.sessionKey,
			player.Name
		)
	)
	return response
end

function RoundCompletionRewards.requestRunAgain(
	player: Player,
	payload: { [string]: any }?
): { [string]: any }
	local previousState = stateByPlayerKey[playerKey(player)]
	if previousState == nil or previousState.claimedAt == nil then
		return reject(
			player,
			previousState,
			RewardLoopConfig.Events.RejectedRunAgain,
			"run_again_before_claim"
		)
	end

	local nextState = RoundCompletionRewards.startRound(
		player,
		if payload ~= nil then payload.sessionKey else nil
	)
	emitTelemetry("NextRoundStarted", {
		sessionKey = nextState.sessionKey,
		secondsAfterClaim = nextState.startedAt - (previousState.claimedAt or nextState.startedAt),
	})

	local response = {
		event = RewardLoopConfig.Events.NextRoundStarted,
		sessionKey = nextState.sessionKey,
	}
	fireState(player, response)
	print(
		string.format(
			"[Polaxory] %s: %s for %s",
			RewardLoopConfig.Events.NextRoundStarted,
			nextState.sessionKey,
			player.Name
		)
	)
	return response
end

function RoundCompletionRewards.grantForCompletedRound(player: Player): CompletionReward?
	local response = RoundCompletionRewards.completeRound(player, nil)
	return response.reward
end

function RoundCompletionRewards.installRemoteHandlers()
	if handlersInstalled then
		return
	end
	handlersInstalled = true

	getOrCreateRemote("RoundRewardStateChanged")

	getOrCreateRemote("ClaimRewardRequested").OnServerEvent:Connect(
		function(player: Player, payload: { [string]: any }?)
			RoundCompletionRewards.claimPendingReward(player, payload)
		end
	)

	getOrCreateRemote("RunAgainRequested").OnServerEvent:Connect(
		function(player: Player, payload: { [string]: any }?)
			RoundCompletionRewards.requestRunAgain(player, payload)
		end
	)

	print(
		"[Polaxory] reward claim/replay remotes ready",
		RemoteContracts.get("ClaimRewardRequested") ~= nil,
		RemoteContracts.get("RunAgainRequested") ~= nil
	)
end

function RoundCompletionRewards._debugReset(player: Player)
	stateByPlayerKey[playerKey(player)] = nil
end

RoundCompletionRewards.installRemoteHandlers()

return RoundCompletionRewards
