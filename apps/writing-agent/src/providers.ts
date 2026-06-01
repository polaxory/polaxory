/**
 * Provider abstraction for Polaxory's inference layer.
 *
 * Per POLAXORY-STACK.md: "Layer the inference. Don't unify it."
 * This module is the layer. Each provider is a profile. Profiles only
 * activate if their API key is set — missing keys skip silently, so the
 * comparison harness adapts to whatever Blake has configured.
 *
 * Anthropic uses its native SDK (better system-prompt and content-block
 * support). Everything else uses the OpenAI SDK with a custom baseURL —
 * most providers (Groq, Mistral, DeepSeek, Gemini via OpenAI-compatible
 * endpoint) expose OpenAI-compatible APIs.
 *
 * Model names below are approximations for mid-2026. Update freely as
 * vendors release new versions — that's why they're config, not constants.
 */

import Anthropic from '@anthropic-ai/sdk';
import OpenAI from 'openai';

// ── Types ──────────────────────────────────────────────────────────────────

export type ProviderType = 'anthropic' | 'openai-compatible';

export interface ProviderProfile {
  /** Short name used to select this profile (e.g., 'claude-sonnet', 'groq-llama'). */
  name: string;
  /** Which SDK path to use. */
  provider: ProviderType;
  /** Model identifier as the provider expects it. */
  model: string;
  /** OpenAI-compatible baseURL override (undefined for native Anthropic). */
  baseURL?: string;
  /** Environment variable name to read the API key from. */
  apiKeyEnvVar: string;
  /** Human-readable description for logs and CLI help. */
  description: string;
  /** Indicative tier — informational only, used for sorting in comparison output. */
  tier: 'premium' | 'mid' | 'cheap';
}

export interface GenerationParams {
  systemPrompt: string;
  userPrompt: string;
  maxTokens: number;
}

export interface GenerationResult {
  content: string;
  inputTokens: number;
  outputTokens: number;
  model: string;
  profile: string;
  elapsedMs: number;
}

// ── Profile registry ───────────────────────────────────────────────────────

/**
 * Registered provider profiles. Add or modify here.
 * A profile only activates at runtime if its apiKeyEnvVar is set.
 */
export const PROFILES: ProviderProfile[] = [
  {
    name: 'claude-sonnet',
    provider: 'anthropic',
    model: 'claude-sonnet-4-5',
    apiKeyEnvVar: 'ANTHROPIC_API_KEY',
    description: 'Claude Sonnet 4.5 — high-stakes voice work',
    tier: 'premium',
  },
  {
    name: 'claude-haiku',
    provider: 'anthropic',
    model: 'claude-haiku-4-5',
    apiKeyEnvVar: 'ANTHROPIC_API_KEY',
    description: 'Claude Haiku 4.5 — fast Anthropic, good for security gate',
    tier: 'mid',
  },
  {
    name: 'groq-llama',
    provider: 'openai-compatible',
    model: 'llama-3.3-70b-versatile',
    baseURL: 'https://api.groq.com/openai/v1',
    apiKeyEnvVar: 'GROQ_API_KEY',
    description: 'Groq Llama 3.3 70B — fast, very cheap (~$0.06/M tokens)',
    tier: 'cheap',
  },
  {
    name: 'mistral-large',
    provider: 'openai-compatible',
    model: 'mistral-large-latest',
    baseURL: 'https://api.mistral.ai/v1',
    apiKeyEnvVar: 'MISTRAL_API_KEY',
    description: 'Mistral Large — strong reasoning, moderate cost',
    tier: 'mid',
  },
  {
    name: 'mistral-small',
    provider: 'openai-compatible',
    model: 'mistral-small-latest',
    baseURL: 'https://api.mistral.ai/v1',
    apiKeyEnvVar: 'MISTRAL_API_KEY',
    description: 'Mistral Small — cheap routine work (~$0.10/M tokens)',
    tier: 'cheap',
  },
  {
    name: 'deepseek-chat',
    provider: 'openai-compatible',
    model: 'deepseek-chat',
    baseURL: 'https://api.deepseek.com/v1',
    apiKeyEnvVar: 'DEEPSEEK_API_KEY',
    description: 'DeepSeek V3 — strong reasoning, cheap (~$0.27/M tokens)',
    tier: 'cheap',
  },
  {
    name: 'gemini-flash',
    provider: 'openai-compatible',
    model: 'gemini-2.0-flash',
    baseURL: 'https://generativelanguage.googleapis.com/v1beta/openai',
    apiKeyEnvVar: 'GEMINI_API_KEY',
    description: 'Gemini 2.0 Flash — cheap, fast (~$0.10/$0.40 per M tokens)',
    tier: 'cheap',
  },
];

// ── Profile selection ──────────────────────────────────────────────────────

export function getProfile(name: string): ProviderProfile | undefined {
  return PROFILES.find((p) => p.name === name);
}

/**
 * Returns the subset of registered profiles whose API key is currently set
 * in process.env. The comparison harness uses this to skip providers Blake
 * hasn't configured.
 */
export function getAvailableProfiles(): ProviderProfile[] {
  return PROFILES.filter((p) => !!process.env[p.apiKeyEnvVar]);
}

// ── Unified generation ─────────────────────────────────────────────────────

/**
 * Generate via the specified profile. Dispatches to the right SDK based on
 * provider type. Returns content + usage metrics.
 *
 * Errors surface from the underlying SDK — caller handles retry / fallback.
 */
export async function generate(
  profile: ProviderProfile,
  params: GenerationParams,
): Promise<GenerationResult> {
  const apiKey = process.env[profile.apiKeyEnvVar];
  if (!apiKey) {
    throw new Error(
      `API key not set for profile '${profile.name}' ` +
        `(expected env var: ${profile.apiKeyEnvVar})`,
    );
  }

  const startedAt = Date.now();

  if (profile.provider === 'anthropic') {
    const client = new Anthropic({ apiKey });
    const response = await client.messages.create({
      model: profile.model,
      max_tokens: params.maxTokens,
      system: params.systemPrompt,
      messages: [{ role: 'user', content: params.userPrompt }],
    });
    const textBlock = response.content.find((b) => b.type === 'text');
    if (!textBlock || textBlock.type !== 'text') {
      throw new Error(`No text content in ${profile.name} response`);
    }
    return {
      content: textBlock.text.trim(),
      inputTokens: response.usage.input_tokens,
      outputTokens: response.usage.output_tokens,
      model: profile.model,
      profile: profile.name,
      elapsedMs: Date.now() - startedAt,
    };
  }

  // openai-compatible path
  const client = new OpenAI({ apiKey, baseURL: profile.baseURL });
  const response = await client.chat.completions.create({
    model: profile.model,
    max_tokens: params.maxTokens,
    messages: [
      { role: 'system', content: params.systemPrompt },
      { role: 'user', content: params.userPrompt },
    ],
  });
  const choice = response.choices[0];
  if (!choice?.message?.content) {
    throw new Error(`No content in ${profile.name} response`);
  }
  return {
    content: choice.message.content.trim(),
    inputTokens: response.usage?.prompt_tokens ?? 0,
    outputTokens: response.usage?.completion_tokens ?? 0,
    model: profile.model,
    profile: profile.name,
    elapsedMs: Date.now() - startedAt,
  };
}
