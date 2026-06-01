# Worker Execution Loop

Polaxory workers are intentionally boring at first. That is the point.

They do not freeform-plan. They:

1. read queued tasks from the FactoryBlackboard
2. claim only tasks allowed by their role contract
3. transition through approved states
4. execute a server-authoritative resource operation
5. report Done or Failed

This gives us cute visible workers in Roblox while preserving a future path to agentic task routing.

## Current modules

- `TaskContracts` defines allowed task shapes and role permissions.
- `TaskQueue` validates and claims tasks.
- `ResourceExecutor` mutates resources on the server only.
- `WorkerBehaviorTree` steps workers through deterministic task execution.
- `SupervisorAgent` proposes constrained tasks rather than arbitrary code.

## Next rails

- add stable suggestion ids
- make approval required before applying supervisor suggestions
- add remote schema validator middleware
- persist factory graph snapshots
- add TestEZ assertions around every transition
