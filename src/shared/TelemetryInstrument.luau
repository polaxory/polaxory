--!strict
-- Polaxory Telemetry Instrument v1
--
-- Purpose:
-- Measure whether the core reward loop creates another round start.
-- This module defines the instrument: the events, required fields,
-- aggregate metrics, privacy boundary, and the minimum snapshot contract.
--
-- Boundary:
-- - Never persist raw Roblox UserId values.
-- - Never persist player names, chat text, IPs, device IDs, or free-form text.
-- - Use short-lived runtime session IDs only for sequencing inside one play session.

local TelemetryInstrument = {}

TelemetryInstrument.Version = "polaxory.telemetry.instrument.v1"

TelemetryInstrument.Events = {
	RoundStarted = "round_started",
	RoundCompleted = "round_completed",
	RewardGranted = "reward_granted",
	RewardClaimed = "reward_claimed",
	NextRoundStarted = "next_round_started",
}

TelemetryInstrument.RequiredFields = {
	round_started = {
		"sessionId",
		"roundId",
		"startedAtUnixMs",
	},
	round_completed = {
		"sessionId",
		"roundId",
		"completedAtUnixMs",
		"durationMs",
		"outcome",
	},
	reward_granted = {
		"sessionId",
		"roundId",
		"rewardId",
		"rewardType",
		"amount",
	},
	reward_claimed = {
		"sessionId",
		"roundId",
		"rewardId",
		"claimedAtUnixMs",
	},
	next_round_started = {
		"sessionId",
		"previousRoundId",
		"roundId",
		"startedAtUnixMs",
		"source",
	},
}

TelemetryInstrument.Aggregates = {
	"rounds_started",
	"rounds_completed",
	"rewards_granted",
	"rewards_claimed",
	"next_rounds_started",
	"completion_rate",
	"reward_claim_rate",
	"next_round_rate_after_claim",
	"avg_round_duration_ms",
	"median_round_duration_ms",
}

TelemetryInstrument.Questions = {
	Primary = "Does claiming a round-completion reward increase the chance that a player starts another round?",
	Secondary = {
		"Where do players drop: start, completion, grant, claim, or next start?",
		"Which reward types create the highest next-round rate?",
		"How long does the playable loop take from start to claim?",
	},
}

TelemetryInstrument.MinimumViableSnapshot = {
	instrumentVersion = TelemetryInstrument.Version,
	window = {
		startedAt = "ISO-8601",
		endedAt = "ISO-8601",
	},
	aggregates = TelemetryInstrument.Aggregates,
	privacy = {
		containsRawUserIds = false,
		containsPlayerNames = false,
		containsFreeText = false,
	},
}

function TelemetryInstrument.getEventName(key: string): string?
	return TelemetryInstrument.Events[key]
end

function TelemetryInstrument.getRequiredFields(eventName: string): { string }?
	return TelemetryInstrument.RequiredFields[eventName]
end

return TelemetryInstrument
