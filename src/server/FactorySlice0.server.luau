local Players = game:GetService("Players")

local FactoryBlackboard = require(script.Parent.FactoryBlackboard)
local ResourceExecutor = require(script.Parent.ResourceExecutor)
local RoundCompletionRewards = require(script.Parent.RoundCompletionRewards)
local SupervisorAgent = require(script.Parent.SupervisorAgent)
local TaskQueue = require(script.Parent.TaskQueue)
local Validators = require(script.Parent.Validators)
local WorkerBehaviorTree = require(script.Parent.WorkerBehaviorTree)

local blackboard = FactoryBlackboard.new()
local taskQueue = TaskQueue.new(blackboard)
local supervisor = SupervisorAgent.new(taskQueue)
local executor = ResourceExecutor.new(blackboard)
local workers = WorkerBehaviorTree.new(taskQueue, executor)

local function startPlayerRound(player: Player)
	RoundCompletionRewards.startRound(player)
end

Players.PlayerAdded:Connect(startPlayerRound)
for _, player in Players:GetPlayers() do
	startPlayerRound(player)
end

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

for _, result in workers:stepAll() do
	print("Polaxory worker step", result.workerId, result.status, result.taskId or "no-task")
end

local errors = Validators.validateSnapshot(blackboard:snapshot())
if #errors > 0 then
	warn("Polaxory Factory Slice 0 validation errors:", table.concat(errors, "; "))
else
	print("Polaxory Factory Slice 0 rails booted with valid task graph.")
end
