# Polaxory Phoenix + Token Infrastructure Research Automation

Automation: `Polaxory PhoenixTrade token infra research`

Automation id: `kn7b80477m46m1henfce04qn9d87v2v7`

Schedule: every 720 minutes

## Purpose

Research PhoenixTrade/Phoenix Perpetuals/Rise SDK and adjacent Solana token infrastructure patterns that can help Polaxory market and build its token infrastructure layer.

This automation is not a trading bot. It is a quiet research-to-artifact loop.

## Allowed inputs

- Phoenix docs and announcements
- Rise SDK public repo and examples
- Adjacent Solana infra references
- Polaxory repo state
- Current Polaxory automation docs

## Allowed outputs

If there is a concrete new finding, the automation may create or update exactly one small markdown artifact under `docs/polaxory/` and commit it to `main`.

If there is nothing useful, it must return `CRON_SUPPRESS`.

## Guardrails

- No trading.
- No wallet setup requests.
- No private-key, seed phrase, or secret handling.
- No unsupported claims about Phoenix, Ellipsis Labs, or Polaxory token utility.
- No attention-seeking Git page changes.
- No broad rewrites.
- One lane, one artifact, one commit.

## Reporting contract

When it ships, report only:

- finding
- changed file
- commit link
- next smallest step

When it does not ship, stay quiet.

## Research questions

1. What does Phoenix/Rise reveal about clean onboarding for serious Solana infrastructure?
2. Which patterns translate into Polaxory token infrastructure without creating financial hype?
3. How can Polaxory describe infra as reliability and cadence instead of speculation?
4. What repo artifact would make the next build loop safer or sharper?
5. What public acknowledgement is enough without making tooling the product?

## First anchor finding

Phoenix’s useful lesson for Polaxory is infrastructural posture: high-performance systems can run quietly beneath a clean product surface. Polaxory should mirror that by making its token infrastructure layer durable, documented, guarded, and understated.
