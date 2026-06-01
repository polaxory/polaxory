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
2. `POLAXORY_SYSTEM_GRAPH_SCHEMA_v0.md` — graph schema: node/edge types, Backrooms Slice 0 draft graph, scenario shape, validation rules, report shape.
3. `POLAXORY_VALIDATOR_CONTRACTS_v0.md` — validator suite.

## Canonical next artifacts

1. `POLAXORY_BACKROOMS_SLICE_0_GDD.md`
2. `POLAXORY_BACKROOMS_SLICE_0_GRAPH.json`
3. `polaxory-rails/` repo skeleton
4. minimal pure-JSON validator implementation plan
5. first Rojo/TestEZ/Open Cloud CI plan

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
