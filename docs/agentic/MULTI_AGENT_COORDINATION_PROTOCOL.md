# Multi-Agent Coordination Protocol

This document defines how Hypurrclaw, Nullsec bot, Claude Code, and external research agents should collaborate without stepping on each other.

## Roles

### Hypurrclaw
- Converts Blake's high-level intent into scoped work.
- Maintains task queues, research memos, and GitHub coordination artifacts.
- Makes small safe commits when explicitly requested.
- Reports only tool-confirmed actions.

### Claude Code
- Best used for deeper implementation passes.
- Should receive narrow tickets with file paths, acceptance criteria, and test expectations.
- Should avoid redesigning the whole product unless a ticket explicitly asks for architecture work.

### Nullsec bot
- Best used as repo/ops sentinel.
- Watches commits, CI failures, stale tasks, security drift, and unsafe broad changes.
- Should open or update issues rather than silently rewriting architecture.

### SuperGrok / external research
- Best used for broad pattern discovery.
- Outputs should become hypotheses with citations and dates.
- Research should not directly override product direction without synthesis.

## Shared artifact types

- `docs/agentic/*` — coordination and operating protocol.
- `docs/research/*` — market, platform, Roblox, agent, and retention research.
- `docs/slices/*` — implementation slices and acceptance criteria.
- GitHub issues — executable tasks for Claude Code / Nullsec / human review.
- Pull requests — larger risky changes.

## Handoff packet format

Each handoff should include:

```text
Task:
Owner candidate:
Context:
Files to inspect:
Files likely to modify:
Acceptance criteria:
Tests/checks:
Risks:
Next handoff:
```

## Conflict policy

When agents disagree:

1. Preserve the smaller reversible change.
2. Write the disagreement down in an issue/comment.
3. Ask for human choice only when both paths are plausible and consequential.
4. Never bury conflicting changes in one giant commit.

## Current Polaxory priority

Build **Factory Slice 0** as a playable Roblox factory loop with agent rails underneath:

```text
FactoryBlackboard
→ SupervisorAgent
→ TaskQueue
→ WorkerBehaviorTree
→ ResourceExecutor
→ Validators
```

The game must stay cute and legible first. Agentic depth should be discoverable underneath, not shoved into the player's face.