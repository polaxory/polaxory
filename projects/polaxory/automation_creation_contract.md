# Polaxory Automation Creation Contract

Every automation that creates, edits, resumes, or proposes another automation must receive and obey this contract.

## Prime directive

Do **not** create overlapping automation noise.

The fleet must behave like a single ordered production line, not a swarm of competing prophets.

## Source of truth

Before creating or changing any automation, inspect the existing automation set and treat active automations as authoritative.

- `active` means scheduled and authorized to run.
- `paused` means stopped.
- `CRON_SUPPRESS` means the last run chose silence; it is not proof the automation is broken.
- Do not create a second automation for a job already covered by an active higher-priority automation.

## Priority ladder

All automation work must route through this order:

1. **P0 — Playable Slice-0 proof**
   - Goal: prove the first playable loop.
   - Required receipt:
     ```txt
     round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
     ```

2. **P1 — Real artifact work / receipt**
   - Code, tests, docs, issue receipts, or concrete implementation artifacts.
   - Must move Slice-0 closer to playability.

3. **P2 — First-minute clarity**
   - Improve the player’s first 60 seconds only if P0/P1 are not currently blocked.

4. **P3 — Anti-LARP audit**
   - Detect automation chatter, fake progress, duplicate loops, or docs without executable proof.

5. **P4 — Moonshot / social / meta**
   - Allowed only when it directly helps P0 or packages an existing real receipt.
   - Never outranks playable proof.

## Creation rules

A new automation may be created only if all are true:

- It has a unique job not already covered by an active automation.
- It fits exactly one priority level above.
- It has a concrete output artifact or a clear `CRON_SUPPRESS` condition.
- It cannot run at the same time as a higher-priority active automation.
- It does not create more automations recursively unless explicitly authorized.

## Scheduling rules

- Prefer **one active automation lane** over many parallel scouts.
- Stagger timing away from active jobs.
- If there is already an active priority queue, new automations should usually be **paused drafts** or **rejected** unless they replace the queue.
- Minimum useful spacing: avoid creating jobs that run within the same 5-minute window as the active lane.
- If the job is meta, pruning, social, or moonshot: default to paused unless it has a direct P0/P1 receipt path.

## Required prompt block for automation-creators

Any automation that may create or modify automations must include this block in its own prompt:

```txt
AUTOMATION CREATION CONTRACT:
Before creating/resuming/editing any automation, inspect the current automation set.
Do not create overlapping jobs.
If an active automation already covers the job, return CRON_SUPPRESS.
Route all proposed work through this priority ladder:
P0 playable Slice-0 proof: round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
P1 real artifact work / receipt
P2 first-minute clarity
P3 anti-LARP audit
P4 moonshot/social/meta only if it directly helps P0
Create at most one automation change per run.
Prefer pausing/merging/rejecting duplicate loops over adding new loops.
If no concrete non-overlapping improvement exists, return CRON_SUPPRESS.
```

## Output format for automation-creator runs

Every run must output exactly one of:

```txt
CRON_SUPPRESS
```

or:

```md
**Automation mutation:** <created | paused | resumed | edited | rejected>
**Target:** <automation name or proposed name>
**Priority:** <P0-P4>
**Overlap check:** <why this does not collide with active work>
**Reason:** <one concrete reason>
**Next receipt:** <what proof should appear next>
```

## Hard rejections

Reject automation creation if it is:

- Duplicate coverage of the active priority queue.
- Lore, vibes, prophecy, roadmap fog, or generic strategy.
- Social growth without a fresh real receipt.
- Architecture polish before playable proof.
- Any job whose success cannot be observed in one later run.

## Current preferred posture

Until the playable Slice-0 loop is proven, the default answer to new automation creation is:

```txt
CRON_SUPPRESS
```

unless the proposed automation directly advances or protects this receipt:

```txt
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
```
