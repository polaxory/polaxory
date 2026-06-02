# Polaxory

> **Agent-built Roblox worlds, exploit-resistant by construction.**

Polaxory builds Roblox experiences through rails that refuse client-authoritative design. Agents can generate gameplay, but the architecture keeps authority on the server, schemas on every remote, and validation in the loop. The result is not just faster world creation — it is exploit-resistant construction by default.

This repository is the **control room, not the demo folder.** It is the clean public/private build layer exported from the Hypurrclaw workspace. It intentionally excludes private agent state, uploaded files, credentials, secrets, and raw attachment blobs.

## The wedge

Roblox developers — especially solo and tiny teams — are overextended and exposed:

- One person can't hold scripting, systems design, security, validation, content, and iteration at once.
- Exploiters punish every weak remote, every client-owned state transition, every optimistic shortcut.
- The loudest unmet need in the community is defense against exploiters.

Polaxory's rails answer that need as a *side effect* of how they're built: the server owns state, the client sends intent only, every remote is typed and validated. You can't write the client-authoritative code exploiters feed on, because the rails reject it.

The full thesis lives in [`manifesto.md`](manifesto.md). The honest, unproven part: **we have not yet confirmed a single Roblox dev wants this.** The devlog tracks that test in the open.

## What exists now (receipts, not promises)

- **Signal Run** — a server-authoritative round/gate/reward loop. The first fossil. See [`experiments/signal-run/`](experiments/signal-run/).
- **Rails constitution + contracts** — server authority, typed remotes, validators. See canonical docs below.
- **Read-only Studio inspection** — we can see the live place, not just the files.

Everything else (UGC pipeline, world memory, agent repair loop, playtest surface) is a named pressure point in [`docs/roadmap.md`](docs/roadmap.md) — **not a shipped module, and not an empty folder pretending to be one.**

## Load order

1. `FILE_KNOLL.md`
2. `SECURITY_BOUNDARY.md`
3. `docs/polaxory/00_ACTIVE_CONTEXT.md`
4. Canonical Polaxory docs under `docs/polaxory/`

Do not load the entire research pile by default. Use the knoll.

## Canonical active docs

- `manifesto.md` — the thesis: pain → principle → architecture → receipt → ambition.
- `docs/security-model.md` — why the rails are exploit-resistant by construction (the spear).
- `docs/roadmap.md` — future surfaces, honestly labeled as not-yet-shipped.
- `docs/competitive-landscape.md` — the four-axis wedge, threat ranking, and why the whitespace is real (and closing).
- `docs/polaxory/POLAXORY_RAILS_CONSTITUTION_v0.md` — the prime law and seven rails.
- `docs/polaxory/POLAXORY_RAILS_SPEC_v0.md`
- `docs/polaxory/POLAXORY_SYSTEM_GRAPH_SCHEMA_v1.md`
- `docs/polaxory/POLAXORY_VALIDATOR_CONTRACTS_v0.md`

## Current next action

Signal Run v0 is built; it is the receipt, not the product. The next move is **demand proof + build in public**:

1. Put the Signal Run slice in front of one real Roblox developer and watch them use it unaided.
2. Run the public devlog (`devlog/`) opening with the honest demand question.
3. Verify the Roblox April 2026 AI-usage policy permits agent-built deployment before promising that future.
4. Only build the next surface once a real dev pulls on it.

## Receipts rule (replaces the old "no pitch sprawl" cut line)

The repo may grow narrative — but **every claim of capability must be backed by a receipt or labeled as ambition.** A new surface gets a folder only when it has working metal inside it. No hollow rooms; the repo must not cosplay as a platform. Prefer tightening an existing doc over adding a new one, and when you do add, add a receipt with it.

## Local guardrails

The pinned local tools live in `aftman.toml`. If `stylua`, `selene`, or `rojo` are missing, run `aftman install` from the repository root before running checks.

Before committing code changes to the playable loop, run the same checks CI uses:

```bash
stylua --check src
selene src
rojo build default.project.json --output build.rbxlx
```

For docs-only changes that do not touch `src`, `default.project.json`, or tool config, note that the guardrail checks were not required rather than forcing a no-op local build.
