local TaskContracts = require(game.ReplicatedStorage.Shared.TaskContracts)

local Validators = {}

function Validators.validateTask(task)
	local errors = {}
	local contract = TaskContracts.getContract(task.type)
	if not contract then
		table.insert(errors, `unknown task type: {tostring(task.type)}`)
		return errors
	end

	for _, fieldName in contract.requiredFields do
		if task[fieldName] == nil then
			table.insert(errors, `task {task.id or "?"} missing {fieldName}`)
		end
	end

	return errors
end

function Validators.validateSnapshot(snapshot)
	local errors = {}

	for stationId, station in snapshot.stations do
		if station.capacity <= 0 then
			table.insert(errors, `station {stationId} has non-positive capacity`)
		end
	end

	for _, task in snapshot.tasks do
		for _, errorMessage in Validators.validateTask(task) do
			table.insert(errors, errorMessage)
		end
	end

	return errors
end

return Validators
