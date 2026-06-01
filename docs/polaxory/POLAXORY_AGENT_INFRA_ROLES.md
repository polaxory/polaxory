# Polaxory Agent Infra Roles

Purpose: define the smallest useful agent infrastructure for Polaxory without creating a fake company of bots.

## North star

A player can enter a Roblox Backrooms-style slice, complete a simple run, earn off-chain points, replay safely, and have the result validated server-side.

## Roles

### 1. Builder

- Job: create the next missing artifact.
- Input: current repo docs and the Slice-0 north star.
- Output: one file or one surgical improvement.
- Must report: changed file, why it matters, next artifact.
- Anti-pattern: broad rewrites or vague strategy docs.

### 2. Validator

- Job: check whether the latest artifacts improve playability.
- Input: GDD, graph, implementation plan, QA script, changed files.
- Output: pass/fail notes, blocker, next smallest fix.
- Must report: whether a player path is clearer than before.
- Anti-pattern: praising docs that do not reduce implementation uncertainty.

### 3. Researcher

- Job: convert external patterns into Polaxory-specific decisions.
- Input: source links, repo context, current ambiguity.
- Output: sourced adaptation notes and automation candidates.
- Must report: source, pattern, adaptation, rejected ideas.
- Anti-pattern: dumping links without decisions.

### 4. Reviewer

- Job: protect simplicity and implementation quality.
- Input: proposed diff or newly committed artifact.
- Output: risks, missing edge cases, simplest next correction.
- Must report: one highest-risk issue.
- Anti-pattern: turning every concern into a new subsystem.

### 5. Security reviewer

- Job: inspect wallet/profile, validation, abuse, and data-boundary risks.
- Input: server validation plan, wallet-linked profile design, points mechanics.
- Output: abuse cases and minimum safeguards.
- Must report: what must be server-authoritative.
- Anti-pattern: treating wallet linkage as permission to make gameplay custodial or fragile.

### 6. Release reviewer

- Job: decide whether Slice-0 is demoable.
- Input: QA script, implementation status, validation status.
- Output: release checklist result and blocker list.
- Must report: demoable / not demoable, and why.
- Anti-pattern: shipping because docs exist.

## Operating rules

- One role per run unless explicitly combining them saves time.
- One artifact per commit unless files are tightly coupled.
- Prefer artifact paths under `docs/polaxory/` until implementation files exist.
- Every role must name the next smallest artifact.
- Silence is allowed when there is no useful change.

## Current active lanes

- Builder lane: active.
- Validator lane: active.
- Research lane: introduced by `POLAXORY_AI_TOOLING_STACK_RESEARCH.md`.
- Release lane: recommended next.

## Next infra tightening

Create `docs/polaxory/POLAXORY_SLICE0_RELEASE_READINESS_CHECKLIST.md` so the automations have a hard gate between planning and demo claims.
