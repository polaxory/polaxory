# SEVEN_RAILS.md

> The seven rails that make up Polaxory's games-on-rails engine.
> Each rail is a directory under `rails/`. Each has its own README with the rail's contract.

---

## 1. intent

**The input layer.** Captures the creator's design intent in a structured, declarative form.

Intent is not a graph yet — it's the upstream description of what the creator wants. A horror game. A simulator. A social hangout. With specific mechanics, specific aesthetics, specific monetization shape.

The intent file is the first thing a creator writes. The graph rail transforms it into a graph. The contract rail derives contracts from the graph. Down the line everything serves the intent.

Format: JSON or YAML, structured but human-writable. See `rails/intent/README.md` for schema.

## 2. graph

**Source of truth.** The system graph — nodes (modules) and edges (events).

Per the prime law, the graph is canonical. Code is downstream. Every module that ships has a node in the graph. Every event that fires has an edge.

Schema details live in `POLAXORY_SYSTEM_GRAPH_SCHEMA_v1.md` (Blake's constitution) and mirror to `rails/graph/`.

Slice 0 (the first concrete graph for the Backrooms flagship) lives at `rails/graph/slices/slice-0-backrooms.graph.json`.

## 3. contract

**Module surfaces declared.** Per-module contracts that say what each module exposes, emits, subscribes to, validates, persists.

A contract is the formal interface of a module. Code implements the contract; the contract is the truth. If a module's behavior diverges from its contract, the validator catches it at build time.

See `rails/contract/README.md` for the contract schema.

## 4. authority

**Server-as-source-of-truth enforcement.** Where the prime law is enforced mechanically.

This rail contains the patterns and helpers that make server-authority effortless: remote-event wrappers with built-in validation, signed action protocols, persistence patterns that mark client-input vs server-derived state.

If you find yourself wanting client-trusted state, the authority rail tells you no and gives you the correct pattern.

## 5. validation

**Build-blocking checks.** Static + runtime validators.

Static: catches issues at Rojo build time. "Module X emits event Y, but no module subscribes to Y" → build fails. "Node X has no contract" → build fails.

Runtime: catches issues during game execution. "Player tried to write to inventory without server permission" → action rejected, audit log entry.

Reports follow a documented shape — see `rails/validation/README.md` for the validator report schema.

## 6. build

**Rojo-driven pipeline.** Turns graph + contracts + services into a Studio-ready slice.

The build rail is the deterministic transformation: graph → contracts → services → Rojo → slice. Same input always produces the same output. Reproducible builds matter for review, for audit, for confidence.

`default.project.json` at the repo root configures Rojo. The build rail's README explains the full pipeline.

## 7. agent

**skills.md plumbing.** Agent rails integration.

Agents per the `skills.md` spec (parent directory: `/Users/blake.jaraczeski/polaxory/skills.md`) declare their permitted actions, costs, cooldowns, event subscriptions, failure behavior. The agent rail wires those declarations into the module graph as event producers and consumers.

When an agent connects, the agent rail validates its `skills.md` against the runtime's registered actions, allocates resources per declared costs, routes events per the manifest. Agents become first-class participants in the graph alongside in-game modules.

---

## The order

The order matters. Each rail consumes from rails above it.

```
1. intent           (creator writes)
       ↓
2. graph            (system structure derived from intent)
       ↓
3. contract         (module surfaces derived from graph)
       ↓
4. authority        (prime law enforced as code patterns)
       ↓
5. validation       (the above three checked)
       ↓
6. build            (validated graph + contracts → slice)
       ↓
7. agent            (agents plug in to the running graph)
```

Reversing the order at any junction is the failure mode. Code without a contract. Contract without a graph node. Graph without intent. Each violation breaks a junction the validator was meant to enforce.

The seven rails are not seven things to remember. They are the canonical order, and the order is the rule.
