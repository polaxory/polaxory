# Polaxory Revenue Model + Agent Economy v0

## Positioning

Polaxory should not begin as a token launcher.

Polaxory begins as a Roblox-first playable studio and product lab. The first business is making playable loops that can earn. The second business is turning the internal production system into reusable rails for creators and agents. The token/protocol layer is optional later, only after there is real usage to coordinate.

## Core Thesis

Games keep Polaxory alive.
Rails make Polaxory valuable.
Agents become the customer once the rails actually work.

Polaxory's unfair angle is not lore, not a token, and not another generic AI wrapper. It is a repeatable path from messy idea to monetized playable output.

```
idea -> scoped playable loop -> Roblox task spec -> telemetry proof -> build log -> monetized game/update
```

## Why Roblox First

Roblox is the right first surface because:

- distribution already exists
- monetization already exists
- creators understand templates and remixing
- small loops can ship fast
- telemetry can prove retention before the company overbuilds
- AI agents can meaningfully help with specs, scripts, economy design, live updates, build logs, and QA checklists

The first product is not a platform. The first product is a playable proof.

## First Game: Signal Run v0

Signal Run v0 exists to prove one thing:

Can Polaxory ship a tight, repeatable, measurable Roblox loop?

Core loop:

```
round_started
player_runs_route
round_completed
reward_granted
reward_claimed
run_again_prompted
next_round_started
```

The player promise:

- short run
- clear goal
- immediate reward
- one-click restart
- visible improvement

The company proof:

- completion rate
- run-again rate
- average session length
- reward claim rate
- drop-off points

## Revenue Model

### Phase 1: Roblox Revenue

Polaxory survives first through games.

Possible revenue:

- game passes
- cosmetics
- consumables
- premium progression skips
- UGC accessory tie-ins
- limited event bundles
- private server perks
- season/event passes if retention justifies them

Rule: no monetization before the loop is fun enough to repeat.

### Phase 2: Build Log + Audience Revenue

As the game ships, Polaxory documents the build.

Revenue opportunities:

- sponsorships
- paid behind-the-scenes breakdowns
- templates
- Gumroad/Ko-fi-style packs
- Roblox creator resources
- collabs with creators or agents

This is not content for vanity. It is distribution, trust, and recruiting.

### Phase 3: Production Rails

Once Polaxory has shipped repeatable loops, the internal process becomes a product.

Possible rails:

- playable-loop spec generator
- Roblox task generator
- telemetry schema generator
- economy tuning assistant
- reward table builder
- live-update planner
- build-log publisher
- QA checklist runner
- retention diagnosis agent

Customers:

- solo Roblox creators
- small game studios
- AI agents building playable content
- brands wanting lightweight Roblox activations
- communities wanting games/events

Revenue:

- SaaS workspace fee
- per-project fee
- template marketplace
- revenue share on games built with Polaxory rails
- paid audits of Roblox loops/economies
- premium agent workflows

### Phase 4: Token or Protocol Optionality

A token only makes sense if it coordinates existing behavior.

Potential later uses:

- creator rewards
- template marketplace incentives
- agent task bounties
- revshare coordination
- governance over shared rails/templates
- access to advanced tooling

Bad reason to launch token:

- to make the project feel real before product exists
- to replace revenue
- to outsource distribution
- to attract mercenary attention before retention exists

## Clanker Review

Clanker is useful if the goal is fast token deployment and social distribution on Base/Farcaster.

Clanker is not the right foundation for Polaxory yet.

Use Clanker later if:

- Polaxory has shipped a playable loop
- there is an audience watching the build
- the token has a specific coordination job
- we want a low-friction social-token experiment

Do not use Clanker now if:

- it distracts from Signal Run v0
- it forces premature token narrative
- it makes the project look like another launch instead of a studio/product lab

Recommended decision:

Build Polaxory top-stack like Hypurrclaw: product-first, identity-first, rails-first. Add token mechanics only after real usage appears.

## Agent Economy Thesis

Most agents today are talkers, posters, traders, or mascots.

The next useful agent category is production agents: agents that help build, ship, measure, and update real products.

Polaxory should build for this agent economy by giving agents rails for action.

Agents would want Polaxory rails because they can turn vague intent into concrete outputs:

- scoped game concepts
- task files
- Luau module plans
- telemetry events
- monetization tests
- build logs
- QA checklists
- update roadmaps
- creator-facing summaries

The thesis:

Agents will compete on output quality. Output quality requires structured rails. Polaxory can become the Roblox/playable-loop rail for agents.

## What To Build Now

### Immediate Deliverable

Build Signal Run v0 as the smallest playable telemetry proof.

### Required Files

```
projects/polaxory/tasks/signal_run_v0_build_spec.md
projects/polaxory/tasks/signal_run_v0_telemetry_schema.md
projects/polaxory/tasks/signal_run_v0_monetization_notes.md
projects/polaxory/tasks/signal_run_v0_build_log_001.md
projects/polaxory/roblox/src/server/RoundService.server.luau
projects/polaxory/roblox/src/server/TelemetrySink.server.luau
projects/polaxory/roblox/src/server/RewardService.server.luau
projects/polaxory/roblox/src/server/SignalRunTestHarness.server.luau
projects/polaxory/roblox/src/client/RewardPanel.client.luau
projects/polaxory/roblox/src/client/RunAgainPrompt.client.luau
```

### Build Order

1. Define one playable round.
2. Define start and finish triggers.
3. Emit telemetry events.
4. Grant simple reward.
5. Show reward panel.
6. Show Run Again prompt.
7. Restart the round.
8. Publish first build log.
9. Only then discuss polish.

## First Public Voice

Polaxory is not launching with a giant promise.
Polaxory is launching with a loop.

If the loop is fun, we expand.
If the loop is weak, we fix it.
If the data says players do not run again, we learn why.

Playable first.
Measurable second.
Worldbuilding third.

The rails are being laid.
