# Slice-0 Receipt Gate

Purpose: keep Polaxory work pointed at one playable proof, not planning drift.

This gate is passed only when a fresh run can produce this ordered receipt:

```txt
round_started -> player_choice -> round_resolved -> reward_claimed -> next_round_started
```

## Current build bite

Implement the smallest server-owned bridge from reward claim to replay.

Required proof for the next repo-working loop:

```txt
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
```

If `player_choice` / `round_resolved` are not yet the live event names, keep the existing server events but do not call Slice-0 done until the player-facing choice and resolution states are represented in code or mapped in telemetry.

## Allowed next code touch

Keep the next implementation narrow:

- `src/client/RoundCompletionRewardPanel.client.luau`
- `src/server/RoundCompletionRewards.luau`
- `src/server/RoundTelemetryLoop.server.luau`

## Acceptance rules

- Client sends intent only: claim reward, then request run again.
- Server grants and accepts exactly one pending reward claim.
- Server starts the next round only after claim.
- Replay is idempotent and cooldown-protected per issue #8.
- A Studio output or deterministic harness prints the ordered receipt once.

## Non-goals

Do not add lore, cosmetics, economy expansion, architecture diagrams, automation commentary, or new systems until this receipt exists.
