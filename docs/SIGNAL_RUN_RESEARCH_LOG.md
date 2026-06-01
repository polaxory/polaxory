# Signal Run Research Log

Purpose: keep the 10-minute assignment loop pointed at one small, shippable improvement at a time. Each pass should find one issue, make one narrow improvement, and end in a quick commit when safe.

## Research Questions

### 1. Can a player double-finish a round?
- **Risk:** `FinishTrigger.Touched` can fire multiple times from the same character/body parts.
- **Probe:** Inspect server state for a per-player `finished` guard before rewards or replay prompts.
- **Good improvement:** Add/verify an idempotent finish path and telemetry for ignored duplicate finishes.
- **Validation:** One reward claim opportunity per round.

### 2. Can rewards be claimed without finishing?
- **Risk:** Client UI can request reward claim even if the server round state is stale or unfinished.
- **Probe:** Check whether `RewardService` validates active round id, finished flag, and unclaimed reward state server-side.
- **Good improvement:** Reject claims that lack a completed server round and emit a quiet telemetry event.
- **Validation:** RemoteEvent spam cannot mint duplicate rewards.

### 3. Can run-again be spammed into broken round state?
- **Risk:** Multiple replay requests may reset the player repeatedly or create overlapping rounds.
- **Probe:** Check for cooldown/idempotency around `RunAgainRequested`.
- **Good improvement:** Server accepts only the first replay request after a finished round.
- **Validation:** Repeated clicks keep exactly one next round active.

### 4. Do checkpoints recover safely after death/reset?
- **Risk:** Spawn reset may ignore last checkpoint or restore stale checkpoint from an old round.
- **Probe:** Verify checkpoint state is scoped to current round id.
- **Good improvement:** Store checkpoint per player per round, clear it on new round, and fall back to `SpawnPoint`.
- **Validation:** Death mid-run returns to latest valid checkpoint; new round returns to spawn.

### 5. Are stale rounds cleaned up?
- **Risk:** Player leaves, AFKs, or errors can leave state that affects later sessions.
- **Probe:** Look for `Players.PlayerRemoving` cleanup and timeout handling.
- **Good improvement:** Add cleanup function shared by leave/timeout paths.
- **Validation:** No stale player state remains after leave or timeout.

## Iteration Template

```txt
Finding:
Hypothesis:
Change:
Validation:
Commit:
Next question:
```

## Current Priority

Start with server-side validation guards before adding more UI polish. Fun is the first feature, but Roblox remotes are chaos goblins; trust the server, not the button.
