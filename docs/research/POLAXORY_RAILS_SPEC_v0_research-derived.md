# POLAXORY_RAILS_SPEC_v0 — research-derived companion

> **NOT THE CANONICAL CONSTITUTION.** This document is a research-grounded synthesis produced by a parallel-research workflow on 2026-06-01 across Rojo, the Luau tooling stack, Open Cloud Luau Execution, production module-graph patterns, GitHub templates, and the Roblox Assistant landscape. It is intended to be READ ALONGSIDE Blake's canonical `POLAXORY_RAILS_CONSTITUTION_v0.md` (saved externally), not in place of it.
>
> Use this for: specific tool versions, named production frameworks (Knit, Matter, Charm, Reflex, Brio, ProfileStore, ServiceBag), real adoption signals, known gotchas, and source URLs grounding every claim.
>
> Do NOT use this for: the prime law, the seven rails naming/order, the graph schema details, or any other constitutional decision that's Blake's call. Where this doc and the constitution diverge, the constitution wins.
>
> The 6 underlying research findings (Rojo, tooling, Open Cloud Luau, module-graph patterns, templates, Roblox Assistant) are preserved in the workflow output and can be extracted with jq if needed for deeper alignment work.

---

## Original synthesis (research-derived, opinionated)

> Status: v0 working draft. Constitution for the games-on-rails product layer. Pairs with POLAXORY-STACK.md (token + infra) and POLAXORY-ENGINE.md (phased build). Subject to revision once Phase 1 ships base modules.

---

## 1. Mission and core thesis

**Polaxory is not "AI writes Roblox scripts." Polaxory is "Roblox games on rails."**

Roblox Assistant already owns the AI-writes-scripts lane. As of April 2026 it ships Planning Mode, Cube-powered mesh generation, project-aware code generation, a beta Playtesting Agent, and a built-in MCP server that invites third-party agents onto Roblox's rails [1][2]. Trying to out-Assistant Assistant inside Studio is a losing position: single model, daily quotas, and a ToS that explicitly forbids training competing products on Assistant output [3].

The defensible wedge is one layer above the script:

- **Roblox Assistant helps creators make things.**
- **Polaxory helps creators make things that hold together.**

A "thing that holds together" is a deterministic module graph: a set of validated game systems that emit events into a typed bus, subscribe to events from other systems, and pass static and runtime checks before a single line of generated Luau is allowed to ship. The script is an output artifact. The graph is the product.

Three principles follow:

1. **Validation is the moat.** Assistant emits Luau and trusts the creator to test it. Polaxory will not emit a module that fails its static contract or its runtime contract on Open Cloud Luau Execution [4]. Generation without validation is not Polaxory's product surface.
2. **Determinism is the developer experience.** Two-phase Init/Start, server-authoritative state, ordered event cascades, lifetime-scoped signals. These are not architectural preferences — they are the only patterns that survive at scale [5]. Polaxory bakes them into the rails so AI-generated code cannot bypass them.
3. **Interconnection is the value.** A Generator module is worth more if Door, Light, Hunter, and Save modules already know how to react to it. The rails are a directed graph of pre-wired reactions. Creators compose; they do not re-author the bus.

If Assistant is the IDE-resident planner, Polaxory is the framework, the type system, and the CI — running outside Studio, governed by token-backed infra, exposed to creators as a small set of opinionated, composable game systems.

---

## 2. The deterministic module graph

A **module** is a Luau package with a declared event API, a declared state surface, and a declared dependency list. A **graph** is the closure of modules in a project, wired through a typed event bus, with a topologically resolved boot order and a validator pass that runs before the project compiles.

The graph is not a runtime concept the creator manipulates. It is a build-time artifact Polaxory's tooling owns. At runtime, the graph becomes ordinary Roblox code: ModuleScripts under `ReplicatedStorage`/`ServerScriptService`, signals dispatched through a single bus, state read from a server-authoritative atomic store.

### How the graph works

- **Modules declare, they do not discover.** A module's manifest lists what it emits and what it subscribes to. Subscriptions are resolved at build time, not at runtime. A subscription to an event no module emits is a build error, not a silent no-op.
- **Boot order is two-phase Init/Start.** Init wires references; Start runs work. This is the only DI pattern with multi-million-session production track record on Roblox [5]. The Polaxory bus injects itself, never direct require chains, so circular dependencies are mechanically impossible.
- **Event cascades are data, not callbacks.** Following the Matter ECS pattern of `useEvent` collecting signals into per-frame batched data [5], the Polaxory bus serializes cascades into an ordered, inspectable log. Cascades are replayable, snapshottable, fuzzable.
- **State writes go through one seam.** Atomic stores (Charm-style) or producer/reducer (Reflex-style) — never ad-hoc tables plus BindableEvents. One write path is the only path that makes cascades testable [5].
- **Persistence is session-locked.** ProfileStore is the only DataStore touchpoint exposed to module code [5]. Generated modules cannot directly call `DataStoreService`.

### The Generator/Door/Hunter cascade, expanded

A horror-genre rails project includes `Generator`, `LightController`, `Door`, `Hunter`, `PlayerState`, and `SaveProfile`. Each is a Polaxory module shipped from the template repo with a sealed contract.

1. `Generator.fail()` is called (player ran out of fuel, sabotage event, scripted trigger — the trigger does not matter to the bus).
2. `Generator` writes `power = false` to the atomic store and emits `GeneratorFailed { generatorId, region, t }` on the bus.
3. The validator (build-time) has already proved three things: `LightController` subscribes to `GeneratorFailed`; `Door` subscribes to it indirectly via `LightController.PowerLost`; `Hunter` subscribes to `Door.Locked`. There are no orphan subscriptions and no missing emitters.
4. At runtime, the bus dispatches the cascade in declared order. `LightController` darkens lights in `region`. `Door_17` (tagged `power-gated`) emits `Door.Locked`. `Hunter` instantiates in `region`, using a `Brio` so its lifetime is tied to `power == false` [5] — when power restores, the Hunter brio dies and every downstream listener tears down automatically. No dangling connections, no leaked threads.
5. After the cascade, the bus records a structured event log. The Playtesting harness can replay this log in CI on Open Cloud Luau Execution [4] and assert: did `Hunter.spawned` fire within 2 frames of `GeneratorFailed`? Did `Door_17.locked` actually emit? Did the cascade halt cleanly when `power = true` was written back?

The cascade is the product. Every module in the chain ships from Polaxory with the cascade pre-wired. A creator does not write the bus, does not author the brio lifetime, does not implement the validator. They configure `Generator.fuelMax`, drop a `Door_17` instance with the `power-gated` tag, and the cascade is live.

---

## 3. Module contract

Every Polaxory module exposes a fixed five-part contract. The contract is the file `module.polaxory.json` (JSONC, comments allowed, mirroring Rojo's project-format choice [6]) co-located with the module source.

### 3.1 API surface (what callers may invoke)

A typed list of public functions. Anything not in the API surface is private to the module and the validator forbids cross-module calls to it.

```jsonc
{
  "api": {
    "fail":    { "args": [], "returns": "void" },
    "repair":  { "args": [{ "name": "fuel", "type": "number" }], "returns": "boolean" },
    "isOnline":{ "args": [], "returns": "boolean" }
  }
}
```

### 3.2 Emits (events the module produces)

Each emitted event has a fixed payload schema. The bus rejects emissions that do not match. Generated Luau cannot smuggle ad-hoc fields through the bus.

```jsonc
{
  "emits": {
    "GeneratorFailed": { "generatorId": "string", "region": "string", "t": "number" },
    "GeneratorRepaired": { "generatorId": "string", "fuel": "number", "t": "number" }
  }
}
```

### 3.3 Subscribes (events the module consumes)

Subscriptions list the source module by name plus the event. At build time the validator verifies every subscription resolves to a real emitter.

```jsonc
{
  "subscribes": [
    { "from": "PlayerState", "event": "PlayerEnteredRegion" },
    { "from": "Sabotage",    "event": "GeneratorSabotaged" }
  ]
}
```

### 3.4 Validates (preconditions and invariants)

Module-author-declared assertions checked at build and runtime. Static assertions ("this module requires `Tag:power-gated` to exist on at least one Part") run during Rojo build; runtime assertions ("at most one generator may be `online == false` per region per 60s") run inside the harness on Open Cloud [4].

```jsonc
{
  "validates": {
    "static": [
      "tag:exists power-gated >= 1",
      "service:exists ReplicatedStorage/Polaxory/Bus"
    ],
    "runtime": [
      "invariant: at-most-one regionFailureWithin60s",
      "precondition: fuel >= 0 on repair"
    ]
  }
}
```

### 3.5 Persists (durable state surface)

The module's persistent state schema, locked to a ProfileStore key namespace. Generated module code cannot write outside the declared keys. Schema changes require a versioned migration declaration — there is no silent shape drift.

```jsonc
{
  "persists": {
    "profileKey": "horror.generator",
    "schema": {
      "lastFailedAt": "number?",
      "totalFailures": "number"
    },
    "version": 1
  }
}
```

The contract is the only thing Polaxory's compiler reads. The Luau source is what gets shipped, but the Luau source is regeneratable from the contract plus the template; the contract is what creators and reviewers reason about.

---

## 4. The validator system

Validation runs in two phases. Both phases are required. Skipping either is not a Polaxory build.

### 4.1 Static checks (Rojo build time)

Static validation runs locally and in CI before the place file is ever uploaded. It catches the failures that don't require a running engine.

- **Selene lint** — Rust-fast Luau linter, Roblox-aware standard library, regenerated upstream every six hours [7]. Roblox themselves ship `selene.toml` in their open-source repos [7]. Polaxory templates pin a known-good Roblox std and a `selene.toml` baseline.
- **StyLua format check** — deterministic formatter, run as `stylua --check .` to fail builds that diverge from the canonical style [8]. Pinned via Rokit per template release; type-syntax regressions in 2.x mean the version is part of the contract [8].
- **luau-lsp analyze** — standalone type-check using the Rojo-generated sourcemap (`rojo sourcemap --output sourcemap.json`) [9]. Type errors fail the build. The new Luau type solver is opt-in per template; one solver per template generation, no IDE/CI drift.
- **Module contract validation** — Polaxory-owned check. Walks every `module.polaxory.json`, verifies every `subscribes.from.event` has a matching `emits` in another contract, verifies every `api` call site references a real function, verifies static assertions resolve (tags exist, services exist, namespaces don't collide).
- **Graph closure** — every emitted event has at least one subscriber OR is explicitly marked `terminal: true`. Orphan emitters are a build error. Cycles in the cascade graph are a build error unless explicitly marked `cycle: allowed` with a documented break condition.

Example static failure: a creator drops a `Hunter` module into a project but the project has no `LightController`. The `Hunter` contract subscribes to `LightController.PowerLost`. Build fails before Rojo runs. The error message names the missing module and links to the genre template that ships it.

### 4.2 Runtime checks (Open Cloud Luau Execution)

Runtime validation runs the built place inside RCC — a real Roblox server with full DataModel, no client, no rendering [4]. This is the only way to catch failures that need the engine.

- **Harness boot** — every module's `Init` runs to completion, no yields, no errors. ServiceBag-style strict no-yield-during-init [5] is enforced by the harness.
- **Cascade replay** — the harness fires every declared `emits` event with synthesized payloads matching the schema, observes the resulting cascade, and asserts every declared subscriber received it within a declared frame budget.
- **Invariant probes** — runtime assertions from each module's `validates.runtime` block are evaluated after the cascade. Invariants that hold under the synthetic trace pass; violations fail with the full event log attached.
- **TestEZ / jest-roblox suite** — each module ships its own behavior tests. The harness wraps them, captures structured logs (timestamp + message_type, as Open Cloud has surfaced since Feb 2025 [4]), returns `{pass, fail, errors[], timings}`.

Two operational constraints govern the runtime layer:

- **Per-place concurrency cap is 10** [4]. Polaxory provisions one validation place per active build lane and shards generations across `placeId`s. Token-staked tenants get more lanes.
- **Per-task wall clock is five minutes** [4]. Test suites are sharded by module so no single task hits the cap. The orchestrator coalesces shard results.

Sandbox limits are absorbed into the harness contract: no `loadstring`, no `debug.loadmodule`, no WebSocket, no plugin APIs [4]. Modules whose generated code would require any of these fail at static validation before they reach RCC.

---

## 5. skills.md integration

The existing skills.md spec defines agent rails — named, invocable capabilities each agent exposes. Skills are not parallel to the module graph; they are first-class graph participants.

Every skill is modeled as a virtual module with the same five-part contract.

- A skill's **API surface** is its invocation signature. The orchestrator calls `apply-charm-store` exactly the way it would call `Generator.fail`.
- A skill **emits** lifecycle events into the bus: `Skill.started`, `Skill.completed { artifacts }`, `Skill.failed { reason }`. Other modules and other skills can subscribe.
- A skill **subscribes** to the events that should trigger it. `apply-remote-middleware` subscribes to `Module.RegisteredRemoteEvent`. When a module registers a remote, the middleware skill fires automatically and the resulting wrapper is part of the cascade, not a separate manual step.
- A skill **validates** its own preconditions. `apply-matter-loop` declares `static: matter package present in wally.lock`. If the package isn't there, the skill cannot fire and the static validator surfaces it.
- A skill **persists** its decisions. A skill that picked Reflex over Charm writes that choice to the project's `state.polaxory.json` so subsequent skills see a consistent ground truth.

This gives Polaxory two important properties:

1. **Skill cascades are validated cascades.** An LLM-driven agent that fires `apply-service-bag` then `apply-charm-store` then `apply-profile-store` is not free-form orchestration — it is a sequence of declared events through the same bus that game-runtime events flow through. The same validator runs on both.
2. **Skills are observable in the same log.** Replay a build and you see both the generation cascade (`Skill.apply-service-bag.completed -> Skill.apply-remote-middleware.started`) and the runtime cascade (`Generator.failed -> Hunter.spawned`) in one ordered stream. There are not two systems to debug.

The agent layer thus reads from and writes to the same graph the game does. Skills are how agents touch the rails. The rails are how the game runs. Same primitives. Same validator. Same log.

---

## 6. Recommended tools stack

Polaxory does not invent Roblox tooling. The professional Luau stack converged in 2025–2026 and Polaxory rides it. The choice per tool is opinionated, not exhaustive.

- **Rokit** is the toolchain manager. One `rokit.toml` per template pins every other tool. Replaces Foreman/Aftman with backwards-compatible manifests [10]. Pinning is part of the validation contract — if CI's Selene is newer than the user's and catches a new lint, the build fails unexpectedly. Rokit eliminates that class of bug.
- **Rojo** is the project structure tool, pinned at v7.6.1 stable for production templates [6]. Fully Managed mode is the target — only mode that supports hermetic builds plus Open Cloud continuous deployment [11]. Canonical `src/server` → `ServerScriptService`, `src/shared` → `ReplicatedStorage`, `src/client` → `StarterPlayerScripts` layout, because that's what every Roblox dev expects and deviating creates onboarding friction [6]. `servePlaceIds` always set in generated project files — without it, a developer can `rojo serve` into the wrong place and overwrite a live game [6].
- **Wally** is the package manager. Required for community packages, baked `wally.lock` in every template, version pinned via Rokit [12]. Known shared/server linking bug is real; smoke-test requires in CI rather than trusting `wally install` alone [12]. The community `gooey` fork is on the awareness list, not the dependency list.
- **Selene** is the linter. Roblox uses it in their own open-source repos — strong adoption signal [7]. Roblox std lib auto-regenerated every six hours upstream; Polaxory CI refreshes on a schedule rather than pinning forever [7].
- **StyLua** is the formatter. Pin version per template release; Luau type-annotation syntax is the most regression-prone area in 2.x [8]. Format-stability test runs in CI.
- **luau-lsp** is the language server and the standalone type-check tool. Consumes Rojo's sourcemap [9]. Standalone analyze mode is the CI type-check gate, separate from lint and format. The new Luau type solver is opt-in and locked per template — IDE and CI must agree.
- **Open Cloud Luau Execution** is the runtime validator [4]. Two scopes, two API keys: `universe.places:write` for the Rojo upload key, `universe.place.luau-execution-session:write` for the runner key. Separation contains blast radius if either leaks. Binary I/O endpoint [4] is reserved for richer dev loops (snapshot diffs of generated Instance trees against reference `.rbxm`).
- **GitHub template repo** is the distribution surface for Phase 1. MIT licensed (matches every credible Roblox-template precedent — grilme99, takoyaki, place-ci-cd-demo [13]). The template ships: `default.project.json`, `rokit.toml`, `wally.toml` + `wally.lock`, `selene.toml`, `stylua.toml`, `.github/workflows/` with Selene + StyLua + luau-lsp analyze + Open Cloud validation jobs, `.vscode/extensions.json` recommending `evaera.vscode-rojo` + Luau LSP, plus the base module set (Bus, Atom store, ProfileStore wrapper, ServiceBag, Brio).

A Studio plugin is explicitly not first. Roblox is opening MCP from Studio outward [1]; Polaxory's first surface is the repo and the CI loop, not the IDE.

---

## 7. Differentiation vs Roblox Assistant

This is the hardest section to write honestly and the most important to get right. Assistant is good and getting better. Polaxory does not win by being a better Assistant.

**What Roblox Assistant does as of April 2026 [1][2][3]:**

- Planning Mode: reads the DataModel, asks clarifying questions, emits an editable action plan.
- Mesh Generation (GA via Cube): text-to-textured-3D inside Studio. Roblox reports 64% lift in average play time on experiences using generated meshes [2].
- Procedural Model Generation: parameterized 3D models with semantic relationships. Coming soon, not GA.
- Project-aware code generation: indexes the full experience, identifies logic errors, refactors to a game's architecture.
- Beta Playtesting Agent: drives the player character, reads logs, screenshots, files bugs against the original plan.
- Built-in MCP server: surfaces Studio context to Claude, Cursor, Codex through unprivileged APIs [1].

**What Assistant is structurally not doing:**

- Single backend model. No router. No model-of-best-fit by task [14].
- Single agent. Multi-agent parallel execution is on the roadmap, not shipped [14].
- In-Studio only. No publishing, no thumbnail/icon generation, no marketplace asset sourcing, no live-ops, no telemetry-driven iteration, no monetization tuning, no community/social plumbing.
- Genre-agnostic. No opinion. No prebuilt monetization patterns. No retention loops.
- Generated code is not guaranteed correct. The supplemental terms explicitly disclaim accuracy [3]. Dev sentiment in 2026 still flags generic AI tooling producing "messy or unusable" Luau [15].
- Daily quotas are tight enough that users hit caps in 1–3 prompts [16].
- ToS forbids using Assistant outputs to "create, train, or improve any other similar or competing product" [3].

**Where Polaxory's wedge sits:**

- **Validation.** Assistant emits and trusts the creator. Polaxory's contract+validator pipeline refuses to ship a module that fails static or runtime checks. That is the moat.
- **The graph.** Assistant has no concept of a deterministic module graph with declared event cascades. It generates scripts; it does not certify that those scripts hold together with the rest of the project.
- **The lifecycle Roblox left alone.** Publish, store-page, thumbnail, icon, marketplace sourcing, live-ops, analytics, monetization, social. None of these are Studio-local. None are Assistant's surface. They are Polaxory's.
- **Multi-agent orchestration through skills.md.** Roblox itself says multi-agent is roadmap [14]. Polaxory ships it now, riding Assistant via MCP plus Open Cloud rather than competing with it.
- **Model-router by design.** Different model for Luau correctness, different model for narrative, different model for balance analysis [14]. Polaxory makes routing a feature; Assistant cannot.
- **Genre opinion.** Backrooms-on-rails, tycoon-on-rails, horror-on-rails. Each ships with monetization patterns and retention loops baked in. Assistant has no opinion. Polaxory has many.

Polaxory rides Assistant via MCP. Polaxory does not train on Assistant outputs. Polaxory is positioned as orchestration plus lifecycle plus validation — never as substitution. The ToS line is bright and Polaxory stays on the correct side of it [3].

---

## 8. Token-backed infra utility

The Polaxory token is the access mechanism for premium parts of the rails. Not yield. Not speculation. Token-staked = infra-unlocked.

Concretely, staking gates four things:

1. **Validator capacity.** The Open Cloud per-place concurrency cap is 10 [4]. Polaxory's free tier shares a small pool of validation places. Stakers get dedicated lanes — N validation places, N parallel build queues, no waiting behind other tenants' generations.
2. **Premium templates.** Base templates (Backrooms, tycoon, obby, simulator) are free with the engine. Premium templates — combat netcode rollback, marketplace-tuned monetization patterns, retention-tested loop variants — unlock at staking thresholds.
3. **Build-queue priority.** Free tier runs FIFO. Staked tiers jump the queue proportional to stake. This is real infra-priority, not a cosmetic badge.
4. **Skill catalog scope.** The base skills.md set (apply-service-bag, apply-charm-store, apply-remote-middleware, apply-brio-signal, apply-matter-loop) is free. Premium skills — `apply-rollback-netcode`, `apply-tuned-monetization`, `apply-live-ops-experiment` — require staking.

Token utility is mechanical, not financial. The token does not pay yield. It does not represent revenue share. It buys validator throughput, premium rails, queue priority, and skill scope. If you don't stake, you still get a working product. If you stake, you get more of the same product, faster, with more pre-validated patterns to compose from.

This aligns with the Polaxory-Stack thesis: token-backed infrastructure for AI-driven game systems. The token mediates access to compute (validator places), to IP (premium templates and skills), and to priority (queue position). Nothing more.

---

## 9. Build sequencing

Phasing maps directly to POLAXORY-ENGINE.md Phases 1/2/3.

### Phase 1 — Template repo and base modules

Ship the GitHub template repo, MIT licensed, with:

- Rojo + Rokit + Wally + Selene + StyLua + luau-lsp configured and pinned.
- The default `src/server`/`src/shared`/`src/client` layout [6].
- The base module set: `Bus`, `Atom` (Charm-style store), `ProfileStoreWrapper`, `ServiceBag`, `Brio`, `RemoteMiddleware`.
- One genre vertical fully wired end-to-end. Recommended: Backrooms (matches existing engine work item #23). `Generator`, `LightController`, `Door`, `Hunter`, `PlayerState`, `SaveProfile` as the canonical cascade.
- README that documents the five-minute clone-to-Studio-running path. This is the gap every existing template leaves open [13].
- GitHub Actions CI running Selene + StyLua check + luau-lsp analyze on every PR.

No validator. No skills.md plumbing. No cockpit. Ship the rails as code, prove the cascade runs, get one vertical playable.

### Phase 2 — Validators and skills.md plumbing

- The module contract (`module.polaxory.json`) as a sealed schema.
- The static validator: graph closure check, contract resolution, orphan emitter detection.
- The runtime validator: Open Cloud Luau Execution harness with TestEZ/jest-roblox integration, structured log capture, sharded test suites under the 5-minute cap [4].
- Two API keys provisioned per tenant (places:write, luau-execution-sessions:write), scoped per universe/place.
- The skills.md bridge: every base skill modeled as a virtual module with the five-part contract; skill cascades flowing through the same bus.
- Token-gated lane provisioning: free tier shares N places, stakers get dedicated lanes.

By end of Phase 2, a creator can submit a generation request, the agent cascade fires through skills.md, the resulting module graph passes static + runtime validation on Open Cloud, and the validated `.rbxl` is deployed via Open Cloud places:write [4]. End-to-end without Studio in the loop.

### Phase 3 — Creator cockpit

- Web UI that surfaces the event log (generation cascade and runtime cascade in one ordered stream).
- Module graph visualization: nodes are modules, edges are subscriptions, color = validation status.
- Build queue with stake-weighted priority visible.
- Premium template and premium skill catalog with stake thresholds.
- Live-ops dashboard: telemetry ingestion from deployed places, retention/monetization metrics, proposed iterations as new skill cascades.
- Studio plugin — only at Phase 3, only if there is real signal that the cockpit needs an in-Studio counterpart. Roblox is opening MCP outward [1]; the assumption is the cockpit lives outside Studio.

Sequencing rule: do not start Phase N+1 until Phase N has one paying tenant running a real game on it.

---

## 10. Open questions

Decisions deliberately deferred for the carve.

1. **Wally vs Pesde.** Wally is still the dominant game-template package manager in 2026; Pesde is rising on the library side [12]. Polaxory commits to Wally for Phase 1. Open question: does Phase 2 add Pesde support, or does Polaxory stake a position?
2. **Knit vs ServiceBag for the spine.** Nevermore's ServiceBag has the production track record [5]. Knit has more creator mindshare but is no longer receiving updates [5]. Phase 1 leans ServiceBag. Open question: does Polaxory ship a Knit-compatibility skill for migration tenants?
3. **Matter ECS as default for simulation-heavy genres.** Matter has no built-in replication [5] — every project rolls its own. Open question: ship a Polaxory-owned replication layer paired with Matter, or pick a genre policy (ECS only for simulators/combat, atomic store only for everything else)?
4. **Studio Script Sync coexistence.** Roblox's official two-way sync is now beta [17]. It overlaps with Rojo. Open question: pick Rojo and document Script Sync as disabled, or support both with a sync-mode flag per project?
5. **Validator severity model.** Should every lint and type warning fail the build, or is there a graduated severity (error / warn / info) creators can tune? Default for v0: every static check is binary pass/fail; runtime checks return structured results with severity.
6. **Stake-to-lane formula.** Linear (stake × lanes) is simplest. Logarithmic prevents whale-monopolization of validator capacity. Open question for the token spec, but the rails spec assumes lanes are the unit being allocated.
7. **MCP-from-outside-Studio scope.** Roblox's MCP exposes unprivileged APIs [1]. Open question: what subset of Polaxory's generation workflow requires MCP-into-Studio, and what subset stays headless via Open Cloud only? Phase 2 spike: probe MCP capabilities outside Studio against engine work item #9.
8. **Genre coverage roadmap.** Backrooms first. Tycoon second. Obby third. After that — combat, simulator, social hangout? Open question and likely a tenant-demand question, not a spec question.
9. **Premium-skill IP boundary.** Are premium skills MIT-licensed but stake-gated for execution, or are they proprietary? Either is defensible. Lean: MIT-licensed source, stake-gated CI execution (anyone can read the skill, only stakers can run it on Polaxory's infra at scale).
10. **Generated-code provenance and audit log.** Every module ships with a contract; does the contract include a hash of the model + prompt + skill cascade that produced its current Luau source? Lean yes — provenance is part of the validation moat — but the storage and disclosure semantics are open.

---

## Sources

[1] Roblox Newsroom, "Roblox Studio Is Going Agentic," Apr 2026. https://about.roblox.com/newsroom/2026/04/roblox-studio-going-agentic
[2] TechCrunch, "Roblox's AI assistant gets new agentic tools to plan, build and test games," Apr 16 2026. https://techcrunch.com/2026/04/16/robloxs-ai-assistant-gets-new-agentic-tools-to-plan-build-and-test-games/
[3] Roblox Help Center, "AI-Based Tools Supplemental Terms and Disclaimer." https://en.help.roblox.com/hc/en-us/articles/20121392440212
[4] Roblox Creator Docs, Open Cloud Luau Execution reference + DevForum beta thread. https://create.roblox.com/docs/cloud/reference/features/luau-execution and https://devforum.roblox.com/t/beta-open-cloud-engine-api-for-executing-luau/3172185
[5] Synthesis from Nevermore ServiceBag, Matter ECS, Knit, ProfileStore, Charm/Reflex documentation. https://quenty.github.io/NevermoreEngine/docs/servicebag/ , https://matter-ecs.github.io/matter/docs/Concepts/ , https://madstudioroblox.github.io/ProfileStore/ , https://github.com/littensy/charm
[6] Rojo project format and getting-started docs. https://rojo.space/docs/v7/project-format/
[7] Selene linter, Kampfkarren/selene + Roblox std lib. https://github.com/Kampfkarren/selene , https://kampfkarren.github.io/selene/roblox.html
[8] StyLua, JohnnyMorganz/StyLua releases. https://github.com/JohnnyMorganz/StyLua
[9] luau-lsp, JohnnyMorganz/luau-lsp README. https://github.com/JohnnyMorganz/luau-lsp/blob/main/README.md
[10] Rokit toolchain manager. https://github.com/rojo-rbx/rokit
[11] Rojo workflows doc, Fully vs Partially Managed. https://rojo.space/docs/v7/workflows/
[12] Wally package manager + known-issues thread + gooey fork. https://github.com/UpliftGames/wally , https://github.com/UpliftGames/wally/issues , https://github.com/MeowSpark/gooey
[13] Reviewed template ecosystem — grilme99/roblox-project-template, takoyakisoft/roblox-rojo-wally-template, Roblox/place-ci-cd-demo, MonzterDev/Roblox-Game-Template, frostproject/roblox-library-template. https://github.com/grilme99/roblox-project-template , https://github.com/Roblox/place-ci-cd-demo
[14] BloxBot, "What's new in Roblox AI 2026" — multi-agent and routing as roadmap. https://www.bloxbot.ai/guide/whats-new-roblox-ai-2026
[15] DevForum, "Developer Intelligence: the best AI for Roblox Studio in 2026." https://devforum.roblox.com/t/developer-intelligence-the-best-ai-for-roblox-studio-in-2026/4512528
[16] DevForum, "Asking the Studio Assistant a singular question resulted in hitting the daily quota." https://devforum.roblox.com/t/asking-the-studio-assistant-a-singular-question-resulted-in-hitting-the-daily-quota/2816830
[17] DevForum, "Studio Script Sync now in beta." https://devforum.roblox.com/t/studio-script-sync-now-in-beta/4065468
