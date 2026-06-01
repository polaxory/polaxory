# POLAXORY Rails Spec v0

Date: 2026-06-01
Status: Canonical working draft

## Purpose

Polaxory is **Roblox games on rails**. The rails prevent AI-generated Roblox projects from becoming random script piles. A Polaxory build must be understandable as:

```txt
intent -> spec -> graph -> contracts -> modules -> validators -> Studio-ready build
```

## Prime directive

**The server is the game. The graph is the source of truth. Scripts are implementation artifacts.**

## Non-negotiables

- Server-authoritative by default.
- Client sends intent only.
- External agents never execute arbitrary Roblox code.
- Every client/server Remote has a contract card.
- Every module declares dependencies, emitted events, listened events, resources, tags, tests, and validators.
- Every gameplay mechanic exists as graph nodes and edges before codegen.
- Every generated file has an owning module and boundary.
- Every validator failure blocks publish/build promotion.
- Token/protocol utility remains off-platform build infra.

## Build pipeline

```txt
Creator brief
  -> Game Design Doc / Slice Spec
  -> System Graph
  -> Module Contracts
  -> Remote Contracts
  -> Resource/Event/Skill Manifests
  -> Rojo filesystem project
  -> Static validation
  -> Unit/integration tests
  -> Engine-backed validation through Open Cloud Luau Execution
  -> Studio-ready build candidate
```

## Required stack

- Rojo
- Selene
- StyLua
- Wally
- luau-lsp
- TestEZ
- Open Cloud Luau Execution
- GitHub Actions

## Canonical repo shape

```txt
polaxory-rails/
  README.md
  default.project.json
  wally.toml
  selene.toml
  stylua.toml
  aftman.toml or rokit.toml
  src/
    ReplicatedStorage/PX/Shared/
    ServerScriptService/PXServer/Services/
    StarterPlayer/StarterPlayerScripts/PXClient/
    StarterGui/PXUI/
  tests/
    unit/
    integration/
    engine/
  docs/
```

## Contracts

Required contract types:

- module contract
- remote contract
- resource contract
- event contract
- skill manifest contract

## Agent gateway rule

External agents may only submit `{ actorId, skillId, targetId, inputs, reasoningRef }`. They may not submit Luau code, arbitrary instance mutations, Remote payloads, server state diffs, or economy/resource final values.

## Validation tiers

- Tier 0 — Spec validation
- Tier 1 — Static project validation
- Tier 2 — Luau tests
- Tier 3 — Engine validation

## Backrooms Slice 0 minimum

Must include rooms, generator, battery, signal, Door17, Hunter01, safe room, extraction door, scout/builder/saboteur skills, graph integrity, and remote security.

Scenario:

```txt
GeneratorFailed -> lights degrade -> Door17 locks -> Hunter activates -> Scout scans -> Builder repairs -> Battery restored -> Door17 unlocks -> player extracts
```

## Done definition

Rails v0 is done when graph schema, validator contracts, Slice 0 graph, Rojo skeleton, lint/format, TestEZ, Open Cloud validation, and Studio-openable build candidate exist.

## Cut line

Do not build full Studio plugin, marketplace, token staking app, many templates, procedural map generator, or arbitrary AI script editing yet. The current job is constitution, graph, validators, slice.
