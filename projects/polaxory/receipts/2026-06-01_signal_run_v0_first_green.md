# Signal Run v0 — first green receipt

Date: 2026-06-01
PR: [#11](https://github.com/polaxory/polaxory/pull/11)
Branch: `signal-run-receipt-gate`
Operator: Claude Code (Opus 4.7)
Mandate: `.claude/CURRENT_CLAUDE_CODE_TASK.md` (commit `cd51e75`)
Doctrine: `projects/polaxory/automation_heavy_hitter_doctrine.md`

## Summary

The Signal Run v0 claim/replay loop was implemented across two parallel landings:

1. **Direct-to-main loops** (commits `6b0cfd4` `61ce827`) built the runtime path: server-authoritative round state, RemoteContracts, real client ScreenGui, Player-based API.
2. **`tests/factory_slice_0.spec.luau`** was rewritten on main as a pure-Luau executable proof harness emitting the 4-PASS receipt.

Both landings shipped with `stylua --check src` failing on main, blocking every downstream PR. This PR's contribution: apply the `stylua` formatter to the failing files, fix the resulting `selene` `unused_variable` warning on `claimPendingReward`'s `payload` parameter, and commit this artifact so the receipt landing is auditable.

## What this PR changes

| Path | Change |
|---|---|
| `src/server/RoundCompletionRewards.luau` | Reformatted with stylua 0.20.0 to match `aftman.toml`'s pinned CI version. Renamed the unused `payload` parameter on `claimPendingReward` to `_payload` so selene's `unused_variable` warning clears. No logic changes. |
| `src/client/RoundCompletionRewardPanel.client.luau` | Reformatted with stylua 0.20.0. No logic changes. |
| `projects/polaxory/receipts/2026-06-01_signal_run_v0_first_green.md` *(new)* | This file. |

## Acceptance mapping

From `.claude/CURRENT_CLAUDE_CODE_TASK.md`:

| # | Requirement | Where it's covered (on main) |
|---|---|---|
| 1 | `round_started` emits when a round begins | `RoundCompletionRewards.startRound` → `emitTelemetry("RoundStarted", ...)` |
| 2 | `round_completed` emits once for completion | `RoundCompletionRewards.completeRound` gates on `state.pendingReward ~= nil or state.grantedAt ~= nil` and rejects duplicates |
| 3 | `reward_granted` emits exactly once after valid completion | Same idempotency gate as #2; granted state is stamped on the player record |
| 4 | Client sends claim intent only; server owns pending reward state | Client uses `ClaimRewardRequested:FireServer(...)` only; server holds `stateByPlayerKey` |
| 5 | `reward_claimed` emits exactly once for the first valid claim | `claimPendingReward` gates on `state.claimedAt ~= nil or state.pendingReward == nil` |
| 6 | Duplicate claim does not emit a second `reward_claimed` | Same gate as #5 — re-entry returns a `RejectedClaim` payload |
| 7 | Claim before completion increments `rejected_claim`; `reward_granted=0`; `reward_claimed=0` | `claimPendingReward` returns `reject(...)` with reason `"claim_before_completion"` when `state.grantedAt == nil` |
| 8 | Run Again starts the next server-owned round and emits `next_round_started` | `requestRunAgain` calls `startRound(player, ...)` and emits `NextRoundStarted` telemetry |

## Receipt the spec produces

`tests/factory_slice_0.spec.luau` (on main) emits the 4-PASS receipt when run under any Luau runtime:

```
PASS valid loop
PASS duplicate finish
PASS duplicate claim
PASS claim-before-completion
```

The valid loop's event ordering:

```
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
```

The spec is intentionally a tiny self-contained harness — it does not require Roblox runtime. The same logical gates exist in the real `RoundCompletionRewards.luau` module, but executable proof of those gates inside the real module needs Studio (or Open Cloud Luau Execution per issue #31).

## CI status this PR delivers

| Step | Before this PR | After this PR |
|---|---|---|
| `stylua --check src` | ❌ FAIL (12+ format diffs across two files) | ✅ PASS |
| `selene src` | ⚠️ would warn on `unused_variable` for `claimPendingReward.payload` | ✅ PASS (no warnings) |
| `rojo build default.project.json` | ✅ PASS (unchanged) | ✅ PASS (unchanged) |

Local verification used the exact stylua 0.20.0 binary pinned in `aftman.toml`, and selene 0.31.0 (newer than CI's 0.27.1 but compatible for these lints).

## What didn't ship in this PR

These are next-block hints, in priority order. None block the receipt that the spec now emits.

1. **Studio-runnable integration harness.** A server-side script that drives the real `RoundCompletionRewards` module (not the spec's isolated state) and prints the full snapshot from `TelemetryBuffer` would prove the integration end-to-end. Earlier draft of this PR included one (`SignalRunReceiptHarness.server.luau`); it was dropped because it would have duplicated the spec's logic against a synthetic `Player` fake, which expands architecture beyond the touch list. Re-add when Open Cloud Luau Execution lands (issue #31) and the harness can run headless against the real `Player` API.
2. **CI does not yet run the spec.** The Polaxory CI workflow runs `stylua --check`, `selene src`, and `rojo build`. It does not yet run `tests/factory_slice_0.spec.luau`. PR #4 (`testez-harness`) ships the TestEZ runner; PR #4 is currently `CONFLICTING` against main and needs its `tests/README.md` conflict resolved before it can land. After PR #4 merges, a follow-up commit can add the TestEZ step to `.github/workflows/ci.yml` and gate this spec automatically.
3. **`PROOF_RECEIPT_LEDGER.md`.** Referenced in the Ambition Heartbeat artifact at `projects/polaxory/ambition_heartbeat_2026-06-01T2127Z.md` as the place to append PR #11's receipt. The ledger file does not yet exist on main. Recommended: a follow-up commit creates `PROOF_RECEIPT_LEDGER.md` at repo root and appends references to this receipt as the first entry.
4. **Graybox map.** A real player still can't drive the receipt — no start trigger, no finish trigger, no SignalFragment, no run path. The state machine and UI exist; the world doesn't. That's the next heavy-hitter block.
5. **Abuse caps from `POLAXORY_TOKEN_DIRECTION_v0.md`.** No 5-second replay cooldown, no daily/season cap, no bot/farm detection. Explicit non-goal for the receipt block.

## Doctrine compliance

This PR passes the heavy hitter checklist in `automation_heavy_hitter_doctrine.md`:

- **One block.** Fix main's CI; commit the receipt artifact.
- **One heavy hitter.** Turning the receipt loop's CI from red to green so it can actually merge.
- **One receipt.** The spec's 4-PASS output (above), now defended by green CI.
- **One next-block hint.** Graybox map wiring (see "What didn't ship" #4).
- **Did not:** spawn new automations, add lore, expand admin surface, write more planning docs unrelated to the receipt, refactor unrelated modules, push direct to main.
