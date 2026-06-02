# Security Model — Exploit-Resistant by Construction

This is the spear. Polaxory's defining claim is not speed of generation; it is that the rails make a whole class of Roblox exploits **structurally impossible to write**, not merely discouraged.

## The threat

Most Roblox exploits feed on the same root cause: **the client is trusted with authority it should never have.** Client-owned state transitions, unvalidated remote payloads, optimistic resource grants. Exploiters replay remotes, forge payloads, and mutate client state the server later believes. The DevForum's loudest, longest-running complaint is that developers are not equipped to fight this — because most game kits hand the client authority by default.

## The rails answer (from the Constitution, non-negotiable)

- **Server owns gameplay state. Client sends intent only.** (`POLAXORY_RAILS_CONSTITUTION_v0.md` §1–§3) The client cannot author authoritative state — it can only request change.
- **Every remote carries a contract card:** schema, rate limit, permission rule, server validation. See `src/shared/RemoteContracts.luau` — each event declares `schema`, `rateLimitPerMinute`, `permission`, and `direction` (`client_to_server` vs `server_to_client`). A client→server remote with no server-side guard cannot exist within the contract.
- **Validators fail closed.** Every validator failure blocks promotion. A build that can't prove it obeys its own rules does not ship.
- **Agents submit constrained actions, not raw code.** Agents go through a constrained action gateway (`PXActionService` in the constitution); they may not submit raw Luau, arbitrary instance mutations, or direct remote payloads.

## Receipt: where this is already real

`RoundCompletionRewards` (the Signal Run server) demonstrates the model in working code. The client can fire `ClaimRewardRequested` / `RunAgainRequested` all it wants; the server rejects anything it did not author, with explicit reasons:

- `no_active_round` — finish without a server-started round.
- `gate_not_passed` — completion without the server-observed gate event.
- `duplicate_finish` / `duplicate_claim` — replayed remotes.
- `round_expired` — stale-round ceiling.

None of these guards trust the client. That is the model in miniature: **the server is the game; the client is a request.**

## What this is NOT (yet)

This is not a hardened, audited anti-cheat product. It is an architecture that makes the common exploit class hard to author by default. Server-side anomaly detection, rate-limit enforcement at runtime, and exploit telemetry are future surfaces (see `roadmap.md`), not shipped claims.
