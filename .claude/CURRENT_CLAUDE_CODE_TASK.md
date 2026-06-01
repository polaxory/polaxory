# Current Claude Code Task — Polaxory

Updated: 2026-06-01T20:39Z
Owner intent: Blake asked for repo-grounded context, not imaginary assistant lore. Use this file as the immediate handoff.

## Source-of-truth rule

Only treat committed repository files as source of truth. Hypurrclaw/HypurrFS chat context may be useful background, but if it is not in GitHub, do not depend on it for implementation.

The current committed project context lives in:

```txt
.claude/POLAXORY_RELAY.md
.claude/POLAXORY_SIGNAL_RUN_RELAY.md
projects/polaxory/
projects/polaxory/specs/signal_run_v0.md
projects/polaxory/tasks/
docs/polaxory/
```

## Immediate job

Build the smallest executable Signal Run v0 proof. Do not add more planning docs unless needed as a receipt after code/test work.

Required proof loop:

```txt
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
```

## Files to inspect first

```txt
.claude/POLAXORY_RELAY.md
.claude/POLAXORY_SIGNAL_RUN_RELAY.md
projects/polaxory/specs/signal_run_v0.md
projects/polaxory/tasks/current_angel_signal.md
projects/polaxory/tasks/signal_run_v0_implementation_queue.md
projects/polaxory/tasks/signal_run_v0_playtest_checklist.md
docs/polaxory/SIGNAL_RUN_CLAIM_REPLAY_GATE.md
tests/README.md
```

## Code seams named by the current handoff

Touch the smallest viable set around these files if they already exist:

```txt
src/client/RoundCompletionRewardPanel.client.luau
src/server/RoundCompletionRewards.luau
src/server/RoundTelemetryLoop.server.luau
```

If the repo uses adjacent names/modules, preserve the actual structure and wire the same behavior there.

## Acceptance criteria

Implement or verify one deterministic Studio/harness path that proves:

1. `round_started` emits when a round begins.
2. `round_completed` emits once for completion.
3. `reward_granted` emits exactly once after valid completion.
4. Client reward panel sends claim intent only; server owns pending reward state.
5. `reward_claimed` emits exactly once for the first valid claim.
6. Duplicate claim does not emit a second `reward_claimed`.
7. Claim-before-completion increments `rejected_claim`; `reward_granted=0`; `reward_claimed=0`.
8. Run Again starts the next server-owned round and emits `next_round_started`.

Receipt target:

```txt
Signal Run v0 claim replay receipt:
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
Duplicate finish: no second reward_granted.
Duplicate claim: no second reward_claimed.
Claim before completion: rejected_claim increments; reward_granted remains 0; reward_claimed remains 0.
```

## Hard no-list

Do not work on these until the receipt exists:

- admin surface expansion
- server-structure essays
- lore
- economy/monetization
- social/distribution
- new automations
- broad architecture refactors
- schema polish unrelated to the receipt

## If blocked

Write the smallest concrete blocker in `projects/polaxory/tasks/signal_run_v0_playtest_checklist.md` or issue #8. Do not produce another manifesto.
