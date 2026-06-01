# Security Boundary

This repository snapshot is intentionally conservative. The goal is a clean working layer with no security breach risk.

## Excluded private runtime state

The following Hypurrclaw workspace paths are never committed:

- `/agent/automations.md`
- `/agent/heartbeat.md`
- `/agent/memories.md`
- `/agent/README.md`
- `/agent/settings.json`
- `/agent/SOUL.md`
- `/agent/thread-summary.md`

Reason: these are private agent/user state mirrors, not project source.

## Excluded attachments

The following class of files is never committed from the workspace export:

- `/attachments/**`
- uploaded PDFs
- uploaded EPUBs
- large binary files
- copyrighted reference books

Reason: they are large, private/reference material, and not clean repository source.

## Secret policy

Do not commit:

- private keys
- seed phrases
- wallet exports
- API keys
- OAuth tokens
- credentials
- `.env` files with secrets
- signed challenges
- auth/session material
- private account state

## Completeness policy

If a workspace file can only be read in truncated form, do not commit that file as complete. Either re-export it through a full-fidelity path later or commit a deliberate summary with clear labeling.

## Current safe layer

This commit contains the clean organizing layer and canonical Polaxory docs needed to continue the build without leaking private runtime state.
