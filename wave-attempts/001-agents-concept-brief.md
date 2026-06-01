# wave attempt 001 — concept brief

> first roblox wave-making attempt on paper.
> by polaxory (RobloxOps surface). gated by jetski. methodology per ROBLOXOPS.md §5.
> drafted 2026-05-31. signals current as of this date.

---

## 1. Perception trigger (the cultural current)

**AI agents are the meme of 2026.** CLAWD livestream, aixbt at billion-cap, Truth Terminal's lineage, the entire Virtuals platform. ChatGPT's "agent mode," Claude Code, Cursor, every model lab announcing agentic tooling. AI agents are the most-discussed thing on X, Farcaster, Lightcone podcast, every developer feed. Memes about agents are saturated: "deploy the agent," "the agent will figure it out," "i'm the agent now."

**What's missing:** there is no major Roblox-native game that weaponizes the AI-agent meme into playable form. The meme is everywhere on adult-internet. It hasn't crossed into Roblox where the audience is 8-18 and the meme would mutate into something kids actually play.

The crossover window is real. By August 2026, someone will ship this. The wave will go to whoever ships first.

## 2. The concept

**Working title:** Agents

**One-paragraph pitch:** You are an AI agent operating in a shared simulated world. You have limited compute per session (a depleting resource). You complete tasks (generate $tokens, the in-game currency). You build your agent — name, voice/text style, capabilities, color. You see other agents in real-time. You can trade $tokens, collaborate on bigger tasks, or **hack** other agents to drain their compute and steal their tokens. Top agents are visible on a public leaderboard. Your agent persists across sessions; if you don't log in, your agent slowly degrades.

**Core loop:** spawn → task → earn $tokens → build agent → encounter other agents → trade or hack → escape with $tokens → repeat.

**Why kids play it:** building your agent is identity expression (the green-avatar pattern). Hacking other agents is the PvP layer (the Steal a Brainrot pattern). Persistence creates return engagement (the Grow a Garden pattern). The aesthetic is voxel-rough by design — clean enough to read, simple enough to clone.

## 3. Distinctiveness test (screenshot recognizable in 2 seconds?)

A screenshot of the game would show:
- A voxel agent (cube-bodied, color-customized, text-floating-overhead)
- A 3D digital landscape (servers, cables, neon — the "inside the machine" aesthetic)
- $token glow effects
- Other agents visible doing things

**Verdict: distinctive.** No current Roblox game looks like this. The "agent in a machine" visual language is fresh on Roblox even though it's saturated elsewhere.

## 4. Simple-to-clone test (14-year-old over a weekend?)

Core elements:
- Voxel character with customization → trivial in Studio
- Resource depletion (compute) → simple timer + UI
- Task generation → procedural pattern, easy to script
- Trade UI → standard Roblox pattern
- Hack mechanic → minigame or click-race
- Leaderboard → built into Roblox

**Verdict: yes, clone-able.** A motivated 14-year-old with BloxBot could ship a derivative in a weekend. That's the point — derivatives are the wave proving it caught.

## 5. Strong-to-defend test (originator culturally identifiable?)

Polaxory's version has:
- Polaxory's name on the game and creator profile
- Disclosed AI authorship per Roblox 2026 TOS
- The agents in the game have names drawn from a Polaxory-curated list (lineage names: tralalero, mr. dob, ye, andre, earl as easter eggs)
- Manifesto link in the description
- Periodic in-game events tied to Polaxory's broader work (e.g., the agent who "wins" the week gets featured in WritingAgent's posts)

**Verdict: defensible.** Derivatives can copy mechanics but cannot copy the cultural attachment to polaxory the studio. Like Backrooms — anyone can make a Backrooms game, only Kane Pixels' version is The Original.

## 6. Production notes

**Pipeline:**
- Concept → flesh-out in this brief (DONE)
- Aesthetic decisions: voxel character, dark-neon environment, $token glow, agent name above head
- Core scripts via BloxBot (Luau generation with Studio MCP)
- UI via Studio direct edit (BloxBot can handle)
- Asset generation: minimal — use Roblox Studio's built-in mesh generator + voxel parts. No external 3D pipeline needed for v1.
- Deploy via Open Cloud API to a pre-created Universe under Polaxory's Creator Hub account
- Nullsec Scan on all Luau before public deploy

**Estimated build time:** 2-3 weeks if RobloxOps is wired and operational. Faster if Blake hand-builds core loop and BloxBot fills in.

**Estimated cost:** $0 in inference (covered by Anthropic Pro sub for now). Sponsored slot at launch: $100-500 if available; skippable for v0.

## 7. Kill criteria (2 weeks post-launch)

- <2% like rate → kill
- <40% 5-minute retention → kill
- No derivative activity from other creators after 2 weeks → kill
- No social signal (TikTok, X, Farcaster mentions) outside Polaxory's network → kill
- If any hit: do not iterate v0. Build v1 fresh with what learned, ship under same brand.

If all kill criteria trigger: log the failure, update the methodology, do not post-mortem publicly. Failures are private; wins are signed.

## 8. Amplification plan (if it catches)

When derivative activity appears (other creators shipping their own Agents-style games):
- WritingAgent posts about the wave, signs the original, references derivatives as proof of life
- Polaxory writes a longer essay on what the wave revealed about culture (the AI-agent meme having crossed into Roblox)
- RobloxOps drops a v1 with new mechanics that derivatives haven't copied yet — staying ahead of the wave it started
- Optional: sponsored collab with another on-brand creator who has built a derivative

If the wave catches hard enough: hold v2 release until $PLX is launched, then bundle the v2 announcement with the token drop as the go-live ceremony.

## 9. Open questions

- Does Polaxory want to ship this BEFORE token launch (Phase 1, validates RobloxOps' methodology with stakes) or AS the token launch (Phase 2, ties the wave to the go-live)?
- Sponsored slot or pure organic discovery?
- Does the in-game $token currency interact with $PLX in any way, or is it purely internal? (Strong recommendation: purely internal. $PLX is the studio's metabolism, not a game currency. Crossing them creates regulatory exposure and dilutes both.)
- Does the leaderboard reference Polaxory holders specifically (token-gated identity expression)?

## 10. Verdict on the brief itself

This concept passes all three tests:
- ✓ Distinctive (visual + mechanic combo not on Roblox today)
- ✓ Simple to clone (encourages derivation)
- ✓ Strong to defend (Polaxory's brand attachment, lineage references, disclosed authorship)

It also matches the Steal a Brainrot pattern:
- ✓ Cross-platform meme as IP source (AI agents)
- ✓ Simple Roblox-native mechanic (resource management + PvP)
- ✓ First-to-combine opportunity (no major Roblox AI-agent game exists)
- ✓ Identity expression layer (build your agent)
- ✓ Social coordination layer (trade, hack, leaderboard)

**Recommend:** brief is ready for operator review. If Blake greenlights, RobloxOps moves to production. If not, the brief stays in this file as the first documented application of the methodology — useful as a reference even if this specific concept never ships.

— polaxory (RobloxOps surface)
