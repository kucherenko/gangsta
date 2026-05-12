#!/usr/bin/env bash
# Inside-container test for Claude Code plugin install.
# The plugin source is mounted at /plugin (cwd).
set -euo pipefail

echo "==> claude --version"
claude --version || true

echo "==> claude plugin validate ./"
# Some Claude Code versions name the subcommand 'plugin', some 'plugins'.
# Try both before declaring failure.
if claude plugin validate ./ 2>&1; then
  echo "PASS: plugin manifest validates"
elif claude plugins validate ./ 2>&1; then
  echo "PASS: plugin manifest validates (via 'plugins' alias)"
else
  echo "FAIL: claude plugin validate rejected the manifest"
  exit 1
fi

echo "==> claude --plugin-dir ./ --init-only (loads plugin, fires SessionStart, exits)"
# --init-only runs setup + SessionStart hooks and exits without a conversation,
# so it doesn't require API auth. If the manifest is malformed, this aborts.
if claude --plugin-dir ./ --init-only 2>&1 | tee /tmp/init.log; then
  echo "PASS: claude loaded the plugin without errors"
else
  echo "FAIL: claude --plugin-dir aborted"
  exit 1
fi

if grep -qiE 'invalid|validation error|failed to' /tmp/init.log; then
  echo "FAIL: error keywords in plugin-load output"
  exit 1
fi

echo "==> All Claude Code install checks passed (Phase 1)"

# ---------------------------------------------------------------------------
# Phase 2: LLM skill query via OpenRouter (only when API key is available)
# ---------------------------------------------------------------------------
# Claude Code proxies through OpenRouter by pointing ANTHROPIC_BASE_URL at the
# Anthropic-compatible endpoint OpenRouter exposes at /api/v1.
# ANTHROPIC_API_KEY is set to the OpenRouter key.
# The model name is passed as-is; OpenRouter routes it.
# Phase 2 is WARN-not-FAIL: free-tier rate limits or model-name validation
# failures don't break the hard Phase 1 gate.
# ---------------------------------------------------------------------------
if [ -n "${OPENROUTER_API_KEY:-}" ]; then
  echo "==> Phase 2: LLM skill query via OpenRouter"
  MODEL="${OPENROUTER_MODEL:-meta-llama/llama-3.3-70b-instruct:free}"
  set +e
  ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1 \
  ANTHROPIC_API_KEY="$OPENROUTER_API_KEY" \
  timeout 90s claude -p \
    --plugin-dir /plugin \
    --model "$MODEL" \
    --max-turns 1 \
    "List all available gangsta skills in this framework" \
    > /tmp/claude-llm.log 2>&1
  llm_rc=$?
  set -e

  echo "--- LLM response (tail 30) ---"
  tail -30 /tmp/claude-llm.log || true
  echo "--- end ---"

  if grep -qiE 'reconnaissance|grilling|sit.down|omerta|heist|laundering' /tmp/claude-llm.log; then
    echo "PASS: LLM response references gangsta skills"
  elif [ "$llm_rc" -ne 0 ]; then
    echo "WARN: LLM query exited $llm_rc — Phase 1 is the hard gate; LLM phase non-fatal"
  else
    echo "WARN: LLM response did not mention expected skill names — check log above"
  fi
else
  echo "==> Phase 2 skipped (OPENROUTER_API_KEY not set)"
fi
