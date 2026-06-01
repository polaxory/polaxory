--!strict

-- Shared gameplay telemetry contract for Polaxory.
-- This module defines event names and required fields only.
-- Do not commit raw private player identifiers in generated snapshots.

local TelemetryEventContract = {}

TelemetryEventContract.SchemaVersion = "polaxory.telemetry.v0"

TelemetryEventContract.Events = {
	SessionStarted = "session_started",
	RoundStarted = "round_started",
	RoundCompleted = "round_completed",
	RoundFailed = "round_failed",
	RewardGranted = "reward_granted",
	RewardClaimed = "reward_claimed",
	ShopOpened = "shop_opened",
	ItemPreviewed = "item_previewed",
	ItemPurchased = "item_purchased",
	PlayerReturned = "player_returned",
}

TelemetryEventContract.RequiredFields = {
	"event_name",
	"schema_version",
	"occurred_at_unix_ms",
	"place_id",
	"job_id",
	"user_id_hash",
	"session_id",
	"properties",
}

function TelemetryEventContract.makeEvent(eventName: string, userIdHash: string, sessionId: string, properties: {[string]: any})
	return {
		event_name = eventName,
		schema_version = TelemetryEventContract.SchemaVersion,
		occurred_at_unix_ms = DateTime.now().UnixTimestampMillis,
		place_id = game.PlaceId,
		job_id = game.JobId,
		user_id_hash = userIdHash,
		session_id = sessionId,
		properties = properties or {},
	}
end

return TelemetryEventContract
