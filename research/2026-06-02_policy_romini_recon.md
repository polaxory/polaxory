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

## 3. Demand — named devs + a concrete case study (deep-research pass, same day)

The §"NOT done" gap below is now partially closed. Verified dev pain, with names + verbatim:

- **Alkaline (DarkyTheOddish22), Jul 2024** — UGC limited drained in minutes: *"exploiters could completely bypass the purchase and trick the server into thinking the purchase went through"* (`MarketplaceService` / `SignalPromptProductPurchase` spoof; trusted `PromptProductPurchaseFinished` without re-checking ownership). **This is the canonical Polaxory case study**: a fail-able rail on purchase-completion verification fails the spoofed callback. Issue + before/after is buildable from this thread alone.
- **Hutch (LMH_Hutch), 200-player paid game** — *"As a developer I have been tasked with creating my own moderation systems, my own logging system(s)… We get nothing."* Toil the rails layer removes.
- **RemoteEvent consensus (EmilyBendsSpace, 47 likes; BullfrogBait, 11)** — *"There is no protecting RemoteEvents… do tons of sanity checks on the server."* The accepted "solution" is a **manual per-remote checklist** (validate context + game state, leaky-bucket rate-limit, server-generated remotes). **That manual checklist is precisely what Polaxory rails automate by construction.** The market's own best-practice answer is the spec for the product.

## 4. Strategic crystallization — what Roblox wants agentic to be

- Roblox wants to be the **substrate**: built-in Studio MCP server, Open Cloud-as-tools (mid-2026), Cube 3D/4D for assets+code. It **archived** its open-source `studio-rust-mcp-server` (Apr 3 2026) to move investment in-house.
- It **explicitly invites third-party agents up**: *"creators can seamlessly use Claude, Cursor, Codex, and other third-party tools with Studio."* The third-party seam is **sanctioned, not contested**.
- The squeeze is real but narrow: Roblox's end-vision is "generate full scenes, including code, with natural language." Generic AI-codegen (Romini + cluster) gets absorbed. **The defensible wedge is not codegen — it is enforcement/verification.** Romini *markets* "Server-safe by default. No exploitable RemoteEvents"; the fetch confirms it **generates code with a security note, does NOT validate/test/guarantee.** Polaxory's survivable shape: the **verification layer that rides Roblox's sanctioned MCP seam and proves** server authority that everyone else only claims.

## 5. What this sweep did NOT do

It still has not proven an issue solved *in a real dev's running game* — the case study above is buildable but not yet built/validated. That gap closes only via the office-hours assignment: put a fail-able rail (Timing Gate v0 → purchase-spoof rail) in front of one real dev and watch. Research de-risks; it does not substitute for demand.

## Sources

- Roblox newsroom (agentic Studio): https://about.roblox.com/newsroom/2026/04/roblox-studio-going-agentic
- AI-Based Tools Supplemental Terms: https://en.help.roblox.com/hc/en-us/articles/20121392440212-AI-Based-Tools-Supplemental-Terms-and-Disclaimer
- ToU April 2026 update (DevForum): https://devforum.roblox.com/t/updates-to-the-roblox-terms-of-use-april-2026/4548394
- Romini.io: https://www.romini.io/
- Cube foundation model / 4D (newsroom): https://about.roblox.com/newsroom/2026/02/accelerating-creation-powered-roblox-cube-foundation-model
- Studio MCP + external LLM support (DevForum): https://devforum.roblox.com/t/studio-mcp-server-updates-and-external-llm-support-for-assistant/4415631
- Demand — UGC purchase-spoof: https://devforum.roblox.com/t/exploiters-manipulating-server-sided-data/3066150
- Demand — devs not equipped for exploiters: https://devforum.roblox.com/t/developers-are-not-equipped-to-deal-with-exploiters/1770356
- Demand — protecting RemoteEvents: https://devforum.roblox.com/t/best-way-to-protect-remoteevents-against-exploiters/1314739
