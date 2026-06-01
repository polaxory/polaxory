# rail: validation

> Static + runtime validators. Build-blocking rules and the validator report.
> Status: v0 sketch. Rule set and report shape pending alignment with `POLAXORY_RAILS_CONSTITUTION_v0.md`.

---

## What this rail does

Runs the build-blocking validators. If a graph + contracts + services combination violates any rule, the validator reports the violation and the build fails.

Two modes:

- **Static** — runs at Rojo build time. Catches structural issues before the slice ships.
- **Runtime** — runs during game execution. Catches behavioral issues that only manifest under live load.

Both modes report into the same shape so reports are comparable across modes and over time.

## Directory layout

```
rails/validation/
├── README.md                  ← this file
├── rules/
│   ├── graph/
│   │   ├── all_edges_have_endpoints.luau
│   │   ├── all_emits_have_subscribers.luau
│   │   ├── no_orphan_nodes.luau
│   │   └── no_circular_dependencies.luau
│   ├── contract/
│   │   ├── all_nodes_have_contracts.luau
│   │   ├── contract_events_match_graph_edges.luau
│   │   └── server_owned_state_marked.luau
│   ├── authority/
│   │   ├── no_raw_remote_events.luau
│   │   ├── no_unauthorized_state_writes.luau
│   │   └── all_writes_audit_logged.luau
│   └── runtime/
│       ├── audit_log_integrity.luau
│       └── invariant_violations.luau
├── report.schema.json         ← validator report shape
└── runner/
    ├── static_runner.ts       ← runs at build time
    └── runtime_runner.luau    ← runs in-game
```

## Validator report shape (draft — pending operator carve)

```json
{
  "report_version": "0.1",
  "slice_id": "slice-0-backrooms",
  "run_id": "run-2026-06-01T18:45:00Z-abc123",
  "mode": "static" | "runtime",
  "result": "PASS" | "FAIL",
  "rules_run": 18,
  "rules_passed": 16,
  "rules_failed": 2,
  "findings": [
    {
      "rule_id": "graph.all_emits_have_subscribers",
      "severity": "error",
      "message": "Module 'Generator' emits 'GeneratorRestarted' but no module subscribes.",
      "location": {
        "node_id": "node-generator-001",
        "file": "rails/graph/slices/slice-0-backrooms.graph.json",
        "line": null
      },
      "suggested_fix": "Add a subscriber for 'GeneratorRestarted' or mark the event as 'broadcast' in the edge metadata."
    }
  ],
  "metadata": {
    "started_at": "...",
    "completed_at": "...",
    "elapsed_ms": 234
  }
}
```

## Build-blocking rules (initial set — pending operator carve)

### Graph rules
- **all_edges_have_endpoints** — every edge has a `from` and `to` referencing existing nodes
- **all_emits_have_subscribers** — every event in a node's `emits` has at least one subscriber (or is marked `broadcast`)
- **no_orphan_nodes** — every node is connected to at least one edge, or marked `singleton`
- **no_circular_dependencies** — `dependency`-type edges form a DAG

### Contract rules
- **all_nodes_have_contracts** — every node in the graph has a contract file
- **contract_events_match_graph_edges** — every event in a contract's emits/subscribes maps to a graph edge
- **server_owned_state_marked** — every persistent state field has an authority marker

### Authority rules
- **no_raw_remote_events** — no `RemoteEvent:FireServer` calls outside the authority rail's wrappers
- **no_unauthorized_state_writes** — no writes to `serverOwned` state from non-authority code
- **all_writes_audit_logged** — every state change writes an audit log entry

### Runtime rules
- **audit_log_integrity** — audit log entries are sequential, signed, and not retroactively modified
- **invariant_violations** — runtime catches contract invariants violated during play

## Severity levels

- **error** — build fails. Must fix before merge.
- **warn** — build passes with warning. Operator decides whether to address before launch.
- **info** — observational. Useful for trends, not for gates.

## Open questions

- Should the validator have a "fix mode" that auto-applies simple fixes (e.g., adding broadcast tags)?
- How are rule sets versioned? When a new rule is added, do existing graphs grandfather in until they touch the affected area?
- Runtime validator overhead — at what frequency does runtime validation run? Per-action? Per-frame? Sampled?
- Cross-slice validators — rules that only make sense across multiple slices (e.g., consistent versioning).

---

## Operator carve required

The rule set, the report shape, and the severity model come from Blake's constitution. This README is a placeholder. Replace with canonical once aligned.
