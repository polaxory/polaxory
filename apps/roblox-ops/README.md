# Polaxory RobloxOps — v0.1

The Roblox-making surface of Polaxory's stack. Per ROBLOXOPS.md: wave-making (original IP that other creators want to derive from), not wave-catching (clone trending games).

v0.1 ships only the Open Cloud API validation harness. Full surface — concept generation, fleet management, deployment pipeline, retention monitoring — comes after operator approval of `wave-attempts/001-agents-concept-brief.md`.

## What this validates (Task #9)

The fundamental technical question: can we deploy a Roblox `.rbxlx` file programmatically to a pre-created placeholder universe via the Open Cloud API? If yes, the entire RobloxOps production pipeline is unblocked. If no, the design changes.

The validation flow:

1. Create a placeholder universe and a place inside it manually on [create.roblox.com](https://create.roblox.com)
2. Generate an API key with `universe-places:write` permission scoped to that universe
3. Run `npm run validate` — uploads a minimal `.rbxlx` file to the place
4. Verify success: the place version number increments, the file is now live in `Saved` state (or `Published` if configured)

If all four steps work, the Open Cloud upload primitive is real and we can build production around it.

## Setup

```bash
cd apps/roblox-ops
cp .env.example .env
# fill in ROBLOX_API_KEY, ROBLOX_UNIVERSE_ID, ROBLOX_PLACE_ID
npm install
```

Keep `.env` local-only. It contains the Roblox Open Cloud key and is intentionally ignored by `apps/roblox-ops/.gitignore`; commit only `.env.example` changes.

## Test fixture (.rbxlx)

A minimal placeholder is included at `fixtures/minimal.rbxlx` — a workspace with one baseplate. Adequate for validation; the upload doesn't actually need playable game logic to verify the API path.

If you'd rather use a properly Studio-exported fixture:

1. Open Roblox Studio
2. File → New (or open any project)
3. File → Save As → save as `.rbxlx` (XML format, NOT `.rbxl` binary)
4. Set `ROBLOX_TEST_RBXLX=/absolute/path/to/your/file.rbxlx` in `.env`

## Usage

### Dry run (recommended first)

Validates config without making API calls:

```bash
npm run validate:dry
```

Prints what it WOULD upload, where, and with which headers. Useful for catching env-var typos before risking an API call.

### Live validation

```bash
npm run validate
```

Uploads the configured `.rbxlx` to the configured place. Defaults to `versionType=Saved` so the file is uploaded but not pushed live to players. Change to `Published` in `.env` only when you actually want to ship.

Success: HTTP 200, JSON response with `versionNumber`, log line `✅ END-TO-END VERIFIED`.

Failure: error printed to stderr with status code and response body. Common failures:

- `401` — API key missing, expired, or not scoped to this universe
- `403` — API key valid but missing `universe-places:write` permission
- `404` — universe or place ID wrong
- `400` — `.rbxlx` file malformed or wrong content type

## What this does NOT do (yet)

- Generate `.rbxlx` files via BloxBot / RbxLuauLLM
- Browser-automate the placeholder universe creation step (manual for now)
- Monitor retention metrics post-deploy
- Run the wave-making methodology end-to-end
- Manage a fleet of multiple games

All of that lives in the post-launch RobloxOps service, which builds on top of this primitive once the primitive is verified.

## What gets unblocked when this passes

- Task #9 closes
- Task #13's Roblox surface gets a real foundation
- `wave-attempts/001-agents-concept-brief.md` becomes shippable (pending operator approval, Task #20)
- The full RobloxOps service can be specced concretely
