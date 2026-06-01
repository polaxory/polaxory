# Signal Run v0 — Playable Wedge Spec

## Purpose
Build the smallest real Roblox playable that proves Polaxory can ship a tangible loop, not another document cloud.

Signal Run v0 exists to validate one retention loop:

```txt
round_started → round_completed → reward_granted → reward_claimed → next_round_started
```

## Game fantasy
The player is a runner inside a corrupted signal corridor. They sprint through short obstacle lanes, collect signal fragments, reach the relay gate, receive a reward, then choose to run again.

This is not yet a full universe. It is a playable proof.

## Core loop
1. Player enters lobby/start pad.
2. Player starts a short timed run.
3. Player dodges simple obstacles and collects signal fragments.
4. Player reaches the end gate.
5. Server marks round complete.
6. Server grants a reward.
7. Client shows reward panel.
8. Player claims reward.
9. Player is offered `Run Again`.
10. Starting another run emits `next_round_started`.

## v0 scope
### Must ship
- One lobby spawn area.
- One short obstacle lane, 20–45 seconds long.
- Start trigger.
- Finish trigger.
- Simple collectible: `SignalFragment`.
- Server-owned round lifecycle.
- Server-owned reward grant.
- Client reward panel placeholder.
- Telemetry events for the full loop.
- Local/test harness that can generate one deterministic aggregate telemetry snapshot.

### Explicitly not v0
- No cosmetics shop.
- No currency economy beyond placeholder reward payload.
- No procedural generation.
- No multiplayer matchmaking.
- No complex combat.
- No lore systems.
- No monetization.

## First playable mechanic
Player runs down a corridor while avoiding low-friction hazard blocks and collecting fragments.

Failure is optional in v0. If a hazard is touched, either:
- reset player to checkpoint, or
- subtract time / fragment score.

Do not overbuild failure yet. The goal is replay proof, not difficulty proof.

## Reward model v0
Reward is fake-but-structured:

```lua
{
    rewardId = "signal_cache_v0",
    fragmentsCollected = number,
    completionTimeMs = number,
    grantedAtUnixMs = number,
}
```

## Telemetry events
Required events:
- `round_started`
- `round_completed`
- `reward_granted`
- `reward_claimed`
- `next_round_started`

Telemetry must stay aggregate-first. Do not commit raw player IDs in snapshots.

## Roblox service/module shape
Suggested files:

```txt
src/shared/TelemetryEventContract.luau
src/shared/RoundTypes.luau
src/server/RoundService.server.luau
src/server/RoundCompletionRewards.luau
src/server/TelemetrySink.server.luau
src/server/SignalRunTestHarness.server.luau
src/client/RoundCompletionRewardPanel.client.luau
src/client/RunAgainPrompt.client.luau
```

## Done definition
Signal Run v0 is done when a developer can run locally and produce this ordered loop at least once:

```txt
round_started
round_completed
reward_granted
reward_claimed
next_round_started
```

Plus one saved aggregate snapshot showing counts for each event.

## Build stance
If a choice appears between game feel and architecture, pick game feel unless the telemetry loop breaks.
If a choice appears between a playable Roblox place and another planning document, pick the place.
