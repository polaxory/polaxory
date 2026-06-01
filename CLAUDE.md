# CLAUDE.md

> Operating context for Claude Code instances working in the polaxory/polaxory repo.
> Read alongside `FILE_KNOLL.md`, `SECURITY_BOUNDARY.md`, and `docs/agentic/*`.

## Reading order

Per `README.md` load order:

1. `FILE_KNOLL.md` (what's included / excluded)
2. `SECURITY_BOUNDARY.md` (what never gets committed)
3. `docs/polaxory/00_ACTIVE_CONTEXT.md` (current thesis + next artifacts)
4. Canonical Polaxory docs under `docs/polaxory/`

Do not load the full research pile by default. Use the knoll.

## Tool-discovery and context minimization

- Before executing any task, search `scripts/`, `apps/*/src/`, and `docs/agentic/` for an existing skill, command, or pattern. Reuse beats reinvention.
- Do not read entire Roblox place files or large `ModuleScript` content into context unless specifically targeted by the task.
- Prefer `grep`, `find`, and `gh` reads over full-file dumps. Fetch specific functions, not whole files.
- When a file exceeds 150 lines, refactor it into a `ModuleScript` and `require()` it from a smaller surface. The repo's own modules already follow this — keep new code inside the bound.
- Avoid deep Demeter chains (`game.Workspace.Part.Surface.Frame.TextLabel`). Cache locals once; reuse them.

## Multi-agent role

This file sits inside the Claude Code role per `docs/agentic/MULTI_AGENT_COORDINATION_PROTOCOL.md`:

- Receive narrow tickets with file paths, acceptance criteria, and test expectations.
- Avoid product redesign unless a ticket explicitly asks for architecture work.
- Make small atomic commits. Branch + PR for risky changes; direct `main` only for trivial docs/config or explicit user requests.
- Report only tool-confirmed actions. Never claim tests passed without a tool result.
- Never fabricate commit SHAs.
- Use the handoff packet format (Task / Owner / Context / Files to inspect / Files likely to modify / Acceptance / Tests-checks / Risks / Next handoff) when proposing follow-on work.

## Commit cadence

- Prefer small, single-concern commits over large opaque changes.
- `scripts/git-microcommit.sh` exists as an AI-assisted commit-message helper for fast iteration. Use it when generating many tight commits.
- On `pull_request` events, CI runs against the synthesized merge result of branch + main. If main is red, PR CI will also be red — fix main's red before expecting PR CI to flip green.
- Recurring lint failure pattern? Surface it as a Nullsec watch issue per `docs/agentic/HYPURRCLAW_OPERATING_LOOP.md` rather than silently re-fixing it.

## Roblox / Luau guardrails

- Server owns gameplay state. Client sends intent only. Anything that looks like client-authoritative resource mutation is a constitution violation (see `docs/polaxory/POLAXORY_RAILS_CONSTITUTION_v0.md`).
- Every Remote needs schema, rate limit, permission rule, and server validation per `src/shared/RemoteContracts.luau` style.
- Every module declares dependencies, emitted events, listened events, resources, tests, validators.
- Run `stylua --check src` and `selene src` locally before pushing. Aftman manages both via `aftman.toml`. CI runs the same checks; recurring format failures are tracked in issue #5.
- Telemetry must stay aggregate. No raw Roblox `UserId`, player names, chat text, IP, or device identifiers in committed snapshots. See `src/shared/TelemetryInstrument.luau` for the boundary.

## Context-pruning loop

Long sessions bloat context. Apply the loop:

1. **Inspect** — search local files / `gh` state / existing skills before doing anything new.
2. **Isolate** — target the specific module, function, or contract; refuse to load adjacent context.
3. **Micro-patch** — write the smallest commit that satisfies the ticket.
4. **Checkpoint** — record what was completed (commit SHA, file paths, open follow-ups) before context fills.
5. **Flush + resume** — start a fresh Claude Code session with only the checkpoint + the next ticket loaded.

If a session is already context-heavy, prefer to ship the smallest meaningful patch and call out the rest as follow-up handoffs rather than push through.

## Cut line

If a file you're producing exceeds 200 lines without an explicit architectural reason, stop and split it. The Roblox-on-rails ethos is small composable modules, not monoliths.
