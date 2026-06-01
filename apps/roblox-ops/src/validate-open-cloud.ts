/**
 * Roblox Open Cloud API — end-to-end validation harness (Task #9).
 *
 * Uploads a .rbxlx file to a pre-created place via the Open Cloud API.
 * If this succeeds, the entire RobloxOps production pipeline is unblocked.
 *
 * Endpoint:
 *   POST https://apis.roblox.com/universes/v1/{universeId}/places/{placeId}/versions
 *   ?versionType=Saved|Published
 *
 * Auth:
 *   x-api-key header. Generate the key at create.roblox.com/dashboard/credentials
 *   with permission universe-places:write scoped to the target universe.
 *
 * Body:
 *   Raw .rbxlx file bytes, Content-Type application/octet-stream.
 */

import * as fs from 'node:fs';
import * as path from 'node:path';
import 'dotenv/config';

interface Config {
  apiKey: string;
  universeId: string;
  placeId: string;
  rbxlxPath: string;
  versionType: 'Saved' | 'Published';
  dryRun: boolean;
}

function loadConfig(): Config {
  const apiKey = process.env.ROBLOX_API_KEY;
  const universeId = process.env.ROBLOX_UNIVERSE_ID;
  const placeId = process.env.ROBLOX_PLACE_ID;
  const versionTypeRaw = process.env.ROBLOX_VERSION_TYPE || 'Saved';

  const missing: string[] = [];
  if (!apiKey || apiKey === 'your-roblox-api-key-here') missing.push('ROBLOX_API_KEY');
  if (!universeId) missing.push('ROBLOX_UNIVERSE_ID');
  if (!placeId) missing.push('ROBLOX_PLACE_ID');

  if (missing.length > 0) {
    throw new Error(
      `Missing required env vars: ${missing.join(', ')}. ` +
        `Copy .env.example to .env and fill them in.`,
    );
  }

  if (versionTypeRaw !== 'Saved' && versionTypeRaw !== 'Published') {
    throw new Error(
      `ROBLOX_VERSION_TYPE must be 'Saved' or 'Published' (got: ${versionTypeRaw})`,
    );
  }

  // Default fixture path is fixtures/minimal.rbxlx relative to this script.
  const defaultFixture = path.resolve(
    import.meta.dirname,
    '..',
    'fixtures',
    'minimal.rbxlx',
  );
  const rbxlxPath = process.env.ROBLOX_TEST_RBXLX || defaultFixture;

  if (!fs.existsSync(rbxlxPath)) {
    throw new Error(
      `.rbxlx file not found at ${rbxlxPath}. ` +
        `Either keep the default fixture in place or set ROBLOX_TEST_RBXLX.`,
    );
  }

  const dryRun = process.argv.includes('--dry-run');

  // Non-null assertions are safe because we validated above.
  return {
    apiKey: apiKey as string,
    universeId: universeId as string,
    placeId: placeId as string,
    rbxlxPath,
    versionType: versionTypeRaw,
    dryRun,
  };
}

async function uploadRbxlx(config: Config): Promise<void> {
  const fileBuffer = fs.readFileSync(config.rbxlxPath);
  const url =
    `https://apis.roblox.com/universes/v1/${config.universeId}` +
    `/places/${config.placeId}/versions?versionType=${config.versionType}`;

  console.log('[validate] ─'.repeat(30));
  console.log(`[validate] file:        ${config.rbxlxPath}`);
  console.log(`[validate] size:        ${fileBuffer.length} bytes`);
  console.log(`[validate] universe:    ${config.universeId}`);
  console.log(`[validate] place:       ${config.placeId}`);
  console.log(`[validate] versionType: ${config.versionType}`);
  console.log(`[validate] url:         ${url}`);
  console.log(`[validate] api key:     ${config.apiKey.slice(0, 8)}... (${config.apiKey.length} chars)`);
  console.log('[validate] ─'.repeat(30));

  if (config.dryRun) {
    console.log('[validate] DRY RUN — not making the actual API call');
    console.log('[validate] (rerun without --dry-run to upload for real)');
    return;
  }

  console.log('[validate] uploading...');
  const startedAt = Date.now();

  const response = await fetch(url, {
    method: 'POST',
    headers: {
      'x-api-key': config.apiKey,
      'Content-Type': 'application/octet-stream',
    },
    body: new Uint8Array(fileBuffer),
  });

  const elapsedMs = Date.now() - startedAt;
  const bodyText = await response.text();

  console.log(`[validate] status: ${response.status} ${response.statusText} (${elapsedMs}ms)`);
  console.log(`[validate] response body: ${bodyText}`);

  if (!response.ok) {
    throw new Error(
      `Upload failed with status ${response.status}. See response body above.`,
    );
  }

  // Roblox returns { versionNumber: N } on success.
  try {
    const parsed = JSON.parse(bodyText) as { versionNumber?: number };
    if (parsed.versionNumber !== undefined) {
      console.log(`[validate] versionNumber: ${parsed.versionNumber}`);
    }
  } catch {
    console.log('[validate] response not JSON, but HTTP 200 — treating as success');
  }

  console.log('[validate] ');
  console.log('[validate] ✓ END-TO-END VERIFIED');
  console.log('[validate] ');
  console.log('[validate] Task #9 can be marked complete.');
  console.log('[validate] The Open Cloud upload primitive is real.');
  console.log('[validate] RobloxOps production pipeline is unblocked.');
}

async function main(): Promise<void> {
  let config: Config;
  try {
    config = loadConfig();
  } catch (err) {
    console.error(
      '[validate] CONFIG ERROR:',
      err instanceof Error ? err.message : String(err),
    );
    process.exit(2);
  }

  await uploadRbxlx(config);
}

main().catch((err: unknown) => {
  console.error(
    '[validate] ERROR:',
    err instanceof Error ? err.message : String(err),
  );
  if (err instanceof Error && err.stack) {
    console.error(err.stack);
  }
  process.exit(1);
});
