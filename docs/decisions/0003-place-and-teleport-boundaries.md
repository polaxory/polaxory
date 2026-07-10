# ADR 0003: Place & Teleport Boundaries

## status
Accepted

## decision
The Roblox universe uses distinct hub, sector, internal-test, staging, and creator-sandbox places. Movement between them uses a versioned teleport payload with party, arrival, return, and reconnect context.

## consequences
- sectors are deployable and recoverable independently.
- party handoff is a first-class platform path.
- internal and staging places remain isolated from public discovery.
- reconnect falls back safely to home when the prior destination is unavailable.
