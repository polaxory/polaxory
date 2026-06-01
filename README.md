# Polaxory
Polaxory is a Roblox game-on-rails production layer: creator intent -> slice spec -> system graph -> contracts -> modules -> validators -> Studio-ready build.
This repository is the clean public/private build layer exported from the Hypurrclaw workspace. It intentionally excludes private agent state, uploaded book files, credentials, secrets, and raw attachment blobs.

## Current product thesis
**Give Polaxory one game idea. It returns a secure, editable Roblox production build.**

First proof: a Backrooms-inspired Roblox vertical slice proving deterministic module graph, server-authoritative mechanics, resource/facility/entity/event contracts, validator reports, and Rojo-compatible output.

## Load order
1. `FILE_KNOLL.md`
2. `SECURITY_BOUNDARY.md`
3. `docs/polaxory/00_ACTIVE_CONTEXT.md`
4. Canonical Polaxory docs under `docs/polaxory/`

Do not load the entire research pile by default. Use the knoll.

## Canonical active docs
- `docs/polaxory/POLAXORY_RAILS_CONSTITUTION_v0.md`
- `docs/polaxory/POLAXORY_RAILS_SPEC_v0.md`
- `docs/polaxory/POLAXORY_SYSTEM_GRAPH_SCHEMA_v1.md`
- `docs/polaxory/POLAXORY_VALIDATOR_CONTRACTS_v0.md`

## Current next action
Build **Signal Run v0** before adding more rails or lore. The next shippable artifact is the smallest Roblox playable loop that proves:

```txt
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
```

First implementation target:
1. Create the Signal Run file skeleton under `src/shared`, `src/server`, and `src/client`.
2. Implement aggregate-first `TelemetrySink.server.luau`.
3. Add `SignalRunTestHarness.server.luau` that prints the ordered proof loop once without raw player IDs.

## Small-change rule
When improving the repo, keep each commit to one narrow artifact or clarification so the rails stay auditable.

## Cut line
No more pitch sprawl. Build the playable loop, prove the reward claim, then improve feel.
