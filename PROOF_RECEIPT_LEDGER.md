# Polaxory Proof Receipt Ledger

Each entry below is one proven proof point: code/test gates were run, and (where
applicable) a player drove the loop in Roblox Studio. Append entries chronologically.
Empty fields are blockers, not decoration.

The ledger is the audit trail the Heavy Hitter Doctrine asks for. If a row has gaps,
the receipt for that block is not yet green.

---

## Entry 003 — Timing Gate v0: the first fail-able toy (TEMPLATE)

Status: PENDING STUDIO PROOF

Date: 2026-06-01
PR: #14 (in flight on `add-round-start-completion-prints`)
Commit: TBD (once this commit pushes)

### What this commit adds

A single server-recognized checkpoint between EnterTrigger and ExitTrigger. The
player can now FAIL before reaching the exit. The receipt loop goes from "walk down
a hallway and click a button" to "time a touch, or get reset." That is the first
playable toy.

Server-side (`src/server/RoundCompletionRewards.luau`):

- `RoundState` gains `gatePassed: boolean` (init `false`).
- `completeRound` rejects with `RejectedClaim/gate_not_passed` when `state.gatePassed`
  is false. The check sits between the stale-round sweep and the duplicate-finish
  guard so the existing hardening contracts still apply.
- New exported `markGatePassed(player)`: finds state, no-ops if stale (drops state)
  or already passed, otherwise flips the flag and emits `GatePassed` telemetry.
- New exported `failRound(player, reason)`: drops the player's state, emits
  `RoundFailed` telemetry, and fires `RoundRewardStateChanged` so the client panel
  can react.
- `RewardLoopConfig.Events` gains `GatePassed` and `RoundFailed`.

Course-side (`src/server/SignalRunCourse.server.luau`):

- New optional trigger discovery for `TimingGate` (BasePart child of
  `Workspace.PolaxoryBackroomsSlice0`).
- When found: a `task.spawn` coroutine toggles `gateIsOpen` and the part's `Color`
  on a 3-seconds-open / 2-seconds-closed cycle. Green `(60, 220, 120)` when open,
  red `(220, 80, 60)` when closed.
- `TimingGate.Touched`: if open, `markGatePassed(player)`; if closed,
  `failRound(player, "gate_closed")`. Per-player 1-second debounce on the gate.
- If `TimingGate` is missing from Studio, script warns and continues; the receipt
  loop still binds Enter/Exit but completeRound will always reject (no path to
  passing the gate).

Tests (`tests/factory_slice_0.spec.luau`):

- Harness `state` extended with `gatePassed: boolean`; `clearState` and
  `resetForFreshRound` both reset it.
- New harness methods: `markGatePassed()`, `failRound(reason)`.
- `finishRound` now rejects with `rejected_finish:gate_not_passed` when
  `state.gatePassed` is false.
- Existing tests `runValidLoop`, `runDuplicateFinishGuard`, `runDuplicateClaimGuard`
  updated to call `markGatePassed()` before `finishRound()`.
- `runValidLoop`'s receipt is now
  `round_started -> gate_passed -> round_completed -> reward_granted -> reward_claimed -> next_round_started`.
- New test `runGateNotPassedGuard` — startRound, skip gate, finishRound, asserts
  `rejected_finish:gate_not_passed`.
- New test `runFailRoundCleanupGuard` — startRound, failRound("gate_closed"),
  asserts state cleared, finishRound rejects as no_active_round, then a fresh
  startRound + markGatePassed + finishRound reaches `reward_granted` (proving the
  player can improve on retry).

### Code / test gates

| Gate | Result | Evidence |
|---|---|---|
| `stylua --check src` | ✅ PASS | exit 0, no diffs (stylua 0.20.0) |
| `selene src` | ✅ PASS | 0 errors, 0 warnings (selene 0.31.0 local; 0.27.1 in CI) |
| `lune run tests/factory_slice_0.spec.luau` | ✅ PASS | 9/9 PASS lines (see below) |
| CI on the PR head | TBD until push | `luau-guardrails` job |

Local lune output:

```
PASS valid loop
PASS duplicate finish
PASS duplicate claim
PASS claim-before-completion
PASS finish-before-start
PASS disconnect cleanup
PASS stale-round cleanup
PASS gate-not-passed
PASS fail-round cleanup
```

### Studio receipt (operator fills after manual drive)

Operator action: in Studio, add a `TimingGate` BasePart inside `Workspace.PolaxoryBackroomsSlice0` between EnterTrigger and ExitTrigger. Save the `.rbxl`. Then drive:

- Spawn: TBD
- EnterTrigger: TBD
- Timing Gate attempted (touched while green AND touched while red, at least once each): TBD
- Failure path tested (touched while red, observed `round_failed:gate_closed` and reset): TBD
- Success reached ExitTrigger (touched gate while green, walked to ExitTrigger, `round_completed` fired): TBD
- Claim: TBD
- Run Again: TBD
- Fresh attempt starts: TBD

### Fun proof (operator's judgment after one drive)

- Can fail: yes / no
- Can improve: yes / no
- Meaningful action before ExitTrigger: yes / no

### Result

TBD — PASS or FAIL with named first blocker

---

## Entry 002 — Round-loop hardening + meaningful CI (TEMPLATE)

Status: PENDING STUDIO PROOF

Date: 2026-06-01
PR: TBD (currently on `add-round-start-completion-prints`)
Commit: TBD (once this commit is pushed)

### Code / test gates

| Gate | Result | Evidence |
|---|---|---|
| `stylua --check src` | ✅ PASS | exit 0, no diffs (stylua 0.20.0, pinned via `aftman.toml`) |
| `selene src` | ✅ PASS | 0 errors, 0 warnings, 0 parse errors (selene 0.31.0 local; 0.27.1 in CI) |
| `lune run tests/factory_slice_0.spec.luau` | ✅ PASS | 7/7 PASS lines (output pasted below) |
| CI `Run Luau spec` step | TBD until first PR push | added to `.github/workflows/ci.yml`; `lune` added to `aftman.toml` so CI installs it |

Local lune output:

```
PASS valid loop
PASS duplicate finish
PASS duplicate claim
PASS claim-before-completion
PASS finish-before-start
PASS disconnect cleanup
PASS stale-round cleanup
```

### Behavior contracts hardened

| Contract | Production code (src/server/RoundCompletionRewards.luau) | Spec (tests/factory_slice_0.spec.luau) |
|---|---|---|
| finishRound rejects when no active round | `completeRound` returns RejectedClaim/`no_active_round` | `runFinishBeforeStartGuard` |
| stateByPlayerKey cleaned on PlayerRemoving | `Players.PlayerRemoving:Connect` inside `installRemoteHandlers` | `runDisconnectCleanupGuard` (harness `disconnect()`) |
| Stale active round expires | per-call `isStale` check in `completeRound`, drops state, emits `round_expired` | `runStaleRoundCleanupGuard` (harness `setNow` past `STALE_ROUND_MS`) |
| Duplicate finish rejects | existing — `state.pendingReward ~= nil` gate (verified) | `runDuplicateFinishGuard` (verified) |
| Duplicate claim rejects | existing — `state.claimedAt ~= nil` gate (verified) | `runDuplicateClaimGuard` (verified) |
| Claim-before-completion rejects | existing — `state.grantedAt == nil` gate (verified) | `runClaimBeforeCompletionGuard` (verified) |

### Studio receipt (operator fills after manual drive)

Commit: TBD
Studio version: TBD
Rojo connected: TBD

Path (paste verbatim `[Polaxory]` lines from Output for one clean cycle):

- round_started: TBD
- round_completed: TBD
- reward_granted: TBD
- reward_claimed: TBD
- next_round_started: TBD

Guard checks (operator confirms each, in Studio or by reading the lune output):

- finish-before-start rejected: TBD (lune covers; can also be exercised in Studio by walking ExitTrigger without EnterTrigger)
- claim-before-completion rejected: TBD (lune covers)
- duplicate claim rejected: TBD (lune covers)
- disconnect cleanup observed or covered by test: TBD (`runDisconnectCleanupGuard` covers)
- stale timeout covered by test: TBD (`runStaleRoundCleanupGuard` covers)

### Result

TBD — PASS or FAIL with named first blocker

---

## Entry 001 — Signal Run v0 receipt loop, first private Studio playtest

Status: GREEN (operator-confirmed 17:51 PT, 2026-06-01)

Date: 2026-06-01
PR: [#11](https://github.com/polaxory/polaxory/pull/11) (merged as `1e8fb98`)
Commit on main: `d672e7e` (after PR #13 fix)

### What was proven

Operator drove three full receipt cycles in Roblox Studio. Output showed:

- `[Polaxory] reward_granted: reward_keys +1 for Polaxory` ×3
- `[Polaxory] reward_shown: reward_keys +1` ×3
- `[Polaxory] reward_claimed: <session> for Polaxory` ×3
- `[Polaxory] next_round_started: <session> for Polaxory` ×3

`round_started` and `round_completed` were firing internally (TelemetryBuffer
aggregate) but did not appear in Output — that gap is closed in Entry 002 (visible
receipt prints) which is currently in the in-flight PR.

### Result

PASS — for reward grant / shown / claim / next-round-start. Loop drove three full
cycles in one session, no errors, no rejects.
