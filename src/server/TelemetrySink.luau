--!strict
-- Durable egress for aggregate telemetry snapshots.
--
-- Snapshots are aggregate-only (counts, unique-session tallies, numeric metrics)
-- so they are safe to persist. A cold Open Cloud Luau Execution session reads
-- this same store to drain snapshots out of the live universe — DataStore is the
-- bridge across the isolated-session boundary. See apps/roblox-ops/src/read-telemetry.ts.

local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

local TelemetrySink = {}

TelemetrySink.StoreName = "polaxory_telemetry"
TelemetrySink.LatestKey = "latest"

-- Persists a snapshot under a timestamped history key plus a fixed LatestKey
-- pointer (so the external reader is a single GetAsync). Returns whether both
-- writes landed; never throws (DataStore is unavailable without API services).
function TelemetrySink.persist(snapshot: any): boolean
	local encoded
	local encoded_ok, encodeErr = pcall(function()
		encoded = HttpService:JSONEncode(snapshot)
	end)
	if not encoded_ok then
		warn("[PolaxoryTelemetry] snapshot encode failed:", encodeErr)
		return false
	end

	local store = DataStoreService:GetDataStore(TelemetrySink.StoreName)
	local historyKey = tostring(snapshot.buildLabel) .. ":" .. tostring(snapshot.generatedAtUnix)

	local wroteHistory = pcall(function()
		store:SetAsync(historyKey, encoded)
	end)
	local wroteLatest = pcall(function()
		store:SetAsync(TelemetrySink.LatestKey, encoded)
	end)

	if wroteHistory and wroteLatest then
		print("[PolaxoryTelemetry] snapshot persisted:", historyKey)
		return true
	end

	warn("[PolaxoryTelemetry] snapshot persist failed (DataStore unavailable? Enable API services)")
	return false
end

return TelemetrySink
