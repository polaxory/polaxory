# Game Data Research Audit v0

Status: initial audit baseline.
Date: 2026-06-01

## Bottom line

We should not pretend the current markdown equals real Roblox research.

The repository has useful strategic framing and implementation planning, but the current data layer is not yet closed. Until first-party telemetry or sourced Roblox public data is captured, game-data claims are working hypotheses.

## What counts as real research

Real research must include at least one of:

- First-party telemetry from a Roblox experience.
- Roblox public game/page/API data with source and capture date.
- Player interviews, playtests, or Discord/community evidence with notes.
- Competitor/game observations with URL, timestamp, and extracted claim.
- Reproducible script output committed as aggregate JSON.

## What does not count by itself

- A polished markdown thesis.
- Unsourced claims about players.
- Generic Roblox trend statements.
- AI-written summaries without source labels.
- Product intuition that is not marked as an assumption.

## Audit categories

Use these labels in future docs:

```txt
[first_party]
[roblox_public]
[external_public]
[playtest]
[desk_research]
[assumption]
```

## Current repo assessment

### Strong

- The Polaxory mission and infrastructure thesis are clear.
- The command room gives the work a product surface.
- The reward-loop task is the right first measurable gameplay loop.
- `apps/roblox-ops` suggests the repo is already moving toward operational data capture.

### Weak

- No verified live gameplay telemetry is committed.
- No aggregate Roblox snapshots are committed.
- No evidence ledger ties markdown claims to sources.
- No dashboard section distinguishes actual data from assumptions.

## Baseline decision

From this point forward, every game-data markdown should include:

1. `Evidence level`
2. `Source`
3. `Captured at`
4. `Decision impact`
5. `What would falsify this`

## Immediate research backlog

1. Capture current Roblox experience metadata.
2. Capture competitor game page snapshots.
3. Instrument round-completion events.
4. Run one player/playtest session and record friction.
5. Convert observations into a decision log, not another loose essay.

## First decision log template

```md
## Decision

## Evidence level

## Source

## Captured at

## What we observed

## What we will ship

## What metric will prove/disprove it
```
