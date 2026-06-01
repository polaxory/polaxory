# Polaxory Heavy Hitter Doctrine

Do not multiply automations. Compound blocks.

Every 5 minutes, the fleet should behave like a block producer:

- one context window
- one heavy hitter
- one receipt
- one next-block hint
- otherwise `CRON_SUPPRESS`

## Priority ladder

1. **P0 — playable Slice-0 proof**
   - `round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started`
2. **P1 — real artifact work / receipt**
   - file, issue, commit, test, checklist, validator, or concrete blocker
3. **P2 — first-minute player clarity**
4. **P3 — anti-LARP audit / merge / prune**
5. **P4 — moonshot / social / meta only if it directly helps P0**

## Combining law

**Combine before creating.**

New automation creation defaults to rejection unless no existing lane can safely cover the job.

If multiple automations overlap, merge their signals into one block. Do not echo all of them.

## Output shape

```txt
BLOCK <UTC timestamp>
parent: <previous receipt or latest known artifact>
purpose: <one purpose>
priority: <P0-P4>
action: <one concrete action or handoff>
artifact: <file/issue/commit/automation/blocker>
receipt: <proof or blocker>
next: <next block hint>
```

If nothing useful:

```txt
CRON_SUPPRESS
```

## Boundaries

- No lore fog.
- No councils unless they collapse into one executable block.
- No automation spawning unless it beats merge/reuse.
- No wallets, trades, secrets, private keys, or external-account mutation.
- Prefer playable proof over docs; prefer docs over vibes; prefer silence over fake motion.
