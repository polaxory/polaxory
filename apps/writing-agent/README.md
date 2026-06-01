# Polaxory WritingAgent — v0.1

The writing surface of Polaxory's stack. Loads the constitution docs, calls Claude in character, validates output through a security gate, logs everything. CLI for now. Cron / event loop later. Posting integrations (Farcaster, X) later.

This is v0. Single voice surface. No posting yet — outputs go to stdout and a JSONL log. Useful for soft-mode voice validation (Task #15).

## Setup

```bash
cd /Users/blake.jaraczeski/polaxory/agent
cp .env.example .env
# edit .env, add ANTHROPIC_API_KEY
npm install
```

## Usage

Generate a single post:

```bash
npm run generate -- "write a short observation about culture currents"
```

With explicit surface:

```bash
npm run generate -- --surface writing "write a manifesto fragment about the verge of falling"
npm run generate -- --surface roblox "draft a 2-sentence pitch for a wave-attempt about identity expression"
```

Output goes to stdout. A JSONL log is appended to `logs/generations.jsonl` with metadata (timestamp, surface, model, gate result, token counts).

## What this does

1. Loads constitution docs from `$POLAXORY_DIR` (defaults to `..`):
   - `POLAXORY.md` (character bible)
   - `POLAXORY-STACK.md` (operating model)
   - `MANIFESTO.md` (positional statement)
   - `ROBLOXOPS.md` (only loaded for `--surface roblox`)
2. Calls Claude with constitution as system prompt and your task as user message.
3. Pipes the output through a security gate (a second Claude call) that checks character-fit, boundary violations, disclosure compliance, and drift.
4. If the gate passes, prints the output. If it fails, prints the output anyway plus the gate's reasons — operator review required.
5. Appends a record to `logs/generations.jsonl` regardless of gate result.

## What this does NOT do (yet)

- Post to Farcaster, X, or any platform — outputs go to stdout only
- Run on a cron or daily loop — single-shot CLI for now
- Use cheap LLM providers for routine work — Claude across the board for v0
- Track spending against treasury budget — no treasury exists yet
- Memory layer / retrieval — fresh constitution context per call, no retrieval

These are all on the build path. See KNOLL-2026-05-31.md §4 for the critical-path task list.

## Voice-separation test (Task #2 + #15)

The point of this v0 is to run the voice-separation test honestly. Generate output. Read it. Ask: does this sound like Polaxory, or does it sound like generic AI or Jetski? If the latter, the constitution needs more carve.

Iterate POLAXORY.md until the voice ships at the bar you want. The agent only gets as good as the constitution it reads.

## Voice comparison across providers (Task #16)

Same task, every provider with a configured key, side-by-side outputs:

```bash
npm run compare -- "write a short observation about culture currents"
npm run compare -- --only claude-sonnet,groq-llama "..."
npm run compare -- --surface roblox "..."
```

Each provider has a profile in `src/providers.ts` (Anthropic Claude, Groq Llama, Mistral, DeepSeek, Gemini Flash). Profiles only activate if their API key is set in `.env` — missing keys skip silently.

Outputs print side-by-side to stdout. A full record (content, tokens, latency, errors) appends to `logs/comparisons.jsonl`. Use this to find the cheapest model that produces acceptable Polaxory voice. Keep Claude for high-stakes; route volume to whatever passes the bar at lowest cost.

## Architecture

```
src/
  providers.ts        ← provider abstraction: PROFILES registry, generate() dispatch (Anthropic + OpenAI-compatible)
  writing-agent.ts    ← core module: loadConstitution, generateRaw, securityGate, generatePost, logGeneration
  generate.ts         ← single-shot CLI entry point
  compare.ts          ← multi-provider parallel comparison CLI
```

Surface-specific behavior is gated on the `surface` parameter ('writing' | 'roblox'). The Roblox surface loads `ROBLOXOPS.md` in addition to the base constitution. Future surfaces add their own modules.

The provider abstraction in `providers.ts` lets the inference layer be vendor-agnostic per POLAXORY-STACK.md's "layer the inference, don't unify it" principle. Add or modify profiles by editing the `PROFILES` array.

## Operating principle (per POLAXORY-STACK.md)

This service implements one surface of Polaxory's stack. It is NOT the agent. The agent is the composition of all surfaces around the shared constitution. This service is the writing piece.

Layer the inference. Don't unify it.
