# Polaxory Automation Blockchain / Knolling Contract

## Goal
Create a perpetual, non-overlapping chain of automation events where each tick serves a specific purpose and advances the build without spawning redundant loops.

## Cadence Math
- Desired theoretical cadence: every 3 minutes
- Ticks per hour: 20
- Ticks per day: 480
- Generic cron floor in the current system: every 5 minutes
- Practical executable cadence: every 5 minutes
- Practical ticks per hour: 12
- Practical ticks per day: 288

The system should not create 480 separate automations. It should create one block-producing automation that emits one useful block per tick, forever, with priority ordering and suppression when no useful block exists.

## Block Model
Each automation run is a block.

Every block must include:
1. `height` — monotonic logical tick number if available, otherwise timestamp-derived
2. `parent` — previous known block/task/receipt, if available
3. `purpose` — one specific reason this block exists
4. `priority` — P0, P1, P2, P3, or P4
5. `action` — exactly one concrete build action, mutation, or rejection
6. `artifact` — file, issue, commit, or automation touched
7. `receipt` — proof that something real happened, or `CRON_SUPPRESS`
8. `next_block_hint` — the next highest-value block candidate

## Priority Ladder
- P0: playable Slice-0 receipt: `round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started`
- P1: real artifact / code / test / commit work
- P2: first-minute clarity and player-loop tightening
- P3: anti-LARP audit and overlap pruning
- P4: moonshot, social, lore, distribution, meta — only if it helps P0/P1

## Non-Overlap Rule
There must be only one active block producer unless explicitly authorized.

Before creating, resuming, or modifying any automation, an agent must:
1. inspect current automations
2. detect active producers
3. refuse duplicates
4. prefer merging or pausing over spawning
5. make at most one automation mutation per run

## Purpose Shards
The single block producer may rotate through purposes, but only one per run:

1. Build block — implement or tighten a concrete artifact
2. Test block — add/verify a receipt, pass criterion, or replay gate
3. Prune block — pause/reject/merge overlapping loops
4. Product block — improve first-minute player comprehension
5. Distribution block — package a proof relic only after P0/P1 progress

## Rejection Defaults
New automation creation defaults to rejection unless it directly advances or protects the current proof receipt.

Reject:
- docs without executable consequence
- lore without playable proof
- social loops before proof
- architecture without a changed artifact
- duplicate scouts/seeds/pruners
- overlapping cadences

## Output Contract
If useful work was done, output a compact block receipt:

```txt
BLOCK <timestamp-or-height>
parent: <previous receipt/artifact if known>
purpose: <one purpose>
priority: <P0-P4>
action: <one concrete action>
artifact: <file/issue/commit/automation>
receipt: <proof>
next: <next block hint>
```

If no useful non-overlapping action exists, return exactly:

```txt
CRON_SUPPRESS
```

## Current System Constraint
The current generic cron automation minimum interval is 5 minutes, not 3 minutes. Therefore, the practical version is a 5-minute block producer unless the scheduler gains a 3-minute cron floor later.
