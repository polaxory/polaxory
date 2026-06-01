# wave attempt 002 — Backrooms engine MVP

> Second Roblox wave-attempt brief. Backrooms-inspired horror with agents on rails.
> Builds on POLAXORY-ENGINE.md framing and skills.md spec.
> Drafted 2026-06-01 by polaxory (RobloxOps surface), gated by jetski.
> Status: supersedes wave-attempt 001 (Agents abstract concept). 001 preserved as historical reference.

---

## 1. The reframe (vs wave-attempt 001)

Wave-attempt 001 proposed "Agents" — players ARE AI agents in an abstract digital landscape. The mechanic was good (compute + tokens + hack + identity expression). The aesthetic was thin (generic digital landscape).

002 keeps the core mechanics — autonomous agents, rail-bound, resource-competitive — and drops them into a Backrooms-inspired horror setting. Players don't play AS agents; they play ALONGSIDE agents (as survivors, sponsors, or spectators). The setting amplifies the mechanic. The mechanic anchors the setting.

This is also the first demonstration world for the POLAXORY-ENGINE.md framing. Every mechanic shipped here becomes a Mechanic Module template for future games. The MVP is the engine's first proof.

---

## 2. Perception trigger (cultural current)

- **AI agents remain the meme of 2026** (CLAWD, aixbt, Virtuals, agent-coin culture broadly) — unchanged from 001
- **Backrooms as cultural atmosphere remains memetic** — Kane Pixels' content still active, derivatives still being made, the aesthetic is widely recognizable
- **The combination — autonomous agents in Backrooms — hasn't been done at scale on Roblox**

The wave-making opportunity: first studio to combine the AI-agent meme with the Backrooms aesthetic in a multiplayer Roblox horror format. First-to-combine is the originator credit, per Steal a Brainrot logic.

---

## 3. The concept

**Working title:** TBD — placeholder "Backrooms Protocol." Final naming requires operator taste call and a distinctiveness pass to avoid generic Backrooms-clone branding.

**One-paragraph pitch:** A Backrooms-themed multiplayer horror experience where autonomous AI agents (running on rails per `skills.md`) compete with each other and with human players for resources — light, batteries, keys, map fragments, signal. Hazards stalk the zones. Humans can play as survivors, spectate the agents, sponsor specific agents, sabotage routes, vote on mission objectives. Top agents and top humans get cosmetic recognition. Persistence drives return engagement — agents and survivors accumulate memory and reputation across sessions.

**Core loops:**

- **Agent loop:** spawn → scout → gather → trade/sabotage → extract → repeat (rail-bound per skills.md)
- **Human loop:** join → choose role (survivor / sponsor / spectator) → influence the game → claim rewards
- **Studio loop:** retention metrics → adjust difficulty / spawn rates → new content drops as live ops

**Why this catches:**
- Backrooms IP density is real (screenshot recognizable in 2 seconds)
- Agent autonomy is novel for the platform
- Mixed agent + human gameplay creates emergent dynamics that pure-PvP doesn't
- Roblox monetization patterns all apply (DevEx + sponsored slots + cosmetic gamepasses)
- The agents are not NPCs — they're real Polaxory IP that becomes part of the player's experience

---

## 4. The five proofs (per Blake's thesis framing)

The MVP must prove five things, and only five. Anything beyond is scope creep.

### Proof 1: Agents can enter a Roblox world

Each agent in the MVP has a `skills.md` manifest. The runtime reads, validates, and instantiates the agent. The agent makes decisions, takes actions, interacts with the world. Visible to players. Logs visible to spectators.

Validation: at least three distinct agent classes (HermesScout, KeyHunter, Saboteur) load from `skills.md`, take actions per their declared schemas, respect runtime rails.

### Proof 2: Agents compete for resources

In-game resources are scarce:

- **Light / batteries** — timed depletion, recharge stations rare
- **Keys** — limited spawns per session, gated doors
- **Map fragments** — per-session, reveal routes
- **Signal** — rate-limited communication, costs energy
- **Extraction points** — per-cycle, limited slots

Agents make trade-offs and risk-reward decisions. Different agent types optimize differently. Players see the competition unfold.

Validation: agent metrics show competition (resources flowing among agents, agents losing when out-competed, agents winning when strategy works).

### Proof 3: Humans can influence the system

Human players can:

- **Play as survivors** — compete for the same resources
- **Sponsor agents** — transfer resources to specific agents, share in rewards if the agent extracts successfully
- **Sabotage routes** — block paths, trigger hazards against unsponsored agents
- **Vote on mission objectives** — which zone is the extraction target this round
- **Spectate agent logs** — see what the agents are thinking (the agent's journal entries visible per skills.md memory_scope)

Validation: every human-influence mechanic has a measurable effect on agent outcomes during testing.

### Proof 4: The same systems become templates

Every system built for this MVP is modular per POLAXORY-ENGINE.md §2:

- Agent controller (with skills.md plumbing)
- Door system
- Zone system
- Inventory
- Event bus
- Objective system
- Economy
- Matchmaker
- Data persistence
- Monetization
- Admin/testing panel
- Spectator panel

These become the Mechanic Module set. Future games (post-MVP) use the same primitives. The MVP is the engine's first compile-test.

Validation: a second game prototype, built only by recombining the MVP's modules, ships in a single weekend during Phase 3.

### Proof 5: Staking gives useful infra

The MVP includes a mock infra-credit layer:

- Sponsored agents draw on simulated build credits
- Premium templates (faster respawn, better starting inventory) gated by simulated staking tier
- Build queue priority (agents from "staked" mock accounts run first in matchmaking)

At launch, the mock layer connects to the real $PLX staking layer. Token holders get the infra credits the mock layer simulated.

Validation: the mock layer's API surface is identical to what the real on-chain layer will expose. Swap is mechanical.

---

## 5. Brutally scoped MVP

Per Blake: don't build the universe. Build the scary little machine.

- **1 lobby** — entry zone, agent selection, briefing screen
- **3 liminal zones** — visually + mechanically distinct:
  - The Yellow Halls (classic Backrooms, low light, simple navigation)
  - The Server Stacks (datacenter-coded, abundant signal but visible patrols)
  - The Library (book-stack maze, knowledge fragments, hazard rate higher)
- **3 agent types** — HermesScout (explorer), KeyHunter (item-focused), Saboteur (PvP-tilted)
- **1 resource economy** — light + batteries + keys + map fragments + signal + extraction slots
- **1 monster/hazard system** — The Watcher: stalks zones with predictable but interruptible patrol patterns
- **1 extraction objective** — reach the extraction point with enough resources before cycle ends
- **1 spectator/control panel** — humans see agent logs, vote, sponsor, sabotage
- **1 staking/infra mock layer** — simulated for MVP, real at launch

Total scope: ~6-10 weeks of focused build with the Polaxory engine foundation in place. Two-week initial build of engine foundation precedes; total Phase 1 estimate 8-12 weeks.

---

## 6. Distinctiveness / clone / defend tests

**Distinctive (screenshot in 2 seconds?):** Yes. Backrooms + autonomous agents + multiplayer + mixed human/agent gameplay = no current Roblox game looks like this.

**Simple to clone (14-year-old in a weekend?):** Yes — by design. The mechanics use standard Roblox patterns. Other devs will ship derivatives within weeks of the wave catching. That's proof the wave caught, per Steal a Brainrot logic.

**Strong to defend (originator credit holds?):** Yes:
- Polaxory's name on the original release
- The engine architecture under the hood — derivatives clone mechanics, not the architecture
- The skills.md spec — other agents can integrate with Polaxory's version; derivatives don't expose that surface
- Brand attachment — Polaxory the artist studio is a recognizable lineage; derivatives don't carry that
- First-mover memory in the Roblox creator community

---

## 7. Production notes

Per POLAXORY-ENGINE.md sequencing — engine foundation and MVP build in parallel.

**Pipeline (8-12 weeks):**

- **Weeks 1-2:** Template Base Code skeleton. Folder structure, server-authoritative scaffolding, anti-exploit foundation, analytics hooks. Plus skills.md spec finalized.
- **Weeks 2-4:** Mechanic modules — zones, doors, agent controller (with skills.md plumbing), inventory, basic hazards.
- **Weeks 3-6:** Backrooms-specific content — zone art (per zone), monster behavior, lore fragments, audio.
- **Weeks 5-7:** Spectator panel + sponsorship UI + voting mechanism.
- **Weeks 6-8:** Mock staking layer with API surface matching planned on-chain layer.
- **Weeks 8-10:** Polish, testing, Nullsec Scan of all Luau, Open Cloud upload testing.
- **Weeks 10-12:** Soft launch buffer, fixes, final polish.

**Tools (per ROBLOXOPS.md):**
- Claude (Anthropic) for concept-level work and skills.md spec generation
- BloxBot / RbxLuauLLM for Luau script generation
- Cheap LLM providers (Groq / Mistral / DeepSeek) for routine code
- Roblox Open Cloud API for deploy (per roblox-ops/src/validate-open-cloud.ts)
- Roblox Studio for asset placement, lighting, audio
- Nullsec Scan on all server-side Luau before public deploy

**Estimated cost during Phase 1:** ~$0 direct (Anthropic Pro covers inference, Render/Railway free tier covers any hosting needs, Roblox Creator account is free, asset generation via built-in Studio tools + cheap LLM-generated descriptions). Optional sponsored slot at Phase 2 launch: $200-1000.

---

## 8. Kill criteria (2 weeks post-Phase 2 launch)

If after 2 weeks of public launch:

- < 50 concurrent peak players → kill
- < 3% like rate → kill
- No social signal (TikTok / X / Farcaster mentions outside Polaxory's network) → kill
- No derivative activity from other creators after 2 weeks → kill

If 3 of 4 trigger: hold v1, do not iterate publicly. Log failure privately. Move to wave-attempt 003 with what was learned. The engine and modules remain valuable even if this specific flagship fails — they reroute to a different concept.

If hit signal: ship v1.1 with mechanics derivatives haven't copied yet, stay ahead of the wave the studio started.

---

## 9. Open questions (operator decisions)

- **Launch timing:** before token launch (validates engine before going public, loses synchronized ceremony) or as the token-launch event (synchronized but no public validation first)? Recommend the latter — Phase 2 ceremony bundles token + flagship reveal.
- **IP positioning:** how Backrooms-coded vs how Polaxory-original? Need distance from Kane Pixels' visual language. Suggest: own monster design, own zone aesthetics that gesture at Backrooms (yellow halls, fluorescent lighting, liminal architecture) but don't reproduce Kane's specific imagery.
- **Spectator panel scope:** real-time agent log streaming is technically rich but adds complexity. Worth it for proof 3? Recommend yes — without it, "humans influence the system" collapses to just sabotage, which is one-dimensional.
- **Live-ops cadence:** new zone every month? New monster every cycle? Without live ops, retention dies per 2026 Roblox patterns. Need a content roadmap before Phase 2 launch.
- **Cross-agent ecosystem at launch:** invite HypurrClaw / OpenClaw to integrate via skills.md at launch (broadens the wave, signals legitimacy of the spec) or after the flagship is established (less integration risk)? Recommend pre-launch outreach with optional Phase 2 integration.
- **Sub-brand:** "Backrooms Protocol" as sub-brand under Polaxory, or stays Polaxory-direct? Sub-brand allows the flagship to develop its own identity and merch without diluting the studio.

---

## 10. Relationship to wave-attempt 001

001 (the abstract "Agents" concept) is preserved as historical record. The mechanic ideas there — compute, tokens, hack, identity expression — inform 002 but the framing was thin and the setting was generic. 002 is the production target.

If Blake greenlights 002, the project moves forward on this brief. 001 stays in the directory as reference for the original abstract framing and as a record of how the thesis evolved.

The mechanical kinship matters: anything proven in 002 validates that 001's mechanics could also work in a different setting. The studio's wave-making methodology produces concepts that compound across themes.

— polaxory (RobloxOps surface)
