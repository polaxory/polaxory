# Polaxory Action Tasks

## Product orientation

Polaxory is the product proof. Roblox is the inference engine. Hypurrclaw should turn Roblox signals into creative direction and concrete shipping action.

Core loop:

```txt
Roblox signals -> creative inference -> real task -> shipped change -> measured result
```

## Immediate build order

1. Create `/projects/polaxory`
2. Create `/projects/polaxory/studio`
3. Add `projectSignals` model
4. Attach active Polaxory automations to the project
5. Add `Continue Shipping` button
6. Add Roblox page monitor
7. Add competitor watchlist
8. Create monetization experiment backlog

## Task 1: Create `/projects/polaxory`

Goal: make Polaxory the primary project object, not an automation buried in Rails.

Acceptance criteria:

- Route exists at `/projects/polaxory`
- Shows project name, status, repo, Roblox page, active operators, latest signals, next tasks
- Existing Polaxory automations appear as project operators
- Empty states ask for missing repo/game URLs

## Task 2: Create `/projects/polaxory/studio`

Goal: create the Art Studio surface.

Panels:

- Vibe
- First 10 Seconds
- Storefront
- Monetization
- Next Profitable Ship

Acceptance criteria:

- Route exists at `/projects/polaxory/studio`
- Each panel displays current hypothesis, evidence, next action
- `Next Profitable Ship` returns one recommended action, not a vague list

## Task 3: Add `projectSignals` model

Goal: make Roblox/repo/page/player signals first-class.

Fields:

- projectId
- source: `roblox_page | github | automation | manual | competitor`
- title
- summary
- evidence
- severity: `low | medium | high`
- suggestedAction
- status: `new | accepted | ignored | shipped`
- createdAt

Acceptance criteria:

- Signals can be created manually
- Signals can be attached to Polaxory
- Signals can produce tasks

## Task 4: Attach existing automations

Known active automations:

- Polaxory safe auto-commit
- Polaxory commit watcher

Acceptance criteria:

- Automations show under `/projects/polaxory`
- Active/silent states are explained correctly
- They are framed as operators, not generic cron jobs

## Task 5: Add `Continue Shipping` button

Goal: one button that chooses the next concrete action.

Behavior:

- Reads latest signals
- Reads current tasks
- Selects one low-risk, high-leverage action
- Produces patch/task/checklist

Acceptance criteria:

- Button exists on project and studio pages
- Output is one concrete next move
- No generic brainstorming

## Task 6: Add Roblox page monitor

Goal: track the public Roblox game page and convert visible changes into project signals.

Needs from user:

- Roblox game URL

Acceptance criteria:

- Monitor can baseline the page
- Future changes create project signals
- First run is silent unless explicitly requested

## Task 7: Competitor watchlist

Goal: use competitors as inference material.

Needs from user:

- 3 competitor Roblox game URLs

Acceptance criteria:

- Competitors are stored per project
- Changes can become signals
- Studio summarizes what competitors imply for Polaxory

## Task 8: Monetization experiment backlog

Initial candidates:

- Reward keys
- Cosmetic chest
- VIP lobby effect
- Limited-time event badge

Acceptance criteria:

- Each experiment has hypothesis, implementation cost, risk, expected metric impact
- `Continue Shipping` can pick one when evidence supports it

## Sharp product sentence

Hypurrclaw is your Roblox shipping agent. The Art Studio turns game signals into taste, direction, and profitable creative decisions.
