# Polaxory PhoenixTrade Setup Research

Purpose: understand how Hypurrclaw/PhoenixTrade-style infrastructure can inform Polaxory without turning the project page into an infra billboard.

## Source anchors

- Phoenix Perpetuals announcement: https://www.ellipsislabs.xyz/blog-posts/introducing-phoenix-perpetuals
- Phoenix Rise SDK docs: https://docs.phoenix.trade/sdk/rise
- Rise SDK public repo: https://github.com/Ellipsis-Labs/rise-public

## What PhoenixTrade is

Phoenix Perpetuals is an on-chain perpetuals exchange on Solana from Ellipsis Labs. The public positioning is speed, liquidity, precise execution, gasless trading for retail users, and professional market infrastructure.

The useful Polaxory lesson is not trading. It is the product posture: serious infrastructure can sit underneath a clean user experience without demanding attention from the player.

## Setup facts

- Phoenix is in a structured/private rollout. Access is via waitlist or allowlist/access code.
- Rise is the developer SDK surface. It ships TypeScript and Rust packages.
- Public/read flows use `PhoenixHttpClient` / `client.api`.
- Exchange metadata, PDA derivation, order packets, and instruction builders use `createPhoenixClient(...)`.
- Live state uses `client.streams` or `createPhoenixWsClient(...)`.
- Onboarding routes are not interchangeable:
  - access/allowlist code: `POST /v1/invite/activate` with `code`
  - referral flow: referral activation route with `referral_code` and authenticated authority
- Full wallet/private-key handling must stay out of repo docs and out of chat.

## Hypurrclaw integration stance

Hypurrclaw already treats PhoenixTrade as a controlled trading surface: read tools first, preview before writes, explicit confirmation before execution, and server-side signing only through approved trading tools.

For Polaxory, copy the discipline, not the exchange mechanics:

- research before shipping
- guardrails before automation
- quiet tooling instead of attention-seeking machinery
- one artifact per loop
- commit only when something concrete changed

## Token infrastructure layer implications

Polaxory can use this as a reference model for a token infrastructure layer:

1. **Signal layer** — watch market, community, repo, and player signals.
2. **Research layer** — convert external infrastructure patterns into Polaxory-specific options.
3. **Guardrail layer** — define what the agent may never do: no secrets, no key handling, no fake claims, no unsupported trading flows.
4. **Artifact layer** — every useful finding becomes a small durable repo artifact.
5. **Public layer** — the Git page only acknowledges the layer is running; it does not make infra the product.

## Marketing angles to research next

- Show Polaxory as a small studio with an operating layer, not a token-first pitch.
- Document one shipped improvement at a time: playability, retention, signal capture, build cadence.
- Use Phoenix-style language sparingly: fast, precise, reliable, infrastructure-backed.
- Avoid claims that imply financial performance, exchange affiliation, or guaranteed token utility.

## Next smallest step

Keep a recurring research loop that watches Phoenix/Rise and adjacent Solana infra patterns, then commits one concrete Polaxory adaptation only when it finds something worth preserving.
