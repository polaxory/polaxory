# Polaxory Slice-0 Artifact Builder Automation

## Purpose

This automation advances the Roblox Slice-0 playable vertical slice with small, safe, reviewable commits.

It exists to move the project from planning toward the minimum playable machine:

> A player can enter a Roblox Backrooms-style slice, complete a simple run, earn off-chain points, replay safely, and have the result validated server-side.

## Schedule

Runs every 4 hours.

## Automation ID

`kn71fznyazngfj2dwg34mz5xkx87vxcf`

## Target artifact order

1. `docs/polaxory/POLAXORY_BACKROOMS_SLICE_0_GDD.md`
2. `docs/polaxory/POLAXORY_BACKROOMS_SLICE_0_GRAPH.json`
3. `polaxory-rails/README.md`
4. `docs/polaxory/POLAXORY_VALIDATOR_IMPLEMENTATION_PLAN_v0.md`
5. `.github/workflows/polaxory-rails-ci.yml`

## Guardrails

Each run should:

- inspect the repo first
- choose exactly one missing or weak artifact
- prefer one-file changes
- avoid secrets
- avoid dependency churn
- avoid broad refactors
- commit only when the change is useful
- preserve the next research or build question

## Run report contract

Each useful run reports:

- commit
- changed file
- why it matters
- next best artifact

If no useful change is available, the automation should return exactly:

```txt
CRON_SUPPRESS
```
