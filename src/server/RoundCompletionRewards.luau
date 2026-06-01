--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RewardLoopConfig = require(ReplicatedStorage:WaitForChild("RewardLoopConfig"))

export type CompletionReward = {
	id: string,
	currency: string,
	amount: number,
	displayName: string,
	progressLabel: string,
	primaryCta: string,
}

local RoundCompletionRewards = {}

function RoundCompletionRewards.grantForCompletedRound(player: Player): CompletionReward
	-- v0 intentionally returns a deterministic reward contract.
	-- Persistence should attach here after the round loop is verified in-game.
	local reward = RewardLoopConfig.RoundCompletionReward

	print(string.format(
		"[Polaxory] %s: %s +%d for %s",
		RewardLoopConfig.Events.RewardGranted,
		reward.currency,
		reward.amount,
		player.Name
	))

	return {
		id = reward.id,
		currency = reward.currency,
		amount = reward.amount,
		displayName = reward.displayName,
		progressLabel = reward.progressLabel,
		primaryCta = reward.primaryCta,
	}
end

return RoundCompletionRewards
