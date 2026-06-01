--!strict

-- Polaxory round completion reward loop v0.
-- This is the product contract first; live persistence and analytics can attach later.

local RewardLoopConfig = {}

RewardLoopConfig.RoundCompletionReward = {
	id = "round_completion_reward_v0",
	displayName = "Round Complete Bonus",
	currency = "reward_keys",
	amount = 1,
	progressLabel = "Earn keys by finishing rounds. Keys unlock cosmetic rewards later.",
	primaryCta = "Play again",
}

RewardLoopConfig.Events = {
	RoundCompleted = "round_completed",
	RewardGranted = "completion_reward_granted",
	RewardShown = "completion_reward_shown",
	RewardClaimed = "completion_reward_claimed",
	ReplayClicked = "completion_replay_clicked",
}

return RewardLoopConfig
