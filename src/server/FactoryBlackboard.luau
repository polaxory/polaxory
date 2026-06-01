local FactoryBlackboard = {}
FactoryBlackboard.__index = FactoryBlackboard

function FactoryBlackboard.new()
	return setmetatable({
		stations = {},
		workers = {},
		tasks = {},
		tick = 0,
	}, FactoryBlackboard)
end

function FactoryBlackboard:addStation(station)
	assert(station.id, "station requires id")
	self.stations[station.id] = station
end

function FactoryBlackboard:addWorker(worker)
	assert(worker.id, "worker requires id")
	self.workers[worker.id] = worker
end

function FactoryBlackboard:addTask(task)
	assert(task.id, "task requires id")
	task.state = task.state or "Queued"
	self.tasks[task.id] = task
end

function FactoryBlackboard:getQueuedTasks()
	local queued = {}
	for _, task in self.tasks do
		if task.state == "Queued" then
			table.insert(queued, task)
		end
	end
	return queued
end

function FactoryBlackboard:snapshot()
	return {
		stations = self.stations,
		workers = self.workers,
		tasks = self.tasks,
		tick = self.tick,
	}
end

function FactoryBlackboard:step()
	self.tick += 1
end

return FactoryBlackboard
