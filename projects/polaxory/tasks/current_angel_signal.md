# Current Angel Signal — Signal Run v0

Last checked: 2026-06-01T20:21Z

## Signal heard
Latest repo activity moved from the issue #8 claim/replay guard into test-note alignment, but still not into playable proof:

```txt
c7a267d Quick improvement: align test notes with Signal Run proof
523be9d docs: add Signal Run claim replay gate
```

The useful part: tests now name the Signal Run validation target.

The remaining blocker: the repo still shows the client reward panel as a preview print path, while server telemetry already has seams for `reward_claimed` and `next_round_started`.

The Slice-0 loop is still blocked until a manual click path or deterministic harness emits the full receipt:

```txt
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
```

Open issue anchor: https://github.com/polaxory/polaxory/issues/8

## Concrete Claude Code instruction
Turn the existing test-note alignment into one executable smoke case. Do not write more docs.

Touch only:

```txt
src/client/RoundCompletionRewardPanel.client.luau
src/server/RoundCompletionRewards.luau
src/server/RoundTelemetryLoop.server.luau
```

If a RemoteEvent seam is unavoidable, add only that seam; do not expand architecture.

Requirements:

1. Client sends intent only: `ClaimRewardRequested` and `RunAgainRequested`.
2. Server owns pending reward state.
3. Server accepts exactly one reward claim for the current pending reward and records `reward_claimed`.
4. Server rejects claim-before-completion and increments `rejected_claim`; `reward_granted` remains 0 and `reward_claimed` remains 0 in that case.
5. Server accepts exactly one run-again request after claim, enforces issue #8's 5-second replay cooldown/idempotency, and records `next_round_started`.
6. Studio output or deterministic harness prints the ordered loop once.
7. No cosmetics, economy, lore, graph/schema polish, RobloxOps setup, monetization, or further test-note/docs-only commits.

## Acceptance proof
Paste this receipt into issue #8 or `tests/README.md` only after the harness/manual click path proves it:

```txt
Signal Run v0 claim replay receipt:
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started

Duplicate finish: no second reward_granted.
Duplicate claim: no second reward_claimed.
Claim before completion: rejected_claim increments; reward_granted remains 0; reward_claimed remains 0.
```
