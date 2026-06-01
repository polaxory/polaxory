#!/usr/bin/env bash
# git-microcommit: AI-assisted frequent commits for Claude Code + gstack loops.
#
# Usage:
#   scripts/git-microcommit.sh
#
# Captures the staged diff (or auto-stages everything if nothing is staged),
# asks an LLM for a one-line imperative commit message under 60 chars,
# falls back to a simple semantic message if the LLM call fails,
# and commits.
#
# Karpathy Guidelines applied to the message:
#   - imperative present tense
#   - <= 60 characters
#   - plain string output, no markdown

set -e

# 1. Ensure we are in a Git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "❌ Error: Not a git repository."
  exit 1
fi

# 2. Capture staged changes; if none, check for unstaged and prompt to stage
STAGED_DIFF=$(git diff --cached)
if [ -z "$STAGED_DIFF" ]; then
  UNSTAGED_DIFF=$(git diff)
  if [ -z "$UNSTAGED_DIFF" ]; then
    echo "✨ Nothing changed. Clean working tree."
    exit 0
  fi
  echo "⚠️ No staged changes found. Staging all current modifications..."
  git add -A
  STAGED_DIFF=$(git diff --cached)
fi

# 3. Formulate the prompt using Karpathy simplicity rules
PROMPT="You are an expert release engineer following the Karpathy Guidelines.
Review the following Git diff and generate a concise, one-line commit message.
- Use imperative present tense (e.g., 'fix bug', 'add test', 'refactor parsing').
- Keep it under 60 characters.
- Strictly output ONLY the commit message string, no quotes, no markdown, no explanation.

GIT DIFF:
$STAGED_DIFF"

# 4. Invoke the underlying fast model. Adjust command if you use a custom wrapper.
echo "🤖 Generating atomic commit message..."
COMMIT_MSG=$(echo "$PROMPT" | claude commit --prompt-stdin 2>/dev/null || true)

# Fallback: simple semantic message based on changed files
if [ -z "$COMMIT_MSG" ] || [[ "$COMMIT_MSG" == *"Error"* ]]; then
  CHANGED_FILES=$(git diff --cached --name-only | tr '\n' ',' | sed 's/,$//')
  COMMIT_MSG="microcommit: update $CHANGED_FILES"
fi

# Clean up unexpected markdown wrappers from the LLM output
COMMIT_MSG=$(echo "$COMMIT_MSG" | sed -e 's/^"//' -e 's/"$//' -e 's/^`//' -e 's/`$//')

# 5. Execute the atomic commit
echo "📝 Committing: \"$COMMIT_MSG\""
if git commit -m "$COMMIT_MSG"; then
  echo "✅ Successfully committed!"
  echo "🚀 Run 'gstack /review' or 'gstack /qa' next to validate your stack."
else
  echo "❌ Git commit failed."
  exit 1
fi
