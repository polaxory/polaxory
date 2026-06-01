# Factory Slice 0 Codemap

This commit turns the research direction into a Rojo-ready Roblox project skeleton.

## Added rails

- `FactoryBlackboard` — shared world/task state
- `TaskContracts` — allowed task types, fields, roles, and transitions
- `TaskQueue` — validates and queues constrained worker actions
- `SupervisorAgent` — deterministic suggestion generator
- `Validators` — first static snapshot/task validation pass

## Slice 0 behavior

Boot state:

- extractor starts full of ore
- machine starts empty
- carrier and fixer workers exist
- supervisor detects the full extractor
- supervisor queues a `MoveResource` task
- validator reports whether the task graph is coherent

## Next coding pass

- add TestEZ package wiring
- add real worker behavior tree stepping
- add server-authoritative resource transfer execution
- add Remote contracts for approved UI interactions
- add CI: Selene, StyLua, Rojo build, TestEZ/headless validation
