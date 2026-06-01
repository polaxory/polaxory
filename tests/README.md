# Polaxory Factory Slice 0 Tests

TestEZ contract + behavior tests for the Factory Slice 0 rails.

## Layout

- `factory_slice_0.spec.luau` — TestEZ test suite, 15 cases across TaskContracts, TaskQueue, ResourceExecutor, SupervisorAgent, and Validators.

## Running (Roblox Studio)

1. Install toolchain: `aftman install`
2. Resolve Wally packages (TestEZ lives in dev-dependencies): `wally install`
3. Sync via Rojo: `rojo serve default.project.json`
4. In Studio, create a server-side runner script:
   ```luau
   local TestEZ = require(game.ReplicatedStorage.DevPackages.TestEZ)
   local results = TestEZ.TestBootstrap:run({ workspace.tests })
   print(results)
   ```

The Rojo project file does not yet sync `DevPackages` or `tests/` into the DataModel — that wiring is part of issue #31 (Open Cloud headless runner) and a small follow-up to expose the tests folder. For Studio runs today, drag the `tests/` folder into Workspace and `DevPackages` into ReplicatedStorage manually after `wally install`.

## Headless runner (planned)

Wiring TestEZ execution into CI via Open Cloud Luau Execution is tracked in **issue #31**.

## What's covered

Maps to `docs/slices/FACTORY_SLICE_0_ACCEPTANCE.md` → "Test/check ideas":

- ✅ Task contract rejects unknown task types
- ✅ Task contract rejects missing required fields
- ✅ Carrier claims MoveResource, cannot claim ClearJam
- ✅ Fixer claims ClearJam, cannot claim MoveResource
- ✅ State transition rules: Queued→Claimed→Running→Done allowed; illegal hops rejected
- ✅ ResourceExecutor refuses overdraw
- ✅ ResourceExecutor refuses exceeding target capacity
- ✅ ResourceExecutor rejects unknown task types
- ✅ Validator detects non-positive station capacity
- ✅ Validator accepts a healthy snapshot
- ✅ Supervisor proposes MoveResource only when extractor is full
- ✅ Supervisor stays silent when extractor is not full

## What's deliberately not covered yet

- Multi-tick simulation (worker → done flow over many step calls)
- DataStore persistence
- Remote rate-limit enforcement (depends on remote wiring in issue #30 / task #30 in the agent task system)
- Open Cloud engine validation in CI (issue #31)
