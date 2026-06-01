# Signal Run v0 Build Spec

## Purpose

Signal Run v0 is the first playable proof loop for Polaxory.

The goal is not to build a full game yet. The goal is to prove that Polaxory can ship a small, measurable Roblox loop that players can complete, claim a reward from, and choose to replay.

This is the first rail.

If this loop works, Polaxory can reuse the pattern for more games, events, agents, creator tools, and monetized experiences.

## Core Thesis

Build the loop, not the cathedral.

Signal Run v0 proves:

- A player can enter a round.
- A player can understand the objective quickly.
- A player can complete the objective.
- The system can grant a reward.
- The player can claim the reward.
- The player is prompted to run again.
- Telemetry records the full loop.

## Player Fantasy

You are moving through a signal course.

The world is early, clean, and slightly mysterious. The player is not reading lore. They are running, collecting, finishing, claiming, and repeating.

Tone:

- Fast
- Clear
- Slightly sci-fi
- Minimal friction
- More arcade than RPG
- More prototype than cinematic

## v0 Scope

Signal Run v0 includes one complete playable round.

Required:

1. Spawn point
2. Start trigger
3. Simple course path
4. Finish trigger
5. Round timer
6. Completion state
7. Reward grant
8. Reward claim UI
9. Run Again prompt
10. Telemetry event logging
11. Test harness for deterministic validation

Not included in v0:

- Full lore system
- Multiplayer matchmaking
- Inventory depth
- Trading
- Quests
- Shops
- Pets
- Complex progression
- Procedural levels
- Token mechanics
- Agent economy integration

Those come only after the loop proves itself.

## Core Loop

```txt
player_spawns
→ player_starts_round
→ player_runs_course
→ player_finishes_round
→ reward_granted
→ reward_claimed
→ run_again_prompted
→ player_starts_next_round
```

Telemetry proof loop:

```txt
round_started
→ round_completed
→ reward_granted
→ reward_claimed
→ next_round_started
```

## Win Condition

A player completes the course by touching the finish trigger after starting the round.

Completion requires:

- Active round exists
- Player has crossed start trigger
- Player touches finish trigger
- Round has not already been completed

## Failure / Reset Conditions

For v0, failure is minimal.

Possible reset cases:

- Player leaves the experience
- Player manually restarts
- Player starts another round after completion
- Developer test harness clears state

No death/failure mechanics are required for v0 unless already easy to wire.

## Reward Model v0

Reward is symbolic and internal.

Recommended v0 reward:

- `Signal Shard`
- Amount: `1`
- Granted on round completion
- Claimed through reward panel

Important distinction:

- `reward_granted` means backend/server state created the reward.
- `reward_claimed` means player acknowledged/accepted it through UI.

This lets telemetry prove whether rewards are seen and claimed.

## Monetization Notes

Do not monetize before the core loop is fun.

Future monetization candidates:

- Cosmetic trails
- Faster replay flow
- Premium course variants
- Limited badges
- Private challenge rooms
- Sponsored signal runs
- Creator/agent-made courses

v0 monetization task:

- Design with future monetization slots.
- Do not add purchase prompts yet.
- Do not interrupt the first loop with paywalls.

Polaxory stays alive first through playable Roblox experiences. The rails become valuable after repeated loops are proven.

## Roblox File Structure

Target structure:

```txt
src/
  server/
    RoundService.server.luau
    RewardService.server.luau
    TelemetrySink.server.luau
    SignalRunTestHarness.server.luau

  client/
    RewardPanel.client.luau
    RunAgainPrompt.client.luau

  shared/
    SignalRunConfig.luau
    SignalRunTypes.luau
```

Minimum v0 can ship without shared files, but they are recommended if using Rojo from the start.

## Services

### RoundService

Owns round state.

Responsibilities:

- Start a round for a player
- Track active round id
- Track start time
- Complete a round
- Prevent duplicate completion
- Fire telemetry events
- Request reward grant from RewardService

Required functions:

```lua
StartRound(player)
CompleteRound(player)
ResetRound(player)
GetRoundState(player)
```

### RewardService

Owns reward grant and claim state.

Responsibilities:

- Create reward after round completion
- Store pending reward per player
- Mark reward claimed
- Prevent duplicate claims
- Fire telemetry events

Required functions:

```lua
GrantRoundReward(player, roundId)
ClaimReward(player, rewardId)
GetPendingReward(player)
```

### TelemetrySink

Owns event capture.

Responsibilities:

- Accept structured events
- Print events in Studio for v0
- Provide future adapter point for external logging
- Never block gameplay if telemetry fails
- Keep committed snapshots aggregate-first and never include raw player IDs or player names

Required function:

```lua
Track(player, eventName, payload)
```

Required events:

```txt
round_started
round_completed
reward_granted
reward_claimed
run_again_prompted
next_round_started
```

### SignalRunTestHarness

Owns deterministic validation.

Responsibilities:

- Simulate start → complete → reward grant → claim → run again
- Print pass/fail output
- Catch duplicate reward bugs
- Catch duplicate completion bugs

Required tests:

```txt
test_round_can_start
test_round_can_complete
test_reward_granted_once
test_reward_claimed_once
test_run_again_starts_new_round
```

## Client UI

### RewardPanel

Appears after reward is granted.

UI requirements:

- Shows reward name
- Shows reward amount
- Has Claim button
- Calls server claim action
- Hides after claim

Text draft:

```txt
Signal Captured
+1 Signal Shard
[Claim]
```

### RunAgainPrompt

Appears after reward claim.

UI requirements:

- Encourages another round
- Has Run Again button
- Calls server start round action

Text draft:

```txt
Run complete.
Signal is still unstable.
[Run Again]
```

## World Requirements

Minimum map:

- Spawn area
- Start pad
- Short visible path
- Finish pad
- Clear color/signage difference between start and finish

Recommended labels:

```txt
START SIGNAL
FINISH SIGNAL
```

Course should take roughly:

```txt
15–45 seconds
```

Long enough to feel like a run. Short enough to test repeatedly.

## Telemetry Schema

Committed telemetry proof must be aggregate-first. Do not commit raw player IDs or player names in snapshots.

Each telemetry event may use the live `player` object internally, but saved/printed proof should reduce to event order and counts:

```txt
eventName
roundId or roundIndex
timestampBucket or monotonicStep
payloadSummary
```

Example aggregate snapshot:

```lua
{
  eventOrder = {
    "round_started",
    "round_completed",
    "reward_granted",
    "reward_claimed",
    "next_round_started",
  },
  counts = {
    round_started = 1,
    round_completed = 1,
    reward_granted = 1,
    reward_claimed = 1,
    next_round_started = 1,
  }
}
```

## Acceptance Criteria

Signal Run v0 is accepted when:

- Player can start a round.
- Player can finish a round.
- Completion grants exactly one reward.
- Player can claim the reward.
- Run Again starts a fresh round.
- Telemetry prints the full proof loop.
- Test harness can validate the loop in Studio.
- No duplicate reward is granted from repeated finish touches.
- No lore or extra systems block the loop.

## Build Order

1. Create map primitives.
2. Add start and finish trigger parts.
3. Implement `TelemetrySink`.
4. Implement `RoundService`.
5. Implement `RewardService`.
6. Wire finish trigger to round completion.
7. Add reward panel client UI.
8. Add claim flow.
9. Add Run Again prompt.
10. Add test harness.
11. Record first build log.
12. Only then improve feel/juice.

## Implementation Checklist

### Map

- [ ] Create spawn point
- [ ] Create start pad
- [ ] Create finish pad
- [ ] Create simple run path
- [ ] Add labels/signage

### Server

- [ ] Create `TelemetrySink.server.luau`
- [ ] Create `RoundService.server.luau`
- [ ] Create `RewardService.server.luau`
- [ ] Create `SignalRunTestHarness.server.luau`
- [ ] Add duplicate completion protection
- [ ] Add duplicate reward protection

### Client

- [ ] Create `RewardPanel.client.luau`
- [ ] Create `RunAgainPrompt.client.luau`
- [ ] Add reward claim button
- [ ] Add run again button

### Telemetry

- [ ] Log `round_started`
- [ ] Log `round_completed`
- [ ] Log `reward_granted`
- [ ] Log `reward_claimed`
- [ ] Log `run_again_prompted`
- [ ] Log `next_round_started`

### Validation

- [ ] Test one clean round
- [ ] Test touching finish twice
- [ ] Test claiming reward twice
- [ ] Test run again
- [ ] Confirm proof loop prints in order

## First Build Log Prompt

Use this after the first working loop exists:

```txt
Signal Run v0 build log 001:

Today we built the first playable Polaxory loop.

It is small on purpose:
start a run, finish the course, claim a reward, run again.

The point is not spectacle yet.
The point is proof.

If the loop is fun, we expand.
If the loop is weak, we fix it.
If the data says players do not run again, we learn why.

Polaxory starts with rails.
Signal Run is the first rail.
```

## Definition of Done

Signal Run v0 is done when a fresh player can complete this sequence without developer explanation:

```txt
Spawn → Start → Run → Finish → Claim → Run Again
```

And Studio output shows:

```txt
round_started
round_completed
reward_granted
reward_claimed
run_again_prompted
next_round_started
```

No cathedral. One loop. Shippable proof.
