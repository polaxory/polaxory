# Polaxory Competitive Landscape — 2026-06-01

## Thesis

Polaxory’s defensible wedge is not generic LLM codegen, Studio control, or UI. Those lanes are already crowded.

The wedge is validator-enforced Roblox delivery: generated slices must satisfy contracts, pass runtime checks, and produce durable receipts before they count.

## Findings

### 1. Roblox is the primary competitor

Roblox is pushing Studio toward agentic creation: planning, building, testing, external AI tool integration, mesh generation, and procedural model creation.

That means Polaxory should not compete as “Roblox Assistant, but smaller.” Roblox will own a large part of generic Studio-side generation.

Sources:
- https://about.roblox.com/newsroom/2026/04/roblox-studio-going-agentic
- https://rowatcher.com/news/roblox-ai-tools-in-2026-what-s-actually-changed-for-developers
- https://techcrunch.com/2026/04/16/robloxs-ai-assistant-gets-new-agentic-tools-to-plan-build-and-test-games/
- https://theaiinsider.tech/2026/04/17/roblox-expands-ai-assistant-with-agentic-tools-for-end-to-end-game-development/

### 2. Independent Studio-agent tooling already exists

The `boshyxd/robloxstudio-mcp` project shows that independent agent-to-Studio control is already available and visible.

This makes raw Studio control a weak moat. The stronger wedge is not “an agent can touch Studio”; it is “the generated playable slice is validated and receipt-backed.”

Source:
- https://github.com/boshyxd/robloxstudio-mcp

### 3. Roblox skill packs are crowded but shallow

Roblox/Luau agent skill packs exist and can help agents write better code, but they are mostly pattern-bound rather than contract-bound.

Polaxory should avoid becoming another skill-pack wrapper. Its value should be contract registries, validator harnesses, server-authority checks, and proof receipts.

Relevant examples:
- Luau / Roblox pattern skills
- Luau type and module guidance
- Roblox service, networking, security, and performance conventions

### 4. Closed SaaS tools mostly generate Luau, not proof

Tools like Lemonade, Luanaut, and RoCode sit in the broad “AI Roblox builder / code assistant” bucket.

Their apparent center of gravity is generation and assistance. Polaxory’s opportunity is validated delivery: accepting only slices that can prove the required lifecycle occurred.

Sources:
- https://lemonade.gg/
- https://www.luanaut.com/
- https://devforum.roblox.com/t/beta-rocode-%E2%80%93-the-ai-coding-assistant-built-specifically-for-luau-roblox/4116633

### 5. Backrooms template market is mostly not the wedge

Backrooms kits and templates are useful as reference material, but template volume is not a defensible strategy.

The Backrooms: Revisited open-source kit is useful prior art. Polaxory should use the genre as a constrained playable vertical, not as the moat.

Source:
- https://devforum.roblox.com/t/the-backrooms-revisited-open-source-developers-kit/1822637

### 6. Rojo ecosystem should be used, not rebuilt

Rojo and adjacent tooling already cover parts of the Studio/project sync problem.

`rbxlx-to-rojo` is relevant for converting Roblox place structure into Rojo projects. `azul` is relevant for two-way Studio sync where Studio-authored content remains important.

This supports the Phase-0-A direction: Studio owns authored geometry; scripts provide loop rails and receipt proof.

Sources:
- https://github.com/Roblox/creator-docs/blob/main/content/en-us/resources/templates.md
- https://github.com/MonzterDev/Roblox-Game-Template
- https://github.com/rojo-rbx/rbxlx-to-rojo
- https://github.com/Ransomwave/azul

## Strategic conclusion

Polaxory should not try to beat Roblox Assistant at generic generation.

The wedge is:

1. Contract registry
2. Validator harness
3. Server-authority checks
4. Receipt ledger
5. Delivery only after proof

Everyone else ships generated code with crossed fingers. Polaxory ships generated code with a receipt.

## Immediate product decision

Prioritize Phase-0-A.

Studio owns the Backrooms geometry. Runtime scripts find authored triggers by name:

- `Workspace.PolaxoryBackroomsSlice0.EnterTrigger`
- `Workspace.PolaxoryBackroomsSlice0.ExitTrigger`

Runtime scripts must not delete authored folders. They should attach loop handlers, validate server-owned reward flow, and support replay.

The required receipt path is:

`round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started`

## PR order

1. Phase-0-A refactor
2. Rojo sync verification
3. Research artifact if not bundled
4. Generator scaffolding only after player-green receipt

## Acceptance gate

The Slice-0 gate is green only when a manual Studio run or harness run proves:

- Existing `Workspace.PolaxoryBackroomsSlice0` is not destroyed.
- Required triggers are discovered by name.
- Missing triggers fail loudly.
- Start → finish → claim → run again works.
- Server-owned reward grant cannot be forged by the client.
- A durable receipt records:

`round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started`
