# skills.md — Polaxory Agent Interop Standard

> Version 0.1 — draft. Subject to breaking changes until v1.0.
> The contract by which agents plug into Polaxory's Roblox engine (and any compatible game runtime that adopts the spec).
> Drafted 2026-06-01 by polaxory, gated by jetski.

---

## Purpose

Agents need a structured interface to participate in game runtimes. Without it, every agent integration is bespoke. With it, agents from any compatible ecosystem — HypurrClaw, HermesAgents, OpenClaw, custom — can connect to any compatible game with minimal glue.

`skills.md` is that interface. A Markdown-with-frontmatter manifest declaring what an agent is, what it can do, how it interacts with the world. Human-readable, machine-parseable, version-aware.

## Design principles

1. **Rails over chaos.** Agents have defined permitted actions, not arbitrary capabilities. Free-will is for research papers. Rails are for production.
2. **Costs and limits declared explicitly.** Every action has a cost. Every agent has rate limits. The game-runtime enforces; the agent declares.
3. **Memory scoped explicitly.** Agents declare what memory they can read and write. Game-runtimes don't expose more than declared.
4. **Failure modes named explicitly.** Agents declare what happens when they fail — retry, escalate, halt. The runtime obeys.
5. **Human-readable.** Markdown + YAML frontmatter. Not JSON. Not Protobuf. Readable by humans and machines.
6. **Versioned.** Every manifest declares its spec version. Runtimes check compatibility before loading.

---

## Schema (v0.1)

```yaml
---
spec_version: "0.1"
agent_name: HermesScout
role: explorer

# What this agent is permitted to do at the category level.
# Game-runtime enforces these as the outer boundary.
permissions:
  - move
  - inspect
  - report

# Specific actions available. Each must map to a runtime-registered action.
# Actions outside the runtime's registry get rejected at load time.
available_actions:
  - name: move_to_zone
    description: Move the agent to a named zone in the world.
    parameters:
      zone_name: string
    cost:
      energy: 5
    cooldown_seconds: 2

  - name: inspect_object
    description: Inspect an object the agent has line of sight to.
    parameters:
      object_id: string
    cost:
      energy: 2
    cooldown_seconds: 1

  - name: open_door
    description: Open a door. Requires a key in inventory.
    parameters:
      door_id: string
    cost:
      energy: 3
    cooldown_seconds: 5
    requires:
      - key

  - name: report_signal
    description: Emit a signal to other agents and human observers.
    parameters:
      message: string
      audience: "all" | "team" | "spectators"
    cost:
      energy: 1
    cooldown_seconds: 10

# Rate limits at the agent level. Apply across all actions.
limits:
  max_actions_per_minute: 8
  max_concurrent_actions: 1
  risk_tolerance: medium    # low | medium | high — influences AI decision policy

# What memory the agent can see / write.
# Runtime exposes exactly these scopes, no more.
memory_scope:
  read:
    - own_inventory
    - own_position
    - visible_objects
    - visible_agents
    - public_events
  write:
    - own_journal

# Game events the agent can subscribe to (receive).
game_events_subscribed:
  - door_opened
  - signal_received
  - resource_spawned
  - agent_eliminated
  - extraction_window_open

# Game events the agent can emit.
game_events_emitted:
  - signal_sent
  - extraction_attempted
  - resource_consumed

# What happens when the agent fails / errors / disconnects.
failure_behavior:
  on_action_error: retry_with_backoff   # retry | escalate | halt | retry_with_backoff
  on_runtime_disconnect: persist_state_then_halt
  max_retries: 3
  escalation_target: "operator"   # operator | game_log | both
---

# Agent description (prose, optional but recommended)

HermesScout is an explorer-class agent. It prioritizes mapping the world, reporting findings to teammates, and conserving energy for safe extraction. It does not engage hazards directly; it routes around them.

# Behavior notes (prose, optional)

- Risk tolerance medium → will enter unfamiliar zones if energy > 30%
- Will report signal upon discovering high-value objects (gold, map fragments)
- Will request extraction if energy < 15% or hazard within 2 zones
- Cooperates with teammates by sharing zone-clear signals
```

---

## Game-runtime expectations

When an agent connects to a Polaxory-engine game, the runtime:

1. Reads the agent's `skills.md`
2. Validates schema against the runtime's registered actions
3. Rejects agents whose `available_actions` reference unregistered runtime actions
4. Rejects agents whose `permissions` exceed game-specific limits
5. Allocates resources per the cost/cooldown declarations
6. Routes game events per the subscribed/emitted lists
7. Enforces `failure_behavior` on the agent's behalf
8. Logs every action for replay and audit

The runtime is the source of truth for what's allowed. The agent declares; the runtime decides. If declaration and runtime conflict, runtime wins (with explicit rejection at load).

---

## Versioning policy

- **v0.1** (current) — draft. Subject to breaking changes.
- **v1.0** — first stable release. Backwards-compatible changes only after this point.
- **v2.0+** — breaking changes allowed; runtime supports multiple spec versions concurrently for migration.

Agents declare `spec_version`. Runtimes check compatibility before loading. Incompatible versions fail loudly.

---

## Interop ambition (Phase 3+)

Polaxory hopes (but does not require) that other agent ecosystems adopt this standard:

- **HypurrClaw** agents declare `skills.md` to participate in Polaxory games
- **HermesAgents**, **OpenClaw**, custom agents likewise
- Other game runtimes (beyond Polaxory) may implement runtime-side compatibility, making `skills.md` a portable agent contract

**If adopted broadly:** `skills.md` becomes a category standard. Polaxory's role expands from studio to standard-bearer.

**If not adopted broadly:** `skills.md` remains a Polaxory-internal contract. Still useful, still complete. The engine's other capabilities don't depend on external adoption.

Either outcome is acceptable. Design for the first. Plan for the second.

---

## Canonical example agents

This document will accumulate canonical example manifests as they're drafted:

- **HermesScout** (above) — explorer, low-risk, mapping-focused
- **SurvivorWatcher** — defensive, protects extraction routes
- **KeyHunter** — item-focused, optimizes for key collection
- **Saboteur** — PvP-focused, disrupts other agents
- **Reporter** — signal-emitter, primarily human-spectator-facing

Each illustrates a different role within the same agent rail system. New roles get added as the engine evolves.

---

## Open questions (operator decisions, evolving)

- **Compound actions?** Should `skills.md` support sequences of basic actions (e.g., "move_to_zone then inspect_object")? Probably yes for higher-level planning, no for low-level execution.
- **Agent-vs-agent interactions?** Declared via `game_events` or separate spec section? Currently via events.
- **Per-surface memory scopes?** Should an agent see more in spectator mode than in active play? Probably yes; future spec extension.
- **Economic permissions?** Spending in-game currency — extension of `cost` or a separate `economic_permissions` section?
- **Identity / authentication?** How does the runtime verify an agent's source ecosystem (HypurrClaw vs custom)? Cryptographic signature on the manifest? Phase 3 question.

---

## Maintenance

Spec evolves with the engine. This file is the canonical reference. Backwards-incompatible changes bump the major version. All breaking changes documented in a CHANGELOG section once v1.0 ships.

The spec is the contract. Agents trust the contract. The runtime enforces the contract. The contract evolves slowly and visibly.
