local SupervisorAgent = {}
SupervisorAgent.__index = SupervisorAgent

function SupervisorAgent.new(taskQueue)
	return setmetatable({ taskQueue = taskQueue }, SupervisorAgent)
end

function SupervisorAgent:inspect(snapshot)
	local suggestions = {}

	for stationId, station in snapshot.stations do
		if station.kind == "Extractor" and (station.inventory.Ore or 0) >= station.capacity then
			table.insert(suggestions, {
				type = "MoveResource",
				sourceStationId = stationId,
				targetStationId = "machine-1",
				resourceKind = "Ore",
				amount = math.min(5, station.inventory.Ore or 0),
				reason = "Extractor is full; route ore into first machine.",
			})
		end
	end

	return suggestions
end

function SupervisorAgent:applySuggestion(suggestion)
	local taskType = suggestion.type
	local payload = table.clone(suggestion)
	payload.type = nil
	return self.taskQueue:enqueue(taskType, payload)
end

return SupervisorAgent
