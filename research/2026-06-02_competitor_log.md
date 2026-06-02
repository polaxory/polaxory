# Competitor Log — "Agent-built worlds, exploit-resistant by construction"

> Started 2026-06-02. Owner: Polaxory.
> Thesis under test: the defensible edge is not "AI makes games/assets" — it's that
> agent-generated gameplay code is **exploit-resistant by construction** because the
> server owns state and the client only sends intent. Anti-LARP: real product edge, not positioning.
>
> Evidence base: deep-research run `wf_cd245b56-c10` (101 agents, 19 sources fetched, 74 claims
> extracted, 25 adversarially verified, 23 confirmed / 2 killed). Companion audience report: `wf_0f96e38c-257`.

## The exact wedge (what a true competitor would have to match)

A real competitor matches Polaxory on **all four axes** at once:

1. **Agentic codegen** — an AI agent writes the gameplay code, not a human from a template.
2. **Server-authority** — server owns gameplay state; client sends intent only.
3. **Anti-exploit by construction** — security is a property of the generated architecture, not a bolt-on scanner.
4. **Telemetry** — aggregate signal on whether the prototype works / fails (Signal Run).

Anyone hitting only 1–2 axes is an *overlap*, not a *competitor*.

---

## VERDICT

**No named player is doing the exact thing — agent-built, exploit-resistant-by-construction Roblox worlds across all four axes. The full four-axis intersection is currently unoccupied.**

Every competitor clusters on one or two overlapping axes. The closest on *framing* (Romini) has no by-construction mechanism and no telemetry; the closest on *capability* (Roblox first-party) is plan-build-test agentic codegen with **zero** server-authority / anti-exploit / telemetry surface today.

### Threat ranking (proximity-to-wedge × ability-to-execute)

| # | Competitor | Axes overlapped | Threat | Why |
|---|-----------|-----------------|--------|-----|
| 1 | **Roblox first-party AI** | Agentic codegen (+ owns platform) | **Highest (strategic)** | Owns the platform; April 2026 "agentic Studio" ships Planning Mode + Mesh/Procedural gen + autonomous Playtesting agent + built-in Studio MCP. Could add server-authority/anti-exploit codegen at any release. Today it does **not** — wedge is open but at platform-owner risk. |
| 2 | **Romini.io** | Agentic codegen + server-authority + anti-exploit *(marketing)* | **Medium (narrative collision)** | Roblox-specific Luau codegen tool; explicitly markets "client/server architecture and anti-exploit patterns natively," "No exploitable RemoteEvents," "Server-safe by default." But "by construction" claim was **refuted 0-3** — it's unaudited prompt-template marketing, no formal/architectural guarantee, no telemetry. Collides on positioning, not mechanism. |
| 3 | **By-construction codegen research** (VeriGuard, Constitutional SDD) | Anti-exploit by construction (generic) | **Medium (framing risk)** | Proves the "by construction" pitch is real & defensible — but generic/domain-agnostic (CSDD's case study is *banking*). Threat = someone ports the generic method to Luau/Roblox. |
| 4 | **Roblox Studio MCP bridges** (official archived `studio-rust-mcp-server`; `Justice219`, `boshyxd`) | Agentic + Roblox | **Low (substrate, not rival)** | Automation bridges exposing arbitrary-Luau execution (`execute_luau`, "no sandboxing — only use with trusted input"). No server-authority / anti-exploit / telemetry. **These are rails Polaxory can ride on, not compete with.** |
| 5 | **Enterprise agent-security startups** (Gitar $9M, CodeIntegrity $4.8M) | "AI-agent security" (broad) | **Low (different market)** | Gitar "does NOT generate code" — post-hoc validation. CodeIntegrity = runtime guardrail wrapper for regulated-industry agents. Opposite end from by-construction game codegen; zero Roblox/Luau connection. |

### Defensible whitespace

> **Agentic Luau codegen that emits server-authoritative, anti-exploit-BY-CONSTRUCTION rails (validated remotes, server-owned state, client-intent-only) WITH aggregate telemetry, on the actual Roblox platform.** No named player occupies this intersection.

The "by construction" framing is **validated as defensible** (published academic work parallels it almost verbatim) **and unowned in the Roblox/game domain.**

### Market-need evidence (not a competitor — supports the thesis)

- **BaxBench** (ETH Zurich, ICML 2025 spotlight): security exploits ran successfully on **~half** of the *functionally correct* programs LLMs generated; best model (o1) only 62% correct. Models "further struggle to generate correct and secure applications" on **less popular frameworks** — predicting weak raw-LLM output for niche Luau/Roblox-multiplayer. *(Caveat: BaxBench tests web backends, not Luau — relevance to Roblox is inference, not measurement.)*

---

## Detailed findings by category

### 1. Roblox first-party AI — NOT eating this wedge (yet)
April 2026 "Roblox Studio is Going Agentic" = three phases only: **Plan** (Planning Mode — analyzes code/data model, asks clarifying questions, produces editable action plans), **Build** (Mesh + Procedural generation), **Test** (Playtesting Agent drives the player character as automated QA — reads logs, screenshots via BYOK, finds bugs). Two independent fetches (Roblox newsroom + TechCrunch) confirm **no mention** of server-authority, anti-exploit, validated remotes, security-by-construction, or telemetry. A search summary attributing "anti-exploit patterns" to Roblox was traced to Romini — conflation, not a first-party capability.

### 2. AI text-to-game / world-model engines — architecturally opposite
**Rosebud AI** targets *browser* games over **WebRTC peer-to-peer** ("No servers. No costs. Players connect directly") — the literal opposite of server-authority. Its "Roblox" marketing is "Roblox-*style*" browser games; no Luau codegen, no Roblox export. Buildbox AI, Ludus, Astrocade, DeepMind Genie 3, Decart/Oasis were in scope but produced **no surviving verified claims** targeting Roblox/Luau or server-authoritative multiplayer (unconfirmed, not cleared).

### 3. Roblox security/anti-exploit frameworks — no AI-generated variant found
Category produced no surviving verified claims that anyone pairs AI codegen with Knit/Matter/Flamework/ByteNet/ProfileService/roblox-ts to emit validated remotes. (Open question below.)

### 4. AI coding agents on Luau/Roblox — MCP bridges only
Three MCP servers verified (official archived April 3 2026 + two community). All are inspect/edit/run-code automation bridges with **no** architectural guarantees, server-authority, or telemetry.

### 5. Secure-by-construction codegen (general) — real, defensible, generic
**VeriGuard** (arXiv 2510.05156, Oct 2025): synthesizes a behavioral policy + formal verification before any action — explicitly "correct-by-construction," near-verbatim parallel to Polaxory's pitch. **Constitutional Spec-Driven Development** (arXiv 2602.02584, Feb 2026): embeds security principles into the spec layer "by construction rather than inspection," versioned constitution mapped to CWE/MITRE Top 25. Both **domain-agnostic** — neither touches Roblox/Luau/game server-authority.

---

## Caveats (verifier flags)

- **Time-sensitivity is the dominant risk.** Strongest signals are all April–June 2026; landscape moves fast. Roblox first-party could add server-authority/anti-exploit codegen in any release and collapse the wedge. **Window is months, not years.**
- Romini's "by construction" / "no exploitable RemoteEvents" = **unaudited vendor marketing** (explicitly refuted 0-3). Overlaps on framing, not verified mechanism.
- CSDD is a non-peer-reviewed single-author preprint; its 73% defect-reduction figure is unverified (claim doesn't rely on it).
- BaxBench's ~50%-exploitable finding is web backends, not Luau — Roblox relevance is reasonable inference, not measured.

## Open questions

1. Does Roblox's post-April-2026 roadmap include server-authority/anti-exploit codegen, or does Hyperion (first-party anti-cheat) intersect the generative roadmap?
2. Romini's actual traction (users/revenue/funding) and telemetry roadmap — hobby tool or funded startup moving toward the full wedge?
3. Do any unverified text-to-game engines (Buildbox AI, Ludus, Astrocade, Genie 3) generate server-authoritative multiplayer / target Roblox export?
4. Is anyone pairing existing Roblox security frameworks (Knit/Matter/Flamework/ByteNet) with AI codegen — an emerging "AI generates ByteNet-validated remotes" pattern?
5. Could VeriGuard/CSDD methods be ported to Luau/Roblox by a third party — is anyone attempting it?

## Sources (primary)

- Roblox newsroom — Studio Going Agentic: https://about.roblox.com/newsroom/2026/04/roblox-studio-going-agentic
- TechCrunch — Roblox agentic tools: https://techcrunch.com/2026/04/16/robloxs-ai-assistant-gets-new-agentic-tools-to-plan-build-and-test-games/
- Romini.io: https://www.romini.io/
- VeriGuard (arXiv): https://arxiv.org/pdf/2510.05156
- Constitutional SDD (arXiv): https://arxiv.org/pdf/2602.02584
- BaxBench (arXiv): https://arxiv.org/pdf/2502.11844
- Roblox studio-rust-mcp-server (archived): https://github.com/Roblox/studio-rust-mcp-server
- Gitar (TechCrunch): https://techcrunch.com/2026/04/15/gitar-a-startup-that-uses-agents-to-secure-code-emerges-from-stealth-with-9-million/
- CodeIntegrity (GeekWire): https://www.geekwire.com/2026/codeintegrity-raises-4-8m-to-put-permanent-guardrails-on-unpredictable-ai-agents/
- Rosebud AI: https://lab.rosebud.ai/blog/create-multiplayer-games-without-coding
