# Signal Run v0 Claim Replay Gate

This is the next tiny receipt gate for Signal Run v0. It exists to stop more setup/docs polish from outrunning the playable proof loop.

## Current repo fact

As of `main` at `d842efe`, the repo already has:

- `src/client/RoundCompletionRewardPanel.client.luau` printing a temporary reward preview payload.
- `src/server/RoundCompletionRewards.luau` returning a deterministic reward contract.
- `src/server/RoundTelemetryLoop.server.luau` with telemetry bindables for `RewardClaimed` and `NextRoundStarted`.

The missing proof is not another spec. The missing proof is the server-owned bridge from claim intent to replay intent.

## Required next implementation bite

Touch only the smallest files needed to wire this path:

```txt
src/client/RoundCompletionRewardPanel.client.luau
src/server/RoundCompletionRewards.luau
src/server/RoundTelemetryLoop.server.luau
```

If a tiny RemoteEvent seam is required, add only that seam and no surrounding architecture.

## Acceptance gate

A manual click path or deterministic harness must prove this ordered loop once:

```txt
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
```

## Server authority checks

The implementation is not accepted unless all are true:

- Client sends intent only: `ClaimRewardRequested` and `RunAgainRequested`.
- Server owns pending reward state.
- One completed round can be claimed exactly once.
- A claim before server completion is rejected and does not emit `reward_granted` or `reward_claimed`.
- Run Again is accepted only after claim and emits `next_round_started` once.
- No economy, inventory, lore, cosmetics, RobloxOps setup, schema expansion, or monetization is added in this pass.

## Receipt to paste back into the issue

```txt
Signal Run v0 claim replay receipt:
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started

Duplicate finish: no second reward_granted.
Duplicate claim: no second reward_claimed.
Claim before completion: rejected_claim increments; reward_granted remains 0; reward_claimed remains 0.
```
