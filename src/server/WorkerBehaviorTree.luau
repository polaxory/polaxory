local WorkerBehaviorTree = {}
WorkerBehaviorTree.__index = WorkerBehaviorTree

function WorkerBehaviorTree.new(taskQueue, executor)
	return setmetatable({ taskQueue = taskQueue, executor = executor }, WorkerBehaviorTree)
end

function WorkerBehaviorTree:stepWorker(worker)
	local task = nil

	if worker.currentTaskId then
		task = self.taskQueue.blackboard.tasks[worker.currentTaskId]
	end

	if not task then
		task = self.taskQueue:claimNext(worker)
	end

	if not task then
		return { status = "Idle", workerId = worker.id }
	end

	if task.state == "Claimed" then
		self.taskQueue:transition(task, "Running")
	end

	local ok, result = pcall(function()
		return self.executor:execute(task)
	end)

	if ok then
		self.taskQueue:transition(task, "Done")
		worker.currentTaskId = nil
		return { status = "Done", workerId = worker.id, taskId = task.id, result = result }
	end

	task.reason = tostring(result)
	self.taskQueue:transition(task, "Failed")
	worker.currentTaskId = nil
	return { status = "Failed", workerId = worker.id, taskId = task.id, reason = task.reason }
end

function WorkerBehaviorTree:stepAll()
	local results = {}
	for _, worker in self.taskQueue.blackboard.workers do
		table.insert(results, self:stepWorker(worker))
	end
	return results
end

return WorkerBehaviorTree
