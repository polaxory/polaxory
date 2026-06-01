# POLAXORY Rails Constitution v0

Date: 2026-06-01
Status: Canonical draft

## 0. Thesis

Polaxory is not “AI writes Roblox scripts.”

Polaxory is a **contract-bound production rail system** for Roblox worlds:

```txt
creator intent -> slice spec -> system graph -> contracts -> modules -> validators -> Studio-ready build
```

The art is that the world becomes legible before it becomes executable.

Every door, entity, resource, remote, skill, validator, and agent action must have a place in the graph. If it cannot be named, owned, connected, validated, and explained, it does not ship.

## 1. Prime law

**The server is the game. The graph is the source of truth. Scripts are artifacts.**

Client UI, agents, and creator prompts may request change. They do not author authoritative state directly.

## 2. The rails

A Polaxory build stands on seven rails:

1. **Intent rail** — creator asks are converted into structured slice specs.
2. **Graph rail** — all gameplay systems become nodes and edges.
3. **Contract rail** — modules, remotes, resources, events, skills, and validators declare boundaries before implementation.
4. **Authority rail** — gameplay mutation is server-owned by default.
5. **Validation rail** — every generated project must fail closed.
6. **Build rail** — Rojo produces reproducible Roblox project structure.
7. **Agent rail** — external agents submit constrained actions, not raw code or arbitrary state diffs.

## 3. Non-negotiables

- Server-authoritative by default.
- Client sends intent only.
- Agent actions go through `PXActionService`.
- Every Remote has a contract card.
- Every module declares owner, dependencies, events, resources, tests, and validators.
- Every resource has source/sink logic or an explicit exemption.
- Every event has producer/consumer logic or is marked terminal.
- Every skill has actor rules, target rules, cost, cooldown, resolver, and telemetry.
- Every validator failure blocks promotion.
- Token/protocol utility stays off-platform infrastructure, not direct Roblox gameplay currency.

## 4. Product boundary

Polaxory **is**:

- a Roblox production constitution;
- a system graph schema;
- a contract library;
- a validator suite;
- a Rojo-ready project skeleton;
- a constrained agent action gateway;
- eventually a creator cockpit for editing specs, graphs, contracts, validation reports, and build candidates.

Polaxory **is not**:

- a generic chatbot inside Studio;
- a loose Luau script generator;
- a client-authoritative game kit;
- a token-gated gameplay economy;
- a marketplace before the rails are proven.

## 5. System spine

```txt
GDD / Slice Spec
  -> PX System Graph
  -> Contract Registry
  -> Module Registry
  -> Rojo Filesystem
  -> Static Validators
  -> TestEZ Suites
  -> Open Cloud Luau Execution Scenario
  -> Build Candidate Report
```

The graph is the loom. Contracts are the thread. Validators are the tension. The final Roblox place is the cloth.

## 6. Canonical services

Minimum server-side services for Slice 0:

- `PXGraphRegistry`
- `PXActionService`
- `PXResourceService`
- `PXFacilityService`
- `PXDoorService`
- `PXHorrorDirectorService`
- `PXZoneService`
- `PXTelemetryService`
- `PXValidationService`

## 7. Agent law

Agents may submit only:

```json
{
  "actorId": "Agent.Builder01",
  "skillId": "Builder.RepairGenerator",
  "targetId": "Facility.GeneratorA",
  "inputs": {},
  "reasoningRef": "optional-trace-id"
}
```

Agents may not submit raw Luau, arbitrary Roblox instance mutations, final resource deltas, direct Remote payloads, server state patches, or unsafe module edits outside contract boundaries.

## 8. Backrooms Slice 0 proof

Minimum dramatic loop:

```txt
GeneratorFailed
  -> lights degrade
  -> Door17 locks
  -> Hunter activates
  -> Scout scans HallwayA
  -> Builder repairs GeneratorA
  -> Battery/Signal constraints resolve
  -> Door17 unlocks
  -> player extracts
```

## 9. Build stack

- Rojo
- Selene
- StyLua
- Wally
- TestEZ
- Open Cloud Luau Execution
- GitHub Actions

## 10. Done definition

Rails v0 is done when constitution, graph schema, validator contracts, Slice 0 graph, Rojo skeleton, lint/format, TestEZ, Open Cloud engine scenario, and Studio-ready build candidate exist.

## 11. Cut line

Do not expand into pitch sprawl. Build the rails. Then prove them with one beautiful, inspectable slice.
