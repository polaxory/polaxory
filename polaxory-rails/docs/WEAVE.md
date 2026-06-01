# WEAVE.md

> The data-flow contract between the seven rails.
> What flows from where, in what form, with what guarantees.

---

## The weave

```
creator intent          (intent rail)
   ↓
   transforms via intent → graph compiler
   ↓
graph                   (graph rail) ← source of truth per the prime law
   ↓
   each node generates a contract stub
   ↓
contracts               (contract rail)
   ↓
   contracts get implemented as services on the server (authority rail enforces server-side ownership)
   ↓
services                (server-side implementation)
   ↓
   validators run (validation rail)
   ↓
validated artifact
   ↓
   Rojo builds the artifact (build rail)
   ↓
Studio-ready slice
   ↓
   slice deploys to a Roblox place; agents (agent rail) connect via skills.md
   ↓
running game
```

---

## What flows in each step

### intent → graph

**Input:** a structured intent document. Game concept, mechanics, aesthetic, monetization shape, target slice (MVP / V1 / V2).

**Transformer:** the intent → graph compiler. Takes the declarative intent and produces a graph (nodes + edges). Some nodes come from templates (e.g., "horror game" intent pulls in Hunter, Light, Hazard nodes by default); others are creator-specified.

**Output:** a graph document conforming to the graph schema.

**Guarantee:** the graph is structurally valid (all nodes have valid schemas, all edges connect existing nodes). It may not yet be semantically complete — some nodes may need contracts.

### graph → contracts

**Input:** the graph document.

**Transformer:** for each node, derive a contract stub from its node type and connected edges. A contract is the formal API surface: what the module exposes, what events it emits, what events it subscribes to, what state it persists, what invariants it maintains.

**Output:** one contract per node.

**Guarantee:** every node in the graph has a contract. Every edge has a producer and a consumer declared in the relevant contracts. Build-blocking validator rejects graphs where this isn't true.

### contracts → services

**Input:** the contracts.

**Transformer:** implement the contracts as services in `src/server/services/`. Services own state, validate inputs, emit events, persist what they own.

**Output:** working Luau services per contract.

**Guarantee:** the authority rail enforces server-side ownership. The validator rejects services that violate server-authority patterns.

### services → validators

**Input:** the services (code) + the contracts (specs) + the graph (structure).

**Transformer:** the validator suite. Runs the build-blocking rules: every edge has endpoints, every emit has subscribers (or is marked broadcast-only), every contract has a service implementation, no orphan modules, no client-trusted state writes, etc.

**Output:** a validator report. PASS / FAIL with specific findings.

**Guarantee:** if PASS, the slice is buildable. If FAIL, the build is rejected and the report says exactly where.

### validators → Rojo build

**Input:** validated services + contracts + graph + Rojo config.

**Transformer:** Rojo. Combines `src/` with package dependencies and project config into a `.rbxl` or sync map.

**Output:** a Studio-ready slice (or, in headless mode, a `.rbxlx` file uploadable via Open Cloud).

**Guarantee:** reproducible build. Same graph + contracts + services → identical slice.

### slice → running game

**Input:** the slice deployed to a Roblox place.

**Transformer:** Roblox's runtime. Plus the agent rail, which loads `skills.md` manifests as agents connect.

**Output:** a running game with agents participating per the prime law.

**Guarantee:** agents only do what their `skills.md` declares, enforced by the agent rail. Server-authority enforced by the authority rail. State changes audited.

---

## Reverse flow (when things change)

Production games change. The weave handles change by routing all changes through the graph:

- A new mechanic? Update the graph; the contracts derive; the services implement; the validators check.
- A new agent type? Update its `skills.md`; the agent rail loads the new manifest at connection time.
- A balance change? Update the contract's invariants (or service config); the validator re-checks.
- A new game slice? Start with a new intent; produce a new graph; the rest follows.

Never edit the slice directly. Never edit a service without updating its contract. Never add a contract without updating the graph. The prime law is enforced through this discipline more than through any specific tool.

---

## Failure modes the weave catches

- Modules with no contracts (graph has nodes; no contract layer): build fails at validation
- Contracts with no services (specs without implementations): build fails at validation
- Services that violate authority (client-trusted writes): build fails at validation
- Events with no subscribers (emit-only with no consumer): build fails unless edge is marked broadcast-only
- Orphan modules (no graph node refers to them): build fails or modules are flagged for removal
- Agents with skills.md that doesn't match registered runtime actions: load fails with clear error

Each catch is a junction where the prime law is enforced. The weave is the prime law in motion.
