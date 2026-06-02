# Competitive Landscape

Strategic read. Evidence base: deep-research run `wf_cd245b56-c10` (101 agents, 19 sources, 74 claims extracted, 23 verified / 2 killed) + audience run `wf_0f96e38c-257`. Full log: `research/2026-06-02_competitor_log.md`.

## The four-axis wedge

A real competitor must match Polaxory on all four at once:

1. **Agentic codegen** — an AI agent writes the gameplay code, not a human from a template.
2. **Server-authority** — server owns state; client sends intent only.
3. **Anti-exploit by construction** — security is a property of the generated architecture, not a bolt-on scanner.
4. **Telemetry** — aggregate signal on whether the prototype works/fails.

Hitting only 1–2 axes is an overlap, not a competitor.

## Verdict

**The full four-axis intersection is unoccupied.** No named player builds agent-made, exploit-resistant-by-construction Roblox worlds with telemetry. Everyone clusters on one or two axes.

## Threat ranking

| # | Competitor | Threat | Why |
|---|---|---|---|
| 1 | **Roblox first-party AI** | Highest (strategic) | Owns the platform. April 2026 agentic Studio = Plan/Build/Test + built-in MCP, but **zero** server-authority/anti-exploit/telemetry today. Could add it any release. |
| 2 | **Romini.io** | Medium (narrative collision) | Markets "no exploitable RemoteEvents / server-safe by default" — but "by construction" was **refuted 0-3**: unaudited prompt-template marketing, no telemetry. Collides on framing, not mechanism. |
| 3 | **VeriGuard / Constitutional-SDD** | Medium (framing risk) | Academic proof that "by construction" is real & defensible — but domain-agnostic (banking, not Roblox). Risk = someone ports the method to Luau. |
| 4 | **Roblox Studio MCP bridges** | Low (substrate) | Arbitrary-Luau automation bridges, no guarantees. Rails to ride on, not rivals. |
| 5 | **Gitar / CodeIntegrity** | Low (different market) | Post-hoc agent-security for regulated industries. No Roblox/Luau connection. |

## Our defensible edge (how to position)

- **vs Romini (closest product):** ours is **architecturally enforced in real code** (server-owned state, typed remotes, fail-closed validators — in the repo, not a prompt template) **+ the telemetry axis they lack.** Do NOT pitch "exploit-resistant" alone — Romini says that. Pitch *enforced + measured.*
- **vs Roblox first-party (biggest threat):** they have codegen, not the security/telemetry axes. Lead with the four-axis intersection on the actual platform.
- **Honest scope of our claim:** "by construction" here means *architecturally enforced*, NOT formally verified. VeriGuard does formal verification; Polaxory does not (yet). Claiming formal proof would be LARP.

## Market-need evidence (supports thesis, not a competitor)

**BaxBench** (ETH Zurich, ICML 2025): LLM-generated code was exploitable on ~half of *functionally correct* programs, worse on less-popular frameworks — predicting weak raw-LLM output for niche Luau multiplayer. *(Caveat: web backends, not Luau — inference, not measurement.)*

## The clock

**Window is months, not years.** Roblox first-party could add server-authority/anti-exploit codegen and collapse the wedge — and the same actor sets the April 2026 AI-usage policy that could forbid agent-built deployment. Double platform-risk on one party. Urgency favors proving demand + public positioning fast.

## Open watch items

1. Does Roblox's roadmap add server-authority/anti-exploit codegen, or does Hyperion (first-party anti-cheat) meet the generative roadmap?
2. Romini's real traction (users/revenue/funding) + telemetry roadmap — hobby tool or funded startup closing on the full wedge?
3. Is anyone pairing Roblox security frameworks (Knit/Matter/Flamework/ByteNet) with AI codegen?
4. Could VeriGuard/CSDD be ported to Luau by a third party?
