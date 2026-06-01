# ROBLOX-SCRIPTING-SOURCES.md

> Curated catalog of sources for Roblox / Luau scripting knowledge.
> RobloxOps' perception layer pulls from these when generating wave attempts.
> 2026-05-31 snapshot. Refresh quarterly or when major sources shift.

---

## Operating principle

The agent's Luau generation is only as good as the corpus it can retrieve from. Native LLM knowledge is broad but shallow on Roblox-specifics; a curated corpus of canonical patterns is what produces production-quality scripts.

**Three rules for inclusion:**

1. **Openly accessible.** Public docs, public forums, public repos. No paywall-bypassing.
2. **Acceptable license.** Anything we ingest must be either public domain, openly licensed (MIT / Apache / CC-BY / CC-SA), or fair-use referenceable.
3. **Brand-compatible.** No exploit / cheat / bypass content. Brand violation is non-negotiable.

---

## Tier 1 — primary sources (scrape and index)

### Roblox Creator Docs

- **URL:** `https://create.roblox.com/docs`
- **What:** Official documentation — Luau language reference, Studio API, Open Cloud API, services, classes, design patterns
- **Why:** Canonical. The factual source for API behavior. If a script disagrees with the docs, the docs win.
- **License:** Roblox-owned but publicly accessible; factual API documentation is referenceable.
- **Scrape approach:** Site is structured; sitemap available. Crawl from sitemap, parse Markdown-rendered content.
- **Priority:** High. This is the spine of the corpus.

### Roblox Developer Forum (DevForum)

- **URL:** `https://devforum.roblox.com`
- **What:** Discourse-based forum with Community Tutorials, Scripting Support, Resources categories. Peer-reviewed by senior Roblox devs.
- **Why:** Where the actual production wisdom lives. Patterns, edge cases, idioms, "why X doesn't work the way you think it does."
- **License:** User-posted content; Discourse typically CC-licensed but each post is by its author. Reasonable referencing is standard practice.
- **Scrape approach:** **Discourse JSON API.** Append `.json` to any thread URL. Clean structured data, no HTML parsing required. Rate-limit politely (1 req/sec).
- **Priority:** High. Highest-quality community corpus.

#### Canonical threads to scrape first

| Thread ID | Title | Category | Priority |
|---|---|---|---|
| 808430 | Roblox Scripting Roadmap & Learning Resource List | roadmap | high |
| 3051404 | Scripting Manual | reference | high |
| 3511460 | Advanced Scripting Tutorial | advanced | high |
| 3541190 | Advanced Scripting Tutorial — Part 2 | advanced | high |
| 1043259 | Learn to Script / Learn to Code in 5 Steps | beginner | high |
| 619443 | Guide on the basics of scripting | beginner | high |
| 3682495 | Guide into Roblox Scripting 1 | beginner | medium |
| 2692468 | Luau Libraries available for use | libraries | high |
| 4448705 | Advanced Scripting Techniques | advanced | medium |

These are the canonical reference threads. Each gets pulled, parsed, indexed.

### Luau official docs + GitHub

- **URLs:** `https://luau.org` and `https://github.com/luau-lang/luau`
- **What:** Language documentation and MIT-licensed reference implementation.
- **Why:** Definitive Luau language reference. Strict, well-typed.
- **License:** MIT. Use freely.
- **Scrape approach:** Pull docs from `luau.org/getting-started/`, `luau.org/syntax/`, etc. Pull READMEs and example dirs from GitHub via API.
- **Priority:** High for language fundamentals.

### Scythe-Technology/luau-roblox

- **URL:** `https://github.com/Scythe-Technology/luau-roblox`
- **What:** Open-source library for manipulating Roblox place/model files (`.rbxlx`, `.rbxm`).
- **Why:** Critical for RobloxOps' production step — programmatic `.rbxlx` generation needs this primitive.
- **License:** Check repo; likely MIT.
- **Scrape approach:** Clone or pull via GitHub API. Parse source files.
- **Priority:** High.

### BloxBot

- **URLs:** `https://www.bloxbot.ai/` and `https://github.com/paralov/app-bloxbot-ai`
- **What:** Open-source AI-to-Roblox-Studio bridge via MCP.
- **Why:** Already in the stack per ROBLOXOPS.md. Reference for how production-quality Luau-via-LLM is structured.
- **License:** MIT.
- **Scrape approach:** Pull source. Study the prompt patterns and code-generation conventions.
- **Priority:** Medium (already known; reference for our own implementation).

---

## Tier 2 — secondary references (cite, link, don't bulk-ingest)

### ScriptingHelpers.org

- **URL:** `https://scriptinghelpers.org`
- **What:** Stack-Overflow-style Q&A for Roblox/Luau.
- **Why:** Specific bug solutions, edge cases, "why doesn't my code work" answers.
- **License:** Standard Q&A site; author-attributed content.
- **Scrape approach:** HTML parsing required (no clean API). Lower priority for bulk; query on-demand.
- **Priority:** Medium. Pull as-needed during specific generation tasks.

### Suphi Kaner YouTube tutorials

- **URL:** YouTube channel; specific videos referenced in DevForum scripting roadmap.
- **What:** Intermediate-level Luau tutorial videos. DevForum-canonical.
- **Why:** Best video corpus for intermediate patterns.
- **License:** Video content; transcripts may be auto-generated by YouTube and accessible.
- **Scrape approach:** YouTube transcript API or yt-dlp for transcripts. Original video copyright remains with creator.
- **Priority:** Medium. Transcript ingestion is reasonable; full video re-publishing is not.

### Roblox official "Coding with Roblox Lua in 24 Hours"

- **What:** Official Roblox-branded learning book.
- **Why:** Curated curriculum from beginner to deployable scripts.
- **License:** Copyrighted publication; cannot ingest directly.
- **Scrape approach:** Reference structure and ToC publicly; do not scrape body.
- **Priority:** Low for ingestion; high for understanding the canonical learning order.

### BoundDev, GameDev Academy, CodaKid, Obby.fun tutorial blogs

- **What:** Various tutorial sites covering Luau patterns.
- **Why:** Reasonable supplementary content.
- **License:** Varies; some CC-licensed, most copyrighted but referenceable.
- **Scrape approach:** Avoid bulk scraping. Cite specific tutorials when relevant.
- **Priority:** Low. Tier 1 sources are denser and higher quality.

---

## Tier 3 — explicitly avoid

These sources host exploits, bypasses, cheats, or content that would violate Polaxory's brand and Roblox's TOS. **Never scrape, never reference, never cite.**

- **Arceus X** (`arceusx.com`) — exploit hub
- **ScriptBlox** — exploit script repository
- **RScripts**, **PasteAndPlay**, **WeAreDevs**, **Synapse X** sites
- Any "free script hub" that hosts bypass / cheating / exploit tools
- Discord servers focused on exploits

Inclusion in this list is permanent. Discovering a source belongs in Tier 3 is itself a kill signal — do not revisit.

---

## Scrape protocol (when running the scraper)

1. **Rate limit.** 1 request per second to any host. Be a polite citizen.
2. **Identify the agent.** Set `User-Agent: polaxory-perception-layer/0.1 (https://polaxory.example.com)`. Even though we're early, identify honestly.
3. **Cache aggressively.** Don't re-fetch on every run. Local cache with TTL.
4. **Preserve attribution.** Every piece of ingested content keeps `author`, `source URL`, `timestamp`. The corpus is a citation index, not a data lake.
5. **Respect robots.txt.** Check it before scraping any new host. Honor disallows.
6. **Strip thoughtfully.** HTML → text conversion preserves structure where it matters (code blocks especially). Don't lose the type system annotations in Luau examples.
7. **Log what was pulled.** Every scrape run produces a manifest: source, count, errors.

---

## Corpus structure (where the scraped content lives)

```
/Users/blake.jaraczeski/polaxory/corpus/
├── roblox-creator-docs/      ← scraped from create.roblox.com/docs
├── devforum/                 ← scraped from devforum.roblox.com (Discourse JSON)
│   ├── threads/{thread_id}.json   ← raw structured data
│   └── threads/{thread_id}.md     ← rendered for human/agent reading
├── luau-lang/                ← from luau.org + github.com/luau-lang/luau
├── github-libs/              ← from open-source Luau libraries (Scythe-Technology, BloxBot, etc.)
└── manifest.json             ← what's been scraped, when, from where
```

The corpus is not in git (gitignored). Each surface that needs Luau knowledge can retrieve from it via embedding search or path-based lookup.

---

## Maintenance

- Quarterly: re-scrape Tier 1 sources to capture updates
- When a new wave attempt requires unfamiliar patterns: scrape on-demand from Tier 2
- When discovering a new Tier 1 candidate: evaluate against the three rules; if it passes, add here
- When discovering Tier 3 content (exploit / bypass / etc.): add to the avoid list, never revisit

The corpus is the perception layer's memory. Keep it clean.
