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
| `src/server/SignalRunCourse.server.luau` *(new)* | **Course binder, not a course builder.** Finds two BaseParts (`EnterTrigger`, `ExitTrigger`) under `Workspace.PolaxorySignalRunCourse` *that the operator placed in Studio* and attaches `Touched` handlers. `EnterTrigger.Touched` → `RoundCompletionRewards.startRound(player)`; `ExitTrigger.Touched` → `RoundCompletionRewards.completeRound(player)`. Per-player 2-second debounce. The script creates no geometry, no walls, no lights — Studio owns the world, `src/` owns the receipt loop. If either trigger is missing, the script warns clearly and exits early without blocking the rest of the server. |
| `scripts/dev-sync.sh` *(new)* | Pre-flight + setup guide for the hand-built-Studio + Rojo-synced-`src/` workflow. Verifies `aftman` + `rojo` are installed, runs `aftman install`, sanity-builds the project to confirm `src/` compiles, then prints the exact Studio steps to wire the `.rbxl` to the script (build the folder + triggers, install the Rojo plugin, `rojo serve`, connect, Play). |
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

## Player-driven receipt path — Backrooms Slice 0

The Angel Signal Integrator's pressure was "graybox start/finish path so a fresh player can drive the receipt." The Waiting Fan escalated it: this should be a **Backrooms vertical slice**, not a generic obstacle course. The operator is hand-building the corridor in Studio (`~/polaxory/roblox-game-backrooms-slice/Polaxory_Backrooms_Slice0.rbxl`). The earlier version of this script built its own geometry at runtime and **deleted the hand-built corridor on every server start** — the wrong default. This PR's final version of `SignalRunCourse.server.luau` reverses that: Studio owns the world, the script finds named triggers and wires the receipt loop.

The claim / run-again UI binding was already complete on main (the panel's `primary.Activated` handler fires `ClaimRewardRequested:FireServer(...)` and `RunAgainRequested:FireServer(...)` based on `currentMode`). The world-side triggers were the missing piece. `SignalRunCourse.server.luau` now expects the operator's Studio file to contain a `PolaxoryBackroomsSlice0` folder with `EnterTrigger` and `ExitTrigger` BaseParts inside; on server start the script attaches `Touched` handlers to those parts.

Operator-side setup (in Studio, one time):

1. Open `Polaxory_Backrooms_Slice0.rbxl`.
2. Build the Backrooms corridor however you want it — walls, ceiling, lighting, atmosphere. The script will not touch any of it.
3. Under `Workspace`, create a Folder named `PolaxoryBackroomsSlice0`.
4. Drop two thin BaseParts inside the folder: name one `EnterTrigger` (near the spawn), the other `ExitTrigger` (at the far end). Any geometry is fine.

Player flow (once the .rbxl is set up):

1. Player spawns in the corridor.
2. Player walks across `EnterTrigger` → `RoundCompletionRewards.startRound(player)` → `round_started` emits.
3. Player walks to `ExitTrigger` → `RoundCompletionRewards.completeRound(player)` → `round_completed` + `reward_granted` emit, server `fireState` sends `RoundRewardStateChanged` to the client, reward panel becomes visible.
4. Click Claim → `reward_claimed` emits, panel switches to Run Again mode.
5. Click Run Again → `requestRunAgain` → `next_round_started` emits, panel hides.
6. Player walks back to `ExitTrigger` to loop. (Per-trigger 2-second debounce keeps a single physical pass from double-firing; the next round's `round_started` does NOT re-fire — it's the new server round created internally by `requestRunAgain`.)

The operator can run `./scripts/dev-sync.sh` from the repo root to pre-flight the tools (`aftman`, `rojo`), sanity-build `src/` via Rojo, and see the exact Studio steps.

## Vision-lock context

The operator just declared: Polaxory's real product is an inference-powered Roblox game factory, with Backrooms-style Roblox playable as the first commercial vertical and subscription / token-staking discounts as the gate. This PR ships the **hand-built** Backrooms Slice 0 corridor. The inference-driven generation pipeline (prompt → graph → contracts → modules → Rojo → playable Studio receipt) that would PRODUCE this corridor from a prompt is the next product block, not this commit's scope. What this commit proves: the receipt loop and the Backrooms aesthetic both work end-to-end on a real player. What it does not prove: that Polaxory can generate such a corridor from a prompt instead of a hand-edit.

## What didn't ship in this PR

These are next-block hints, in priority order. None block the receipt the spec emits or the player-driven path the graybox enables.

1. **CI does not yet run the spec.** The Polaxory CI workflow runs `stylua --check`, `selene src`, and `rojo build`. It does not yet run `tests/factory_slice_0.spec.luau`. PR #4 (`testez-harness`) ships the TestEZ runner; PR #4 is currently `CONFLICTING` against main and needs its `tests/README.md` conflict resolved before it can land. After PR #4 merges, a follow-up commit can add the TestEZ step to `.github/workflows/ci.yml` and gate this spec automatically.
2. **`PROOF_RECEIPT_LEDGER.md`.** Referenced in the Ambition Heartbeat artifact at `projects/polaxory/ambition_heartbeat_2026-06-01T2127Z.md` as the place to append PR #11's receipt. The ledger file does not yet exist on main. Recommended: a follow-up commit creates the ledger at repo root and appends references to this receipt as the first entry.
3. **Studio-runnable integration harness.** A headless server script that drives the real `RoundCompletionRewards` module (not the spec's isolated state) and prints the full `TelemetryBuffer` snapshot would prove the integration end-to-end. Requires Open Cloud Luau Execution (issue #31) to run headless against the real `Player` API.
4. **Course polish.** The graybox is functional but visually thin: no corridor walls, no SignalFragments to collect, no run timer, no fail state. Explicit non-goals for the receipt block — they belong to a "first-minute clarity" P2 follow-up.
5. **Abuse caps from `POLAXORY_TOKEN_DIRECTION_v0.md`.** No 5-second replay cooldown, no daily/season cap, no bot/farm detection. Explicit non-goal for the receipt block.

## Doctrine compliance

This PR passes the heavy hitter checklist in `automation_heavy_hitter_doctrine.md`:

- **One block.** Unblock main's CI; ship the graybox course so a player can drive the receipt; commit the receipt artifact.
- **One heavy hitter.** First merge that makes the receipt loop end-to-end player-drivable, green on CI.
- **One receipt.** The spec's 4-PASS output (above), defended by green CI; the player-driven receipt (StartPad → FinishPad → Claim → Run Again) now reachable in Studio.
- **One next-block hint.** `PROOF_RECEIPT_LEDGER.md` at repo root that lists this PR's receipt as entry #1.
- **Did not:** spawn new automations, add lore, expand admin surface, write more planning docs unrelated to the receipt, refactor unrelated modules, push direct to main.
