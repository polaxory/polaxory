# Polaxory Slice-0 Playability Validator Automation

## Purpose

This automation checks whether Polaxory Slice-0 is moving toward an actually playable Roblox Backrooms-style experience, not just accumulating attractive planning documents.

The Slice-0 target is simple:

> A player can enter a Roblox Backrooms-style run, navigate a simple space, reach an objective or fail state, earn off-chain points through server-side validation, and replay safely.

The builder automation creates forward motion. This validator automation keeps that motion honest.

## Why this exists

Game projects fail quietly when the repo looks productive but the player experience is still undefined. This automation exists to catch that drift early.

It should repeatedly ask:

- Can a player start a run?
- Is there a clear objective?
- Can the player finish or fail?
- Are rewards validated server-side?
- Can the player replay without corrupting state or farming rewards?
- Is the next artifact moving toward playability, or only expanding lore/scope?

## Validation checklist

### 1. Core loop clarity

The repo should eventually define, in implementation-ready terms:

- Enter run
- Spawn or load Slice-0 room/path
- Navigate toward a clear objective
- Trigger success or failure
- Submit result for validation
- Award off-chain points if valid
- Allow replay

If any step is missing, the validator should identify the smallest next artifact that closes the gap.

### 2. Server-side validation coverage

The validator should look for explicit handling of:

- No client-trusted reward claims
- Duplicate claim prevention
- Reward already-claimed flag
- Stale round cleanup
- Leave/disconnect cleanup
- Basic anti-spam or cooldown guard
- Score/time/objective sanity checks

A Slice-0 that trusts the client to award points is not valid.

### 3. Missing implementation artifacts

The validator should call out missing files or specs for:

- Roblox gameplay scripts
- Server/API validation flow
- Data model for runs, players, points, and claims
- Test checklist
- Failure/replay behavior
- Minimal UX flow

It should prefer concrete target paths over generic advice.

## Reporting contract

On each run, the automation should produce one of two outputs.

### Suppress when there is nothing useful

If no meaningful playability signal changed, return exactly:

```text
CRON_SUPPRESS
```

### Report when action is useful

If there is a useful finding, report:

- **Playability status:** green, yellow, or red
- **Biggest blocker:** the single issue most preventing a playable Slice-0
- **Next file to create/edit:** exact path if possible
- **Smallest useful commit:** a safe docs-first or implementation-plan change
- **Commit link:** only if the automation made a safe commit

## Status definitions

### Green

The repo contains enough implementation-ready detail for a minimal playable Slice-0 loop with server-side reward validation.

### Yellow

The repo has a plausible Slice-0 plan, but one or more implementation or validation details are still underspecified.

### Red

The repo is mostly concept/lore/planning and cannot yet guide a playable, validated Slice-0 build.

## Safe commit policy

The automation may make small docs-only commits when the improvement is obvious and low-risk. Examples:

- Add a missing checklist
- Tighten vague wording into implementation criteria
- Add exact target paths for next artifacts
- Convert broad ambitions into validator questions

It must not:

- Claim gameplay exists without repository evidence
- Invent completed implementation
- Deploy code
- Delete files
- Expand scope beyond Slice-0
- Replace the builder automation

## Recommended schedule

Run every 4 hours, alongside the Slice-0 artifact builder.

The builder asks, "What should we create next?"

The validator asks, "Does this make the game more playable?"

Both are needed. One pushes. One checks the steering.
