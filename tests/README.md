# Polaxory Test Notes

Current Signal Run validation target:

- round completion grants the deterministic reward contract
- reward payload stays isolated from raw player IDs
- reward claim advances toward the next playable round
- telemetry records aggregate round events before player-level analytics

Factory Slice 0 validation backlog:

- task contracts reject malformed tasks
- worker roles only claim allowed task types
- supervisor suggestions produce valid queued tasks
- snapshot validator catches impossible station capacity

Wire these to TestEZ once the package tree lands.
