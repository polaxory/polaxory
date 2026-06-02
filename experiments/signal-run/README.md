# Experiment: Signal Run

**Signal Run is the receipt, not the product.**

It is the first fossil of the architecture forming: a server-authoritative playable loop proving that agents can build a Roblox experience without handing authority to the client.

## What it proves

The loop runs: `round_started → gate_passed → round_completed → reward_granted → reward_shown → reward_claimed → next_round_started`. Every transition is one server-owned state change with a player-visible feedback point. The client renders state and sends intent (`ClaimRewardRequested`, `RunAgainRequested`); the server owns truth and rejects anything it didn't author.

## What it does NOT prove

That a Roblox developer wants the system underneath it. That is the open question the devlog tracks.

## Where the code lives

- Server: `src/server/RoundCompletionRewards.luau`, `src/server/SignalRunCourse.server.luau`, `src/server/RoundTelemetryLoop.server.luau`
- Client: `src/client/RoundCompletionRewardPanel.client.luau`
- Contracts: `src/shared/RemoteContracts.luau`, `src/shared/RewardLoopConfig.luau`

See `receipts.md` for the concrete proof artifacts.
