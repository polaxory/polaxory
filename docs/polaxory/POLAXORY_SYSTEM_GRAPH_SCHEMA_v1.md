# POLAXORY System Graph Schema v1

Date: 2026-06-01
Status: Canonical draft

## Purpose

The Polaxory System Graph is the middle layer between creative intent and Roblox implementation. It answers what exists, who owns it, dependencies, events, resources, and validators. A generated Roblox project is invalid if it cannot be explained by the graph.

## Graph envelope

```json
{
  "schemaVersion": "px.graph.v1",
  "projectId": "polaxory-backrooms-slice-0",
  "title": "Polaxory Backrooms Slice 0",
  "railsVersion": "px.rails.v0",
  "createdAt": "2026-06-01T00:00:00Z",
  "nodes": [],
  "edges": [],
  "contracts": {
    "modules": [],
    "remotes": [],
    "resources": [],
    "events": [],
    "skills": [],
    "validators": []
  },
  "scenarios": [],
  "metadata": {}
}
```

## Node schema

Required fields: `id`, `type`, `label`, `ownerModule`, `runtimeOwner`.

Allowed runtime owners:

- `Server`
- `ClientPresentation`
- `SharedConfig`
- `ToolingOnly`

Rule: any node that mutates gameplay state must be `Server` owned.

## Edge schema

Required fields: `id`, `from`, `to`, `type`, `required`.

Edge types include dependency, events, resources, gameplay, constraints, and presentation. Presentation edges may not create authoritative gameplay state.

## Slice 0 graph draft

Canonical nodes include:

- `Room.Control`
- `Room.HallwayA`
- `Room.SafeRoomA`
- `Exit.ExtractionDoor`
- `Facility.GeneratorA`
- `Door.Door17`
- `Entity.Hunter01`
- `NavRegion.HunterA`
- `Resource.Battery`
- `Resource.Signal`
- `Skill.Scout.ScanZone`
- `Skill.Builder.RepairGenerator`
- `Skill.Saboteur.OverloadDoor`
- `Event.GeneratorFailed`
- `Event.DoorLocked`
- `Validator.GraphIntegrity`
- `Validator.RemoteSecurity`
- `Validator.ResourceIntegrity`
- `Validator.EngineBoot`

Canonical scenario: Generator failure -> Door17 locks -> Hunter activates -> Scout scans -> Builder repairs -> Door17 unlocks -> player extracts.

## Build-blocking validation rules

- Every node id is unique.
- Every edge references existing `from` and `to` nodes.
- Every gameplay-state node is server-owned.
- Every event has producer and consumer unless terminal.
- Every resource has source and sink or explicit exemption.
- Every locked door has unlock path.
- Every hostile entity has nav region and safe-room constraint.
- Every skill has cost, cooldown, eligibility, target rules, and server resolver.
- Every Remote has schema, rate limit, permission rule, and server validation.
- No client-owned node may grant, spend, unlock, damage, reward, or mutate authoritative state.

## Cut line

Keep Slice 0 small enough to inspect by hand. The first graph should prove coherence, not infinite content.
