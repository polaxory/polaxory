# Polaxory AI Tooling Stack Research

Purpose: convert useful AI-building patterns from Karpathy-style research loops and Garry Tan's gstack workflow into a tight, repo-native infrastructure plan for Polaxory Slice-0.

This is not a giant agent fantasy. It is a small production layer for getting from docs to a playable Roblox Backrooms-style slice.

## Slice-0 north star

A player can enter a Roblox Backrooms-style slice, complete a simple run, earn off-chain points, replay safely, and have the result validated server-side.

Every tool below is judged by whether it moves that target closer.

## Source stack

### Karpathy-style patterns

- `autoresearch`
  - Source: `https://github.com/karpathy/autoresearch`
  - Pattern: bounded autonomous research loop with a clear metric and a timebox.
  - Polaxory adaptation: use tiny artifact loops that create or improve exactly one file per run.
  - Automation candidate: Slice-0 artifact builder.

- `program.md` instruction-file pattern
  - Source: `autoresearch` workflow pattern.
  - Pattern: humans edit the agent's instructions; agents edit the working artifact.
  - Polaxory adaptation: store automation contracts in docs so each loop has a visible operating spec.
  - Automation candidate: automation contract docs for builder, validator, QA, and release loops.

- Fixed metric plus budget
  - Source: Karpathy research-loop style.
  - Pattern: a run should know what score it is optimizing and when to stop.
  - Polaxory adaptation: each automation reports one measurable movement toward playability, not vague activity.
  - Automation candidate: playability validator.

- LLM wiki / memory layer
  - Source: Karpathy LLM Wiki pattern, e.g. `https://github.com/ScrapingArt/Karpathy-LLM-Wiki-Stack`.
  - Pattern: raw sources remain stable; the LLM maintains a structured markdown knowledge layer.
  - Polaxory adaptation: keep research, decisions, ambiguity registers, and implementation plans under `docs/polaxory/`.
  - Automation candidate: research assignment loop and decision-register updater.

- CLAUDE-style guardrails
  - Source: Karpathy-inspired coding rules, e.g. `https://github.com/multica-ai/andrej-karpathy-skills`.
  - Pattern: think before coding, prefer simple changes, avoid drive-by rewrites, verify the goal.
  - Polaxory adaptation: every agent run must be surgical, explain why the changed file matters, and name the next smallest artifact.
  - Automation candidate: commit hygiene reviewer.

### Garry Tan / gstack patterns

- `gstack`
  - Source: `https://github.com/garrytan/gstack`
  - Pattern: specialized command roles for planning, review, QA, shipping, security, and retros.
  - Polaxory adaptation: convert commands into repo-native automation roles rather than one mega-agent.

- `/office-hours`
  - Use: pressure-test a product idea before implementation.
  - Polaxory adaptation: review Slice-0 assumptions and reject scope creep.
  - Automation candidate: weekly idea-pressure-test report.

- `/plan-ceo-review`
  - Use: founder/product review.
  - Polaxory adaptation: ask whether the next artifact makes the player loop clearer.
  - Automation candidate: product-decision reviewer.

- `/plan-eng-review`
  - Use: architecture, edge cases, implementation risk.
  - Polaxory adaptation: review Roblox, server validation, points, replay, and wallet-profile boundaries.
  - Automation candidate: implementation-plan reviewer.

- `/plan-design-review`
  - Use: design-quality review.
  - Polaxory adaptation: prevent AI-slop maps and mechanics; demand one strong playable beat.
  - Automation candidate: slice feel reviewer.

- `/qa` / `/qa-only`
  - Use: browser or product QA.
  - Polaxory adaptation: once code exists, verify the minimal player path rather than just files.
  - Automation candidate: Slice-0 playability validator.

- `/review`
  - Use: code and production-readiness review.
  - Polaxory adaptation: inspect the smallest implementation diff against the north star.
  - Automation candidate: safe auto-commit reviewer.

- `/ship` / `/land-and-deploy`
  - Use: release-manager flow.
  - Polaxory adaptation: only ship when the run path, points, replay, and validation story are coherent.
  - Automation candidate: release readiness checklist.

- `/cso`
  - Use: security review.
  - Polaxory adaptation: review wallet-linked profile boundaries, server validation, and abuse cases.
  - Automation candidate: wallet/profile security reviewer.

- `/retro`
  - Use: post-run retrospective.
  - Polaxory adaptation: after every few commits, identify what moved playability and what was noise.
  - Automation candidate: commit-retro loop.

## Tightened Polaxory infra

### Automation lanes

1. Builder lane
   - Owns: creating the next missing artifact.
   - Current doc: `docs/polaxory/POLAXORY_SLICE0_ARTIFACT_BUILDER_AUTOMATION.md`.
   - Rule: create or improve one high-leverage file per run.

2. Validator lane
   - Owns: checking whether artifacts make Slice-0 more playable.
   - Current doc: `docs/polaxory/POLAXORY_SLICE0_PLAYABILITY_VALIDATOR_AUTOMATION.md`.
   - Rule: validate the player path, not just documentation volume.

3. Research lane
   - Owns: turning external tools, patterns, and references into Polaxory-specific decisions.
   - Current doc: this file.
   - Rule: every external source must become either a Polaxory adaptation or a rejected idea.

4. Release lane
   - Owns: deciding when Slice-0 is ready to package, test, or demo.
   - Next likely doc: `docs/polaxory/POLAXORY_SLICE0_RELEASE_READINESS_CHECKLIST.md`.
   - Rule: no release without a playable path and validation story.

### Commit contract

Every automation commit should report:

- Commit link.
- Changed files.
- Why the change matters for Slice-0.
- Which lane it belongs to.
- The next smallest artifact.
- Any blocker or ambiguity.

### Guardrails

- Do not build a broad metaverse plan before Slice-0 works.
- Do not create more roles than the repo can act on.
- Do not treat wallet linkage as core gameplay; it is profile/progression infrastructure.
- Do not optimize lore before the run loop is playable.
- Prefer one concrete artifact over ten speculative automations.

## Recommended next artifacts

1. `docs/polaxory/POLAXORY_SLICE0_RELEASE_READINESS_CHECKLIST.md`
   - Defines the minimum bar for demo/release.

2. `docs/polaxory/POLAXORY_AMBIGUITY_REGISTER.md`
   - Converts vague ambitions into explicit decisions.

3. `docs/polaxory/POLAXORY_SLICE0_QA_SCRIPT.md`
   - Describes the exact player path QA must verify.

4. `docs/polaxory/POLAXORY_AGENT_INFRA_ROLES.md`
   - Maps builder, validator, researcher, reviewer, security, and release roles to repo artifacts.

## Default recommendation

Keep the current automation system small:

- Builder: makes artifacts.
- Validator: checks playability.
- Researcher: imports useful external patterns.
- Release reviewer: decides whether the slice is demoable.

Everything else is noise until the player can complete the first run.
