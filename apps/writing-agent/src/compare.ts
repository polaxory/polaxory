/**
 * Polaxory — voice comparison harness (Task #16).
 *
 * Runs a single task through every provider that has a configured API key.
 * Prints side-by-side outputs so the operator can score voice quality across
 * model tiers. Logs all generations to logs/comparisons.jsonl.
 *
 * Usage:
 *   npm run compare -- "your task"
 *   npm run compare -- --surface roblox "draft a wave pitch"
 *   npm run compare -- --only claude-sonnet,groq-llama "..."
 *
 * Goal: find the cheapest model that produces acceptable Polaxory voice for
 * routine work. Keep Claude for high-stakes; route volume to whatever passes
 * the voice bar at lowest cost.
 */

import * as fs from 'node:fs';
import * as path from 'node:path';
import 'dotenv/config';
import { loadConstitution, type Surface } from './writing-agent.js';
import {
  generate,
  getAvailableProfiles,
  getProfile,
  PROFILES,
  type GenerationResult,
  type ProviderProfile,
} from './providers.js';

const POLAXORY_DIR =
  process.env.POLAXORY_DIR || path.resolve(import.meta.dirname, '../..');
const MAX_OUTPUT_TOKENS = parseInt(process.env.MAX_OUTPUT_TOKENS || '2048', 10);

interface ParsedArgs {
  surface: Surface;
  task: string;
  only: string[] | null;
}

function parseArgs(argv: string[]): ParsedArgs {
  const args = argv.slice(2);
  let surface: Surface = 'writing';
  let only: string[] | null = null;
  const taskParts: string[] = [];

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg === '--surface' || arg === '-s') {
      const next = args[i + 1];
      if (next !== 'writing' && next !== 'roblox') {
        throw new Error(`--surface must be 'writing' or 'roblox' (got: ${next})`);
      }
      surface = next;
      i++;
    } else if (arg === '--only') {
      const next = args[i + 1];
      if (!next) throw new Error('--only requires a comma-separated profile list');
      only = next.split(',').map((s) => s.trim()).filter(Boolean);
      i++;
    } else if (arg === '--help' || arg === '-h') {
      printHelp();
      process.exit(0);
    } else {
      taskParts.push(arg);
    }
  }

  const task = taskParts.join(' ').trim();
  if (!task) {
    throw new Error('No task provided. Try: npm run compare -- "your task"');
  }

  return { surface, task, only };
}

function printHelp(): void {
  console.log(`
Polaxory voice comparison — runs the same task through every configured provider.

Usage:
  npm run compare -- [options] "your task"

Options:
  --surface, -s     'writing' (default) or 'roblox'
  --only            comma-separated profile names (e.g., 'claude-sonnet,groq-llama')
  --help, -h        show this help

Registered profiles:
${PROFILES.map((p) => `  ${p.name.padEnd(16)} ${p.tier.padEnd(8)} ${p.description}`).join('\n')}

A profile only runs if its API key env var is set. Skip configuration of
providers you don't want to test.
`);
}

function selectProfiles(only: string[] | null): ProviderProfile[] {
  const available = getAvailableProfiles();

  if (!only) return available;

  const selected: ProviderProfile[] = [];
  for (const name of only) {
    const profile = getProfile(name);
    if (!profile) {
      console.warn(`[compare] unknown profile: ${name} — skipping`);
      continue;
    }
    if (!process.env[profile.apiKeyEnvVar]) {
      console.warn(
        `[compare] profile ${name} has no API key set (${profile.apiKeyEnvVar}) — skipping`,
      );
      continue;
    }
    selected.push(profile);
  }
  return selected;
}

interface ComparisonRecord {
  timestamp: string;
  task: string;
  surface: Surface;
  results: Array<{
    profile: string;
    model: string;
    tier: string;
    success: boolean;
    content?: string;
    inputTokens?: number;
    outputTokens?: number;
    elapsedMs?: number;
    error?: string;
  }>;
}

function logComparison(record: ComparisonRecord): string {
  const logsDir = path.join(POLAXORY_DIR, 'agent', 'logs');
  if (!fs.existsSync(logsDir)) {
    fs.mkdirSync(logsDir, { recursive: true });
  }
  const logPath = path.join(logsDir, 'comparisons.jsonl');
  fs.appendFileSync(logPath, JSON.stringify(record) + '\n', 'utf-8');
  return logPath;
}

function printResult(
  profile: ProviderProfile,
  result: GenerationResult | { error: string },
): void {
  const header = `═══ ${profile.name} (${profile.tier}) ═══ ${profile.model}`;
  console.log('\n' + header);
  console.log('─'.repeat(header.length));
  if ('error' in result) {
    console.log(`ERROR: ${result.error}`);
    return;
  }
  console.log(result.content);
  console.log(
    `\n  ↳ ${result.inputTokens} in / ${result.outputTokens} out · ${result.elapsedMs}ms`,
  );
}

async function main(): Promise<void> {
  const { surface, task, only } = parseArgs(process.argv);
  const profiles = selectProfiles(only);

  if (profiles.length === 0) {
    console.error('[compare] No profiles available. Set API keys in .env.');
    console.error('[compare] See .env.example for the env vars to configure.');
    process.exit(1);
  }

  console.error(`[compare] surface=${surface}`);
  console.error(`[compare] task=${task}`);
  console.error(
    `[compare] profiles: ${profiles.map((p) => p.name).join(', ')}`,
  );
  console.error('[compare] generating in parallel...\n');

  // Load constitution once — same context for all profiles.
  const constitution = loadConstitution(surface);

  const systemPrompt =
    `You are Polaxory, operating the ` +
    `${surface === 'writing' ? 'WritingAgent' : 'RobloxOps'} surface. ` +
    `Read the constitution below carefully. ` +
    `Every output must pass: "ship in character, never out of character."\n\n` +
    `Speak AS Polaxory — first person, lowercase aesthetic, terse where Jetski sprawls, ` +
    `names rather than explains. No preamble. No meta-commentary. Just the work.\n\n` +
    `CONSTITUTION:\n\n${constitution.raw}`;

  const userPrompt =
    `Task: ${task}\n\n` +
    `Produce the output. No "Here is..." or "I'll write...". Just the work.`;

  // Run all profiles in parallel.
  const settled = await Promise.allSettled(
    profiles.map(async (profile) => {
      const result = await generate(profile, {
        systemPrompt,
        userPrompt,
        maxTokens: MAX_OUTPUT_TOKENS,
      });
      return { profile, result };
    }),
  );

  const record: ComparisonRecord = {
    timestamp: new Date().toISOString(),
    task,
    surface,
    results: [],
  };

  for (let i = 0; i < settled.length; i++) {
    const profile = profiles[i];
    const settledResult = settled[i];
    if (settledResult.status === 'fulfilled') {
      const { result } = settledResult.value;
      printResult(profile, result);
      record.results.push({
        profile: profile.name,
        model: profile.model,
        tier: profile.tier,
        success: true,
        content: result.content,
        inputTokens: result.inputTokens,
        outputTokens: result.outputTokens,
        elapsedMs: result.elapsedMs,
      });
    } else {
      const errMsg =
        settledResult.reason instanceof Error
          ? settledResult.reason.message
          : String(settledResult.reason);
      printResult(profile, { error: errMsg });
      record.results.push({
        profile: profile.name,
        model: profile.model,
        tier: profile.tier,
        success: false,
        error: errMsg,
      });
    }
  }

  const logPath = logComparison(record);
  console.error('\n' + '═'.repeat(60));
  console.error(`[compare] logged: ${logPath}`);
  console.error(`[compare] ${record.results.filter((r) => r.success).length}/${record.results.length} succeeded`);
}

main().catch((err: unknown) => {
  console.error('[compare] ERROR:', err instanceof Error ? err.message : String(err));
  if (err instanceof Error && err.stack) {
    console.error(err.stack);
  }
  process.exit(1);
});
