--!strict

-- Client seam for the v0 round-completion reward panel.
-- Hook this to the real round-complete remote once the game loop endpoint is named.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RewardLoopConfig = require(ReplicatedStorage:WaitForChild("RewardLoopConfig"))

local function showRewardPanel(reward)
	print(
		string.format(
			"[Polaxory] %s: %s +%d. %s CTA=%s",
			RewardLoopConfig.Events.RewardShown,
			reward.currency,
			reward.amount,
			reward.progressLabel,
			reward.primaryCta
		)
	)
end

-- Temporary preview payload so the reward loop can be validated before UI polish.
showRewardPanel({
	currency = RewardLoopConfig.RoundCompletionReward.currency,
	amount = RewardLoopConfig.RoundCompletionReward.amount,
	progressLabel = RewardLoopConfig.RoundCompletionReward.progressLabel,
	primaryCta = RewardLoopConfig.RoundCompletionReward.primaryCta,
})
