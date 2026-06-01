--!strict

-- Client seam for the v0 round-completion reward panel.
-- Server sends reward state. Client only sends claim / run-again intent.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- src/shared/* syncs to ReplicatedStorage.Shared.* per default.project.json.
local Shared = ReplicatedStorage:WaitForChild("Shared")
local RewardLoopConfig = require(Shared:WaitForChild("RewardLoopConfig"))

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("PolaxoryRemotes")
local stateChanged = remotes:WaitForChild("RoundRewardStateChanged") :: RemoteEvent
local claimRequested = remotes:WaitForChild("ClaimRewardRequested") :: RemoteEvent
local runAgainRequested = remotes:WaitForChild("RunAgainRequested") :: RemoteEvent

local gui = Instance.new("ScreenGui")
gui.Name = "PolaxoryRoundRewardPanel"
gui.ResetOnSpawn = false
gui.Enabled = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "Panel"
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.Size = UDim2.fromOffset(420, 220)
frame.BackgroundTransparency = 0.15
frame.Parent = gui

local message = Instance.new("TextLabel")
message.Name = "Message"
message.BackgroundTransparency = 1
message.Position = UDim2.fromOffset(20, 20)
message.Size = UDim2.fromOffset(380, 110)
message.Font = Enum.Font.GothamBold
message.TextScaled = true
message.TextWrapped = true
message.TextColor3 = Color3.fromRGB(255, 255, 255)
message.Parent = frame

local primary = Instance.new("TextButton")
primary.Name = "PrimaryAction"
primary.Position = UDim2.fromOffset(90, 145)
primary.Size = UDim2.fromOffset(240, 52)
primary.Font = Enum.Font.GothamBold
primary.TextScaled = true
primary.Parent = frame

local currentSessionKey: string? = nil
local currentMode: "claim" | "run_again" | nil = nil

local function renderRewardGranted(payload: { [string]: any })
	local reward = payload.reward
	currentSessionKey = payload.sessionKey
	currentMode = "claim"
	message.Text = string.format(
		"Round complete! %s +%d\n%s",
		reward.currency,
		reward.amount,
		reward.progressLabel
	)
	primary.Text = reward.primaryCta or RewardLoopConfig.RoundCompletionReward.primaryCta
	gui.Enabled = true
	print(
		string.format(
			"[Polaxory] %s: %s +%d",
			RewardLoopConfig.Events.RewardShown,
			reward.currency,
			reward.amount
		)
	)
end

local function renderRewardClaimed(payload: { [string]: any })
	currentSessionKey = payload.sessionKey
	currentMode = "run_again"
	message.Text = "Reward claimed. Ready for the next run?"
	primary.Text = RewardLoopConfig.RoundCompletionReward.replayCta
	gui.Enabled = true
end

local function renderRejected(payload: { [string]: any })
	message.Text = string.format("Request rejected: %s", tostring(payload.reason))
	primary.Text = "Close"
	currentMode = nil
	gui.Enabled = true
end

primary.Activated:Connect(function()
	if currentMode == "claim" then
		claimRequested:FireServer({
			sessionKey = currentSessionKey,
		})
	elseif currentMode == "run_again" then
		runAgainRequested:FireServer({
			sessionKey = currentSessionKey,
		})
	else
		gui.Enabled = false
	end
end)

stateChanged.OnClientEvent:Connect(function(payload: { [string]: any })
	if payload.event == RewardLoopConfig.Events.RewardGranted then
		renderRewardGranted(payload)
	elseif payload.event == RewardLoopConfig.Events.RewardClaimed then
		renderRewardClaimed(payload)
	elseif payload.event == RewardLoopConfig.Events.NextRoundStarted then
		gui.Enabled = false
		currentMode = nil
		currentSessionKey = payload.sessionKey
		print(
			string.format(
				"[Polaxory] %s: %s",
				RewardLoopConfig.Events.NextRoundStarted,
				payload.sessionKey
			)
		)
	elseif
		payload.event == RewardLoopConfig.Events.RejectedClaim
		or payload.event == RewardLoopConfig.Events.RejectedRunAgain
	then
		renderRejected(payload)
	end
end)
