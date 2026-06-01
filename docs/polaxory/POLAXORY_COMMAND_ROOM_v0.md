# Polaxory Command Room v0

## Product intent

Polaxory is the proof that a small Roblox studio with an AI operating layer can out-ship larger teams.

The command room is the first product surface for that proof. It is not a generic dashboard. It is the place where a Roblox project turns player signal, page signal, repo signal, and operator status into the next profitable action.

## Core thesis

Roblox is the inference engine. Polaxory is the studio loop. Hypurrclaw is the operating layer that turns signal into shipped updates.

## Route

`/projects/polaxory`

## The page must answer one question

What should we ship next, and why?

If a section does not help answer that, it is infrastructure leakage.

## Above-the-fold layout

### 1. Mission card

- Title: `Polaxory Command Room`
- Subtitle: `A Roblox studio loop that learns from players faster than normal teams can plan.`
- Goal: `Turn live game, repo, and market signals into shipped updates.`
- CTA: `Continue Shipping`

### 2. Next profitable ship

Initial recommendation:

- Ship: `Round completion reward loop`
- Why: `Players need a clearer reason to replay after a completed round.`
- Expected effect: `Higher replay intent and retention.`
- Risk: `Low`
- Action: `Generate patch task`

### 3. Signals

Initial signal lanes:

- Player signal: session completion, replay intent, drop-off moments
- Game page signal: visits, favorites, likes, thumbnail/title conversion
- Repo signal: latest commits, open build tasks, validator status
- Competitor signal: adjacent Roblox games and update cadence

### 4. Operators

Initial operators:

- `Commit Watcher`: watches repo changes and summarizes build movement
- `Safe Auto Commit`: turns approved product intent into repo artifacts
- `Signal Reader`: converts Roblox/project signals into prioritized ship suggestions
- `Patch Generator`: turns the selected next ship into implementation tasks

## Data contract

The command room reads from `projects/polaxory/command_room.json` first. Later, each field can be backed by live GitHub, Roblox, analytics, and Hypurrclaw automation state.

## First profitable loop

1. Show the strongest next ship.
2. Explain why it matters.
3. Let the operator create a task or patch.
4. Commit or queue the result.
5. Watch the game/repo signals after release.
6. Repeat.

## Non-goals

- Do not build a generic automation list.
- Do not lead with Rails internals.
- Do not make users inspect logs to understand momentum.
- Do not ask for twenty setup fields before showing the next action.

## Acceptance criteria

- A user can open `/projects/polaxory` and understand the mission in under ten seconds.
- The page shows a concrete next ship with a reason.
- The page names active operators.
- The page distinguishes player/end-user value from infrastructure value.
- The page has a `Continue Shipping` action, even if the first version is a task-generation stub.
