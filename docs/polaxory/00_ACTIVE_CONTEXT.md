# Polaxory Active Context

Purpose: tiny working context for future turns. Load this first. Do **not** load the whole research pile unless a specific source is needed.

## Current thesis

Polaxory is **Roblox games on rails**: a production layer that turns messy creator intent into validated, interconnected Roblox systems instead of random scripts.

## One-line product

**Give Polaxory one game idea. It returns a secure, editable Roblox production build.**

## First proof

A Backrooms-inspired Roblox vertical slice proving the rails engine:

- one map sector
- generator
- fuse/resource
- locked door
- hunter/entity
- safe room
- extraction
- module graph
- validator report
- Rojo/Studio-ready build candidate

## Strategic decision

Game first. Engine underneath. Protocol later.

Do not lead with token. Do not lead with generic AI scripting. Lead with a working, validated Roblox build.

## Defensible wedge

Roblox Assistant can generate code. Polaxory should own:

- deterministic module graph
- reusable mechanics contracts
- server-authoritative templates
- validators
- CI/testing loop
- creator-ready production structure

## Core build pipeline

```txt
creator prompt
  -> GDD/spec
  -> module graph
  -> configs/contracts
  -> Rojo project files
  -> static validators
  -> engine validation
  -> Studio-ready build candidate
```

## Canonical artifacts created

1. `POLAXORY_RAILS_SPEC_v0.md` — rails constitution: product boundary, required stack, module/remote/resource/event/skill contracts, validation tiers, Slice 0 minimum.
2. `POLAXORY_SYSTEM_GRAPH_SCHEMA_v1.md` — graph schema: node/edge types, Backrooms Slice 0 draft graph, scenario shape, validation rules, report shape.
3. `POLAXORY_VALIDATOR_CONTRACTS_v0.md` — validator suite.

## Current implementation focus

Build **Signal Run v0** before adding more rails or lore. The next shippable artifact is the smallest Roblox playable loop that proves:

```txt
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
```

Implementation target:

1. Wire the existing `src/shared`, `src/server`, and `src/client` skeleton around the proof loop instead of adding parallel scaffolding.
2. Keep telemetry aggregate-first in `TelemetryBuffer.luau` and `RoundTelemetryLoop.server.luau`.
3. Keep reward proof isolated from raw player IDs via `RoundCompletionRewards.luau` and `RoundCompletionRewardPanel.client.luau`.

Acceptance check: each transition in the proof loop should be traceable to one server-owned state change and one player-visible feedback point before new rails or lore are added.

## Required stack

- Rojo
- Selene
- StyLua
- Wally
- luau-lsp
- TestEZ
- Open Cloud Luau Execution
- GitHub Actions

## Non-negotiable constraints

- Server authoritative by default.
- External agents never execute arbitrary Roblox code.
- Agents submit constrained actions through a DSL/gateway.
- Every Remote needs schema, rate limit, permission rule, and server validation.
- Every module must register events/resources/tests/validators.
- Token utility stays off-platform as build infra.

## Context rule

Use this file as the compact memory. Only open source docs when writing specific specs or checking exact details.
