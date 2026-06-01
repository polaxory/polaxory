# Factory Slice 0 Acceptance Criteria

## Goal

Create the smallest Polaxory loop that proves both game feel and agent rails.

The player should understand the toy factory within 30 seconds and see one worker complete one useful task without reading an architecture doc.

## Player-facing loop

1. A raw item appears in an input bin.
2. A cute worker notices the item.
3. The worker carries or transforms it.
4. The output bin receives the completed item.
5. The player receives coins/progress/positive feedback.
6. The supervisor suggests one simple improvement.
7. The player approves or ignores it.

## System-facing loop

```text
FactoryBlackboard records world state
SupervisorAgent proposes a constrained task
TaskQueue validates and enqueues it
WorkerBehaviorTree claims and executes it
ResourceExecutor mutates authoritative resources
Validators check graph/resource coherence
HUD reflects the result
```

## Acceptance criteria

- The loop can run in Studio with no external services.
- At least one worker can complete at least one task.
- Resource changes happen on the server.
- Client UI can display task/progress state.
- Invalid tasks are rejected with readable reasons.
- The blackboard exposes enough state for debugging.
- The slice does not require LLM calls.

## Non-goals

- No monetization.
- No complex tycoon economy.
- No multi-agent chat UI.
- No autonomous code-writing agents inside Roblox.
- No procedural factory generation yet.

## Test/check ideas

- Task contract rejects missing fields.
- Worker cannot claim already-claimed task.
- ResourceExecutor refuses client-side mutation.
- Validator detects negative inventory.
- Supervisor only proposes allowlisted task types.

## Handoff for Claude Code

Task: implement or tighten Factory Slice 0 from this acceptance doc.

Files to inspect:

```text
default.project.json
src/server/**
src/client/**
src/shared/**
docs/agentic/**
```

Acceptance: commit small, keep modules documented, and add/update tests where possible.

## Handoff for Nullsec bot

Watch for:

- broad unsafe rewrites,
- CI failures,
- client-authoritative resource mutation,
- task contracts becoming free-form strings,
- docs drifting from implementation.
