/**
 * Polaxory telemetry drain — pulls the latest aggregate snapshot out of the
 * live universe via the Open Cloud Luau Execution API.
 *
 * Why this exists:
 *   RoundTelemetryLoop.server.luau accumulates an aggregate snapshot in memory
 *   and, on SnapshotRequested, persists it to the "polaxory_telemetry" DataStore
 *   (key "latest"). Luau Execution runs in an ISOLATED ephemeral session — it
 *   cannot read a live server's memory — but it CAN read the universe DataStore
 *   that the live server wrote. That DataStore is the bridge across the boundary.
 *
 * Endpoint (create task):
 *   POST https://apis.roblox.com/cloud/v2/universes/{universeId}
 *        /places/{placeId}/luau-execution-session-tasks
 *
 * Auth:
 *   x-api-key header. Key needs permission `luau-execution-sessions:write`
 *   scoped to the target place. (universe-places:write is for the upload path.)
 *
 * Body:
 *   { "script": "<luau source>" }
 *
 * Polling:
 *   The create response returns a `path`. GET https://apis.roblox.com/cloud/v2/{path}
 *   until `state` is COMPLETE or FAILED. Script return values land in `output.results`.
 *   Engine logs are at GET https://apis.roblox.com/cloud/v2/{path}/logs.
 */

import 'dotenv/config';

interface Config {
  apiKey: string;
  universeId: string;
  placeId: string;
  storeName: string;
  key: string;
  dryRun: boolean;
}

const API_BASE = 'https://apis.roblox.com/cloud/v2';
const POLL_INTERVAL_MS = 2000;
const POLL_TIMEOUT_MS = 60_000;

function loadConfig(): Config {
  const apiKey = process.env.ROBLOX_API_KEY;
  const universeId = process.env.ROBLOX_UNIVERSE_ID;
  const placeId = process.env.ROBLOX_PLACE_ID;

  const missing: string[] = [];
  if (!apiKey || apiKey === 'your-roblox-api-key-here') missing.push('ROBLOX_API_KEY');
  if (!universeId) missing.push('ROBLOX_UNIVERSE_ID');
  if (!placeId) missing.push('ROBLOX_PLACE_ID');

  if (missing.length > 0) {
    throw new Error(
      `Missing required env vars: ${missing.join(', ')}. ` +
        `Copy .env.example to .env and fill them in. The API key needs the ` +
        `luau-execution-sessions:write scope on the target place.`,
    );
  }

  return {
    apiKey: apiKey as string,
    universeId: universeId as string,
    placeId: placeId as string,
    storeName: process.env.POLAXORY_TELEMETRY_STORE || 'polaxory_telemetry',
    key: process.env.POLAXORY_TELEMETRY_KEY || 'latest',
    dryRun: process.argv.includes('--dry-run'),
  };
}

/** The Luau the isolated session runs. Reads the snapshot the live server wrote. */
function readerScript(storeName: string, key: string): string {
  const safeStore = JSON.stringify(storeName);
  const safeKey = JSON.stringify(key);
  return [
    'local DataStoreService = game:GetService("DataStoreService")',
    `local store = DataStoreService:GetDataStore(${safeStore})`,
    `local raw = store:GetAsync(${safeKey})`,
    'if raw == nil then',
    `  return { found = false, key = ${safeKey} }`,
    'end',
    'return { found = true, snapshot = raw }',
  ].join('\n');
}

interface TaskResource {
  path?: string;
  state?: string;
  output?: { results?: unknown[] };
  error?: unknown;
}

async function api(config: Config, url: string, init?: RequestInit): Promise<TaskResource> {
  const response = await fetch(url, {
    ...init,
    headers: {
      'x-api-key': config.apiKey,
      'Content-Type': 'application/json',
      ...(init?.headers ?? {}),
    },
  });
  const bodyText = await response.text();
  if (!response.ok) {
    throw new Error(`${init?.method ?? 'GET'} ${url} -> ${response.status} ${response.statusText}\n${bodyText}`);
  }
  return bodyText ? (JSON.parse(bodyText) as TaskResource) : {};
}

const sleep = (ms: number): Promise<void> => new Promise((r) => setTimeout(r, ms));

async function drain(config: Config): Promise<void> {
  const script = readerScript(config.storeName, config.key);
  const createUrl =
    `${API_BASE}/universes/${config.universeId}` +
    `/places/${config.placeId}/luau-execution-session-tasks`;

  console.log('[drain] ─'.repeat(20));
  console.log(`[drain] universe: ${config.universeId}`);
  console.log(`[drain] place:    ${config.placeId}`);
  console.log(`[drain] store:    ${config.storeName} / key: ${config.key}`);
  console.log(`[drain] url:      ${createUrl}`);
  console.log(`[drain] api key:  ${config.apiKey.slice(0, 8)}... (${config.apiKey.length} chars)`);
  console.log('[drain] ─'.repeat(20));

  if (config.dryRun) {
    console.log('[drain] DRY RUN — script that WOULD run:');
    console.log(script);
    console.log('[drain] (rerun without --dry-run to execute)');
    return;
  }

  console.log('[drain] creating Luau Execution task...');
  const created = await api(config, createUrl, { method: 'POST', body: JSON.stringify({ script }) });
  const taskPath = created.path;
  if (!taskPath) {
    throw new Error(`No task path in create response: ${JSON.stringify(created)}`);
  }
  console.log(`[drain] task: ${taskPath} (state: ${created.state})`);

  const startedAt = Date.now();
  let task = created;
  while (task.state !== 'COMPLETE' && task.state !== 'FAILED') {
    if (Date.now() - startedAt > POLL_TIMEOUT_MS) {
      throw new Error(`Timed out after ${POLL_TIMEOUT_MS}ms waiting on ${taskPath} (last state: ${task.state})`);
    }
    await sleep(POLL_INTERVAL_MS);
    task = await api(config, `${API_BASE}/${taskPath}`);
    console.log(`[drain] state: ${task.state}`);
  }

  if (task.state === 'FAILED') {
    throw new Error(`Task FAILED: ${JSON.stringify(task.error ?? task)}`);
  }

  const result = task.output?.results?.[0] as { found?: boolean; snapshot?: string } | undefined;
  if (!result?.found) {
    console.log('[drain] no snapshot persisted yet — fire SnapshotRequested in a live session first.');
    return;
  }

  const snapshot = JSON.parse(result.snapshot as string);
  console.log('[drain] ✓ snapshot drained:');
  console.log(JSON.stringify(snapshot, null, 2));
}

async function main(): Promise<void> {
  let config: Config;
  try {
    config = loadConfig();
  } catch (err) {
    console.error('[drain] CONFIG ERROR:', err instanceof Error ? err.message : String(err));
    process.exit(2);
  }
  await drain(config);
}

main().catch((err: unknown) => {
  console.error('[drain] ERROR:', err instanceof Error ? err.message : String(err));
  if (err instanceof Error && err.stack) console.error(err.stack);
  process.exit(1);
});
