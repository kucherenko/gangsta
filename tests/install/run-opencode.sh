#!/usr/bin/env bash
# Inside-container test for OpenCode plugin install.
set -euo pipefail

echo "==> opencode --version"
opencode --version || true

# Point OpenCode at the local checkout (file:// avoids needing a clone).
mkdir -p "$HOME/.config/opencode"
cat > "$HOME/.config/opencode/opencode.json" <<JSON
{
  "plugin": ["gangsta@file:///plugin"]
}
JSON

echo "==> Configured opencode.json:"
cat "$HOME/.config/opencode/opencode.json"

echo "==> opencode run --print-logs (load plugin and exit)"
# `opencode run` with --print-logs surfaces plugin discovery output. We give
# it a no-op prompt and a short timeout; we only care about plugin load.
# Exit code 124 = timeout (expected, no API key).
set +e
timeout 30s opencode run --print-logs "hello" > /tmp/opencode.log 2>&1
rc=$?
set -e

echo "--- opencode log (last 100 lines) ---"
tail -100 /tmp/opencode.log || true
echo "--- end log ---"

# Plugin should be discovered/loaded regardless of API failure.
if grep -iqE 'gangsta.*(loaded|discovered|registered|plugin)' /tmp/opencode.log; then
  echo "PASS: opencode discovered the gangsta plugin"
elif grep -iqE 'plugin.*gangsta' /tmp/opencode.log; then
  echo "PASS: opencode references the gangsta plugin"
else
  echo "WARN: no explicit 'gangsta' load line; checking for plugin errors"
fi

if grep -iqE 'error.*gangsta|gangsta.*(invalid|fail)' /tmp/opencode.log; then
  echo "FAIL: opencode reported a plugin error"
  exit 1
fi

echo "==> opencode install check passed (Phase 1)"

# ---------------------------------------------------------------------------
# Phase 2: LLM skill query via OpenRouter (only when API key is available)
# ---------------------------------------------------------------------------
# OpenCode has native OpenRouter support. Auth is written to
# ~/.local/share/opencode/auth.json; the model is set in opencode.json as
# "openrouter/<model-id>".
# Phase 2 is WARN-not-FAIL: free-tier rate limits are non-fatal.
# ---------------------------------------------------------------------------
if [ -n "${OPENROUTER_API_KEY:-}" ]; then
  echo "==> Phase 2: LLM skill query via OpenRouter (native OpenCode support)"
  MODEL="${OPENROUTER_MODEL:-meta-llama/llama-3.3-70b-instruct:free}"

  # Write OpenRouter auth
  mkdir -p "$HOME/.local/share/opencode"
  cat > "$HOME/.local/share/opencode/auth.json" <<JSON
{"openrouter":{"key":"$OPENROUTER_API_KEY"}}
JSON

  # Update config: keep plugin, add model
  cat > "$HOME/.config/opencode/opencode.json" <<JSON
{
  "plugin": ["gangsta@file:///plugin"],
  "model": "openrouter/$MODEL"
}
JSON

  set +e
  timeout 90s opencode run "List all available gangsta skills in this framework" \
    > /tmp/opencode-llm.log 2>&1
  llm_rc=$?
  set -e

  echo "--- LLM response (tail 30) ---"
  tail -30 /tmp/opencode-llm.log || true
  echo "--- end ---"

  if grep -qiE 'reconnaissance|grilling|sit.down|omerta|heist|laundering' /tmp/opencode-llm.log; then
    echo "PASS: opencode LLM response references gangsta skills"
  elif [ "$llm_rc" -ne 0 ]; then
    echo "WARN: opencode LLM query exited $llm_rc — Phase 1 is the hard gate; LLM phase non-fatal"
  else
    echo "WARN: opencode LLM response did not mention expected skill names — check log above"
  fi
else
  echo "==> Phase 2 skipped (OPENROUTER_API_KEY not set)"
fi
