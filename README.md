# Polaxory
Polaxory is a Roblox game-on-rails production layer: creator intent → slice spec → system graph → contracts → modules → validators → Studio-ready build.
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
round_started -> round_completed -> reward_granted -> reward_shown -> reward_claimed -> next_round_started
```
Current implementation target:
1. Wire the existing `src/shared`, `src/server`, and `src/client` skeleton around the proof loop instead of adding parallel Signal Run scaffolding.
2. Keep telemetry aggregate-first in `TelemetryBuffer.luau` and `RoundTelemetryLoop.server.luau`.
3. Keep reward proof isolated from raw player IDs via `RoundCompletionRewards.luau` and `RoundCompletionRewardPanel.client.luau`.
4. Keep replay requests server-owned: the client sends intent only; idempotency and cooldown checks must happen before starting the next round.
Acceptance check: each transition in the proof loop should be traceable to one server-owned state change and, for the reward path, the player-visible `reward_shown` feedback point before new rails or lore are added.
## Small-change rule
When improving the repo, keep each commit to one narrow artifact or clarification so the rails stay auditable. Prefer tightening an existing active doc or file over adding a new artifact unless the current load order needs it.
For docs-only edits, clarify an existing decision, acceptance check, or guardrail; avoid adding new scope, lore, or implementation promises.
## Local guardrails
The pinned local tools live in `aftman.toml`. If `stylua`, `selene`, or `rojo` are missing, run `aftman install` from the repository root before running checks.
Before committing code changes to the playable loop, run the same checks CI uses from the repository root:
```bash
stylua --check src
selene src
rojo build default.project.json --output build.rbxlx
```
For docs-only changes that do not touch `src`, `default.project.json`, or tool config, note that the guardrail checks were not required rather than forcing a no-op local build. This includes edits limited to README files, issue templates, or `docs/` content.
These checks keep local edits aligned with the repo’s format, lint, and Studio-build expectations.
## Cut line
No more pitch sprawl. Build the playable loop, prove the reward claim, then improve feel.