# Place Topology v0

## universe places
- **Hub:** social home / central district.
- **Sector places:** one place per independently playable game pod.
- **Internal test:** private integration and contract testing.
- **Staging:** release-candidate validation.
- **Creator sandbox:** constrained creator-runtime testing, isolated from platform core.

## teleport contract
Every transition carries a versioned payload containing:
- source place and destination place
- party id and party member roster
- arrival intent / entry point
- return target and reconnect fallback
- contract version

Do not pass game-local progression, currencies, power items, or balance state through the shared teleport payload.

## flows
1. hub → sector: party arrives together at a sector-defined entry point.
2. sector → hub: return to the party-safe hub point.
3. disconnect: reconnect resolves to the last safe place; if unavailable, return home.
4. staging/internal-test: never become public discovery targets.

## first graybox
Spawn, profile touchpoint, party UI, one portal, and one return point. No terrain, lore, or campus work until this loop works.
