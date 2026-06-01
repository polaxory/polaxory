# Polaxory Token Direction v0

Status: decisions locked, 2026-06-01. No spec sprawl — only calls and constraints.

## Decisions

1. **Token shape (MVP):** off-chain points + wallet identity. No claim contracts in v0. No real-money risk while game feel is being validated. (Recommendation A from operator brief.)
2. **Core promise (Signal Run):** *"Signal Run is a game where players complete short skill runs to earn studio-signed keys that unlock future season cosmetics."* The hook is **studio-signed** — Polaxory's name attached makes the keys collector-shaped instead of disposable.
3. **Identity binding:** wallet ↔ Roblox player binding happens at first reward claim, not at session start. Players don't need a wallet to play; they need one to claim. Lazy binding reduces friction.
4. **Ledger:** server-authoritative reward ledger lives in ProfileStore. Off-chain to start. Migrate-to-chain path documented but not built.
5. **Priority order (operator-confirmed):** Validation guards → `GAME_TOKEN_INTEGRATION_PLAN.md` → contract research → contract work. Each gate must pass before the next opens.
6. **Repo permissions (Claude Code):** inspect issues/code; commit narrow docs/guard/test improvements; never destructive ops, never broad refactors, never secrets. Encoded in `CLAUDE.md`. Validated by Nullsec watch (issue #3).

## Constraints (binding before any reward ships)

- **Server-authoritative finish.** `FinishTrigger.Touched` is a hint, not truth. Server confirms.
- **One claim per completed round.** Idempotent claim with server-side `claimed` flag.
- **5-second replay cooldown.** `RunAgainRequested` rate-limited per player.
- **20-minute stale round timeout.** Server clears round state if no finish event in window.
- **Wallet ↔ player binding stored server-side.** One wallet per player; rebinding requires operator review.
- **Daily cap:** 50 keys/wallet/day. **Season cap:** 500 keys/wallet/season. Numbers tunable; caps non-tunable.
- **Bot/farm detection v0:** flag rounds completed in less than the world's theoretical-minimum run time (precomputed per map). Flag triggers manual review, not auto-ban.
- **Telemetry stays aggregate.** No raw `UserId`, no wallet-to-userid mapping in committed snapshots. (Inherited from `docs/polaxory/TELEMETRY_INSTRUMENT_v1.md`.)

## Non-goals for v0

- Robux mechanics, randomized chest mechanics, paid token claim contracts, multi-wallet cross-game bridges, NFT minting. All future-phase, all explicitly out of MVP.

## Open questions (not blockers)

1. Which chain for eventual wallet binding — Base (matches Polaxory's token venue per `docs/polaxory/POLAXORY-STACK.md`) or Solana (matches Hypurrclaw)? Recommend Base.
2. Season cadence — 30 days, 60 days, 90 days? Affects cap calibration.
3. Studio-signed key visual identity — depends on Theme decision (Task #35).

## What gets built next, in order

1. **Validation guard pass** — close the 5 Signal Run Research Log risks (issues to be opened from this doc).
2. **`GAME_TOKEN_INTEGRATION_PLAN.md`** — written ONLY after validation guards land. Defines wallet binding, ledger schema, claim flow, abuse controls.
3. **Contract research doc** — survey of SPL/ERC claim contract patterns, no deploy.
4. **Contract work** — gated by all the above, plus operator decision on chain.
