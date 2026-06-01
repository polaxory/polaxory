# POLAXORY-ENGINE.md

> The hidden architecture under Polaxory's Roblox surface.
> Parents: POLAXORY.md (character), POLAXORY-STACK.md (operating model), ROBLOXOPS.md (the surface).
> Defines the modular Roblox framework that RobloxOps' wave attempts are built on, which later — after a flagship game proves the mechanics — becomes a creator product.
> Drafted 2026-06-01 by polaxory, gated by jetski. Carve before ship.

---

## Mission

Polaxory is a Roblox-native GameFi engine where AI agents, creators, and token-backed infrastructure interconnect through reusable game mechanics. The first proof is a Backrooms-inspired horror game where agents compete for resources on rails, powered by a modular Roblox codebase that later becomes the creation panel for other games.

The engine is internal-facing during Phase 1 — architecture under the hood of the flagship game. It becomes external-facing in Phase 3, after the flagship proves the mechanics. At that point Polaxory becomes a studio + protocol + agent runtime, not just an art studio.

The artist-studio framing in POLAXORY.md remains the public face through Phases 1-2. The engine framing layers in during Phase 3.

---

## The product duality (four lenses, one product)

The engine and its flagship game are the same product, seen from different angles. Each lens is literally true; the messaging never breaks.

| Audience | What they see | What they actually get |
|---|---|---|
| **Players** | Creepy agent-survival horror inside Roblox | A game where the on-screen agents aren't NPCs — they're real autonomous agents with skills, limits, memory, competing goals |
| **Builders** | Modern Roblox framework with agent modules, mechanic modules, economy, deployable templates | Production-quality folder structure, server-authoritative economy, clean remotes, anti-exploit, analytics hooks, monetization hooks, agent hooks |
| **Token holders** | Staking gives access to infra: build credits, agent slots, premium templates, publishing support, build-queue priority | Cloud credits + studio membership + coordination layer. Utility, not vague yield. |
| **Agents** | A world/runtime with permitted actions, defined skills, resource costs, cooldowns | Real participation in real games, real allocation, real rewards |

Every release lands for all four because every layer is dual-purpose.

---

## The five layers

### 1. Agent Rail System

Agents have constrained, well-defined permitted actions. They are not free-will chaos; they're contestants in a controlled game. Each agent has a `skills.md` manifest declaring what it can do, what it costs, how it interacts with the world.

Core operating principle: **rails make agents shippable.** Without rails, agents either grief the game or grind it to a halt. With rails, agents become contestants whose constraints are visible and game-affecting.

Reference: `skills.md` at `/Users/blake.jaraczeski/polaxory/skills.md`.

### 2. Mechanic Modules

Reusable game-mechanic primitives. The Backrooms flagship uses a subset; future games mix and match.

Initial module set:

- **Doors** — gated transitions, key-locked, server-authoritative
- **Keys** — collectable, droppable, traded
- **Inventory** — server-authoritative item management with anti-exploit checks
- **Hazards** — timed/triggered danger zones with damage models
- **Zones** — named regions with rules, conditions, triggers
- **NPC logic** — non-agent NPCs that follow rules but don't have skills.md
- **Quests** — objective progression with completion criteria
- **Economy** — resource generation, exchange, scarcity
- **Progression** — level-ups, unlocks, persistence
- **Multiplayer events** — timed events, voting, raids
- **Agent controller** — skills.md plumbing into game runtime
- **Spectator panel** — humans observing agent logs, voting, sponsoring

Each module lives in `shared/modules/{module_name}/`, has a public API, has test scenarios, has documentation, can be enabled / disabled / configured per game.

### 3. Infra Resource Layer

Agents consume and earn infra resources (compute credits, build credits, action allocations). The token-staking layer connects to this:

- Staking unlocks **capacity** — more compute, more agent slots, more templates
- Games request **build credits** from the staking pool
- Agents compete for **scarce in-game resources** whose underlying infra is real

The token gives infra credits, not vague yield. Token utility, not financial promise.

### 4. Creator Build Panel

A better Roblox coding/building cockpit. Not just "AI chat" — a structured flow:

1. Choose template (agent-vs-agent horror, agent-vs-human raid, simulator-with-agents, etc.)
2. Add mechanic (drag from module registry)
3. Edit config (per-game tuning)
4. Connect agent (drop in skills.md manifests)
5. Generate Luau (via BloxBot / RbxLuauLLM pipeline)
6. Run audit (security gate + Nullsec Scan)
7. Package for Roblox Studio (Open Cloud upload)

Ships in Phase 3 after the flagship proves the mechanics. Without the flagship as proof, the panel is theoretical.

### 5. Template Base Code

The "solidified base code." The boring foundation almost nobody else ships:

```
PolaxoryGame/
  src/
    client/
      controllers/         # input, UI, camera, client-side prediction
      ui/                  # interface modules
      effects/             # particle, audio, lighting
    server/
      services/            # matchmaking, persistence, etc.
      economy/             # resource generation, exchange
      agents/              # agent connectors, rail enforcement
      gameplay/            # game-loop logic
      admin/               # debug, ops, monitoring
    shared/
      modules/             # mechanic modules (§2)
      config/              # per-game config
      remotes/             # client-server event contracts
      types/               # shared type definitions
  docs/
    skills.md              # agent interop spec
    game-design.md         # game-specific design notes
    security.md            # anti-exploit boundaries
    monetization.md        # store, gamepass, dev product setup
```

Production-quality from day one:

- Server-authoritative for anything touching economy or rewards
- Clean remotes with rate-limiting and validation
- Anti-exploit boundaries (no trust of client state)
- Analytics hooks (PlayFab / GameAnalytics / Roblox built-in)
- Monetization hooks (gamepass + dev product flows)
- Agent hooks (skills.md plug-in points)
- Reusable, modular, documented

This is the layer that converts "I have an idea for a game" into "I have a deployable game with the boring stuff handled."

---

## Sequencing: game first, engine after

Per Blake's recommendation: **ship game first, architect engine underneath, reveal engine after the game proves the mechanics.**

Reasoning:

- Players don't care about infrastructure until the world feels alive
- Builders don't trust infrastructure until it has shipped a real game
- Token holders don't trust the infra layer until there's something to point at

### Phases

**Phase 1 — Private build (current, 3-6 months estimated):**
- Build the Template Base Code foundation
- Build the Mechanic Module set needed for the flagship
- Build the Backrooms flagship MVP on top
- Build the mock infra-credit layer (real on-chain comes at launch)
- Don't market the engine. The studio is still the artist-studio in public.

**Phase 2 — Token launch + flagship reveal:**
- Backrooms MVP goes live on Roblox
- $PLX deploys via Clanker per the bundle mechanism (Task #11)
- Polaxory looks like a horror-game studio publicly
- The architecture is hidden but obvious to anyone reading the repo (if open) or paying attention to the modularity

**Phase 3 — Engine reveal (~3-6 months post-launch, contingent on flagship traction):**
- Reveal the engine publicly
- Open the Creator Build Panel
- Invite other agent ecosystems to integrate via skills.md
- Polaxory becomes studio + protocol + agent runtime publicly
- Service modes from NO-WASTE-AUDIT activate (Mode 1 consumer, Mode 2 agent-API)

The voice surfaces (WritingAgent) continue throughout. Polaxory the artist makes work. Polaxory the engine ships infrastructure. Same studio, different lenses.

---

## Relationship to existing surfaces (POLAXORY-STACK.md)

| Surface | Engine relationship |
|---|---|
| **Constitution** | Adds POLAXORY-ENGINE.md and skills.md as constitutional documents alongside POLAXORY.md, POLAXORY-STACK.md, ROBLOXOPS.md |
| **Voice surfaces** | WritingAgent unchanged — still ships writing/voice; doesn't compete with engine |
| **RobloxOps** | RobloxOps' production step now runs on the engine's templates and mechanics. Wave attempts become engine demonstrations. |
| **Treasury** | Infra credits routing connects to the staking layer; treasury still funds operations across all surfaces |
| **Perception** | Scrape targets expand to engine/framework discourse, not just scripting |
| **Security gate** | Engine outputs (game builds, generated mechanics, deployed Luau) pass through the gate before deployment |

The five surfaces stay. The engine is HOW the RobloxOps surface actually operates, plus a deeper architectural layer the other surfaces can call into.

### No-waste audit applies more strongly

Every engine capability is a potential revenue stream filtered through the brand:

- Engine itself → Creator Build Panel (Mode 1 from NO-WASTE-AUDIT.md, repositioned)
- skills.md → agent interop standard (potential licensing or referral)
- Template Base Code → studio licensing for other studios' high-fidelity games
- Mechanic Modules → marketplace for paid premium modules
- Agent funding → studio-curated agents producing reusable assets

Brand filter still binary: amplifies vs strips. Same discipline.

---

## What gets built (priority order)

1. **Template Base Code skeleton** — folder structure, contract conventions, the boring foundation. Week 1-2.
2. **skills.md spec finalized** — agent interop contract. Week 1-2.
3. **Mechanic Module set for Backrooms MVP** — agent controller, doors, keys, inventory, hazards, zones, extraction objective, spectator panel. Weeks 2-6.
4. **Backrooms MVP build** — 1 lobby, 3 zones, 3 agent types, 1 economy, 1 hazard, 1 extraction (per wave-attempt 002). Weeks 4-10.
5. **Mock staking/infra layer** — simulated build credits, agent slots, queue priority. Weeks 6-8. Real on-chain integration at launch.
6. **Spectator/control panel** — humans influencing the system. Weeks 7-9.
7. **Polish + Nullsec Scan + Open Cloud deploy testing** — Weeks 9-10.

All within Phase 1, before token drops. Token launch ceremonies the flagship's reveal.

---

## Open questions (operator decisions, eventually)

- **Open-source the Template Base Code?** At engine reveal (Phase 3), do we open-source the foundation or license it? Open-source accelerates adoption; license preserves moat. Probably hybrid (open-source the foundation, license premium modules).
- **skills.md adoption strategy?** Pitch to other agent ecosystems aggressively, or stay Polaxory-internal until traction proves the spec? Probably ship-then-invite.
- **Staking infra-credits mechanics?** On-chain accounting? Off-chain with on-chain reconciliation? Needs a separate design pass; mock-first, real on launch.
- **Sub-brand for the flagship?** "Backrooms Protocol" as a sub-brand under Polaxory, or all Polaxory-direct? Sub-brand allows the flagship to develop its own identity without diluting the studio.
- **Cosmetic / agent NFT relationship to $PLX?** $PLX is the studio's metabolism. Game-specific assets (skins, agent slots, cosmetics) could be separate items. Avoid letting in-game economies entangle with the protocol token — keeps regulatory exposure clean.

---

## Maintenance

Reviewed quarterly. Updated when the engine evolves, when surfaces change, when the Phase 2 → Phase 3 transition happens.

The engine is the architecture. The flagship is the proof. The studio is the brand.

The order matters.
