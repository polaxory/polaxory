local TaskContracts = {}

TaskContracts.Types = {
	MoveResource = {
		allowedRoles = { Carrier = true },
		requiredFields = { "sourceStationId", "targetStationId", "resourceKind", "amount" },
	},
	ClearJam = {
		allowedRoles = { Fixer = true },
		requiredFields = { "targetStationId", "reason" },
	},
}

TaskContracts.AllowedTransitions = {
	Queued = { Claimed = true, Failed = true },
	Claimed = { Running = true, Failed = true },
	Running = { Done = true, Failed = true },
	Done = {},
	Failed = {},
}

function TaskContracts.getContract(taskType: string)
	return TaskContracts.Types[taskType]
end

function TaskContracts.canTransition(fromState: string, toState: string): boolean
	local targets = TaskContracts.AllowedTransitions[fromState]
	return targets ~= nil and targets[toState] == true
end

return TaskContracts
