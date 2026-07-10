# Game Pod Contract v0

## purpose
The contract a sector must implement to launch, receive a party, report outcomes, and return players home.

## required capabilities
1. **Launch** — declare readiness, supported party size, version, and entry intents.
2. **Arrival** — accept the versioned teleport payload and place a party at a safe entry point.
3. **Session** — own all local gameplay loops, economy, progression, and save state.
4. **Telemetry** — emit common session events plus sector-specific outcomes.
5. **Return** — provide a safe return intent and tolerate failed home/sector service dependencies.
6. **Operations** — support health checks, pause mode, release versioning, and removal.

## common telemetry
- session_started
- party_arrived
- core_loop_completed
- session_ended
- return_requested
- return_completed

## quality bar
A pod is independently playable. It cannot require another sector's code, economy, or availability to be fun. Cross-sector events must give each participating sector a native reason to participate.
