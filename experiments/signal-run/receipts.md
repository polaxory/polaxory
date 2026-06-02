# Signal Run — Receipts

Concrete proof, not narrative. Each line is something that exists and can be checked.

## The loop, server-owned

`RoundCompletionRewards.luau` implements the full state machine with server-authoritative rejection. The client cannot force a reward; the server rejects with explicit reasons:

- `no_active_round` — finish without a server-started round
- `gate_not_passed` — completion without the server-observed timing gate
- `duplicate_finish` / `duplicate_claim` — replayed remotes
- `round_expired` — 20-minute stale-round ceiling

## Visible proof prints

Load-bearing green receipt lines fire on each real transition (`round_started`, `gate_passed`, `round_completed`, `reward_granted`) — marked LOAD-BEARING in source so they are not removed without an equivalent observability path. These are the human-visible evidence the loop actually ran.

## Tests

- TestEZ harness with 15 contract tests (PR #4, branch `testez-harness`).
- CI (`ci.yml`) runs stylua + selene + the Luau spec + a Rojo build on every push/PR.

## Telemetry (aggregate-only)

`TelemetryBuffer.luau` records aggregate funnel events (`round_started` … `next_round_started`) with no raw UserIds, names, or free text — privacy boundary held by design.

## Open gaps (honest)

- The live finish path passes no duration, so `round_completed` telemetry records duration 0.
- The funnel rate that answers the retention question (`next_round_rate_after_claim`) is specified but not computed.
- The telemetry snapshot never leaves server memory (no export path yet).

These are tracked, not hidden. A receipt that omits its own gaps is marketing.
