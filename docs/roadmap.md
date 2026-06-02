# Roadmap

The rule: a surface earns a folder only when it has working metal. Until then it lives here, named honestly, so the ambition is visible without faking the receipts.

## Shipped (has receipts)

- **Signal Run loop** — server-authoritative round → gate → reward → claim → replay. See `experiments/signal-run/`.
- **Rails constitution + remote contracts** — `docs/polaxory/POLAXORY_RAILS_CONSTITUTION_v0.md`, `src/shared/RemoteContracts.luau`.
- **Validator patterns (partial)** — `src/server/Validators.luau` checks task/resource integrity. The full validator suite in `POLAXORY_VALIDATOR_CONTRACTS_v0.md` is mostly spec, not yet implemented.
- **Read-only Studio inspection** — live DataModel/script inspection via MCP.

## Next build — the validation kernel

Per the 2026-06-02 CEO review (deep research `research/2026-06-02_third-party-opening.md`):
the defensible, Roblox-proof wedge is a developer tool, not another game. Build **one kernel**:

- **Validation kernel** — extract `RemoteContracts` + `Validators` into a standalone module
  with a clean typed interface (in: remotes / AI-generated code; out: verdicts +
  server-authoritative guarded output). Makes AI-generated remotes exploit-resistant by
  construction. NOT welded into the game.
- **Dogfood** — extend Signal Run with the purchase-spoof verification rail and run it
  through the kernel, so the game proves the kernel catches a real exploit (Alkaline's loss).

## Weaves on the kernel (NOT shipped — trajectory, held not built)

Each calls the kernel; named here, shippable later without a rewrite, gated on real demand.
None gets a folder until it has metal.

- **W-A: game-system generation** — rails generate whole systems (the original "games on rails").
- **W-B: agent-skill on Roblox's MCP seam** — any dev's AI code forced onto the rails. Purest wedge hit.
- **W-UGC: UGC pipeline validation** — reuse the kernel's contract/validation on generated content.
- **W-Web: web medium** — paste/connect code → validated output; paid access; real inference.
- **W-Crypto: crypto rails** — pay-for-inference in crypto; a solo dev anywhere buys access with no LLC/processor.

Supporting surfaces (still named, still unbuilt): world memory, agent repair loop, playtest
harness for multiplayer/real-time (fills the Playtest Agent's disclosed gaps), full validator
suite (0 of 12 implemented to spec), runtime hardening.

## Gating risk

Double platform-risk, same actor (Roblox), window measured in months not years — see `docs/competitive-landscape.md`:

1. **Policy:** ~~Verify the platform permits agent-built deployment.~~ **Checked 2026-06-02 (`research/2026-06-02_policy_romini_recon.md`): permitted.** Roblox sanctions AI/agent codegen and ships its own; the only genAI restriction is on runtime AI-chatbot experiences, which doesn't apply to build-time agents. Policy risk downgraded. (Caveat: full AI-Based Tools Supplemental Terms not yet line-read.)
2. **Competitive:** Roblox first-party shipped agentic Studio (Plan/Build/Test) in April 2026 with zero server-authority/anti-exploit/telemetry today. It could add those axes any release and collapse the wedge. This is now the *primary* platform risk.

Urgency favors proving demand + public positioning fast, while the four-axis intersection is still unowned.
