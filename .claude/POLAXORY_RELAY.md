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

Ship the loop. Then read the loop. Then ship again.
