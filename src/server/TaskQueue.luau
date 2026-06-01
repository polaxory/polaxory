local TaskContracts = require(game.ReplicatedStorage.Shared.TaskContracts)

local TaskQueue = {}
TaskQueue.__index = TaskQueue

function TaskQueue.new(blackboard)
	return setmetatable({ blackboard = blackboard, nextId = 0 }, TaskQueue)
end

function TaskQueue:_nextTaskId(prefix: string): string
	self.nextId += 1
	return `{prefix}-{self.nextId}`
end

function TaskQueue:enqueue(taskType: string, payload)
	local contract = TaskContracts.getContract(taskType)
	assert(contract, `unknown task type: {taskType}`)

	for _, fieldName in contract.requiredFields do
		assert(payload[fieldName] ~= nil, `missing required task field: {fieldName}`)
	end

	local task = table.clone(payload)
	task.id = task.id or self:_nextTaskId(taskType)
	task.type = taskType
	task.state = "Queued"
	self.blackboard:addTask(task)
	return task
end

function TaskQueue:claimNext(worker)
	for _, task in self.blackboard:getQueuedTasks() do
		local contract = TaskContracts.getContract(task.type)
		if contract and contract.allowedRoles[worker.role] then
			task.state = "Claimed"
			task.workerId = worker.id
			worker.currentTaskId = task.id
			return task
		end
	end
	return nil
end

function TaskQueue:transition(task, toState: string)
	assert(
		TaskContracts.canTransition(task.state, toState),
		`invalid transition {task.state} -> {toState}`
	)
	task.state = toState
	return task
end

return TaskQueue
