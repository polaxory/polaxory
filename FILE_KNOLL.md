# Polaxory Repository Knoll

This file is the organization map. It exists to keep the repo clean and prevent context bloat.

## Clean commit policy

Included:

- `README.md` — repo entry and current build direction.
- `SECURITY_BOUNDARY.md` — what was intentionally excluded and why.
- `docs/polaxory/` — canonical Polaxory build docs and working thesis.
- `docs/roblox-standards/` — Roblox production/security standards when exported in full.
- `docs/research/` — research notes and reading plans when safe to commit.
- `assets/` — lightweight SVG assets.

Excluded by design:

- `/agent/*` — private memory, automations, settings, SOUL, summaries.
- `/attachments/*` — uploaded books, PDFs, EPUBs, large binary/private reference material.
- secrets, keys, tokens, auth material, wallet material, credential files.
- any file whose content could not be read fully without truncation. Partial/truncated documents should never be committed as if complete.

## Canonical active Polaxory files

Use these as current working source of truth:

- `docs/polaxory/00_ACTIVE_CONTEXT.md`
- `docs/polaxory/POLAXORY_RAILS_CONSTITUTION_v0.md`
- `docs/polaxory/POLAXORY_RAILS_SPEC_v0.md`
- `docs/polaxory/POLAXORY_SYSTEM_GRAPH_SCHEMA_v1.md`
- `docs/polaxory/POLAXORY_VALIDATOR_CONTRACTS_v0.md`

## Active source/reference files

Use only when creating next artifacts:

- `docs/polaxory/POLAXORY_PRACTICAL_BUILD_RESEARCH_v0.md`
- `docs/polaxory/polaxory-mvp-architecture.md`
- `docs/polaxory/polaxory-research-brief.md`
- `docs/polaxory/polaxory-research-continuation-3-2026-06-01.md`

## Generic Roblox standards

Reference only. Do not load by default. Most relevant:

- remote contracts
- anti-exploit/security
- save data/profile
- economy/progression
- inventory/items
- pets
- quests
- social/trading
- testing/QA
- release/publishing

## Next build move

Create:

1. `docs/polaxory/POLAXORY_BACKROOMS_SLICE_0_GDD.md`
2. `docs/polaxory/POLAXORY_BACKROOMS_SLICE_0_GRAPH.json`
3. `polaxory-rails/` skeleton
4. validator implementation plan

No more pitch sprawl.
