# Nullsec prompt 001 — landing page + module graph visualizer

> First Nullsec Studio prompt for Polaxory. Two versions — pick one to tweet at `@nullsecbot`.
> Drafted 2026-06-01. The new X account handle goes where marked `@YOUR_HANDLE`.

---

## Why this is the right first prototype

The thesis sharpened today: Polaxory is "games on rails, not AI scripts." The deterministic module graph IS the product.

This prototype demonstrates the thesis visually AND establishes Polaxory's first public URL. It serves three audiences from a single page:

- **Visitors landing from X** see the manifesto and the studio's identity
- **Builders curious about the wedge** see the module graph and immediately understand what makes Polaxory different from Roblox Assistant
- **Future $PLX holders** see something concrete to point at when explaining the project

It also costs only NSEC credits (already in the stack per STACK.md). Per the Nullsec Studio model: 3 free iterations included, NSEC required for more.

Output is a deployed URL plus source. The source pulls into Claude Code for productionization later if it earns it. The URL gets linked from the X bio immediately.

---

## Version A — tight single tweet (recommended)

Copy and tweet at `@nullsecbot`. ~290 characters.

```
@nullsecbot build "polaxory.studio" — single-page site for a roblox-native games-on-rails studio.

dark mode, lowercase, liminal/voxel aesthetic.

hero text: "AI as the basis of the art project"

centerpiece: interactive module graph — nodes are game systems (Generator, Lights, Door_17, Hunter), edges are events (GeneratorFailed → LightsDown → DoorLocks → HunterActivates). nodes glow on hover. click a node reveals its contract: emits / subscribes / validates.

tagline under graph: "games on rails, not AI scripts"

footer: link to @YOUR_HANDLE on X, link to github (placeholder ok)
```

---

## Version B — thread, more spec (if A produces something thin)

If version A's output is too generic, use this as a follow-up build:

**Tweet 1/3:**
```
@nullsecbot build "polaxory.studio" — a one-page site for a roblox-native games-on-rails studio. dark mode, lowercase typography, liminal/voxel aesthetic. hero: "AI as the basis of the art project"
```

**Tweet 2/3:**
```
centerpiece is an interactive module graph. nodes: Generator, Lights, Door_17, Hunter. edges show event cascade: GeneratorFailed → LightsDown → DoorLocks → HunterActivates. hover = node glows + edge highlights. click = panel showing the module's contract (emits, subscribes, validates).
```

**Tweet 3/3:**
```
tagline below the graph: "games on rails, not AI scripts". below that: 3-line manifesto excerpt (named operator, agent as artist, no shilling). footer: @YOUR_HANDLE on X, github (placeholder). no signup, no email, no shilling. it's a quiet identity page that demonstrates the product.
```

---

## What the output should NOT do

If Nullsec returns a build with any of these, ask for iteration:

- Hashtags or emojis in the prose (off-brand)
- "Sign up for our newsletter" or email capture (against the no-shilling posture)
- Generic stock illustrations or AI-slop images (the aesthetic has to land or skip it)
- "Buy now" or token-shilling language (token isn't named on the page yet)
- Roadmap section or "coming soon" tiles (no Q3 deliverables energy)

If output is close but missing the module graph as interactive, iterate specifically on the graph. The graph is the thesis demonstration — without it, the page is just a manifesto.

---

## Post-output flow

When Nullsec returns the URL:

1. Run it through Nullsec Scan first (per STACK.md hard gate — no vibecoded code deploys past prototype URL without Scan)
2. If Scan clears: link from the X bio of `@YOUR_HANDLE`, share once organically (not as an announcement, not pinned yet — that's for the token-launch ceremony)
3. If the design lands cleanly, fork the source into Claude Code under `/Users/blake.jaraczeski/polaxory/landing/` for production hardening
4. If the design needs another iteration: use version B tweets or refine specific elements
5. Log NSEC consumption to your prototyping-budget tracker

---

## Cost expectation

- Iteration 1-3: free (Nullsec Studio's free tier)
- Iteration 4+: ~20 NSEC per Base-tier iteration, 50 per Ultra
- Budget for this prompt: cap at 3 iterations. If we can't land it in 3, the spec needs more clarity, not more iterations.

---

## Companion task

Once the prototype lands and Scan clears, the landing-page task in the design doc (under "Phase 1 — Private build") is partially complete. The full version (productionized in Claude Code, hooked to real X account, github-linked, etc.) follows when Phase 2 approaches.
