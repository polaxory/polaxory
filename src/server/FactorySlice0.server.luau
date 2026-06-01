local FactoryBlackboard = require(script.Parent.FactoryBlackboard)
local TaskQueue = require(script.Parent.TaskQueue)
local SupervisorAgent = require(script.Parent.SupervisorAgent)
local Validators = require(script.Parent.Validators)

local blackboard = FactoryBlackboard.new()
local taskQueue = TaskQueue.new(blackboard)
local supervisor = SupervisorAgent.new(taskQueue)

blackboard:addStation({
	id = "extractor-1",
	kind = "Extractor",
	capacity = 10,
	inventory = { Ore = 10 },
})

blackboard:addStation({
	id = "machine-1",
	kind = "Machine",
	capacity = 10,
	inventory = { Ore = 0, Plate = 0 },
})

blackboard:addWorker({ id = "carrier-1", role = "Carrier" })
blackboard:addWorker({ id = "fixer-1", role = "Fixer" })

for _, suggestion in supervisor:inspect(blackboard:snapshot()) do
	supervisor:applySuggestion(suggestion)
end

local errors = Validators.validateSnapshot(blackboard:snapshot())
if #errors > 0 then
	warn("Polaxory Factory Slice 0 validation errors:", table.concat(errors, "; "))
else
	print("Polaxory Factory Slice 0 rails booted with valid task graph.")
end
