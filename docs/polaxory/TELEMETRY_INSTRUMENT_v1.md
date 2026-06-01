# Polaxory Telemetry Instrument v1

Status: baseline design  
Date: 2026-06-01  
Scope: Roblox first playable reward loop

## Mission

Design the smallest instrument that tells us whether the gameplay loop is working.

The loop we are measuring:

```txt
round_started
→ round_completed
→ reward_granted
→ reward_claimed
→ next_round_started
```

The product question is not "did we add analytics?"

The product question is:

> Does a completed round plus a claimable reward make the player start another round?

## Instrument principle

Measure the loop, not the player.

Polaxory should capture aggregate behavioral signals first. Do not commit or export raw Roblox user identifiers, player names, chat content, IP addresses, device identifiers, or free-form player text. Runtime systems may use a short-lived session id to sequence events during one play session, but committed fixtures and snapshots stay aggregate.

## Required event spine

### `round_started`

Fired when a player enters an active round.

Required fields:

- `sessionId`
- `roundId`
- `startedAtUnixMs`

### `round_completed`

Fired when the round reaches a terminal outcome.

Required fields:

- `sessionId`
- `roundId`
- `completedAtUnixMs`
- `durationMs`
- `outcome`

Allowed `outcome` values for v1:

- `success`
- `fail`
- `abandon`
- `timeout`

### `reward_granted`

Fired when the server decides the player earned a reward.

Required fields:

- `sessionId`
- `roundId`
- `rewardId`
- `rewardType`
- `amount`

### `reward_claimed`

Fired when the player accepts or claims the reward.

Required fields:

- `sessionId`
- `roundId`
- `rewardId`
- `claimedAtUnixMs`

### `next_round_started`

Fired when the same runtime session starts another round after a claim or completion.

Required fields:

- `sessionId`
- `previousRoundId`
- `roundId`
- `startedAtUnixMs`
- `source`

Allowed `source` values for v1:

- `reward_claim_panel`
- `play_again_button`
- `auto_queue`
- `manual_start`

## First aggregate metrics

Minimum viable dashboard metrics:

- `rounds_started`
- `rounds_completed`
- `rewards_granted`
- `rewards_claimed`
- `next_rounds_started`
- `completion_rate = rounds_completed / rounds_started`
- `reward_claim_rate = rewards_claimed / rewards_granted`
- `next_round_rate_after_claim = next_rounds_started / rewards_claimed`
- `avg_round_duration_ms`
- `median_round_duration_ms`

## Decision thresholds

Use these as crude early gates, not sacred truth:

- If `completion_rate < 0.35`, fix round clarity before reward design.
- If `reward_claim_rate < 0.50`, fix reward presentation before economy depth.
- If `next_round_rate_after_claim < 0.25`, the reward is not yet creating replay intent.
- If `avg_round_duration_ms` is too high for the target session length, shorten the first round before adding more systems.

## First implementation target

Wire existing seams into the instrument:

- `RoundCompletionRewards.luau` emits `reward_granted`
- `RoundCompletionRewardPanel.client.luau` triggers or relays `reward_claimed`
- the round entry path emits `round_started` and `next_round_started`
- `RoundTelemetryLoop.server.luau` receives events and updates `TelemetryBuffer`
- a local harness can produce one deterministic sample snapshot

## What this unlocks

This gives Polaxory a real iteration loop:

1. Ship a playable reward loop.
2. Capture aggregate loop data.
3. Read the drop-off point.
4. Pick the next task from evidence.
5. Ship again.

That is the actual infrastructure thesis in miniature.
