# POLAXORY Validator Contracts v0

Date: 2026-06-01
Status: Canonical working draft

## Purpose

Validators are the enforcement layer for Polaxory rails. A build is done when the graph, contracts, project files, tests, and engine scenario satisfy the validator suite.

## Philosophy

**Fail early. Fail loudly in CI. Fail safely in-game.**

## Verdict shape

```json
{
  "validatorId": "Validator.GraphIntegrity",
  "status": "pass | fail | warn | skipped",
  "severity": "blocking | warning | info",
  "scope": "graph | contract | source | engine | scenario",
  "checkedAt": "2026-06-01T00:00:00Z",
  "messages": []
}
```

## Required validators for Rails v0

- `GraphIntegrity`
- `RuntimeAuthority`
- `RemoteContractCoverage`
- `ResourceIntegrity`
- `EventFlowIntegrity`
- `SkillManifestIntegrity`
- `DoorLockPath`
- `EntityNavigationSafety`
- `ModuleBoundary`
- `ToolchainStaticChecks`
- `EngineBoot`
- `ScenarioBackroomsSlice0`

## First implementation order

1. Implement `GraphIntegrity` as a pure JSON validator.
2. Implement `RemoteContractCoverage` against contract files.
3. Implement `ResourceIntegrity` and `EventFlowIntegrity`.
4. Implement `ModuleBoundary` against the Rojo tree.
5. Add StyLua/Selene checks.
6. Add TestEZ tests for resource and skill resolution.
7. Add Open Cloud `EngineBoot`.
8. Add `ScenarioBackroomsSlice0`.

## Cut line

Rails v0 only needs enough enforcement to prove coherent graph, secure remotes, server authority, resource/event sanity, engine boot, and Backrooms slice scenario pass.
