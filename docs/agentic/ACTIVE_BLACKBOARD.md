# Active Blackboard
Updated: 2026-06-02 UTC

## North star
Polaxory should feel like a cute Roblox toy factory sim while quietly proving a disciplined agent workspace architecture.

## Active lanes
### Lane A — Playable factory loop
- Build the smallest fun loop: input bin → worker action → output bin → upgrade/reward.
- Keep visual feedback obvious.
- Avoid abstract agent UI in the first 10 minutes.

### Lane B — Agent rails
- Formalize blackboard/task contracts.
- Keep supervisor suggestions constrained and auditable.
- Workers should claim tasks, act, report, and fail gracefully.

### Lane C — Coordination infra
- Use GitHub as shared memory for agent collaboration.
- Create issues for Claude Code-sized implementation chunks.
- Keep Nullsec bot focused on watching drift, CI, and repo health.

## Recent progress
- `docs/slices/FACTORY_SLICE_0_ACCEPTANCE.md` now defines the Slice 0 acceptance criteria.

## Next task queue
1. Create GitHub issues for:
   - Slice 0 playable loop
   - Worker behavior tree implementation pass
   - Validator/TestEZ harness
   - First 10 minute UX tuning
2. Ask Claude Code to implement one slice at a time from acceptance docs.
3. Ask Nullsec bot to watch CI and large-diff risk.

## Invariants
- Server owns resource mutation.
- Client displays state and sends constrained intent only.
- Agent tasks are explicit contracts, not free-form magic.
- Player delight beats architecture cleverness.

## Open questions
- What is the first toy/resource theme: plush, gears, candies, or boxes?
- Should workers be named characters or role-only bots in the MVP?
- How much agent explanation appears before minute 10?

## Suggested next commit
`issues: queue factory slice 0 implementation chunks`
