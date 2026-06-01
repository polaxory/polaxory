# rail: contract

> Per-module contracts. The formal API surface of each module.
> Status: v0 sketch. Schema pending alignment with `POLAXORY_RAILS_CONSTITUTION_v0.md`.

---

## What this rail does

Holds the contract for every module in the graph. A contract is the truth; the code implements it.

Derived from the graph: every node in the graph has a contract. The contract declares what the module exposes (public API), emits (events), subscribes to (events), validates against (invariants), and persists (state).

When a contract changes, the graph and the implementing service have to track. The validator catches drift.

## Contract structure (draft — pending operator carve)

Each module has a contract file in `rails/contract/modules/{module_name}.contract.luau` (or `.json`).

```luau
-- contract: Generator
return {
  module_name = "Generator",
  node_id = "node-generator-001",
  category = "mechanic",
  
  -- Public API exposed to other modules (via the runtime, not direct calls)
  api = {
    GetState = { returns = "GeneratorState" },
    Restart = { params = { reason = "string" }, returns = "boolean" },
  },
  
  -- Events emitted (each must match a graph edge)
  emits = {
    "GeneratorFailed",
    "GeneratorRestarted",
  },
  
  -- Events subscribed to
  subscribes = {
    "PowerSurgeDetected",
    "MaintenanceWindowOpened",
  },
  
  -- Invariants this module maintains
  validates = {
    "generator_state_is_running_or_failed",
    "no_negative_power_output",
  },
  
  -- State this module owns and persists
  persists = {
    "power_output",
    "last_failure_timestamp",
    "restart_count",
  },
  
  -- Authority: server-only writes for all persistent state
  authority = "server",
}
```

## Contract conventions

- Contracts are versioned. Breaking changes bump the version. The runtime supports concurrent versions during migration.
- Contracts are reviewed before they merge. Changes here ripple through the graph and services.
- Every contract has a corresponding test scenario in `rails/contract/tests/`.

## Validation rules

(Implemented in `rails/validation/`; surfaced here as contract-side expectations.)

- Every event in `emits` must correspond to an outgoing edge in the graph
- Every event in `subscribes` must correspond to an incoming edge in the graph
- Every state key in `persists` must be writable only by the module (no other module can write)
- `authority = "server"` is required for any module that owns persisted state (prime law)
- API methods must declare param + return types (Luau strict mode)

## Slice 0 Backrooms — modules

The Slice 0 Backrooms graph references these contracts (each scaffolded under `rails/contract/modules/`):

- `Generator.contract.luau`
- `Lights.contract.luau`
- `Door.contract.luau`
- `Hunter.contract.luau`
- `Inventory.contract.luau`
- `ResourceEconomy.contract.luau`
- `ExtractionPoint.contract.luau`
- `SpectatorPanel.contract.luau`

Plus contracts for each agent type per `skills.md`:

- `HermesScout.skills.md` → derived contract
- `KeyHunter.skills.md` → derived contract
- `Saboteur.skills.md` → derived contract

## Open questions

- TypeScript or Luau for contract files? Luau lets validators run in the Roblox runtime; TypeScript lets validators run in CI.
- Contract diffing: how do we visualize what changes when a contract updates?
- Contract → service code generation: do we generate stub Luau services from contracts, or hand-write them against the contract?
- How are contracts shared between client and server modules?

---

## Operator carve required

The contract schema, the validation rules, and the conventions for evolving contracts come from Blake's constitution. This README is a placeholder. Replace with canonical once aligned.
