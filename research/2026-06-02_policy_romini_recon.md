# Recon — Policy + Romini (2026-06-02)

> gstack browse + web search/fetch sweep. Aimed at two unknowns gating the public "exploit-resistant rails on Roblox" claim: (1) is agent-built deployment allowed, (2) is the closest rival a real threat.

## 1. Is agent-built deployment allowed on Roblox? — YES (with one caveat)

- Roblox **sanctions** AI/agent codegen. It ships its own (April 2026 agentic Studio: Plan/Build/Test). The newsroom announcement is pure enablement — zero restriction on AI-authored code being published.
- April 2026 ToU update folded the **AI-Based Tools Supplemental Terms** into the main User/Creator Terms. AI Tools "generate and explain code"; **user is solely responsible for outputs** and must hold rights to prompts.
- Only genAI **restriction**: experiences whose *main purpose* is a live generative-AI bot/character players interact with continuously. That governs **runtime genAI**, NOT using agents to **build** a game. Does not apply to Polaxory.
- **Verdict:** the earlier "double platform threat" is really single. Roblox can *compete*, but does not *forbid* agent-built deploys. Policy risk downgraded.
- **Caveat:** this is search-summarized. Full "AI-Based Tools Supplemental Terms" not yet read line-by-line — verify any attribution/disclosure/deploy clause there before relying on this.

## 2. Romini.io — closest rival, real claims (from their own site)

- **What it is:** a prompt-to-script freemium tool. "Generate scripts in seconds," free plan = 3 scripts/day, Pro tier gates combat/pets/etc. Chat workspace: "Create a shop system with ProximityPrompt" -> a Luau snippet.
- **What it markets:** "anti-exploit patterns natively," "Server-safe by default. No exploitable RemoteEvents." A "0% Server-safe output patterns" stat (placeholder, unrendered).
- **What it is NOT:** not an autonomous agent loop (prompt -> code), not architecturally enforced (best-practice *text*, not validated/fail-closed), no telemetry, no whole-architecture rails. Confirms competitor-log finding: collides on **framing**, not **mechanism** ("by construction" refuted 0-3).
- **Traction:** no funding / user numbers / reviews surfaced. Reads indie/hobby freemium, not a funded startup closing the four-axis wedge.
- **Verdict:** wedge stays open. Polaxory differentiation holds — enforced vs suggested, whole architecture vs snippets, measured vs silent.

## 3. What this sweep did NOT do

It did not produce a real Roblox dev wanting the product, and it did not prove an issue is solved. Those gaps (named by Blake 2026-06-02) close only via the office-hours assignment: put Signal Run in front of one real dev and watch. Research de-risks; it does not substitute for demand.

## Sources

- Roblox newsroom (agentic Studio): https://about.roblox.com/newsroom/2026/04/roblox-studio-going-agentic
- AI-Based Tools Supplemental Terms: https://en.help.roblox.com/hc/en-us/articles/20121392440212-AI-Based-Tools-Supplemental-Terms-and-Disclaimer
- ToU April 2026 update (DevForum): https://devforum.roblox.com/t/updates-to-the-roblox-terms-of-use-april-2026/4548394
- Romini.io: https://www.romini.io/
