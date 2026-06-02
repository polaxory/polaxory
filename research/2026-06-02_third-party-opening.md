# Third-Party Opening — Deep Research (2026-06-02)

> Run `wf_42e270fa-7c1` / task `wycy1p1ep`: 102 agents, 20 sources, 86 claims → 25 verified → 21 confirmed / 4 killed → 7 after synthesis. Question: where does Roblox dev break that Roblox won't fix and a third party can?

## The crystallized finding

**Roblox's April 2026 agentic Studio is a productivity + functional-QA tool, not a security tool.** Across every primary first-party source (newsroom, DevForum, TechCrunch), ZERO coverage of server-authority enforcement, exploit-resistance, or validation of AI-generated code (verified 3-0). The Playtest Agent self-discloses false-positive "Pass" results and cannot test real-time-reactive loops (vehicle/combat) or multiplayer — exactly the surfaces where exploits live.

**Roblox ships the MCP seam and invites third parties up.** "Creators can seamlessly use Claude, Cursor, Codex, and other third-party tools with Studio" (verified 3-0). Third-party tooling on the MCP seam is Roblox's *intended posture*, not contested ground.

**Roblox's own docs prescribe the pattern but leave the build to devs.** creator-docs verbatim: "The server decides... primary security comes from robust validation and rate limiting." No turnkey first-party service. **The pattern is documented; the build is not** (verified 3-0).

**The primitives exist; the pairing doesn't.** Flamework auto-generates type-guards on remotes (validation on by default); ByteNet gives typed networking (verified 3-0). But the one evidenced "AI codegen + Roblox security framework" pairing (a Flamework-roblox-ts agent skill on Smithery) has **~1 install** (medium confidence, single source). The wedge is emerging and open, not solved.

## The sharpest wedge (realism-filtered)

> **A validator/linter + agent skill that makes AI-generated Roblox remotes server-authoritative and exploit-resistant by construction** — flags client-authoritative mutations and unvalidated RemoteEvent→DataStore writes, emits Flamework-guarded / ByteNet-typed remotes, rides Roblox's sanctioned MCP seam.

Tiny-team shippable: the rules already exist (creator-docs), the primitives exist (Flamework/ByteNet), the pairing is ~unbuilt.

## Realism-ranked shortlist

1. **SHARPEST** — static-analysis/lint + agent skill validating AI-generated remotes against the server-authority pattern, emitting guarded/typed remotes. Tiny-team shippable.
2. Exploit-resistance test harness for multiplayer/real-time loops (fills the Playtest Agent's disclosed gaps). Harder — needs multi-client sim.
3. Regression/telemetry layer catching the false-positive "Pass" problem. Moderate.
4. Platform-scale anti-cheat (Hyperion territory). NOT tiny-team — out of scope.

## Honest caveats (verifier flags)

- **Time-sensitive.** All hinges on April 2026 launch state; Roblox lists multiplayer playtesting as planned. Re-verify quarterly — the security negative space could close if Roblox extends the agent.
- **Bridge clauses are inference, not source statements:** "this is where exploits occur," "Roblox structurally won't build it." Sound, but analytical.
- **Roblox DOES cover client-side anti-tamper (Hyperion/Byfron).** So "exploit resistance" generically is partly covered. The OPEN wedge is specifically *AI-codegen-paired server-authority / remote-validation* — not anti-cheat at large.
- **Adoption fork (open question):** Flamework/ByteNet are rbxts (TypeScript-on-Roblox). If most solo devs stay plain Luau, the validator must target Luau-native output, not just the rbxts ecosystem. This changes the build surface materially.

## Sources (primary)
- Roblox newsroom (agentic Studio): https://about.roblox.com/newsroom/2026/04/roblox-studio-going-agentic
- Playtest Agent beta: https://devforum.roblox.com/t/studio-beta-studio-assistant-mcp-playtest-agent/4566767
- Built-in MCP server: https://devforum.roblox.com/t/assistant-updates-studio-built-in-mcp-server-and-playtest-automation/4474643
- creator-docs server-side detection: https://github.com/Roblox/creator-docs/blob/main/content/en-us/scripting/security/server-side-detection.md
- Flamework networking: https://flamework.fireboltofdeath.dev
- ByteNet: https://devforum.roblox.com/t/bytenet-advanced-networking-library-.../2733365
- Flamework-roblox-ts skill (~1 install): https://smithery.ai/skills/StephenSHorton/flamework-roblox-ts
