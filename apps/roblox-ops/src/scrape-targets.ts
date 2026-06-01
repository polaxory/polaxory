/**
 * Canonical scrape targets for the DevForum scraper.
 *
 * Add or remove threads here. Priority hint (high/medium/low) affects whether
 * the thread runs on a basic invocation or only with --include-all.
 *
 * Source: docs/ROBLOX-SCRIPTING-SOURCES.md §"Canonical threads to scrape first"
 */

export interface ScrapeTarget {
  /** Full thread URL. The scraper converts to .json automatically. */
  url: string;
  /** Topical category for corpus organization. */
  category:
    | 'roadmap'
    | 'reference'
    | 'advanced'
    | 'beginner'
    | 'libraries'
    | 'patterns'
    | 'open-cloud';
  /** Priority hint for the scraper. */
  priority: 'high' | 'medium' | 'low';
  /** Optional human-readable note. */
  notes?: string;
}

export const SCRAPE_TARGETS: ScrapeTarget[] = [
  // Roadmap and meta-references
  {
    url: 'https://devforum.roblox.com/t/roblox-scripting-roadmap-learning-resource-list/808430',
    category: 'roadmap',
    priority: 'high',
    notes: 'Canonical learning path. Beginner → intermediate → advanced organized.',
  },

  // Comprehensive references
  {
    url: 'https://devforum.roblox.com/t/scripting-manual/3051404',
    category: 'reference',
    priority: 'high',
    notes: 'Covers Lua basics, Roblox API, instances, event handling, CFrames, filtering.',
  },

  // Advanced
  {
    url: 'https://devforum.roblox.com/t/advanced-scripting-tutorial/3511460',
    category: 'advanced',
    priority: 'high',
    notes: 'ModuleScripts, code organization, metatables, OOP. By Ideal.',
  },
  {
    url: 'https://devforum.roblox.com/t/advanced-scripting-tutorial-part-2/3541190',
    category: 'advanced',
    priority: 'high',
    notes: 'Optimization techniques and concept-based methods.',
  },
  {
    url: 'https://devforum.roblox.com/t/advanced-scripting-techniques/4448705',
    category: 'advanced',
    priority: 'medium',
  },

  // Beginner
  {
    url: 'https://devforum.roblox.com/t/learn-to-script-learn-to-code-in-5-steps/1043259',
    category: 'beginner',
    priority: 'high',
  },
  {
    url: 'https://devforum.roblox.com/t/guide-on-the-basics-of-scripting/619443',
    category: 'beginner',
    priority: 'high',
  },
  {
    url: 'https://devforum.roblox.com/t/guide-into-roblox-scripting-1/3682495',
    category: 'beginner',
    priority: 'medium',
  },

  // Libraries
  {
    url: 'https://devforum.roblox.com/t/luau-libraries-available-for-use/2692468',
    category: 'libraries',
    priority: 'high',
    notes: 'Curated list of community libraries with usage notes.',
  },

  // Open Cloud
  {
    url: 'https://devforum.roblox.com/t/programmatically-update-configs-the-open-cloud-configs-api/4509549',
    category: 'open-cloud',
    priority: 'high',
    notes: 'Configs API announcement. Direct relevance to RobloxOps deploy pipeline.',
  },
  {
    url: 'https://devforum.roblox.com/t/new-open-cloud-apis-for-configuring-developer-products-and-game-passes/4114297',
    category: 'open-cloud',
    priority: 'medium',
    notes: 'Dev products + game passes via Open Cloud.',
  },
  {
    url: 'https://devforum.roblox.com/t/your-brand-new-cloud-api-reference-documentation-is-here/4139597',
    category: 'open-cloud',
    priority: 'medium',
  },
];

export function getHighPriorityTargets(): ScrapeTarget[] {
  return SCRAPE_TARGETS.filter((t) => t.priority === 'high');
}
