# Player & Data Contract v0

## universal profile
Platform-owned, portable state:
- identity
- cosmetic ownership and loadout
- social and party state
- settings
- safety and moderation state

## game-local state
Sector-owned, non-portable state:
- progression
- currencies
- gameplay-power items
- quests
- rankings
- balance state
- local saves

## rules
- the platform datastore is a registry, not a junk drawer.
- no global currency.
- sector code may read the supported universal profile surface but may not mutate unrelated platform domains.
- game-local schemas are versioned and migrated by the owning sector.
- platform and creator data require reporting, rollback, deletion, and ownership-transfer paths where applicable.

## minimum interface
A player session exposes a stable player id, universal-profile revision, party context, safety state, and settings snapshot. A sector attaches local state behind its own namespace.
