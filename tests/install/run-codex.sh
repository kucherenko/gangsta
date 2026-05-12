#!/usr/bin/env bash
# Codex install per .codex/INSTALL.md (clone + symlink).
# The repo is mounted at /plugin; we simulate ~/.gangsta with a copy so the
# symlink target matches the documented path.
set -euo pipefail

mkdir -p "$HOME/.gangsta"
cp -r /plugin/. "$HOME/.gangsta/"

mkdir -p "$HOME/.agents/skills"
ln -sf "$HOME/.gangsta/skills" "$HOME/.agents/skills/gangsta"

# Assertions: symlink exists, resolves, and at least one SKILL.md is reachable.
test -L "$HOME/.agents/skills/gangsta" \
  || { echo "FAIL: symlink not created"; exit 1; }

test -d "$HOME/.agents/skills/gangsta/" \
  || { echo "FAIL: symlink does not resolve to a directory"; exit 1; }

count=$(find -L "$HOME/.agents/skills/gangsta" -name SKILL.md | wc -l)
if [ "$count" -lt 5 ]; then
  echo "FAIL: expected at least 5 SKILL.md files, found $count"
  exit 1
fi

echo "PASS: Codex install reachable; $count SKILL.md files discoverable"

# ---------------------------------------------------------------------------
# Phase 2: LLM skill query via Codex CLI + OpenRouter (optional)
# ---------------------------------------------------------------------------
# The Codex CLI (@openai/codex) supports OPENAI_BASE_URL + OPENAI_API_KEY for
# custom endpoints. OpenRouter accepts these and routes to any free model.
# The CLI is run from /plugin (CWD) so it picks up AGENTS.md, giving it the
# full gangsta framework instructions as its system context.
# Phase 2 is WARN-not-FAIL: free-tier rate limits are non-fatal.
# ---------------------------------------------------------------------------
if [ -n "${OPENROUTER_API_KEY:-}" ]; then
  echo "==> Phase 2: LLM skill query via Codex CLI + OpenRouter"
  MODEL="${OPENROUTER_MODEL:-meta-llama/llama-3.3-70b-instruct:free}"

  set +e
  OPENAI_API_KEY="$OPENROUTER_API_KEY" \
  OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
  timeout 90s codex \
    --model "$MODEL" \
    --approval-mode full-auto \
    "What gangsta skills are available in this framework? List them by name." \
    > /tmp/codex-llm.log 2>&1
  llm_rc=$?
  set -e

  echo "--- LLM response (tail 30) ---"
  tail -30 /tmp/codex-llm.log || true
  echo "--- end ---"

  if grep -qiE 'reconnaissance|grilling|sit.down|omerta|heist|laundering' /tmp/codex-llm.log; then
    echo "PASS: Codex LLM response references gangsta skills"
  elif [ "$llm_rc" -ne 0 ]; then
    echo "WARN: Codex LLM query exited $llm_rc — Phase 1 is the hard gate; LLM phase non-fatal"
  else
    echo "WARN: Codex LLM response did not mention expected skill names — check log above"
  fi
else
  echo "==> Phase 2 skipped (OPENROUTER_API_KEY not set)"
fi
