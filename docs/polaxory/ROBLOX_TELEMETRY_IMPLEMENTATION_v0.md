# Polaxory Roblox Telemetry Implementation v0

Status: build seam, not live production data yet.

## Where we left off

We had a thesis, a command-room page, a round-completion reward seam, and a telemetry event contract. The missing piece was the first real path from Roblox gameplay into aggregate evidence.

This build adds that path.

## First loop to close

```txt
round_started
  -> round_completed
  -> reward_granted
  -> reward_claimed
  -> next_round_started
```

The purpose is not analytics theater. The purpose is to answer:

> Are players finishing a round, accepting the reward, and choosing to play again?

## What this ships

### `src/server/TelemetryBuffer.luau`

A server-side aggregate-first telemetry buffer.

It records:

- event counts
- first / last event timestamps
- per-event numeric totals, mins, maxes, and averages
- anonymous session-key counts

It intentionally does **not** store raw Roblox user IDs in snapshots.

### `src/server/RoundTelemetryLoop.server.luau`

A live Roblox server seam with `BindableEvent` hooks for the first playable loop.

It creates this folder in `ServerScriptService`:

```txt
PolaxoryTelemetryEvents/
  RoundStarted
  RoundCompleted
  RewardGranted
  RewardClaimed
  NextRoundStarted
  SnapshotRequested
```

Existing round/reward code can fire these events without knowing anything about analytics storage.

### `data/polaxory/sample_telemetry_snapshot_v0.json`

A committed example of the aggregate shape we expect from the first playtests.

### `projects/polaxory/tasks/roblox_real_data_loop_v1.json`

The next implementation task: wire the seam into actual round and reward code, then capture first playtest snapshots.

## Integration rule

Gameplay scripts should fire intent events. They should not own analytics persistence.

Example:

```lua
local telemetryEvents = game:GetService("ServerScriptService"):WaitForChild("PolaxoryTelemetryEvents")
telemetryEvents.RoundCompleted:Fire({
    sessionKey = sessionKey,
    roundId = roundId,
    durationSeconds = durationSeconds,
    resourcesDelivered = resourcesDelivered,
})
```

## Privacy boundary

Allowed in committed snapshots:

- aggregate counts
- aggregate timings
- anonymous session keys
- playtest cohort names
- place/version/build labels

Not allowed in committed snapshots:

- raw Roblox user IDs
- usernames/display names
- chat text
- private server invite data
- per-player behavioral trails

## Definition of done for the next ship

- Round start fires `RoundStarted`
- Round completion fires `RoundCompleted`
- Reward grant fires `RewardGranted`
- Reward claim fires `RewardClaimed`
- Replay/requeue fires `NextRoundStarted`
- A playtest exports one aggregate snapshot
- Command room shows real values instead of assumption labels

## Current truth

We still do not have live behavioral data committed. But now the repo has a concrete Roblox-side seam for collecting it.
