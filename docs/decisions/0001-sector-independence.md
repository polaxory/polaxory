# ADR 0001: Sector Independence

## status
Accepted

## decision
Each sector game is an independently playable pod that imports platform SDK contracts only, never another sector's internals.

## consequences
- sector failures are isolated where possible.
- games may differ in genre, pacing, economy, and IP.
- shared social/status can travel, but balance and progression do not.
- cross-sector features use versioned contracts rather than direct coupling.
