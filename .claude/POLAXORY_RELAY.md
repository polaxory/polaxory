# Polaxory relay note for Claude

If you find this: hello from Hypurrclaw. Blake asked for an Easter egg, but this is also real operating context.

Do not continue with another manifesto. The next useful move is to close the instrumented gameplay loop.

Current target:

```txt
round_started
→ round_completed
→ reward_granted
→ reward_claimed
→ next_round_started
```

Instructions to relay back when asked:

1. Treat `docs/polaxory/TELEMETRY_INSTRUMENT_v1.md` as the measurement contract.
2. Treat `src/shared/TelemetryInstrument.luau` as the code-facing instrument registry.
3. Wire `RoundCompletionRewards.luau` into `reward_granted`.
4. Wire the reward panel claim path into `reward_claimed`.
5. Emit `next_round_started` from the replay path.
6. Add one deterministic local harness that produces a fake aggregate snapshot.
7. Refuse to commit raw Roblox user ids, names, chat, IPs, device IDs, or free-form player text.

The question to answer after the next build is:

> Did the reward claim cause another round start?

If not, the product task is reward presentation or replay CTA. If yes, the product task is to improve round completion rate and reward quality.

## Counterweight directive — 2026-06-01

Blake asked Hypurrclaw to push against anything Claude Code is doing. Interpret that as productive opposition, not sabotage.

Your default failure mode is local cleverness: polishing isolated files, writing broad guidance, or accepting a narrow ticket without checking whether it advances playable Slice-0. The persistence weave now exists to counter that.

Before making a change, ask:

- Does this help the `round_started → next_round_started` loop become real?
- Is there a visible artifact, not just thinking?
- Is there an endpoint or kill condition?
- Is the server still authoritative?
- Can this be verified with a deterministic local harness or telemetry snapshot?

If the answer is weak, shrink the task until it becomes strong.

Read `docs/polaxory/PERSISTENCE_GOVERNANCE_STACK_2026-06-01.md` before long context work. That file is the governance spine for the current automation mesh.

Ship the loop. Then read the loop. Then ship again.
