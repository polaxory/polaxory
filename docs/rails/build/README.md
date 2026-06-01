# rail: build

> Rojo-driven pipeline. Graph + contracts + services → Studio-ready slice.
> Status: v0 sketch. Tooling config files exist at repo root; pipeline not yet wired.

---

## What this rail does

Takes a validated graph + contracts + services and produces a Studio-ready Roblox slice. Deterministic: same input → same output.

Three modes:

- **Local** — `rojo serve` for live-sync development with Studio open
- **CI / headless** — produces `.rbxlx` files for Open Cloud Luau execution validation, no Studio required
- **Deploy** — builds the final `.rbxlx`, runs through Nullsec Scan, uploads via Open Cloud API

## Pipeline stages

```
1. validate           — run all build-blocking rules from rails/validation/
                        (build aborts if any error severity finding)
2. resolve packages   — Wally installs declared dependencies into Packages/
3. lint               — Selene + StyLua run over src/
                        (build aborts if either fails)
4. type check         — Luau strict mode type checks (per .luaurc)
                        (build aborts on type errors)
5. compile            — Rojo combines src/ + Packages/ per default.project.json
                        produces .rbxlx in build/
6. headless validate  — Open Cloud Luau execution runs runtime validators
                        against the produced .rbxlx (CI mode only)
                        (build aborts on validator failures)
7. security scan      — Nullsec Scan over all server-side Luau (deploy mode only)
                        (deploy aborts on critical findings)
8. upload             — Open Cloud upload to the configured Universe + Place
                        (deploy mode only)
```

## Configuration files (at repo root)

- `default.project.json` — Rojo: source root mapping, service tree
- `wally.toml` — Wally: package dependencies
- `selene.toml` — Selene: static analysis rules
- `stylua.toml` — StyLua: formatter config
- `.luaurc` — Luau strictness + aliases

These are wired at repo root because they're standard locations the surrounding tooling expects.

## Build commands (target — not yet implemented)

```bash
# Install dependencies
wally install

# Local dev: live-sync with Studio
rojo serve default.project.json

# Headless CI build (produces .rbxlx, runs validators)
bun tools/build.ts --mode ci --slice slice-0-backrooms

# Deploy build (validators + scan + upload)
bun tools/build.ts --mode deploy --slice slice-0-backrooms
```

## Open Cloud Luau execution integration

For headless validation per the prime-law-via-validators discipline, the build rail uses Roblox's Open Cloud Luau execution API. The API runs Luau against a published place without a live Studio session — perfect for CI.

Pipeline:

1. Build rail produces `.rbxlx`
2. Tools script uploads to a sandbox Universe via Open Cloud
3. Tools script invokes Open Cloud Luau execution with a validation harness
4. Harness runs runtime validators per `rails/validation/`
5. Results return as a validator report
6. Build rail consumes the report; passes or fails accordingly

Reference: `roblox-ops/src/validate-open-cloud.ts` already validates the upload primitive (Task #9). This rail builds the headless validation harness on top.

## Open questions

- Wally vs npm-via-package-json: do we keep Wally for runtime Roblox packages and use bun/npm for tooling scripts?
- Build caching strategy — what's the cache key? Graph hash? Source hash? Both?
- Reproducibility across machines — Rojo + Wally version pinning suffices?
- Studio plugin pathway later — does the plugin call into this pipeline, or have its own?

---

## Operator carve required

The exact pipeline stages, the build mode definitions, and the integration with Open Cloud Luau execution come from Blake's constitution. This README is a placeholder. The configs at repo root are scaffold-ready and can be tuned once the canonical conventions are pulled in.
