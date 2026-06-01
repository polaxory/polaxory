# Research Assignment Loop

## Purpose

Continuously improve Polaxory through tiny, safe, observable commits.

This loop is an assignment engine, not a random cleanup bot. Each run should turn one concrete repo observation into one narrow improvement and one committed artifact.

## Iteration Rules

- Inspect the repository and recent commits before changing anything.
- Pick exactly one small issue, gap, TODO, missing doc, missing test, weak naming, unsafe edge case, or unclear developer workflow.
- Prefer improvements that make the project easier to understand, run, validate, or ship.
- Make one narrow change per run.
- End each successful run with one quick commit.
- Do not do broad refactors.
- Do not upgrade dependencies.
- Do not delete major files.
- Do not touch secrets, auth, deploy keys, tokens, environment files, or private config.

## Required Research Note

Every completed run should report:

```txt
Finding:
Hypothesis:
Change:
Commit:
Next question:
```

## Current Focus

Signal Run v0: round loop, reward loop, replay loop, validation guards, and tiny Roblox Studio validation artifacts.

## Good Assignment Targets

- A short validation checklist for a newly generated loop.
- A missing runbook note that helps another developer test the feature.
- A small docs correction that removes ambiguity.
- A narrow guardrail around spam, stale state, or replay flow.
- A next-question log entry that keeps the research chain alive.

## Bad Assignment Targets

- Large generated rewrites.
- Dependency upgrades.
- Broad architecture changes.
- Secret/config edits.
- Cosmetic churn with no research note.

## Example Result

```txt
Finding:
Reward loop has UI but no assignment-style validation doc.

Hypothesis:
A short test checklist will make future iteration safer.

Change:
Added docs/SIGNAL_RUN_TEST_CHECKLIST.md.

Commit:
Add Signal Run test checklist

Next question:
Can round timeout cleanup be validated from a solo Studio run?
```
