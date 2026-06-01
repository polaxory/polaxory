--!strict
-- Aggregate-first telemetry buffer for Polaxory Roblox playtests.
--
-- Privacy rule: this module stores anonymous session keys and aggregate metrics.
-- Do not pass raw Roblox user IDs, usernames, display names, chat text, or private server invite data.

local TelemetryBuffer = {}
TelemetryBuffer.__index = TelemetryBuffer

export type NumericMetrics = { [string]: number }

export type EventPayload = {
	sessionKey: string?,
	roundId: string?,
	metrics: NumericMetrics?,
	metadata: { [string]: string }?,
}

export type EventAggregate = {
	count: number,
	firstSeenUnix: number,
	lastSeenUnix: number,
	sessions: { [string]: boolean },
	metrics: {
		[string]: {
			count: number,
			total: number,
			min: number,
			max: number,
			average: number,
		},
	},
}

export type Snapshot = {
	generatedAtUnix: number,
	buildLabel: string,
	events: { [string]: any },
}

local SAFE_EVENT_NAMES: { [string]: boolean } = {
	round_started = true,
	round_completed = true,
	reward_granted = true,
	reward_claimed = true,
	next_round_started = true,
}

local function nowUnix(): number
	return os.time()
end

local function shallowCopyMetric(metric: any): any
	return {
		count = metric.count,
		total = metric.total,
		min = metric.min,
		max = metric.max,
		average = metric.average,
	}
end

function TelemetryBuffer.new(buildLabel: string?)
	local self = setmetatable({}, TelemetryBuffer)
	self._buildLabel = buildLabel or "local-playtest"
	self._events = {} :: { [string]: EventAggregate }
	return self
end

function TelemetryBuffer:isSafeEventName(eventName: string): boolean
	return SAFE_EVENT_NAMES[eventName] == true
end

function TelemetryBuffer:record(eventName: string, payload: EventPayload?)
	if not self:isSafeEventName(eventName) then
		warn("[PolaxoryTelemetry] ignored unknown event:", eventName)
		return false
	end

	local unix = nowUnix()
	local aggregate = self._events[eventName]

	if aggregate == nil then
		aggregate = {
			count = 0,
			firstSeenUnix = unix,
			lastSeenUnix = unix,
			sessions = {},
			metrics = {},
		}
		self._events[eventName] = aggregate
	end

	aggregate.count += 1
	aggregate.lastSeenUnix = unix

	if payload ~= nil and payload.sessionKey ~= nil and payload.sessionKey ~= "" then
		aggregate.sessions[payload.sessionKey] = true
	end

	local metrics = if payload ~= nil then payload.metrics else nil
	if metrics ~= nil then
		for key, value in pairs(metrics) do
			if typeof(value) == "number" then
				local metric = aggregate.metrics[key]
				if metric == nil then
					metric = { count = 0, total = 0, min = value, max = value, average = 0 }
					aggregate.metrics[key] = metric
				end

				metric.count += 1
				metric.total += value
				metric.min = math.min(metric.min, value)
				metric.max = math.max(metric.max, value)
				metric.average = metric.total / metric.count
			end
		end
	end

	return true
end

function TelemetryBuffer:snapshot(): Snapshot
	local events = {}

	for eventName, aggregate in pairs(self._events) do
		local metrics = {}
		for metricName, metric in pairs(aggregate.metrics) do
			metrics[metricName] = shallowCopyMetric(metric)
		end

		local uniqueSessions = 0
		for _sessionKey in pairs(aggregate.sessions) do
			uniqueSessions += 1
		end

		events[eventName] = {
			count = aggregate.count,
			uniqueSessions = uniqueSessions,
			firstSeenUnix = aggregate.firstSeenUnix,
			lastSeenUnix = aggregate.lastSeenUnix,
			metrics = metrics,
		}
	end

	return {
		generatedAtUnix = nowUnix(),
		buildLabel = self._buildLabel,
		events = events,
	}
end

function TelemetryBuffer:reset()
	self._events = {}
end

return TelemetryBuffer
