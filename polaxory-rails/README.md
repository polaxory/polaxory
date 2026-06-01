# polaxory-rails

> The Roblox-native games-on-rails engine. Where creator intent becomes a validated, deployable Studio slice — not a pile of generated scripts.
>
> Status: **v0 scaffolding.** Built 2026-06-01 from the constitution Blake drafted externally. Skeleton structure pending faithful alignment with `POLAXORY_RAILS_CONSTITUTION_v0.md` and `POLAXORY_SYSTEM_GRAPH_SCHEMA_v1.md`.

---

## Prime law

> **The server is the game. The graph is the source of truth. Scripts are artifacts.**

Everything in this repo defers to that. Scripts are downstream of contracts. Contracts are downstream of the graph. The graph is downstream of the creator's intent.

Reverse the order at any point and the system stops being a rails engine and becomes another script generator. The difference is what makes Polaxory defensible against Roblox Assistant — Assistant generates scripts; Polaxory generates *systems that hold together*.

---

## The seven rails

Each rail is a directory under `rails/`. Each has a README explaining what it does, what it consumes, and what it produces.

| Rail | What it does |
|---|---|
| **intent** | Captures the creator's design intent in a structured, declarative form. The input layer. |
| **graph** | The system graph — nodes (modules) and edges (events). Source of truth for what the game IS. |
| **contract** | Per-module contracts: API surface, emits, subscribes, validates, persists. |
| **authority** | Enforces the prime law. Server-side ownership of state. No client-trusted writes. |
| **validation** | Static + runtime validators. Build-blocking rules. The validator report. |
| **build** | Rojo-driven pipeline that turns graph + contracts → Studio-ready slice. |
| **agent** | Agent rails per `skills.md`. Agents plug into the module graph as event producers / consumers. |

---

## The weave

```
creator intent
   ↓
graph                              ← source of truth
   ↓
contracts                          ← module surfaces declared
   ↓
services                           ← server-authoritative implementation
   ↓
validators                         ← build-blocking checks
   ↓
Rojo build                         ← deterministic artifact
   ↓
Studio-ready slice
```

Each step is a transformation; each transformation has a contract; each contract has validators. The system holds together because every junction is checked.

---

## Repo structure

```
polaxory-rails/
├── README.md                     ← this file
├── default.project.json          ← Rojo config (source roots, sync map)
├── wally.toml                    ← Wally package config
├── selene.toml                   ← Selene static analysis config
├── stylua.toml                   ← StyLua formatter config
├── .luaurc                       ← Luau project config (strictness, globals)
├── .gitignore
├── docs/
│   ├── PRIME_LAW.md              ← the server-is-the-game discipline
│   ├── SEVEN_RAILS.md            ← the seven rails, in depth
│   └── WEAVE.md                  ← the data-flow contract between rails
├── rails/                        ← the seven rails, each its own subsystem
│   ├── intent/                   ← creator intent capture
│   ├── graph/                    ← node + edge schema, slices
│   ├── contract/                 ← module contracts
│   ├── authority/                ← server-as-source-of-truth enforcement
│   ├── validation/               ← validators + report shape
│   ├── build/                    ← Rojo pipeline
│   └── agent/                    ← skills.md plumbing
├── src/                          ← Roblox source root (per Rojo conventions)
│   ├── client/
│   ├── server/
│   └── shared/
└── tools/                        ← validators, build orchestration, headless tests
```

---

## Build path (Phase 1)

In sequence, but each step unblocks the next:

1. **Rails READMEs** — each rail explained, conventions stated. Operator-readable. (Status: scaffolded in v0.)
2. **Graph schema** — node + edge schema, taxonomies, validator rules. Mirrors `POLAXORY_SYSTEM_GRAPH_SCHEMA_v1.md`. (Status: pending alignment with Blake's schema doc.)
3. **Slice 0 Backrooms graph** — the first concrete graph. Generator → Lights → Door → Hunter cascade. (Status: pending.)
4. **Contract scaffolding** — TypeScript or Luau interfaces for module contracts. (Status: pending.)
5. **Validators** — implementations of the build-blocking rules. (Status: pending.)
6. **Rojo build** — `default.project.json` + Wally + Selene + StyLua configured. (Status: configs scaffolded; not yet wired.)
7. **Open Cloud Luau headless validation** — CI runner that validates Slice 0 end-to-end without Studio. (Status: pending.)
8. **Studio plugin** — later, not first. After the headless pipeline proves the validation surface.

---

## Operator notes

- This skeleton was scaffolded automatically. Every rail's README is a v0 sketch — Blake's carve is required before the rail's contract is locked.
- The constitution lives outside this repo (Blake's external location). The repo references its terminology but doesn't yet inline the canonical text. When the constitution is shared or mirrored, `docs/PRIME_LAW.md` and `docs/SEVEN_RAILS.md` get updated to be faithful excerpts.
- The skills.md spec for agent rails lives at `/Users/blake.jaraczeski/polaxory/skills.md` (parent directory). This repo's `rails/agent/` references it rather than duplicating.

---

## Maintenance

The skeleton evolves with the constitution. Breaking changes to the graph schema require a version bump (`v1.0` → `v2.0`). Additive changes to a rail's contract get noted in that rail's README CHANGELOG section.

The prime law does not change.
