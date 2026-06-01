# Polaxory Launch OODA — 2026-06-01

Status: working launch map

## Prime vision
Polaxory is a Roblox game studio shaped like an operating system: creator intent enters, a playable and validated Roblox slice comes out. The public surface is the game/art studio. The hidden machinery is rails, graph, contracts, validators, CI, and quiet agent loops.

One-line product: **Give Polaxory one game idea. It returns a secure, editable Roblox production build.**

First proof: a Backrooms-inspired Roblox vertical slice that proves the rails engine by shipping one playable loop: enter run, navigate a sector, restore/collect a resource, survive pressure, unlock/extract, receive validated off-chain points, replay safely.

## OODA

### Observe
Built or present in repo/context:
- Active thesis and load order in `README.md` and `docs/polaxory/00_ACTIVE_CONTEXT.md`.
- Canonical rails spec: `docs/polaxory/POLAXORY_RAILS_SPEC_v0.md`.
- Security boundary and private-state exclusion.
- GitHub Actions CI placeholder at `.github/workflows/ci.yml`.
- Research assignment loop brief: `docs/RESEARCH_ASSIGNMENT_LOOP.md`.
- Active automations for artifact building, playability validation, commit watching, safe auto-commit, Phoenix/Rise token-infra research, and automation self-evaluation.
- The current required stack is named: Rojo, Selene, StyLua, Wally, luau-lsp, TestEZ, Open Cloud Luau Execution, GitHub Actions.

Missing or not yet proven:
- `docs/polaxory/POLAXORY_BACKROOMS_SLICE_0_GDD.md` is still not present.
- `docs/polaxory/POLAXORY_BACKROOMS_SLICE_0_GRAPH.json` is still not present.
- The `polaxory-rails/` production skeleton is not yet the dominant repo reality.
- No Studio-openable playable Slice-0 is proven.
- No end-to-end validation report proves reward/replay/server-authority behavior.

### Orient
This is not ready to market as a playable product yet. It is ready to market internally as a serious studio operating spine. The repo has moved from pitch fog into a rails constitution plus automation system, but the launch bottleneck is now concrete implementation artifacts.

The correct metaphor is art studio discipline, not SaaS sprawl:
- Work to code: build from named contracts and graph rules.
- Sacred space: keep the repo/load order clean.
- Be on time: tight cadences, no loose research spirals.
- Thoroughness counts: validators must block false claims.
- Keep a list: every loop ends with one next question.
- Reset: after every artifact, return to the playable slice checklist.
- Take responsibility: no claiming playable until Studio and validation evidence exist.
- Persistence: one small artifact, one commit, repeat.

### Decide
Launch should be staged.

**Launch Stage 0 — Studio operating system:** nearly ready.
Evidence required: this OODA doc, automation self-eval, clear active context, no public hype around tooling.

**Launch Stage 1 — Slice-0 design lock:** next target.
Evidence required: GDD + graph fixture + validator checklist all committed.

**Launch Stage 2 — Playable technical proof:** not ready.
Evidence required: Rojo skeleton + minimal Luau modules + TestEZ/static checks + engine/open-cloud validation notes.

**Launch Stage 3 — Public playable/art-studio launch:** not ready.
Evidence required: Studio-openable build candidate, screen/video proof, validated run loop, replay safety, off-chain point validation.

### Act
Immediate build sequence:
1. Create `POLAXORY_BACKROOMS_SLICE_0_GDD.md`.
2. Create `POLAXORY_BACKROOMS_SLICE_0_GRAPH.json`.
3. Create `polaxory-rails/README.md` and skeleton map.
4. Create validator implementation plan tied to the graph.
5. Tighten `.github/workflows/ci.yml` around lint/test/validation gates.
6. Reduce or narrow any automation that commits without launch relevance.

## Tight launch checklist

### Product truth
- [ ] Player can enter a Backrooms-style run.
- [ ] Player can navigate one sector/path.
- [ ] Player can interact with at least one resource/objective.
- [ ] Player can reach success or fail state.
- [ ] Player can replay without stale state.
- [ ] Reward/points are server-authoritative and off-chain.

### Rails truth
- [ ] Slice has a GDD/spec.
- [ ] Slice has a deterministic graph fixture.
- [ ] Every module has an owner and boundary.
- [ ] Every Remote has schema, rate limit, permission rule, and server validation.
- [ ] Every resource/event/skill is declared before implementation.
- [ ] Validator failures block promotion.

### Repo truth
- [ ] `polaxory-rails/` skeleton exists.
- [ ] Rojo project file exists.
- [ ] TestEZ path exists.
- [ ] Selene/StyLua config exists.
- [ ] CI runs lint/format/test/validator placeholders.
- [ ] README points to real files only.

### Studio discipline
- [ ] Tooling is acknowledged but not made the show.
- [ ] Automations are lane-bound.
- [ ] Every automation can answer: what did I ship, validate, or suppress?
- [ ] No broad auto-commits.
- [ ] No token-first messaging.
- [ ] No false playable claims.

## Launch proximity
Current estimate: **35–45% to a credible internal Slice-0 launch**, **15–25% to a public playable launch**.

Reason: the vision, rails, constraints, and automation spine exist. The playable proof does not. The next 3 commits should not expand the concept; they should convert the concept into the GDD, graph, and repo skeleton that force implementation.

## Next smallest commit
Create `docs/polaxory/POLAXORY_BACKROOMS_SLICE_0_GDD.md` with only the playable loop, required entities/resources/events/remotes, fail/success states, and validation acceptance criteria.
