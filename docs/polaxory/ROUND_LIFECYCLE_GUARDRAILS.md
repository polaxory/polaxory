# Round lifecycle guardrails

Small implementation notes for Signal Run round-state work. Keep this doc close to the server modules that own leave, timeout, and replay handling.

## Server-owned outcomes

A round should end through exactly one server-owned path:

- `completed` when the extraction/completion condition succeeds.
- `abandoned` when the player leaves or the round is explicitly canceled.
- `timed_out` when the stale-round timeout closes it.

Use one shared cleanup function for all end paths so player state, checkpoint state, temporary connections, and telemetry are cleared consistently.

## Replay requests

Replay should be idempotent after a finished round: accept the first valid request, then rate-limit later requests so repeated clicks cannot create overlapping rounds.

## Checkpoint scope

Checkpoint state must be scoped to the current round id and cleared on every new round, timeout, completion, abandon, and player leave.
