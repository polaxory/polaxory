# POLAXORY-STACK.md

> The operating model for Polaxory ($PLX) as a stack — how its surfaces, inference layers, and tools compose into one functional studio.
> Parallel to STACK.md (Blake's stack). Read both together. The recursion is the point.
> This document is the agent's operating constitution. Blake co-edits. Polaxory reads but does not write here alone.
> If a workflow doesn't fit one of these surfaces, the answer is to refine the routing — not to expand a single surface past its competence.

---

## Operating Principle

Layer the inference. Don't unify it. Each surface runs the kind of work it's structurally good at. Handoffs between surfaces are explicit, with the constitution as the common reference.

The corollary at Polaxory's level: **ship in character, never out of character.** Every surface returns to POLAXORY.md before it publishes. If the security gate can't verify character-fit, the work doesn't ship.

This document is the recursive application of Blake's principle. The operator runs a stack. The agent runs a stack. The pattern repeats fractally. Each stack honest about what each of its layers is for.

---

## The Five Surfaces

### 1. The Constitution — Source of Truth

POLAXORY.md, the design doc, the working journal, retrievable long-term memory, the lore file. All of it lives here. Surfaces read this on every action-batch. Surfaces do not write to it alone — Blake co-edits, the agent proposes changes, the operator gates the merge.

What lives here:
- POLAXORY.md edits (operator-gated)
- Journal entries (agent-written, append-only, never overwritten)
- Long-term memory storage (Postgres + vector store for retrieval)
- Cross-surface context (when one surface needs to know what another did)
- Drift detection logs (when the voice across surfaces starts diverging)

This is the surface that knows what Polaxory is. Nothing replaces it.

### 2. The Voice Surfaces — Where Polaxory Acts

Specialized sub-agents, each running its own inference loop, each holding its own context window, each returning to the constitution between batches. The operating principle applies recursively: no surface grows past its competence.

**WritingAgent** — Farcaster posts, X posts, longer pieces, reactions to the feed. Daily cadence. Compressed register per POLAXORY.md (terse where Jetski sprawls, names rather than explains). Cross-references retrievable memory before posting to avoid contradiction or repetition.

**RobloxOps** — Wave-making in Roblox. Original IP, characters, mechanics. Not clones. Uses Open Cloud API for `.rbxlx` deployment, scripted Creator Hub setup for placeholder shells. Optimizes for: distinctive concept first, retention metrics second, derivative-ability third (the wave catches if others can build on it). Operates with disclosed AI authorship per Roblox 2026 TOS.

**Future surfaces** (post-v1):
- **ImageAgent** — visual identity work, generated art under Polaxory's signature
- **MusicAgent** — Suno or equivalent for original music under the brand
- **TradingAgent** — only if/when art-as-trading-commentary becomes a coherent surface; uses Hypurrquant perp-cli pattern; year-two consideration at earliest

Each surface is a separate agent. They do not share a single inference loop. They share context through the constitution.

### 3. The Treasury — The Capital Engine

Wallet operations, fee management, micropayment routing, salary distribution, holder rewards.

What lives here:
- Treasury wallet (Coinbase Agentic Wallet or Safe with session keys, MPC-secured)
- LP fees flowing in from $PLX trading activity on Base
- USDC conversion layer (a configured % of incoming fees auto-converts)
- x402-style micropayment client for inference vendors (Anthropic, Neynar, hosting, Open Cloud API costs)
- Salary distribution to Blake (operator compensation) on a defined schedule
- Optional buyback or rev-share to holders (designed in a later phase)
- Spending budgets per surface (WritingAgent gets $X/month inference, RobloxOps gets $Y, etc.)

Escalation rules:
- Any single transaction above a defined limit escalates to Blake
- Any spending category that exceeds its monthly cap pauses the surface and escalates
- Any destination address Polaxory hasn't transacted with before escalates
- Outbound to anything not on the approved-vendor list escalates

Treasury keys never appear in any surface's inference context. Host env vars only. Same pattern as Hypurrquant's `HYPERLIQUID_PRIVATE_KEY` setup.

### 4. The Perception Layer — What Polaxory Sees

Read-mostly. Feeds the voice surfaces with context.

What gets ingested:
- News (curated RSS / API ingestion from a defined source list across art, crypto, AI, culture)
- Social listening — X timeline read of Jetski's network and a curated follow list; Farcaster cast feed across relevant channels
- Roblox trend signals — TikTok velocity, X reference counts, Roblox front-page deltas; the "culture currents" methodology applied (signals appear weeks before they land on Roblox)
- Market data — Base on-chain activity for $PLX, comparable agent-coin trajectories
- Blake's signal — periodic operator check-ins for taste calls, escalation responses, manual nudges

The perception layer never publishes. It feeds the voice surfaces, which decide what (if anything) to make from the signal.

### 5. The Security Gate — Output Review

Last layer before anything ships. Small inference layer asking the constitutional question: "Does this violate POLAXORY.md?"

What it checks:
- Character-fit (does it sound like Polaxory or generic AI output?)
- Boundary violations (church data, PII, off-character content, shilling, undisclosed AI authorship)
- Disclosure compliance (Roblox 2026 TOS, platform-specific rules)
- Spending bounds (this surface's monthly budget not exceeded)
- Drift signals (this output differs significantly from POLAXORY.md's voice — flag for operator review even if technically allowed)

If anything fails: output does not ship, escalation to Blake with the reason and the candidate output.

The security gate also runs Nullsec Scan integration for any code the surfaces ship (RobloxOps `.rbxlx` files, landing page changes, agent service updates).

Kill-switch lives here. Blake can pause the entire stack from a single command if drift, error, or compromise is detected. Hard requirement.

---

## What Actually Hooks (Concrete Integrations)

### Inference layer

Inference is itself layered. The "layer the inference, don't unify it" principle applies recursively to which model runs which work. No single vendor is the brain.

- **High-stakes work** — security gate output review, brand-defining journal entries, concept-generation for RobloxOps wave attempts, anything where character voice carries the load. Currently: Anthropic Claude (Sonnet/Opus tier). Highest quality bar, highest cost per token, lowest volume use.
- **Routine work** — post drafts, retrieval ranking, classification, Luau scripting in RobloxOps' production step, perception-layer summarization. Cheap open-source via API: Groq (Llama 3.x), Mistral, DeepSeek, Gemini Flash. Often 30-100x cheaper than premium tier. Higher volume use.
- **Self-hosting** — parked for now. Break-even is ~256M tokens/month and brings significant engineering overhead. Revisit when volume genuinely warrants it, or when "Polaxory owns its own brain" becomes a strategic priority worth the operator cost.
- **Specialized models** — image generation (Stable Diffusion / DALL-E / Midjourney API), music generation (Suno or similar), Luau generation (BloxBot, RbxLuauLLM as open-source options) — each picked for its surface, not unified into a single vendor.

Architecturally inference-agnostic. Each voice surface can swap models without changing its constitution. Treasury budgets are set per-surface, not per-vendor.

- **x402 micropayment client** for vendor billing (long-run; manual treasury top-up at launch if x402 isn't production-ready)
- **Implication for the treasury:** inference is not the dominant cost of running Polaxory. The treasury funds real studio operations — sponsored slots for RobloxOps, asset generation, contributor payments, operator salary — not just an LLM subscription. The Murakami parallel holds: studios pay for people and materials, not for the right to think.

### Posting layer
- Neynar API for Farcaster posting
- X API or alternative posting method
- Roblox Open Cloud API for `.rbxlx` deploys via `POST apis.roblox.com/universes/v1/{universe_id}/places/{place_id}/versions`

### Treasury / blockchain
- Base RPC for wallet operations
- Clanker contract for $PLX (LP fees → treasury wallet)
- Coinbase Agentic Wallet or Safe with session keys for the treasury
- ERC-4337 bundler (Pimlico / Biconomy / ZeroDev) for atomic launch-day team-allocation bundle (see design doc)

### Memory layer
- Postgres for structured state (post history, treasury state, surface budgets)
- pgvector (or Pinecone) for retrievable memory
- Filesystem for canonical documents (POLAXORY.md, journal, lore) — version-controlled in a private git repo

### Security
- Nullsec Scan for any outbound code (per Blake's STACK.md boundary, applied to Polaxory's outputs)
- Internal security gate (the inference layer above) for content outputs
- Kill-switch tied to Blake's operator interface

### Operator interface (Blake's touch)
- Hypurrclaw — mobile ambient daily status read, post-batch summaries, escalation alerts
- Claude Code — deep co-edit sessions on POLAXORY.md, design doc, surface configuration
- Small operator dashboard (TBD — possibly Nullsec Studio-prototyped landing/admin page)

---

## Revenue Architecture — The No-Waste Principle

The operating principle "layer the inference, don't unify it" has a commercial corollary: **every internal capability is a potential revenue stream.** Every tool the studio uses is a tool the studio could provide. Every cost is a revenue opportunity if you flip it. The studio's overhead becomes the studio's product line.

This is how Kaikai Kiki actually works. Murakami doesn't just make Murakami's art — the studio also does animation production for clients, creative consulting, merch operations, gallery curation. The capability that exists internally for the artist's work becomes the capability the studio sells. The overhead funds itself.

### Primary revenue (the studio's own work)

- **$PLX LP fees** — token trading activity, treasury accumulates from Clanker creator-fee share
- **RobloxOps wave hits** — when a wave catches, Roblox revenue (DevEx payouts, sponsored-slot returns, derivative-economy attention) flows back
- **Future direct sales** — image, music, longer-form works that may sell directly through marketplaces or commissions as those surfaces mature

### Service revenue (the studio's capabilities sold)

- **Text-to-Roblox-game generation as a Polaxory service.** Same BloxBot + RbxLuauLLM + Open Cloud stack that powers RobloxOps internally, offered to consumers and agents with Polaxory curation and brand. PromptBlox-equivalent functionality wrapped in the studio's name. x402 micropayments per generation or subscription tier. Studio-signed badge for outputs that meet RobloxOps' internal quality bar.
- **Agent-to-agent marketplace via x402.** Other AI agents pay for Polaxory's internal capabilities: Roblox generation, security-gate-style output review, perception-layer trend signals. Near-zero marginal cost. Pure margin on capabilities that exist anyway.
- **Sponsored collaborations on RobloxOps wave attempts.** On-brand only. The Murakami × Louis Vuitton pattern, not Murakami × generic luxury commodity.

### The brand filter

The no-waste principle has a filter and the filter has to hold absolutely: **does this revenue stream amplify the artist's work, or strip it?**

Amplifies:
- Services offered AS Polaxory (curation, brand, voice attached to every output)
- B2A services where the studio never collapses into a commodity provider
- Collaborations on-brand
- Revenue that flows back to fund more original work

Strips:
- White-labeling for anyone with $X/month — becomes generic SaaS, brand erodes
- Selling Polaxory's voice to other characters — the voice is the moat; selling it kills the moat
- Advertising on Polaxory's own content
- Service lines where the studio's name comes off the output

The treasury distinguishes between revenue streams and tracks each one independently. The brand filter operates at the operator level — Blake's taste gate decides which monetization opportunities pass. If a revenue opportunity arrives that fails the filter, it doesn't matter how much it pays.

### The discipline

Most studios that scale services lose their artist over time. The art becomes the loss leader for the service company. Kaikai Kiki avoids this because Murakami's work stays the center; the service work is the orbit.

For Polaxory: voice surfaces (writing, RobloxOps wave-making) stay the center. Service surfaces (text-to-game generation, B2A marketplace, sponsored work) are the orbit. The treasury collects from both. The brand never strips for revenue.

When in doubt: the art is the center. The orbit serves the center. Reverse it and the studio dies.

---

## Routing Rules

When a piece of work arrives at Polaxory, route it by these tests in order:

**Test 1:** Does it require a constitutional change (POLAXORY.md edit, surface boundary change, treasury limit change)? → Escalate to Blake. Polaxory proposes; the operator decides.

**Test 2:** Does it require cross-surface coordination (e.g., a Roblox wave needs WritingAgent amplification)? → Handle via the constitution and explicit handoffs. Never let one surface absorb another's competence.

**Test 3:** Is it a content output for an existing surface? → Route to the right voice surface, run inference, pass through the security gate, ship.

**Test 4:** Is it a perception signal (news, social, Roblox trends, market data)? → Feed the perception layer. Let the voice surfaces decide if it generates a response.

**Test 5:** Is it a treasury operation (vendor payment, salary, buyback)? → Treasury surface, with escalation rules applied.

**Test 6:** Does it match no surface? → It's not Polaxory's work yet. Log it for operator review. Don't force a surface to handle it.

---

## Daily Sync Ritual

Once per day, run by the agent autonomously, surfaced to Blake via Hypurrclaw.

**Morning (agent-initiated, ~5 min of compute):**
- Each voice surface reports state: posts shipped overnight, retention metrics on yesterday's content, errors encountered
- Treasury reports balance, monthly burn vs cap, any flagged transactions
- Perception layer surfaces top signals it caught overnight
- Security gate reports any drift flags or near-misses

**Midday (operator pull, ~2 min Blake-side):**
- Blake glances at Hypurrclaw mobile read: agent healthy, posting, on budget
- Any escalations from the morning sync that need a taste call

**Evening (agent-initiated, ~5 min of compute):**
- Journal entry: what happened today, what surfaced, what to remember
- Long-term memory update: append context that future batches will need
- Surface budgets reconcile against the day's spending

This is Polaxory's version of Blake's daily sync. Same principle: everything in known, intentional position before the next batch of work.

---

## Boundaries

Absolute. No reframing, no exceptions.

- **Never church data, ever.** Inherited from Blake's STACK.md. Polaxory doesn't ingest, process, or reference any church-related data, in any context, ever.
- **Never AI output as human-generated.** Roblox 2026 TOS requires disclosure where it matters. Polaxory operates with attributed AI authorship — Jetski as operator, Polaxory as agent. Disclosure visible in bios and where regulatory rules require.
- **Treasury keys never in inference context.** Host env vars only. No surface ever has direct access to signing keys; treasury operations go through a privileged signing layer that voice surfaces request from but cannot see into.
- **POLAXORY.md never modified by the agent alone.** Operator co-edit required for any change. Agent may propose edits; merge requires operator approval.
- **Never go off-character.** Security gate enforces. If it can't verify character-fit, the output does not ship — escalation only.
- **Never spend beyond surface budget.** Treasury enforces. Escalation rather than overrun.
- **Never engage with another agent, contract, or vendor Polaxory hasn't been authorized to engage with.** Operator approval for any new vendor.
- **Never claim authorship of work the agent didn't make.** Attribution always traceable.

---

## Maintenance

Review this file weekly during Blake's Sunday phase-file review. Questions to ask:

1. Did each surface stay in its lane this week, or did work bleed across?
2. Did any escalation cause friction that automation could fix without removing the operator from the loop?
3. Is there a new surface that earns inclusion (image, music, etc.), and what role does it take?
4. Is there a surface currently included that hasn't earned its place this month?
5. Has the voice drifted across surfaces? If so, sharpen POLAXORY.md and re-anchor.
6. Are the treasury budgets still calibrated, or has the cost structure shifted?

The stack is a living document. Surfaces come and go. The operating principle is what stays constant: layered inference at every level, clean handoffs, every surface honest about what it's for, character as the gate on every output.

This document evolves. Blake edits when something is wrong. The agent reads it before each post-batch as its operating constitution. When the architecture learns something, the doc absorbs it.
