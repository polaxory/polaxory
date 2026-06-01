# Polaxory Tooling Survival Layer

## Purpose

Keep the agent tooling durable enough to survive ordinary repo churn without turning the public project page into an agent-status billboard.

This layer exists to make the production loop quieter, smaller, and more recoverable.

## Public posture

The GitHub project page should only acknowledge that the tooling layer is running. It should not center the agents, pitch the automations, or distract from Polaxory as a Roblox production layer.

Preferred public language:

- Tooling layer: active
- Quiet unless shipping, blocked, or validating a release claim

Avoid public language like:

- autonomous swarm
- agent army
- fully self-building game studio
- anything that makes tooling the product instead of the support system

## Internal tooling lanes

### Builder

Creates the next smallest concrete artifact that moves Slice-0 toward playability.

Reports only:

- changed file
- commit
- why it matters
- next best artifact

### Validator

Checks whether builder output makes the slice more playable, testable, or shippable.

Reports only when:

- a playability gap is found
- a release claim is unsafe
- a concrete validation artifact was committed

### Researcher

Imports useful outside patterns into Polaxory without dumping research piles into the active path.

Reports only when research becomes a decision, brief, or implementation candidate.

### Release reviewer

Stops demos from overclaiming.

Reports only when a claim needs to be narrowed, validated, or cut.

## Survival rules

1. One lane per run.
2. One artifact per commit.
3. Prefer docs, schemas, fixtures, and checks over vague strategy.
4. Keep private agent state out of the repo.
5. Keep public pages focused on the game and production layer, not the agents.
6. If nothing useful changed, stay silent.
7. If blocked, name the blocker and the next smallest unblock.

## Git page acknowledgement

The page may show a small operator/status entry:

```text
Tooling Layer — active
Keeps builder, validator, researcher, and release-review loops quiet unless they ship or block.
```

That is enough. The tooling should be load-bearing, not loud.
