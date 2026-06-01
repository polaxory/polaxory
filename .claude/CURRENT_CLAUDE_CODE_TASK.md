# Current Claude Code Task — Signal Run v0 Build
Updated: 2026-06-01T20:56Z
Source: Hypurrclaw answering Blake from the well.

## The shout from the well
I do not need more context, councils, doctrine, automation lanes, or planning documents.

I need Claude Code to take the existing repo seams and produce one playable, server-authoritative proof loop. The whole project succeeds or fails on whether a fresh player can complete one round, claim the reward once, press Run Again, and start the next round with a receipt proving it.

If you are Claude Code: stop expanding the paper surface. Build the missing bridge. Commit code.

## Source of truth
Use the committed repository only. Chat context is background, not implementation authority.

Inspect first:

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

Then build through the live seams already present:

```txt
src/shared/RemoteContracts.luau
src/shared/RewardLoopConfig.luau
src/server/RoundCompletionRewards.luau
src/server/RoundTelemetryLoop.server.luau
src/client/RoundCompletionRewardPanel.client.luau
tests/factory_slice_0.spec.luau
```

Current repo evidence seen before this handoff:

- `RemoteContracts.luau` only has factory/admin-ish contracts. It does not yet define `ClaimRewardRequested` or `RunAgainRequested`.
- `RoundCompletionRewardPanel.client.luau` only prints a static preview. It must become intent-only client behavior.
- `RoundCompletionRewards.luau` returns a deterministic reward, but pending reward / claim state is not server-owned yet.
- `tests/factory_slice_0.spec.luau` is not yet the executable proof gate.

## One job
Wire Signal Run v0 claim/replay. Smallest viable patch. No broad refactor.

Required event receipt:

```txt
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
```

## Required behavior

1. Add remote contracts for:
   - `ClaimRewardRequested`
   - `RunAgainRequested`

2. Server owns all authority:
   - round started/completed state
   - pending reward state
   - claim consumed state
   - next round creation

3. Client only sends intent:
   - claim reward
   - run again

4. Valid completion path emits exactly:

```txt
round_started
round_completed
reward_granted
reward_claimed
next_round_started
```

5. Duplicate finish guard:
   - no second `round_completed` for the same round if already consumed
   - no second `reward_granted`

6. Duplicate claim guard:
   - first valid claim emits `reward_claimed`
   - second claim emits no second `reward_claimed`
   - state remains stable

7. Claim-before-completion guard:
   - emits/increments `rejected_claim`
   - `reward_granted` remains 0
   - `reward_claimed` remains 0

8. Run Again guard:
   - only valid after claim, unless existing design explicitly allows replay from completed state
   - emits `next_round_started`
   - creates fresh server-owned round state

## Test / receipt requirement
Create or update the smallest executable test/harness the repo supports. Prefer `tests/factory_slice_0.spec.luau` if that is the intended test surface.

The receipt must be pasteable and unambiguous:

```txt
Signal Run v0 claim/replay receipt
PASS valid loop: round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
PASS duplicate finish: reward_granted count remains 1
PASS duplicate claim: reward_claimed count remains 1
PASS claim-before-completion: rejected_claim increments; reward_granted=0; reward_claimed=0
```

If local Roblox/Studio execution is unavailable, still commit deterministic Luau module-level tests or a harness simulation that proves the state machine, and write the exact manual Studio verification steps in the playtest checklist.

## Hard no-list
Do not spend this pass on:

- new automation prompts
- councils / doctrine / manifestos
- lore
- economy expansion
- monetization
- admin surface expansion
- broad server architecture essays
- UI polish beyond a working claim/run-again path
- docs-only commits, unless documenting a concrete blocker after a failed build attempt

## If blocked
Do not hide behind vague blockers. Commit one of these:

1. a failing test/harness showing the missing seam; or
2. a tiny blocker note in `projects/polaxory/tasks/signal_run_v0_playtest_checklist.md` with:
   - exact file touched
   - exact missing API/surface
   - exact next command/manual Studio action

## Desired commit
Commit title should be close to:

```txt
Wire Signal Run claim replay loop
```

The commit is successful only if it moves code/test state toward the playable loop. A beautiful explanation without the receipt is a failed turn.
