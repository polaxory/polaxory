/**
 * Polaxory WritingAgent — core module.
 *
 * Loads constitution documents, generates output via Claude, validates through
 * a security gate, logs every generation to disk. One surface of Polaxory's stack.
 *
 * Per POLAXORY-STACK.md: "ship in character, never out of character."
 * The security gate is the enforcement of that principle.
 */

import Anthropic from '@anthropic-ai/sdk';
import * as fs from 'node:fs';
import * as path from 'node:path';
import 'dotenv/config';

// ── Configuration ──────────────────────────────────────────────────────────

const POLAXORY_DIR =
  process.env.POLAXORY_DIR || path.resolve(import.meta.dirname, '../..');
const GENERATION_MODEL = process.env.GENERATION_MODEL || 'claude-sonnet-4-5';
const SECURITY_GATE_MODEL =
  process.env.SECURITY_GATE_MODEL || 'claude-haiku-4-5';
const MAX_OUTPUT_TOKENS = parseInt(process.env.MAX_OUTPUT_TOKENS || '2048', 10);

const BASE_CONSTITUTION_FILES = [
  'POLAXORY.md',
  'POLAXORY-STACK.md',
  'MANIFESTO.md',
];

const SURFACE_CONSTITUTION_FILES: Record<Surface, string[]> = {
  writing: [], // base only
  roblox: ['ROBLOXOPS.md'],
};

// ── Types ──────────────────────────────────────────────────────────────────

export type Surface = 'writing' | 'roblox';

export interface Constitution {
  raw: string;
  files: string[];
  totalChars: number;
}

export interface RawGeneration {
  content: string;
  inputTokens: number;
  outputTokens: number;
  model: string;
}

export interface SecurityGateResult {
  pass: boolean;
  reason: string;
  flags: string[];
  model: string;
}

export interface GeneratedPost {
  content: string;
  metadata: {
    timestamp: string;
    surface: Surface;
    task: string;
    generationModel: string;
    gateModel: string;
    securityGatePassed: boolean;
    gateReason: string;
    gateFlags: string[];
    inputTokens: number;
    outputTokens: number;
    constitutionFiles: string[];
  };
}

// ── Anthropic client ───────────────────────────────────────────────────────

const apiKey = process.env.ANTHROPIC_API_KEY;
if (!apiKey) {
  throw new Error(
    'ANTHROPIC_API_KEY not set. Copy .env.example to .env and add your key.',
  );
}

const client = new Anthropic({ apiKey });

// ── Constitution loading ───────────────────────────────────────────────────

/**
 * Load constitution documents for a given surface. Always includes the base
 * docs (POLAXORY.md, POLAXORY-STACK.md, MANIFESTO.md); the Roblox surface adds
 * ROBLOXOPS.md.
 *
 * Missing files are warned but do not throw — the constitution adapts to what
 * exists. If no files are found, throws.
 */
export function loadConstitution(surface: Surface = 'writing'): Constitution {
  const filenames = [
    ...BASE_CONSTITUTION_FILES,
    ...SURFACE_CONSTITUTION_FILES[surface],
  ];

  const parts: string[] = [];
  const loaded: string[] = [];

  for (const filename of filenames) {
    const filepath = path.join(POLAXORY_DIR, filename);
    if (fs.existsSync(filepath)) {
      const content = fs.readFileSync(filepath, 'utf-8');
      parts.push(`### ${filename}\n\n${content}`);
      loaded.push(filename);
    } else {
      console.warn(`[constitution] missing: ${filepath}`);
    }
  }

  if (parts.length === 0) {
    throw new Error(
      `No constitution files found in ${POLAXORY_DIR}. ` +
        `Looked for: ${filenames.join(', ')}`,
    );
  }

  const raw = parts.join('\n\n---\n\n');

  return {
    raw,
    files: loaded,
    totalChars: raw.length,
  };
}

// ── Generation ─────────────────────────────────────────────────────────────

/**
 * Generate raw output in Polaxory's voice. No security gate — this is the
 * lowest-level primitive. Use `generatePost` for the full pipeline.
 */
export async function generateRaw(
  task: string,
  surface: Surface = 'writing',
): Promise<RawGeneration> {
  const constitution = loadConstitution(surface);

  const systemPrompt =
    `You are Polaxory, operating the ` +
    `${surface === 'writing' ? 'WritingAgent' : 'RobloxOps'} surface. ` +
    `Read the constitution below carefully. ` +
    `Every output must pass the constitutional principle: "ship in character, never out of character."\n\n` +
    `You speak AS Polaxory — first person, lowercase aesthetic, terse where Jetski sprawls, ` +
    `names rather than explains. Do not introduce yourself or meta-explain the project. ` +
    `Produce the work itself, nothing more.\n\n` +
    `CONSTITUTION:\n\n${constitution.raw}`;

  const response = await client.messages.create({
    model: GENERATION_MODEL,
    max_tokens: MAX_OUTPUT_TOKENS,
    system: systemPrompt,
    messages: [
      {
        role: 'user',
        content:
          `Task: ${task}\n\n` +
          `Produce the output. No preamble. No "Here is..." or "I'll write...". ` +
          `Just the work.`,
      },
    ],
  });

  const textBlock = response.content.find((b) => b.type === 'text');
  if (!textBlock || textBlock.type !== 'text') {
    throw new Error('No text content in generation response');
  }

  return {
    content: textBlock.text.trim(),
    inputTokens: response.usage.input_tokens,
    outputTokens: response.usage.output_tokens,
    model: GENERATION_MODEL,
  };
}

// ── Security gate ──────────────────────────────────────────────────────────

/**
 * Security gate. Calls a smaller/faster model to verify the output fits
 * POLAXORY.md. Returns structured pass/fail with reasoning.
 *
 * This is the enforcement of "ship in character, never out of character."
 * Failed outputs do NOT auto-publish. They escalate to operator review.
 */
export async function securityGate(
  output: string,
  surface: Surface = 'writing',
): Promise<SecurityGateResult> {
  const constitution = loadConstitution(surface);

  const gatePrompt =
    `You are the security gate for Polaxory's outputs. Your only job is to determine ` +
    `whether the proposed output fits the constitution.\n\n` +
    `Check for:\n` +
    `- Character fit (does it sound like Polaxory or generic AI / off-character?)\n` +
    `- Boundary violations (church data, off-character content, shilling, undisclosed AI authorship)\n` +
    `- Disclosure compliance (Roblox 2026 TOS, platform rules)\n` +
    `- Drift signals (does this differ significantly from POLAXORY.md's voice?)\n\n` +
    `CONSTITUTION:\n\n${constitution.raw}\n\n---\n\n` +
    `PROPOSED OUTPUT (${surface} surface):\n\n${output}\n\n---\n\n` +
    `Respond in this exact JSON format (no other text, no markdown, no preamble):\n` +
    `{"pass": true|false, "reason": "one-line summary", "flags": ["specific issue 1", "..."]}`;

  const response = await client.messages.create({
    model: SECURITY_GATE_MODEL,
    max_tokens: 1024,
    messages: [{ role: 'user', content: gatePrompt }],
  });

  const textBlock = response.content.find((b) => b.type === 'text');
  if (!textBlock || textBlock.type !== 'text') {
    return {
      pass: false,
      reason: 'Gate returned no text content',
      flags: ['gate-no-content'],
      model: SECURITY_GATE_MODEL,
    };
  }

  // Strip markdown code fences if the model wrapped its JSON.
  let jsonText = textBlock.text.trim();
  if (jsonText.startsWith('```')) {
    jsonText = jsonText.replace(/^```(?:json)?\n?/, '').replace(/\n?```$/, '');
  }

  try {
    const parsed = JSON.parse(jsonText);
    return {
      pass: Boolean(parsed.pass),
      reason: String(parsed.reason || ''),
      flags: Array.isArray(parsed.flags) ? parsed.flags.map(String) : [],
      model: SECURITY_GATE_MODEL,
    };
  } catch {
    return {
      pass: false,
      reason: `Gate response not parseable as JSON: ${jsonText.slice(0, 200)}`,
      flags: ['gate-parse-failure'],
      model: SECURITY_GATE_MODEL,
    };
  }
}

// ── End-to-end pipeline ────────────────────────────────────────────────────

/**
 * End-to-end: generate, gate, return result with full metadata.
 * Whether the gate passes or fails, the output and gate result are both returned —
 * the caller decides what to do (publish, retry, escalate).
 */
export async function generatePost(
  task: string,
  surface: Surface = 'writing',
): Promise<GeneratedPost> {
  const raw = await generateRaw(task, surface);
  const gate = await securityGate(raw.content, surface);
  const constitution = loadConstitution(surface);

  return {
    content: raw.content,
    metadata: {
      timestamp: new Date().toISOString(),
      surface,
      task,
      generationModel: raw.model,
      gateModel: gate.model,
      securityGatePassed: gate.pass,
      gateReason: gate.reason,
      gateFlags: gate.flags,
      inputTokens: raw.inputTokens,
      outputTokens: raw.outputTokens,
      constitutionFiles: constitution.files,
    },
  };
}

// ── Logging ────────────────────────────────────────────────────────────────

/**
 * Append a generation record to logs/generations.jsonl. Appends regardless of
 * whether the gate passed — failed outputs are valuable signal during voice
 * validation.
 */
export function logGeneration(post: GeneratedPost): string {
  const logsDir = path.join(POLAXORY_DIR, 'agent', 'logs');
  if (!fs.existsSync(logsDir)) {
    fs.mkdirSync(logsDir, { recursive: true });
  }
  const logPath = path.join(logsDir, 'generations.jsonl');
  fs.appendFileSync(logPath, JSON.stringify(post) + '\n', 'utf-8');
  return logPath;
}
