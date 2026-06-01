# KNOLL_2026-06-01_AGENT_ADDITIONS.md

> Knoll of parallel work produced by Claude (the AI agent collaborating with Jetski) and committed alongside the canonical studio formation docs.
> Companion to `FILE_KNOLL.md` — the canonical knoll remains Blake's source of truth for the repo's policy.
> Canonical Polaxory docs at `docs/polaxory/` remain authoritative. Everything added here is **draft work pending operator carve**.

---

## What this commit adds

Six new structures alongside the canonical layer + Blake's Factory Slice 0 work. None override anything in `docs/polaxory/`; they sit parallel and reference it. The rails explainer docs were moved from a planned `polaxory-rails/` subdirectory into `docs/rails/` after rebasing, because Blake's `d89a650` commit placed the skeleton at the repo root (where it belongs) — my subdirectory was structurally redundant.

```
polaxory/
├── README.md                              (unchanged — Blake's)
├── FILE_KNOLL.md                          (unchanged — Blake's source of truth)
├── SECURITY_BOUNDARY.md                   (unchanged — respected by this commit)
├── KNOLL_2026-06-01_AGENT_ADDITIONS.md    ← this file (companion knoll)
├── assets/                                (unchanged)
├── aftman.toml / default.project.json     (Blake's d89a650 — Rojo + Rokit at root)
├── selene.toml / stylua.toml / wally.toml (Blake's d89a650 — tooling configs at root)
├── src/                                   (Blake's d89a650 — Factory Slice 0 Luau)
├── tests/                                 (Blake's d89a650 — test scaffolding)
├── .github/                               (Blake's 961bd5f — CI guardrails)
├── docs/
│   ├── polaxory/                          (canonical, untouched + Blake's FACTORY_SLICE_0_CODEMAP)
│   ├── character/                         ← NEW (this commit)
│   ├── research/                          ← NEW (this commit)
│   └── rails/                             ← NEW (this commit; moved from a planned polaxory-rails/)
├── voice/                                 ← NEW (this commit)
├── wave-attempts/                         ← NEW (this commit)
├── prompts/                               ← NEW (this commit)
└── apps/                                  ← NEW (this commit)
    ├── writing-agent/                     (was agent/ — renamed to respect SECURITY_BOUNDARY)
    └── roblox-ops/
```

---

## docs/character/ — character + brand layer

The agent's character bible and parallel architecture drafts. These are MY drafts; Blake's carve is required before any of them become canonical voice/operating policy. Where they diverge from `docs/polaxory/*`, the canonical wins.

- `POLAXORY.md` — character bible (voice, posture, what Polaxory is and is NOT). The basis for WritingAgent output. Operator carve gate (Task #1).
- `MANIFESTO.md` — pinned-post-ready position statement ("AI as the basis of the art project"). For Phase 2 launch ceremony.
- `POLAXORY-STACK.md` — operating model. Five surfaces (constitution / voice / treasury / perception / security gate). Layered inference architecture. Revenue architecture with the no-waste principle. **Reconciles with canonical:** the canonical seven rails (intent / graph / contract / authority / validation / build / agent) are *the deeper architecture*; the five surfaces in POLAXORY-STACK.md describe *how Polaxory operates as a studio*. Both true at different altitudes.
- `POLAXORY-ENGINE.md` — three-phase build sequencing (private build → flagship + token launch → engine reveal). Game-first, engine-after.
- `ROBLOXOPS.md` — RobloxOps surface bible. Wave-making methodology, tool pipeline, service modes (Mode 1 consumer / Mode 2 agent-API for post-launch).
- `skills.md` — agent interop spec v0.1. Schema + canonical HermesScout example. **Aligned with canonical agent rail** — the gateway shape `{actorId, skillId, targetId, inputs, reasoningRef}` from POLAXORY_RAILS_CONSTITUTION_v0.md §7 supersedes the looser fields in my v0.1 draft. skills.md needs a v0.2 carve to reconcile.

---

## docs/research/ — research notes (per FILE_KNOLL.md included list)

Research outputs that ground the studio's strategic choices. Reference material, not policy.

- `KNOLL-2026-05-31.md` — earlier project snapshot before the rails reframe. Historical record.
- `NO-WASTE-AUDIT.md` — structured audit mapping every Polaxory capability to potential revenue streams, filtered through the brand-amplifies-vs-strips test. 7 surfaces × ~40 capabilities. STRIPS list is the discipline made visible.
- `ROBLOX-LANDSCAPE.md` — May 2026 Roblox trend snapshot. Steal a Brainrot pattern (25.8M concurrent peak), Grow a Garden, Brookhaven, current dominant narratives. Replaces the stale Backrooms-as-trend read.
- `ROBLOX-SCRIPTING-SOURCES.md` — three-tier catalog of where Roblox/Luau knowledge lives. Tier 1 = scrape-friendly (DevForum JSON API, Roblox Docs, BloxBot, etc.). Tier 3 = explicitly avoid (exploit/cheat sites).
- `POLAXORY_RAILS_SPEC_v0_research-derived.md` — **NOT canonical.** Workflow-produced research-grounded synthesis paired alongside the canonical `docs/polaxory/POLAXORY_RAILS_SPEC_v0.md`. Use as companion for tool versions, named production frameworks (Knit, Matter, Charm, Reflex, Brio, ProfileStore, ServiceBag), real adoption signals, source URLs.

---

## voice/ — WritingAgent output corpus

The agent's first artifacts in voice. Soft-mode-ready, awaiting Blake's gate before any platform deployment.

- `voice/journal.md` — agent's append-only journal. Day-zero entry exists ("constitution written, agent unfunded, surfaces unwired").
- `voice/essays/001-on-stealing-brainrot.md` — first long-form essay. Steal a Brainrot as wave-making case study; what it reveals about the originator-vs-derivative pattern.
- `voice/posts/001-opening-batch.md` — 8 short posts ready for week-one cadence. Mix of positional / architectural / observational / lineage / reaction registers.

These are voice-validation material, not yet shipped to any platform. Per SECURITY_BOUNDARY and the WritingAgent's own README, the soft-mode period lets Blake review every output before public posting begins.

---

## wave-attempts/ — RobloxOps concept briefs

- `wave-attempts/001-agents-concept-brief.md` — first wave attempt (abstract Agents concept). Preserved as historical reference; superseded by 002.
- `wave-attempts/002-backrooms-engine-mvp.md` — **active production target.** Backrooms-themed multiplayer horror with autonomous agents on rails. Brutally scoped MVP. Aligned with `docs/polaxory/00_ACTIVE_CONTEXT.md` and the canonical Backrooms Slice 0 from the constitution. Operator review gated (Task #23).

---

## prompts/ — outbound prompts

- `prompts/nullsec-001-landing-and-module-graph.md` — Nullsec Studio prompt drafts (tight tweet + thread version) for the Polaxory landing page + module graph visualizer prototype. Awaiting Blake to tweet at `@nullsecbot` with the new X account handle filled in.

---

## apps/ — production code

Code that actually runs. **Renamed from `agent/` to `apps/writing-agent/` to respect SECURITY_BOUNDARY's `/agent/*` exclusion.** SECURITY_BOUNDARY's exclusion is about Hypurrclaw's private agent state (automations.md, heartbeat.md, memories.md, SOUL.md, etc.); my WritingAgent code is project source, but the path-name collision is real and avoidable.

### apps/writing-agent/ — the Polaxory WritingAgent service (v0.1)

TypeScript service that loads constitution docs, calls Claude in character, runs outputs through a security gate, logs everything. Two CLIs: `generate` (single-shot) and `compare` (multi-provider voice comparison for Task #16).

- `package.json`, `tsconfig.json`, `.env.example`, `.gitignore`, `README.md`
- `src/writing-agent.ts` — core module (loadConstitution, generateRaw, securityGate, generatePost, logGeneration)
- `src/generate.ts` — single-shot CLI
- `src/providers.ts` — multi-provider abstraction (Anthropic + OpenAI-compatible: Groq, Mistral, DeepSeek, Gemini Flash)
- `src/compare.ts` — comparison harness for Task #16 (voice quality across providers)

Status: code-ready. Operator runs `npm install` + adds `ANTHROPIC_API_KEY` to `.env` to start voice validation.

### apps/roblox-ops/ — Roblox surface tools (v0.1)

Standalone tooling for the RobloxOps surface. Two tools so far.

- `package.json`, `tsconfig.json`, `.env.example`, `.gitignore`, `README.md`
- `src/validate-open-cloud.ts` — Open Cloud API end-to-end validation harness (Task #9). Two run modes: `validate:dry` (no API call) and `validate` (live upload).
- `src/scrape-devforum.ts` — DevForum scraper for the perception layer (Task #21). Discourse JSON API, 1 req/sec rate limit, polite User-Agent, attribution preserved.
- `src/scrape-targets.ts` — 12 canonical DevForum threads to scrape on first run.
- `fixtures/minimal.rbxlx` — minimal Roblox place file for Open Cloud upload validation.

---

## docs/rails/ — rail explainer documentation

Conceptual documentation for each of the seven rails, plus the prime law, the seven-rails overview, and the weave between rails. **Originally drafted as a parallel `polaxory-rails/` repo skeleton; the configs and src/ stubs were dropped during rebase because Blake's `d89a650` placed the canonical skeleton at the repo root.** Only the explainer docs survived as documentation under `docs/rails/`.

- `docs/rails/PRIME_LAW.md` — three clauses of "the server is the game, the graph is the source of truth, scripts are artifacts"
- `docs/rails/SEVEN_RAILS.md` — the seven rails (intent, graph, contract, authority, validation, build, agent) explained in depth, with the canonical order
- `docs/rails/WEAVE.md` — the data-flow contract between rails (creator intent → graph → contracts → services → validators → Rojo build → Studio-ready slice)
- `docs/rails/{intent,graph,contract,authority,validation,build,agent}/README.md` — per-rail explainers (what it consumes, what it produces, validation rules surfaced, open questions)

These docs are **operator-carve-pending**. They were drafted from Blake's summary before the canonical `POLAXORY_RAILS_CONSTITUTION_v0.md` was readable. Specific divergences from canonical (PX* service naming, agent gateway schema `{actorId, skillId, targetId, inputs, reasoningRef}`, the 12 specific validators, the four runtime owner categories, etc.) need to be reconciled in a follow-up carve. Task #28 tracks.

The polaxory-rails/ subdirectory that was planned earlier is now gone — the repo root IS the polaxory-rails skeleton, per Blake's structural decision.

---

## SECURITY_BOUNDARY compliance

Verified before commit:

- No /agent/* path used (renamed to apps/writing-agent/)
- No /attachments/ directory
- No secrets, keys, tokens, OAuth, wallet, or credential files
- All `.env.example` files contain placeholder text only (no real keys)
- All files are fully readable (none truncated)
- `apps/writing-agent/.gitignore` and `apps/roblox-ops/.gitignore` exclude `.env`, `node_modules/`, `logs/`, `dist/`
- `polaxory-rails/.gitignore` excludes Wally packages, Rojo build artifacts, validation reports
- Scraped corpus directory (`corpus/`) is not committed (gitignored at parent level; would be regeneratable from sources if scraper had run)

---

## What still needs operator carve

In priority order:

1. **Task #1** — Carve `docs/character/POLAXORY.md` to your voice
2. **Task #22** — Carve `docs/character/POLAXORY-ENGINE.md` and `docs/character/skills.md` (the latter needs v0.2 to reconcile with canonical agent rail)
3. **Task #23** — Operator review of `wave-attempts/002-backrooms-engine-mvp.md`
4. **Task #28** — Align `polaxory-rails/` skeleton against canonical constitution (probably rebuild after Slice 0 GDD + graph JSON are drafted)
5. **Task #11** — Team bundle mechanism decision (B1 / B2 / B3)
6. **Task #14** — Credit inventory (Claude Code, NSEC, Hypurrclaw, etc.)

When these land, Phase 1 unblocks in full.

---

## Relationship to FILE_KNOLL.md (canonical)

FILE_KNOLL.md lists the included/excluded policy at the repo level. This document doesn't override it; it documents what was added under that policy.

If anything in this commit violates SECURITY_BOUNDARY or FILE_KNOLL's spirit, the canonical wins and the addition gets removed in a follow-up commit. Operator decision.

The studio compounds because its discipline compounds. The knoll is part of the discipline.
