# rail: agent

> Agent rails per `skills.md`. Agents plug into the module graph as event producers and consumers.
> Status: v0 sketch. The canonical skills.md spec lives at `/Users/blake.jaraczeski/polaxory/skills.md`.

---

## What this rail does

Loads agent manifests (`skills.md` documents), validates them against the runtime's registered actions, allocates resources per declared costs, routes game events per the subscribed/emitted lists, enforces failure behavior on the agent's behalf.

Agents become first-class graph participants alongside in-game modules. From the graph's perspective, an agent IS a node with declared edges.

## Where the spec lives

The canonical `skills.md` schema is at `/Users/blake.jaraczeski/polaxory/skills.md` (parent dir). This rail's job is to implement the runtime-side of that spec for Polaxory's engine.

We don't duplicate the spec here. We implement against it.

## How agents connect (target flow)

```
1. Agent issues a connection request to the runtime
   with its skills.md manifest as the payload

2. Agent rail validates the manifest:
   - schema check (matches skills.md v0.1)
   - actions check (every available_action maps to a runtime-registered action)
   - permissions check (declared permissions ⊆ game-specific permission set)
   - memory_scope check (declared scopes ⊆ runtime-exposed scopes)
   - game_events check (subscribed/emitted events exist in the graph)

3. If valid: agent gets allocated:
   - resource pool per declared costs
   - rate-limit budget per declared limits
   - subscription registrations per game_events_subscribed
   - emission rights per game_events_emitted

4. If invalid: connection rejected with structured error
   listing every failure (not just first)

5. Once connected: agent operates within rails
   - every action call goes through cost + cooldown gate
   - every emit gets validated against game_events_emitted
   - every event-receive matches game_events_subscribed
   - failure_behavior applied on errors per the manifest
```

## Directory layout

```
rails/agent/
├── README.md                       ← this file
├── runtime/
│   ├── manifest_loader.luau        ← parses + validates skills.md
│   ├── runtime_registry.luau       ← runtime's catalog of registered actions
│   ├── action_dispatcher.luau      ← routes agent actions through gates
│   ├── event_router.luau           ← routes game events to/from agents
│   ├── resource_allocator.luau     ← cost + cooldown enforcement
│   └── failure_handler.luau        ← failure_behavior enforcement
├── manifests/                      ← canonical agent manifests for Slice 0
│   ├── HermesScout.skills.md
│   ├── KeyHunter.skills.md
│   └── Saboteur.skills.md
└── adapters/                       ← bridges to external agent ecosystems
    ├── README.md
    ├── hypurrclaw/                 ← adapter for HypurrClaw agents
    ├── openclaw/                   ← adapter for OpenClaw agents
    └── hermes/                     ← adapter for HermesAgents
```

## Adapter pattern

Other agent ecosystems may not natively use skills.md. The adapter layer maps their conventions to skills.md and back. This is how the interop ambition becomes real without requiring other ecosystems to change their internals.

Each adapter:

- Takes the external system's manifest format
- Produces a skills.md document that the agent rail can load
- Maps external action invocations to internal action calls
- Routes events back to the external system in its native shape

## Validation rules the agent rail enforces

(Implemented in `rails/validation/` and surfaced here as agent-side expectations.)

- Manifest must declare `spec_version` and the runtime must support it
- Every action in `available_actions` must map to a runtime-registered action
- Permissions must not exceed game-specific limits
- Memory scopes must not exceed runtime-exposed scopes
- Subscribed/emitted events must exist as graph edges (or be marked `broadcast`)
- Cost declarations must be honored at action-invoke time
- Cooldowns must be honored at action-invoke time
- Failure behavior must be honored on errors

## Open questions

- Manifest discovery: agents push their manifest at connection, or runtime pulls from a registry?
- Hot reload of manifests: can an agent update its skills.md while running?
- Cross-runtime agents: can an agent operate in multiple Polaxory games simultaneously?
- Identity/signing: how does the runtime verify an agent's source ecosystem (HypurrClaw vs custom)? Cryptographic signature on the manifest?

---

## Operator carve required

The runtime-side enforcement details, the adapter conventions, and the cross-ecosystem identity model are operator decisions pending Blake's constitution carve. The implementation can begin once Slice 0's agent types (HermesScout, KeyHunter, Saboteur) have their skills.md manifests finalized.
