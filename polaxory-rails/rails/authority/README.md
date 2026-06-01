# rail: authority

> Server-as-source-of-truth enforcement. Where the prime law lives as code patterns.
> Status: v0 sketch.

---

## What this rail does

Enforces the prime law mechanically. Contains the patterns, helpers, and guardrails that make server-authority the default and client-trust impossible to accidentally introduce.

The authority rail doesn't enforce "be careful, write good code." It enforces "the wrong thing literally won't compile / will be rejected by the validator."

## What lives here

```
rails/authority/
├── README.md                       ← this file
├── server/
│   ├── remote_wrappers.luau        ← typed RemoteEvent/RemoteFunction wrappers with input validation
│   ├── action_protocol.luau        ← signed action submissions from client
│   ├── persistence_marker.luau     ← marks state as server-owned vs derived
│   └── audit_log.luau              ← every server-side state change logged
└── patterns/
    ├── no_client_trust.md          ← the pattern. why. how it shows up wrong.
    ├── signed_actions.md           ← the action protocol
    └── server_owned_state.md       ← state ownership patterns
```

## Core patterns

### Remote wrappers with input validation

Vanilla Roblox `RemoteEvent` and `RemoteFunction` are trust holes. The authority rail provides typed wrappers that:

- Validate input shape (rejects malformed payloads)
- Rate-limit per player (rejects spam)
- Authenticate via signed action protocol (rejects spoofed origin)
- Log every call with full context
- Return audit-trail-shaped responses

Usage:

```luau
local AuthorityRemotes = require(game.ReplicatedStorage.Shared.AuthorityRemotes)

local RestartGeneratorRemote = AuthorityRemotes.declare("RestartGenerator", {
  params = { reason = "string", max_length = 200 },
  rate_limit = { per_player = "1 per 10 seconds" },
  returns = "boolean",
})

-- client-side
RestartGeneratorRemote:invoke({ reason = "Manual restart by player" })

-- server-side
RestartGeneratorRemote:onInvoke(function(player, params)
  -- params is already validated. player is the actual player object.
  -- audit log entry already written.
  -- proceed with the action.
end)
```

### Signed actions

Some actions need stronger authentication than "this came from a client we trust." The signed action protocol issues short-lived signatures from the server, the client includes the signature in its action submission, the server verifies before processing.

Used for: high-value actions (inventory transfers, economy operations, agent sponsorships).

### Server-owned state marker

State has provenance. Some state is server-owned (the Inventory's gold count). Some state is server-derived (the Inventory's display total). Some state is client-input (the player's last clicked button). The authority rail's pattern requires every state field to be marked:

```luau
local InventoryState = AuthorityState.declare({
  gold = AuthorityState.serverOwned("number", { default = 0, persistent = true }),
  displayTotal = AuthorityState.serverDerived("number", function(state) return state.gold * 100 end),
  lastInteraction = AuthorityState.clientInput("number", { default = 0, persistent = false }),
})
```

The validator rejects writes from any code path that doesn't have authority over the field.

### Audit log

Every server-side state change writes an audit log entry: who, when, what changed, before/after, source action. Audit logs persist for at least 7 days and feed into the validation system's runtime reports.

## Validation rules the authority rail enforces

- No `RemoteEvent:FireServer` from client code — must use the wrapped `AuthorityRemotes`
- No direct write to a `serverOwned` state field from non-authority code paths
- No persistence of `clientInput` state across sessions
- No state writes without an audit log entry

## Open questions

- How does the authority rail interact with skills.md actions? Agent actions go through the same wrappers as player actions?
- Cross-server state authority: how do we handle state that lives in multiple servers (e.g., cross-server inventory)?
- Audit log retention: 7 days is the floor. What's the right ceiling? GDPR / age-related data rules to consider.

---

## Operator carve required

The specific authority patterns, the action protocol details, and the audit log shape come from Blake's constitution. This README is a placeholder. Replace with canonical once aligned.
