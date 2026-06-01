/**
 * Polaxory WritingAgent — CLI entry point.
 *
 * Usage:
 *   npm run generate -- "your task here"
 *   npm run generate -- --surface roblox "your task here"
 *
 * Prints the generated output to stdout. Prints metadata (gate result, tokens,
 * timing) to stderr so stdout is pipeable. Appends a JSONL record to logs/.
 */

import { generatePost, logGeneration, type Surface } from './writing-agent.js';

interface ParsedArgs {
  surface: Surface;
  task: string;
}

function parseArgs(argv: string[]): ParsedArgs {
  // Skip node + script name.
  const args = argv.slice(2);
  let surface: Surface = 'writing';
  const taskParts: string[] = [];

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg === '--surface' || arg === '-s') {
      const next = args[i + 1];
      if (next !== 'writing' && next !== 'roblox') {
        throw new Error(
          `--surface must be 'writing' or 'roblox' (got: ${next})`,
        );
      }
      surface = next;
      i++; // skip the value
    } else if (arg === '--help' || arg === '-h') {
      printHelp();
      process.exit(0);
    } else {
      taskParts.push(arg);
    }
  }

  const task = taskParts.join(' ').trim();
  if (!task) {
    throw new Error('No task provided. Try: npm run generate -- "your task"');
  }

  return { surface, task };
}

function printHelp(): void {
  console.log(`
Polaxory WritingAgent — generate output in character.

Usage:
  npm run generate -- [options] "your task description"

Options:
  --surface, -s     'writing' (default) or 'roblox'
  --help, -h        show this help

Examples:
  npm run generate -- "draft a short observation about culture currents"
  npm run generate -- -s roblox "pitch a wave-attempt riding the identity-expression trend"
`);
}

async function main(): Promise<void> {
  const { surface, task } = parseArgs(process.argv);

  console.error(`[agent] surface=${surface}`);
  console.error(`[agent] task=${task}`);
  console.error('[agent] generating...');

  const startTime = Date.now();
  const post = await generatePost(task, surface);
  const elapsedMs = Date.now() - startTime;

  // Output goes to stdout (pipeable).
  console.log(post.content);

  // Metadata goes to stderr.
  console.error('');
  console.error('─'.repeat(60));
  console.error(`[agent] gate=${post.metadata.securityGatePassed ? 'PASS' : 'FAIL'}`);
  console.error(`[agent] reason: ${post.metadata.gateReason}`);
  if (post.metadata.gateFlags.length > 0) {
    console.error(`[agent] flags: ${post.metadata.gateFlags.join(', ')}`);
  }
  console.error(
    `[agent] tokens: ${post.metadata.inputTokens} in / ${post.metadata.outputTokens} out`,
  );
  console.error(`[agent] elapsed: ${elapsedMs}ms`);
  console.error(`[agent] constitution: ${post.metadata.constitutionFiles.join(', ')}`);

  const logPath = logGeneration(post);
  console.error(`[agent] logged: ${logPath}`);

  // Exit code reflects gate result.
  process.exit(post.metadata.securityGatePassed ? 0 : 2);
}

main().catch((err: unknown) => {
  console.error('[agent] ERROR:', err instanceof Error ? err.message : String(err));
  if (err instanceof Error && err.stack) {
    console.error(err.stack);
  }
  process.exit(1);
});
