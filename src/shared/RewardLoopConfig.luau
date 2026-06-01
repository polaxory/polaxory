--!strict

-- Polaxory round completion reward loop v0.
-- Server owns reward state. Client only renders and sends claim / replay intent.
local RewardLoopConfig = {}

RewardLoopConfig.RoundCompletionReward = {
	id = "round_completion_reward_v0",
	displayName = "Round Complete Bonus",
	currency = "reward_keys",
	amount = 1,
	progressLabel = "Earn keys by finishing rounds. Keys unlock cosmetic rewards later.",
	primaryCta = "Claim reward",
	replayCta = "Run again",
}

RewardLoopConfig.Events = {
	RoundStarted = "round_started",
	RoundCompleted = "round_completed",
	RewardGranted = "reward_granted",
	RewardShown = "reward_shown",
	RewardClaimed = "reward_claimed",
	RejectedClaim = "rejected_claim",
	RejectedRunAgain = "rejected_run_again",
	ReplayClicked = "replay_clicked",
	NextRoundStarted = "next_round_started",
}

return RewardLoopConfig
