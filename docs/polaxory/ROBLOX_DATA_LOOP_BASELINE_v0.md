# Roblox Data Loop Baseline v0

Status: baseline, not proven production telemetry yet.
Date: 2026-06-01

## Why this exists

Polaxory cannot iterate faster until the studio closes the loop between:

1. What we think players want
2. What we ship into Roblox
3. What players actually do
4. What we change next

The current repository has strong markdown and early implementation seams, but we should treat most game-data notes as hypotheses until they are backed by first-party Roblox data or explicitly cited external research.

## Current honest state

### We have

- A command-room thesis for Polaxory.
- Early Roblox project rails and Luau seams.
- A round-completion reward-loop task/spec.
- `apps/roblox-ops` scaffolding for Roblox/Open Cloud/devforum-oriented operations.
- Markdown that frames game data, market signals, and creative direction.

### We do not have yet

- Live first-party Roblox gameplay telemetry.
- A recurring export/import job from Roblox/Open Cloud into repo-tracked artifacts.
- A stable schema for gameplay events.
- A source-of-truth dashboard that compares hypothesis vs actual player behavior.
- Evidence that the markdown research is based on fresh observed player data instead of desk research or product intuition.

## Research audit rule

Every future markdown about game data must label its evidence level:

- `first_party`: captured from our Roblox experience or our backend.
- `roblox_public`: Roblox public game/page/API data.
- `external_public`: third-party/public market, creator, or community source.
- `desk_research`: synthesis, observation, or hypothesis without direct data capture.
- `assumption`: useful working belief, not evidence.

If a file does not label evidence, treat it as `assumption` until audited.

## Minimum telemetry loop

### Event contract

Start with events that directly change shipping decisions:

- `session_started`
- `round_started`
- `round_completed`
- `round_failed`
- `reward_granted`
- `reward_claimed`
- `shop_opened`
- `item_previewed`
- `item_purchased`
- `player_returned`

### Minimum fields

- `event_name`
- `schema_version`
- `occurred_at_unix_ms`
- `place_id`
- `job_id`
- `user_id_hash`
- `session_id`
- `round_id` when applicable
- `reward_id` when applicable
- `item_id` when applicable
- `properties` object

Do not commit raw Roblox user identifiers into the repo. Use hashes or aggregate exports.

## Baseline artifact format

Commit generated snapshots under:

```txt
data/polaxory/roblox-snapshots/YYYY-MM-DD/*.json
```

Allowed snapshot types:

- `experience_summary.json`
- `event_counts.json`
- `retention_proxy.json`
- `reward_loop_funnel.json`
- `research_sources.json`

Snapshots should be safe to commit: aggregate-only, no secrets, no raw private player data.

## First loop to close

The first measured loop is the round-completion reward loop:

```txt
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
```

Decision we want to unlock:

> Are rewards causing players to continue into another round?

If not, ship better reward presentation before shipping more content.

## Next real tasks

1. Add a small Luau telemetry module with a local queue and safe event schema.
2. Emit telemetry from the round-completion reward seam.
3. Add an `apps/roblox-ops` ingest script that can normalize exports into aggregate JSON snapshots.
4. Audit existing game-data markdown and mark each claim as evidence-backed or assumption.
5. Render the latest snapshot inside `/projects/polaxory` so the command room stops being static.

## Baseline acceptance criteria

This baseline is useful when:

- The repo contains an explicit data-loop spec.
- There is a task file that names implementation steps.
- There is a research-audit file that says what is real and what is not.
- Future commits have a clear place to land telemetry, snapshots, and source labels.
