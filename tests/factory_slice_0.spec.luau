-- Factory Slice 0 contract tests.
--
-- Each `describe` covers one module's behavior against the acceptance criteria
-- in docs/slices/FACTORY_SLICE_0_ACCEPTANCE.md. Tests use TestEZ
-- (wally dev-dependency: roblox/testez@0.4.1).
--
-- Runner setup (Roblox Studio path):
--   1. Install Wally + Rojo via aftman: `aftman install`
--   2. Resolve packages: `wally install`
--   3. Sync to Studio via Rojo, open this project in Studio
--   4. Run via TestEZ.TestBootstrap.run from a server-side runner script
--
-- Headless runner (Open Cloud Luau Execution) covered in issue #31.

return function()
	local Shared = game.ReplicatedStorage.Shared
	local Server = game.ServerScriptService.Server
	local TaskContracts = require(Shared.TaskContracts)

	describe("TaskContracts", function()
		it("rejects unknown task types", function()
			expect(TaskContracts.getContract("NotARealTaskType")).to.equal(nil)
		end)

		it("knows MoveResource and ClearJam", function()
			expect(TaskContracts.getContract("MoveResource")).to.be.ok()
			expect(TaskContracts.getContract("ClearJam")).to.be.ok()
		end)

		it("allows valid state transitions", function()
			expect(TaskContracts.canTransition("Queued", "Claimed")).to.equal(true)
			expect(TaskContracts.canTransition("Claimed", "Running")).to.equal(true)
			expect(TaskContracts.canTransition("Running", "Done")).to.equal(true)
		end)

		it("rejects illegal state transitions", function()
			expect(TaskContracts.canTransition("Done", "Running")).to.equal(false)
			expect(TaskContracts.canTransition("Failed", "Done")).to.equal(false)
			expect(TaskContracts.canTransition("Queued", "Done")).to.equal(false)
		end)
	end)

	describe("TaskQueue", function()
		local FactoryBlackboard = require(Server.FactoryBlackboard)
		local TaskQueue = require(Server.TaskQueue)

		it("Carrier can claim MoveResource", function()
			local board = FactoryBlackboard.new()
			board:addStation({ id = "a", kind = "Extractor", capacity = 10, inventory = { Ore = 5 } })
			board:addStation({ id = "b", kind = "Machine", capacity = 10, inventory = { Ore = 0 } })
			local queue = TaskQueue.new(board)
			queue:enqueue("MoveResource", {
				sourceStationId = "a",
				targetStationId = "b",
				resourceKind = "Ore",
				amount = 1,
			})
			local worker = { id = "w1", role = "Carrier" }
			local claimed = queue:claimNext(worker)
			expect(claimed).to.be.ok()
			expect(claimed.type).to.equal("MoveResource")
			expect(claimed.state).to.equal("Claimed")
		end)

		it("Carrier cannot claim ClearJam", function()
			local board = FactoryBlackboard.new()
			board:addStation({ id = "a", kind = "Machine", capacity = 10, inventory = {} })
			local queue = TaskQueue.new(board)
			queue:enqueue("ClearJam", { targetStationId = "a", reason = "stuck" })
			local worker = { id = "w1", role = "Carrier" }
			expect(queue:claimNext(worker)).to.equal(nil)
		end)

		it("Fixer can claim ClearJam", function()
			local board = FactoryBlackboard.new()
			board:addStation({ id = "a", kind = "Machine", capacity = 10, inventory = {} })
			local queue = TaskQueue.new(board)
			queue:enqueue("ClearJam", { targetStationId = "a", reason = "stuck" })
			local worker = { id = "f1", role = "Fixer" }
			local claimed = queue:claimNext(worker)
			expect(claimed).to.be.ok()
			expect(claimed.type).to.equal("ClearJam")
		end)

		it("Fixer cannot claim MoveResource", function()
			local board = FactoryBlackboard.new()
			board:addStation({ id = "a", kind = "Extractor", capacity = 10, inventory = { Ore = 5 } })
			board:addStation({ id = "b", kind = "Machine", capacity = 10, inventory = { Ore = 0 } })
			local queue = TaskQueue.new(board)
			queue:enqueue("MoveResource", {
				sourceStationId = "a",
				targetStationId = "b",
				resourceKind = "Ore",
				amount = 1,
			})
			local worker = { id = "f1", role = "Fixer" }
			expect(queue:claimNext(worker)).to.equal(nil)
		end)

		it("rejects enqueue with missing required fields", function()
			local board = FactoryBlackboard.new()
			local queue = TaskQueue.new(board)
			expect(function()
				queue:enqueue("MoveResource", { sourceStationId = "a" })
			end).to.throw()
		end)
	end)

	describe("ResourceExecutor", function()
		local FactoryBlackboard = require(Server.FactoryBlackboard)
		local ResourceExecutor = require(Server.ResourceExecutor)

		it("moves resource from source to target", function()
			local board = FactoryBlackboard.new()
			board:addStation({ id = "a", kind = "Extractor", capacity = 10, inventory = { Ore = 5 } })
			board:addStation({ id = "b", kind = "Machine", capacity = 10, inventory = { Ore = 0 } })
			local executor = ResourceExecutor.new(board)
			local result = executor:execute({
				type = "MoveResource",
				sourceStationId = "a",
				targetStationId = "b",
				resourceKind = "Ore",
				amount = 3,
			})
			expect(result.moved).to.equal(3)
			expect(board.stations.a.inventory.Ore).to.equal(2)
			expect(board.stations.b.inventory.Ore).to.equal(3)
		end)

		it("cannot overdraw source inventory", function()
			local board = FactoryBlackboard.new()
			board:addStation({ id = "a", kind = "Extractor", capacity = 10, inventory = { Ore = 2 } })
			board:addStation({ id = "b", kind = "Machine", capacity = 10, inventory = { Ore = 0 } })
			local executor = ResourceExecutor.new(board)
			expect(function()
				executor:execute({
					type = "MoveResource",
					sourceStationId = "a",
					targetStationId = "b",
					resourceKind = "Ore",
					amount = 5,
				})
			end).to.throw()
		end)

		it("cannot exceed target capacity", function()
			local board = FactoryBlackboard.new()
			board:addStation({ id = "a", kind = "Extractor", capacity = 100, inventory = { Ore = 50 } })
			board:addStation({ id = "b", kind = "Machine", capacity = 10, inventory = { Ore = 8 } })
			local executor = ResourceExecutor.new(board)
			expect(function()
				executor:execute({
					type = "MoveResource",
					sourceStationId = "a",
					targetStationId = "b",
					resourceKind = "Ore",
					amount = 5,
				})
			end).to.throw()
		end)

		it("rejects unknown task type", function()
			local board = FactoryBlackboard.new()
			local executor = ResourceExecutor.new(board)
			expect(function()
				executor:execute({ type = "NotReal" })
			end).to.throw()
		end)
	end)

	describe("SupervisorAgent", function()
		local FactoryBlackboard = require(Server.FactoryBlackboard)
		local TaskQueue = require(Server.TaskQueue)
		local SupervisorAgent = require(Server.SupervisorAgent)

		it("suggests MoveResource when extractor is full", function()
			local board = FactoryBlackboard.new()
			board:addStation({
				id = "extractor-1",
				kind = "Extractor",
				capacity = 10,
				inventory = { Ore = 10 },
			})
			board:addStation({
				id = "machine-1",
				kind = "Machine",
				capacity = 10,
				inventory = { Ore = 0 },
			})
			local queue = TaskQueue.new(board)
			local supervisor = SupervisorAgent.new(queue)
			local suggestions = supervisor:inspect(board:snapshot())
			expect(#suggestions).to.equal(1)
			expect(suggestions[1].type).to.equal("MoveResource")
			expect(suggestions[1].sourceStationId).to.equal("extractor-1")
		end)

		it("makes no suggestion when extractor is not full", function()
			local board = FactoryBlackboard.new()
			board:addStation({
				id = "extractor-1",
				kind = "Extractor",
				capacity = 10,
				inventory = { Ore = 3 },
			})
			local queue = TaskQueue.new(board)
			local supervisor = SupervisorAgent.new(queue)
			local suggestions = supervisor:inspect(board:snapshot())
			expect(#suggestions).to.equal(0)
		end)
	end)

	describe("Validators", function()
		local FactoryBlackboard = require(Server.FactoryBlackboard)
		local Validators = require(Server.Validators)

		it("flags non-positive station capacity", function()
			local board = FactoryBlackboard.new()
			board:addStation({ id = "broken", kind = "Machine", capacity = 0, inventory = {} })
			local errors = Validators.validateSnapshot(board:snapshot())
			expect(#errors > 0).to.equal(true)
		end)

		it("accepts a healthy snapshot", function()
			local board = FactoryBlackboard.new()
			board:addStation({ id = "ok", kind = "Machine", capacity = 10, inventory = {} })
			local errors = Validators.validateSnapshot(board:snapshot())
			expect(#errors).to.equal(0)
		end)
	end)
end
