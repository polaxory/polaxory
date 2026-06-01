# PRIME LAW

> **The server is the game. The graph is the source of truth. Scripts are artifacts.**

---

## The three clauses

### 1. The server is the game.

State that matters lives on the server. The client is a renderer with input. Anything important — economy, ownership, agent actions, validation outcomes — is owned, validated, and persisted server-side.

This is not a stylistic preference. It's the only defensible posture on Roblox: clients can be tampered with; servers can't (within Roblox's sandbox). Any module that asks the client to be authoritative violates the prime law and the validator system rejects it at build time.

### 2. The graph is the source of truth.

What the game IS lives in the graph — nodes (modules) and edges (events). Code is generated from the graph or written to satisfy contracts the graph implies. The graph is canonical; the code is downstream.

If a script does something the graph doesn't describe, the script is wrong or the graph is incomplete. Either way, the resolution is to update the graph, not to special-case the script.

### 3. Scripts are artifacts.

Scripts are outputs, not sources. Production-quality scripts are valuable, but they're produced from valid graphs and contracts, not authored in isolation. A script that exists outside the graph is a leak — fix the graph to absorb it or delete the script.

This is the discipline that makes Polaxory different from Roblox Assistant. Assistant generates scripts. Polaxory generates *systems that hold together*. The script is incidental; the system is the product.

---

## What this rules in

- Server-authoritative economy, ownership, agent actions, validation
- Graph-first design: changes start in the graph, propagate to contracts, then to code
- Build-blocking validators that refuse to ship a graph + code combination that violates the law
- Versioned graph schemas (breaking changes bump major versions)
- Audit logs for every server-side state change

## What this rules out

- Client-side trust for economy operations
- Scripts that bypass the graph (no "I'll just hand-write this one")
- Special-case modules that don't declare contracts
- Implicit dependencies between modules — every dependency is an edge in the graph
- "Just this once" exceptions — the law doesn't have exceptions; the graph absorbs the case or the case doesn't ship

---

## Operator notes

The prime law is the most expensive thing to discover too late. Most Roblox games carry the cost of an incomplete server-authority discipline forever — every exploit, every economy reset, every roll-back traces to a moment when the client got trusted with something it shouldn't have been.

Polaxory pays the cost up front. The validator catches the violation at build time, not in production after a player exploits it.

The graph-as-source-of-truth discipline is the equivalent law for code. Most Roblox codebases drift because scripts get written without graph updates. Polaxory's build pipeline rejects drift. Either the graph absorbs the new behavior or the build fails.

The discipline costs velocity at the top of the funnel. It pays back at every junction below.
