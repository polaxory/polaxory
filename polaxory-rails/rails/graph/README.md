# rail: graph

> The system graph. Source of truth per the prime law.
> Status: v0 sketch. Schema pending alignment with `POLAXORY_SYSTEM_GRAPH_SCHEMA_v1.md`.

---

## What this rail does

Holds the canonical graph for each slice. Nodes are modules; edges are events. The graph is what the game IS.

Other rails derive from the graph:
- Contracts derive their API surface from the graph
- Services implement the contracts
- Validators check the graph for completeness
- The build rail compiles the graph + downstream artifacts into a Studio slice

## Directory layout

```
rails/graph/
├── README.md                          ← this file
├── schema/
│   ├── node.schema.json               ← node schema (JSON Schema)
│   ├── edge.schema.json               ← edge schema (JSON Schema)
│   └── taxonomies.md                  ← node + edge taxonomies (enumerated types)
└── slices/
    └── slice-0-backrooms.graph.json   ← Slice 0 graph
```

## Node schema (draft — pending operator carve)

```json
{
  "id": "string (unique within slice)",
  "type": "string (from node taxonomy)",
  "label": "human-readable name",
  "category": "string (mechanic | agent | infrastructure | spectator | hazard)",
  "owns_state": ["string array of state keys this node owns"],
  "emits": ["array of event names this node can emit"],
  "subscribes": ["array of event names this node consumes"],
  "validates": ["array of invariant names this node maintains"],
  "persists": ["array of state keys this node persists across sessions"],
  "metadata": {}
}
```

## Edge schema (draft — pending operator carve)

```json
{
  "id": "string (unique within slice)",
  "type": "string (event | dependency | data_flow)",
  "from": "node id",
  "to": "node id",
  "event": "event name (matches an emits on `from` and a subscribes on `to`)",
  "guarantees": ["string array — e.g. ordered, deduplicated, at_least_once"],
  "metadata": {}
}
```

## Node taxonomy (draft — pending operator carve)

Categories of nodes the graph supports:

- **mechanic** — gameplay primitives (Generator, Door, Inventory, etc.)
- **agent** — agents per skills.md (HermesScout, KeyHunter, etc.)
- **infrastructure** — services, persistence, matchmaker
- **spectator** — human-facing observation/influence layers
- **hazard** — entities that threaten agents/players (TheWatcher, etc.)

## Edge taxonomy (draft — pending operator carve)

- **event** — A emits, B subscribes. Default kind.
- **dependency** — A depends on B's presence (not event-driven; structural).
- **data_flow** — A pushes a stream of data to B (e.g., agent telemetry to spectator).

## Slice 0 Backrooms — concrete example

The Slice 0 Backrooms graph lives at `rails/graph/slices/slice-0-backrooms.graph.json` (pending). It contains the Generator → Lights → Door → Hunter cascade and the agent rails for the three MVP agent types.

Example edge from the cascade:

```json
{
  "id": "edge-001",
  "type": "event",
  "from": "Generator",
  "to": "Lights",
  "event": "GeneratorFailed",
  "guarantees": ["ordered", "at_least_once"]
}
```

## Validation rules the graph rail enforces

(Implemented in `rails/validation/`; surfaced here as expectations.)

- Every node has a unique id within its slice
- Every node has a type from the taxonomy
- Every edge has both endpoints existing in the graph
- Every edge's event name appears in the source node's `emits` array
- Every edge's event name appears in the target node's `subscribes` array (unless event is marked `broadcast`)
- No orphan nodes (every node is connected to at least one edge, or marked as singleton)
- No circular dependencies in `dependency` edges

## Open questions

- Versioning per slice or per graph?
- Mutable graphs (live ops) vs immutable per slice?
- How does the graph handle sub-graphs (e.g., nested agent behaviors)?
- Is the graph machine-generated from intent, hand-edited, or both?

---

## Operator carve required

Blake's `POLAXORY_SYSTEM_GRAPH_SCHEMA_v1.md` is the canonical schema. This README's draft is a placeholder. Replace with the canonical schema and taxonomy once aligned. The build-blocking validation rules and the validator report shape from the constitution land in `rails/validation/`.
