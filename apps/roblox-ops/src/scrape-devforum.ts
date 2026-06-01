/**
 * Polaxory — DevForum scraper.
 *
 * Pulls canonical Roblox DevForum threads via the Discourse JSON API.
 * Saves structured records (.json) and rendered text (.md) to the corpus dir.
 *
 * Discourse exposes any thread as JSON by appending `.json` to the URL.
 * No HTML parsing needed. Clean attribution. Rate-limited to 1 req/sec.
 *
 * Usage:
 *   npm run scrape                              ← scrapes all high-priority targets
 *   npm run scrape -- --include-all             ← scrapes everything in targets list
 *   npm run scrape -- --url <thread_url>        ← scrapes one specific thread
 *
 * Output lives in $POLAXORY_DIR/corpus/devforum/threads/.
 */

import * as fs from 'node:fs';
import * as path from 'node:path';
import 'dotenv/config';
import { SCRAPE_TARGETS, getHighPriorityTargets, type ScrapeTarget } from './scrape-targets.js';

const POLAXORY_DIR =
  process.env.POLAXORY_DIR || path.resolve(import.meta.dirname, '../..');
const CORPUS_DIR = path.join(POLAXORY_DIR, 'corpus', 'devforum', 'threads');
const RATE_LIMIT_MS = 1100; // 1 req/sec + buffer

const USER_AGENT =
  'polaxory-perception-layer/0.1 (polaxory.studio; +https://polaxory.studio)';

// ── Discourse JSON shape (partial — only what we use) ──────────────────────

interface DiscoursePost {
  id: number;
  post_number: number;
  username: string;
  name?: string;
  created_at: string;
  updated_at: string;
  cooked: string; // HTML-rendered content
  raw?: string; // raw BBCode/markdown (may not be present in public endpoint)
}

interface DiscourseThreadResponse {
  id: number;
  title: string;
  fancy_title?: string;
  category_id: number;
  created_at: string;
  posts_count: number;
  views: number;
  like_count?: number;
  post_stream: {
    posts: DiscoursePost[];
    stream: number[];
  };
}

// ── Scraped record (what we save to disk) ──────────────────────────────────

interface ScrapedPost {
  postNumber: number;
  username: string;
  authorName: string | null;
  createdAt: string;
  updatedAt: string;
  bodyHtml: string;
  bodyText: string;
}

interface ScrapedThread {
  threadId: number;
  title: string;
  sourceUrl: string;
  category: ScrapeTarget['category'];
  categoryId: number;
  createdAt: string;
  postsCount: number;
  views: number;
  likeCount: number | null;
  scrapedAt: string;
  posts: ScrapedPost[];
}

// ── HTML → text (minimal, preserves code blocks) ───────────────────────────

/**
 * Convert Discourse "cooked" HTML to readable plain text. Preserves code
 * blocks (critical — they contain the Luau examples we care about).
 * Not a full HTML parser; intentionally simple, regex-based, good enough.
 */
function htmlToText(html: string): string {
  let text = html;

  // Preserve code blocks: replace <pre><code>...</code></pre> with fenced markdown
  text = text.replace(
    /<pre[^>]*><code[^>]*class="lang-([^"]+)"[^>]*>([\s\S]*?)<\/code><\/pre>/gi,
    (_m, lang, body) => `\n\n\`\`\`${lang}\n${decodeEntities(body)}\n\`\`\`\n\n`,
  );
  text = text.replace(
    /<pre[^>]*><code[^>]*>([\s\S]*?)<\/code><\/pre>/gi,
    (_m, body) => `\n\n\`\`\`\n${decodeEntities(body)}\n\`\`\`\n\n`,
  );

  // Inline code
  text = text.replace(/<code[^>]*>([\s\S]*?)<\/code>/gi, (_m, body) => `\`${decodeEntities(body)}\``);

  // Convert links to markdown
  text = text.replace(
    /<a[^>]*href="([^"]+)"[^>]*>([\s\S]*?)<\/a>/gi,
    (_m, href, body) => `[${stripTags(body)}](${href})`,
  );

  // Headers
  text = text.replace(/<h(\d)[^>]*>([\s\S]*?)<\/h\d>/gi, (_m, level, body) => {
    const hashes = '#'.repeat(Math.min(parseInt(level, 10), 6));
    return `\n\n${hashes} ${stripTags(body)}\n\n`;
  });

  // Paragraphs and breaks
  text = text.replace(/<\/?p[^>]*>/gi, '\n\n');
  text = text.replace(/<br\s*\/?>/gi, '\n');

  // Lists
  text = text.replace(/<li[^>]*>([\s\S]*?)<\/li>/gi, (_m, body) => `\n- ${stripTags(body).trim()}`);
  text = text.replace(/<\/?[uo]l[^>]*>/gi, '\n');

  // Strip remaining tags
  text = stripTags(text);

  // Decode entities
  text = decodeEntities(text);

  // Collapse excess whitespace
  text = text.replace(/\n{3,}/g, '\n\n');
  text = text.trim();

  return text;
}

function stripTags(html: string): string {
  return html.replace(/<[^>]+>/g, '');
}

function decodeEntities(s: string): string {
  return s
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'")
    .replace(/&apos;/g, "'")
    .replace(/&nbsp;/g, ' ')
    .replace(/&amp;/g, '&'); // & last to avoid double-decode
}

// ── Fetch ──────────────────────────────────────────────────────────────────

function jsonUrlFor(threadUrl: string): string {
  // Strip query/hash, ensure .json suffix on the thread URL (Discourse pattern).
  const u = new URL(threadUrl);
  const cleanPath = u.pathname.replace(/\/+$/, '');
  return `${u.origin}${cleanPath}.json`;
}

async function fetchThread(threadUrl: string): Promise<DiscourseThreadResponse> {
  const jsonUrl = jsonUrlFor(threadUrl);
  const response = await fetch(jsonUrl, {
    headers: {
      'User-Agent': USER_AGENT,
      Accept: 'application/json',
    },
  });
  if (!response.ok) {
    throw new Error(`Failed to fetch ${jsonUrl}: ${response.status} ${response.statusText}`);
  }
  return (await response.json()) as DiscourseThreadResponse;
}

// ── Scrape one thread ──────────────────────────────────────────────────────

async function scrapeOne(target: ScrapeTarget): Promise<ScrapedThread> {
  console.log(`[scrape] fetching: ${target.url}`);
  const raw = await fetchThread(target.url);

  const posts: ScrapedPost[] = raw.post_stream.posts.map((p) => ({
    postNumber: p.post_number,
    username: p.username,
    authorName: p.name || null,
    createdAt: p.created_at,
    updatedAt: p.updated_at,
    bodyHtml: p.cooked,
    bodyText: htmlToText(p.cooked),
  }));

  return {
    threadId: raw.id,
    title: raw.title,
    sourceUrl: target.url,
    category: target.category,
    categoryId: raw.category_id,
    createdAt: raw.created_at,
    postsCount: raw.posts_count,
    views: raw.views,
    likeCount: raw.like_count ?? null,
    scrapedAt: new Date().toISOString(),
    posts,
  };
}

// ── Save ───────────────────────────────────────────────────────────────────

function saveThread(thread: ScrapedThread): { jsonPath: string; mdPath: string } {
  fs.mkdirSync(CORPUS_DIR, { recursive: true });

  const jsonPath = path.join(CORPUS_DIR, `${thread.threadId}.json`);
  fs.writeFileSync(jsonPath, JSON.stringify(thread, null, 2), 'utf-8');

  const mdPath = path.join(CORPUS_DIR, `${thread.threadId}.md`);
  const md = renderMarkdown(thread);
  fs.writeFileSync(mdPath, md, 'utf-8');

  return { jsonPath, mdPath };
}

function renderMarkdown(thread: ScrapedThread): string {
  const lines: string[] = [];
  lines.push(`# ${thread.title}`);
  lines.push('');
  lines.push(`> Source: ${thread.sourceUrl}`);
  lines.push(`> Thread ID: ${thread.threadId}`);
  lines.push(`> Category: ${thread.category}`);
  lines.push(`> Posts: ${thread.postsCount} · Views: ${thread.views}` + (thread.likeCount ? ` · Likes: ${thread.likeCount}` : ''));
  lines.push(`> Scraped: ${thread.scrapedAt}`);
  lines.push('');
  lines.push('---');
  lines.push('');

  for (const post of thread.posts) {
    const author = post.authorName
      ? `${post.authorName} (@${post.username})`
      : `@${post.username}`;
    lines.push(`## Post #${post.postNumber} — ${author}`);
    lines.push('');
    lines.push(`_${post.createdAt}_`);
    lines.push('');
    lines.push(post.bodyText);
    lines.push('');
    lines.push('---');
    lines.push('');
  }

  return lines.join('\n');
}

// ── Manifest ───────────────────────────────────────────────────────────────

interface ManifestEntry {
  threadId: number;
  title: string;
  sourceUrl: string;
  category: string;
  scrapedAt: string;
  jsonPath: string;
  mdPath: string;
  postsCount: number;
}

function updateManifest(entry: ManifestEntry): void {
  const manifestPath = path.join(POLAXORY_DIR, 'corpus', 'manifest.json');
  fs.mkdirSync(path.dirname(manifestPath), { recursive: true });

  let manifest: { devforum: ManifestEntry[] } = { devforum: [] };
  if (fs.existsSync(manifestPath)) {
    try {
      manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf-8'));
      if (!manifest.devforum) manifest.devforum = [];
    } catch {
      // start fresh if corrupted
      manifest = { devforum: [] };
    }
  }

  // Replace existing entry for this threadId.
  manifest.devforum = manifest.devforum.filter((e) => e.threadId !== entry.threadId);
  manifest.devforum.push(entry);
  manifest.devforum.sort((a, b) => a.threadId - b.threadId);

  fs.writeFileSync(manifestPath, JSON.stringify(manifest, null, 2), 'utf-8');
}

// ── Sleep ──────────────────────────────────────────────────────────────────

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

// ── CLI ────────────────────────────────────────────────────────────────────

interface ParsedArgs {
  includeAll: boolean;
  singleUrl: string | null;
}

function parseArgs(argv: string[]): ParsedArgs {
  const args = argv.slice(2);
  let includeAll = false;
  let singleUrl: string | null = null;

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg === '--include-all') {
      includeAll = true;
    } else if (arg === '--url') {
      const next = args[i + 1];
      if (!next) throw new Error('--url requires a value');
      singleUrl = next;
      i++;
    } else if (arg === '--help' || arg === '-h') {
      console.log(`
DevForum scraper for Polaxory's perception layer.

Usage:
  npm run scrape                       scrape all high-priority targets
  npm run scrape -- --include-all      scrape everything in scrape-targets.ts
  npm run scrape -- --url <thread_url> scrape one specific thread

Output: $POLAXORY_DIR/corpus/devforum/threads/{thread_id}.{json,md}
Manifest: $POLAXORY_DIR/corpus/manifest.json
`);
      process.exit(0);
    }
  }

  return { includeAll, singleUrl };
}

async function main(): Promise<void> {
  const { includeAll, singleUrl } = parseArgs(process.argv);

  let targets: ScrapeTarget[];
  if (singleUrl) {
    targets = [{ url: singleUrl, category: 'patterns', priority: 'medium' }];
  } else if (includeAll) {
    targets = SCRAPE_TARGETS;
  } else {
    targets = getHighPriorityTargets();
  }

  console.log(`[scrape] targets: ${targets.length}`);
  console.log(`[scrape] corpus dir: ${CORPUS_DIR}`);
  console.log(`[scrape] rate limit: ${RATE_LIMIT_MS}ms between requests`);
  console.log('');

  let succeeded = 0;
  let failed = 0;

  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    try {
      const thread = await scrapeOne(target);
      const { jsonPath, mdPath } = saveThread(thread);
      updateManifest({
        threadId: thread.threadId,
        title: thread.title,
        sourceUrl: thread.sourceUrl,
        category: target.category,
        scrapedAt: thread.scrapedAt,
        jsonPath,
        mdPath,
        postsCount: thread.postsCount,
      });
      console.log(`[scrape] ✓ ${thread.title} (${thread.postsCount} posts) → ${path.basename(mdPath)}`);
      succeeded++;
    } catch (err) {
      const msg = err instanceof Error ? err.message : String(err);
      console.error(`[scrape] ✗ ${target.url}: ${msg}`);
      failed++;
    }

    // Rate limit between requests (skip after the last one).
    if (i < targets.length - 1) {
      await sleep(RATE_LIMIT_MS);
    }
  }

  console.log('');
  console.log(`[scrape] done. ${succeeded} succeeded, ${failed} failed.`);
  console.log(`[scrape] manifest: ${path.join(POLAXORY_DIR, 'corpus', 'manifest.json')}`);
}

main().catch((err: unknown) => {
  console.error('[scrape] ERROR:', err instanceof Error ? err.message : String(err));
  if (err instanceof Error && err.stack) {
    console.error(err.stack);
  }
  process.exit(1);
});
