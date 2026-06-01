# rail: intent

> Captures the creator's design intent in a structured, declarative form.
> Status: v0 sketch. Schema pending alignment with `POLAXORY_RAILS_CONSTITUTION_v0.md`.

---

## What this rail does

Receives intent from a creator (human or agent), produces a structured intent document that the graph rail can compile into a graph.

Intent is upstream of the graph. It's the description of what the creator wants. A game type. A set of mechanics. An aesthetic. A monetization shape. The intent → graph compiler turns this into a concrete graph.

## Input format (draft — pending operator carve)

```yaml
---
intent_version: "0.1"
slice_id: slice-0-backrooms
working_title: "Backrooms Protocol"
game_type: horror_survival
operator: jetski

aesthetic:
  setting: backrooms_liminal
  visual_style: voxel_low_poly
  lighting: dim_fluorescent
  audio: sparse_ambient_with_hazard_cues

mechanics:
  - resource_economy:
      resources: [light, batteries, keys, map_fragments, signal]
      scarcity_model: timed_depletion
  - agent_competition:
      agent_types: [HermesScout, KeyHunter, Saboteur]
      rail_model: skills_md
  - human_influence:
      roles: [survivor, sponsor, spectator]
      mechanisms: [sponsor, sabotage, vote, spectate_logs]
  - hazard:
      entity: TheWatcher
      patrol_pattern: predictable_interruptible
  - extraction:
      cycle_based: true
      slots_per_cycle: 3

monetization:
  cosmetic_gamepasses: true
  dev_products: false
  sponsored_collaborations: post_launch_only
  token_gating: phase_3

constraints:
  build_phase: phase_1
  scope: brutally_minimal
  ship_target: token_launch_ceremony
---

# Notes

Free-form prose for the creator's framing, references, anti-patterns to avoid.
```

## Output

A normalized intent document validated against the intent schema. Passes to the graph rail.

## Invariants

- Every intent declares a `slice_id` unique within the project.
- Every mechanic referenced must have a corresponding mechanic template (or the graph compiler fails with "no such mechanic template").
- Constraints are honored downstream — `phase_1` scope can't reference `phase_3` token gating in shippable form.

## Open questions

- How specific should the intent format be? Too loose and it's wishy-washy; too tight and it's just the graph by another name.
- Does the intent rail support templates (e.g., "horror_survival" template pre-fills common mechanics)?
- How are intents versioned? Per-slice or globally?
- Does intent live in this repo, or in a separate creator-cockpit project?

---

## Operator carve required

Blake's constitution defines the intent schema. This README's draft schema is a placeholder. Replace with the canonical schema once aligned.
