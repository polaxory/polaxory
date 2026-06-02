# Roadmap

The rule: a surface earns a folder only when it has working metal. Until then it lives here, named honestly, so the ambition is visible without faking the receipts.

## Shipped (has receipts)

- **Signal Run loop** — server-authoritative round → gate → reward → claim → replay. See `experiments/signal-run/`.
- **Rails constitution + remote contracts** — `docs/polaxory/POLAXORY_RAILS_CONSTITUTION_v0.md`, `src/shared/RemoteContracts.luau`.
- **Validator patterns (partial)** — `src/server/Validators.luau` checks task/resource integrity. The full validator suite in `POLAXORY_VALIDATOR_CONTRACTS_v0.md` is mostly spec, not yet implemented.
- **Read-only Studio inspection** — live DataModel/script inspection via MCP.

## Future surfaces (NOT shipped — pressure points, not modules)

These are where the architecture is moving next. They are named, not built. None has a folder until it has metal.

- **UGC generation pipeline** — agents producing content surfaces under contract.
- **World memory** — persistence of world state, rules, and intent across iterations.
- **Agent repair loop** — validator failures become structured feedback an agent acts on, not vibes.
- **Playtest surface** — drive a real playtest, observe, feed results back.
- **Validator suite (full)** — the 12 validators in `POLAXORY_VALIDATOR_CONTRACTS_v0.md` as an invocable, structured-verdict report (currently 0 of 12 implemented to spec).
- **Roblox runtime hardening** — runtime rate-limit enforcement, exploit telemetry, anomaly detection.

## Gating risk

Double platform-risk, same actor (Roblox), window measured in months not years — see `docs/competitive-landscape.md`:

1. **Policy:** ~~Verify the platform permits agent-built deployment.~~ **Checked 2026-06-02 (`research/2026-06-02_policy_romini_recon.md`): permitted.** Roblox sanctions AI/agent codegen and ships its own; the only genAI restriction is on runtime AI-chatbot experiences, which doesn't apply to build-time agents. Policy risk downgraded. (Caveat: full AI-Based Tools Supplemental Terms not yet line-read.)
2. **Competitive:** Roblox first-party shipped agentic Studio (Plan/Build/Test) in April 2026 with zero server-authority/anti-exploit/telemetry today. It could add those axes any release and collapse the wedge. This is now the *primary* platform risk.

Urgency favors proving demand + public positioning fast, while the four-axis intersection is still unowned.
