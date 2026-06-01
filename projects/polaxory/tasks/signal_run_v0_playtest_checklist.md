# Signal Run v0 — Slice-0 Playtest Checklist

Purpose: verify the smallest playable reward loop in Roblox Studio before any polish, lore, economy, or monetization work.

## Required manual pass

Run one fresh local Studio session and record the observed event order.

Expected proof loop:

```txt
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
```

## Pass criteria

- [ ] Player can spawn and start a round without developer explanation.
- [ ] Player can finish the course once.
- [ ] Finishing grants exactly one pending reward.
- [ ] Claim button records exactly one `reward_claimed`.
- [ ] Run Again starts a fresh server-owned round and records `next_round_started`.
- [ ] Touching finish twice does not emit a second `reward_granted`.
- [ ] Clicking Claim twice does not emit a second `reward_claimed`.
- [ ] Claim before server completion increments `rejected_claim`; `reward_granted` remains 0; `reward_claimed` remains 0.

## Receipt to paste into issue #8

```txt
Signal Run v0 playtest receipt:
Manual path: Spawn -> Start -> Run -> Finish -> Claim -> Run Again
Observed telemetry: round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
Duplicate finish: no second reward_granted
Duplicate claim: no second reward_claimed
Claim before completion: rejected_claim increments; reward_granted=0; reward_claimed=0
```

## Stop rule

If any checkbox fails, do not add UI polish, lore, economy, graph/schema work, or RobloxOps setup. Fix the failing loop seam first.
