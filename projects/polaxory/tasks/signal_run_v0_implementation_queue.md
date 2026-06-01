# Signal Run v0 — Implementation Queue

## Goal
Build one tangible Roblox playable loop before adding lore, economy, monetization, or content scale.

Proof loop:

```txt
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
```

## Current micro-ship pin

Before polishing UI or docs, add this server-authority smoke case to the next implementation pass:

```txt
ClaimRewardRequested before a server-completed round -> rejected_claim count increments; reward_granted remains 0; reward_claimed remains 0.
```

This pins issue #7 to an executable Slice-0 guard: the reward loop must be playable, but not client-mintable.

## P0 — Create the playable skeleton

### Task 1: Roblox project structure
Create these files/folders in the repo:

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

Done when the project opens in Roblox Studio / Rojo without missing module errors.

### Task 2: Build graybox map
Make the smallest possible Roblox place:

- Spawn/lobby pad
- Start trigger
- Straight corridor lane
- 5–10 hazard blocks
- 8–15 SignalFragment collectibles
- Finish/relay gate

Done when a player can physically run from start to finish in 20–45 seconds.

### Task 3: Server round lifecycle
Implement `RoundService` as the authority for:

- `StartRound(player)`
- `CompleteRound(player)`
- `ClaimReward(player)`
- `StartNextRound(player)`

Done when client UI cannot fake completion without server state changing.

### Task 4: Telemetry sink
Implement aggregate-first telemetry:

- Count events by type
- Store session-local snapshots only
- Never commit raw player IDs

Done when a test can output ordered counts for all five events.

### Task 5: Reward grant
Implement fake-but-structured reward payload:

```lua
{
    rewardId = "signal_cache_v0",
    fragmentsCollected = number,
    completionTimeMs = number,
    grantedAtUnixMs = number,
}
```

Done when completion always creates exactly one reward payload.

### Task 6: Reward panel + Run Again
Client UI:

- Shows reward payload summary
- Has Claim button
- After claim, shows Run Again button

Done when clicking Run Again starts another server-owned round.

### Task 7: Deterministic test harness
Create a harness that simulates the whole loop once and prints/saves aggregate output.

Done when the loop order is visible:

```txt
round_started
round_completed
reward_granted
reward_claimed
next_round_started
```

## First commit target
Commit message:

```txt
Build Signal Run v0 playable telemetry loop
```

Include:

- Luau module skeletons
- Graybox map notes or placeholder assets
- Deterministic telemetry harness
- Aggregate snapshot fixture if available

## Hard no-list for this sprint
Do not build:

- cosmetics
- shop
- procedural generation
- monetization
- deep lore
- multiplayer systems
- complex combat

If tempted, write it in backlog and return to the loop.
