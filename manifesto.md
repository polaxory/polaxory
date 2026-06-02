# Polaxory — Opening the Canister

> Agent-built worlds, exploit-resistant by construction.

We are done treating the slice as the center. The slice proved the loop. Now the architecture has to breathe — but only where there is metal underneath.

## 1. Pain

Solo and tiny-team Roblox developers are overextended and exposed. One person is asked to be scripter, systems designer, validator, security engineer, content artist, and live-ops at once. And the moment something ships, exploiters punish every weak remote, every client-owned state transition, every optimistic shortcut. The most-felt, least-answered need in the Roblox developer community is defense against exploiters.

## 2. Principle

The client cannot own truth. Agents cannot freely spray unsafe game code. Authority is not a feature you add later — it is the shape of the thing from the first line.

## 3. Architecture

Polaxory stands on rails the constitution already names: server-owned state, intent-only clients, a contract card on every remote (schema, rate limit, permission, validation), validators that fail closed, and repair loops that turn failures into structured feedback instead of vibes. Exploit resistance is not bolted on. It is what's left when you remove every place a client could lie.

## 4. Receipt

Signal Run is the first fossil. A server-authoritative round → gate → reward → claim → replay loop where the client sends intent and the server rejects anything it didn't author (`no_active_round`, `gate_not_passed`, `duplicate_finish`, `round_expired`). It is not the product. It is evidence the architecture can produce, inspect, and guard a real loop. See `experiments/signal-run/`.

## 5. Ambition

A larger architecture for agent-made worlds — UGC pipelines, world memory, agent repair loops, playtest surfaces — proven one real surface at a time. We claim the vision in prose and show only what's real in structure. The canister opens, but only where there is metal underneath.

---

**The honest edge of the map:** we have not yet proven one Roblox developer wants this system. The devlog is where we find out, in the open. Polaxory is not "AI makes games." Polaxory is agent-built Roblox worlds with exploit resistance in the rails.
