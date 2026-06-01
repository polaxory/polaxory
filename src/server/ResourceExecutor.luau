local ResourceExecutor = {}
ResourceExecutor.__index = ResourceExecutor

function ResourceExecutor.new(blackboard)
	return setmetatable({ blackboard = blackboard }, ResourceExecutor)
end

function ResourceExecutor:_getStation(stationId: string)
	local station = self.blackboard.stations[stationId]
	assert(station, `unknown station: {stationId}`)
	return station
end

function ResourceExecutor:moveResource(task)
	local source = self:_getStation(task.sourceStationId)
	local target = self:_getStation(task.targetStationId)
	local kind = task.resourceKind
	local amount = task.amount or 0

	assert(amount > 0, "MoveResource amount must be positive")
	assert((source.inventory[kind] or 0) >= amount, `source lacks {kind}`)

	local targetHeld = target.inventory[kind] or 0
	assert(targetHeld + amount <= target.capacity, `target capacity exceeded for {target.id}`)

	source.inventory[kind] = (source.inventory[kind] or 0) - amount
	target.inventory[kind] = targetHeld + amount

	return {
		moved = amount,
		resourceKind = kind,
		from = source.id,
		to = target.id,
	}
end

function ResourceExecutor:clearJam(task)
	local station = self:_getStation(task.targetStationId)
	station.jammed = false
	return { cleared = station.id, reason = task.reason }
end

function ResourceExecutor:execute(task)
	if task.type == "MoveResource" then
		return self:moveResource(task)
	elseif task.type == "ClearJam" then
		return self:clearJam(task)
	else
		error(`no executor for task type: {tostring(task.type)}`)
	end
end

return ResourceExecutor
