# Polaxory Infrastructure

## What the infrastructure builds

Polaxory infrastructure exists to turn a Roblox project into a persistent operating loop.

It is not a generic task app. It is not a cron dashboard. It is not a pile of automations.

It is the machinery that connects creative intent to player signal to shipped updates.

## Core loop

```txt
Roblox game signal
  -> project memory
  -> studio interpretation
  -> ranked next ship
  -> GitHub task / commit / patch
  -> Roblox update
  -> measured result
  -> next decision
```

## Product surfaces

### 1. Project

The project is the main object. For now, that project is Polaxory.

The project page should answer:

- What is this game?
- What is the current thesis?
- What is the next profitable ship?
- What evidence supports it?
- Which operators are active?

### 2. Signals

Signals are the inputs that tell the studio what is happening.

Initial signals:

- GitHub commits.
- Pending tasks.
- Roblox game URL/page status.
- Competitor pages.
- Player-facing updates.
- Monetization experiments.

Future signals:

- Retention.
- Session length.
- Funnel drop-off.
- Purchases.
- Favorites.
- Likes/dislikes.
- Social mentions.
- Server population patterns.

### 3. Art Studio

The Art Studio is the command room.

It turns raw signals into taste, direction, and concrete creative decisions.

It should show:

- Current creative thesis.
- Player problem.
- Next ship.
- Why now.
- Expected impact.
- Smallest safe action.
- Evidence.
- Open questions.

### 4. Operators

Operators are bounded automations attached to the project.

Current operators:

- Polaxory commit watcher.
- Polaxory safe auto-commit.

Operators should be visible only as part of the project context. They are not the hero.

Good operator framing:

> Watching commits to keep the project loop current.

Bad operator framing:

> Cron job running every 60 minutes.

### 5. Continue Shipping

Continue Shipping is the primary action.

It should produce one of three outputs:

1. A concrete task.
2. A safe patch.
3. A decision memo explaining why no patch should be made yet.

It should never produce vague strategy without an action.

## Build order

1. Create the Polaxory project object.
2. Add `/projects/polaxory`.
3. Add the Art Studio view.
4. Attach existing operators to the project.
5. Add fields for Roblox game URL and competitor URLs.
6. Add a signal model.
7. Add a ranked Next Ship card.
8. Add Continue Shipping.
9. Make Continue Shipping create a task, patch, or decision memo.
10. Measure whether shipped updates improve the player loop.

## Infrastructure principle

Rails are the engine. Roblox is the car.

Do not expose infrastructure as the product. Expose the decision the infrastructure enables.

Every screen should collapse complexity into:

```txt
What happened?
What does it mean?
What should we ship next?
Why should we believe that?
```

## Current strategic bet

The first profitable ship should improve the first-session reward loop.

Reason:

- First-session clarity affects retention.
- Retention creates more signal.
- More signal improves future creative decisions.
- Better creative decisions increase monetization readiness.

Recommended next action:

> Add a simple post-round reward moment and track whether it increases replay intent.
