# Round Completion Reward Loop v0

## Decision
Ship a small non-paid reward loop that fires immediately after a player completes a round.

## Player promise
Finishing a round should feel like progress, not a dead end.

## Product reason
The first command-room recommendation is retention/replay intent. The cheapest useful move is to make round completion produce a visible reward and a clear reason to play one more round.

## v0 behavior
1. Player completes a round.
2. Game grants a small completion reward: `reward_keys +1`.
3. Client shows a round-complete reward panel.
4. Panel explains progress toward a future cosmetic/unlock.
5. Player sees a `Play again` CTA.
6. System emits named analytics seams.

## Not in v0
- No Robux mechanics.
- No randomized paid chest.
- No full inventory economy.
- No dependency on live analytics before the loop exists.

## Events to emit later
- `round_completed`
- `completion_reward_granted`
- `completion_reward_shown`
- `completion_reward_claimed`
- `completion_replay_clicked`

## Acceptance criteria
- Reward appears immediately after round completion.
- Reward communicates progress or unlock intent.
- Loop does not require paid mechanics in v0.
- Replay CTA exists on the reward surface.
- The implementation can be measured through replay/session signals later.

## Next patch
Create the Luau modules that define the reward contract, grant the reward, and expose a client UI seam.
