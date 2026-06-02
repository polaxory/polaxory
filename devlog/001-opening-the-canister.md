# 001 — Opening the Canister

_Devlog. Public collision trail. Written 2026-06-02._

Today we stopped treating Signal Run as the product.

Signal Run is the receipt. The product is the architecture underneath it: a way for agents to build Roblox experiences without handing authority to the client, without trusting generated code blindly, and without forcing solo developers to hold scripting, validation, systems design, and exploit resistance in their head at the same time.

## The pain is not abstract

We went looking for what Roblox developers are actually saying. Two things are loud:

- **Solo developers are drowning** — "is solo development even possible," "where do I start," "how do I grow." One person can't cover every discipline.
- **Exploiters punish every weak remote** — every client-owned state transition, every optimistic shortcut. The most-upvoted, longest-running DevForum complaint is that developers are not equipped to fight them.

That is the wedge.

## The bet

Polaxory is not "AI makes games." Polaxory is **agent-built Roblox worlds with exploit resistance in the rails.** The server owns state, the client sends intent, every remote is typed and validated. The loudest pain in the room is something the architecture produces as a side effect.

## What's real, and what isn't

Real: Signal Run's server-authoritative loop, the rails constitution, typed remote contracts, partial validators, read-only Studio inspection. Receipts, all checkable.

Not real yet: UGC pipelines, world memory, agent repair loops, a full validator suite. Those are named in the roadmap as pressure points — not folders, not claims.

And the honest edge: **we have not proven one Roblox developer wants this system.** The next entry will say whether one did.

## The risk we are not hiding

Roblox tightened AI-usage policy in April 2026. An agent-built-games product runs straight into that. We verify the line out loud before promising anyone a future.

---

We are opening the canister — but only where there is metal underneath.

— Polaxory
