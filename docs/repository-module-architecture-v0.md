# Repository & Module Architecture v0

## principle
A sector imports the platform SDK only. It never imports another sector's internals.

```text
packages/
  platform/
  ui-shell/
  data-contracts/
  telemetry/
  moderation/
  teleport/
  game-pod-sdk/
games/
  hub/
  flagship-sector/
  future-sector-template/
tools/
  internal-test/
  staging/
  creator-sandbox/
docs/
  decisions/
```

## ownership
- `packages/platform`: universal profile access, permissions, feature flags, service boundaries.
- `packages/ui-shell`: shared shell only; sector UI remains local.
- `packages/data-contracts`: versioned schemas and migration rules.
- `packages/telemetry`: common event envelope and outcome metrics.
- `packages/moderation`: reporting, rollback, deletion, ownership transfer, enforcement hooks.
- `packages/teleport`: place routing, party arrival, reconnect, and return-home contracts.
- `packages/game-pod-sdk`: the supported interface for all sector games.

## release rule
Each sector must build, test, deploy, pause, and be removable without rewriting the universe. Shared-service failure should degrade a sector gracefully rather than brick it.
