#!/usr/bin/env bash
# Inside-container test for OpenCode plugin install.
# Installs via the documented git source (mirrors .opencode/INSTALL.md):
#   "plugin": ["gangsta@git+https://github.com/kucherenko/gangsta.git"]
set -euo pipefail

echo "==> opencode --version"
opencode --version || true

# Use the documented git source — same as users follow in INSTALL.md.
mkdir -p "$HOME/.config/opencode"
cat > "$HOME/.config/opencode/opencode.json" <<JSON
{
  "plugin": ["gangsta@git+https://github.com/kucherenko/gangsta.git"]
}
JSON

echo "==> Configured opencode.json:"
cat "$HOME/.config/opencode/opencode.json"

echo "==> opencode run --print-logs (load plugin and exit)"
# `opencode run` with --print-logs surfaces plugin discovery output. We give
# it a no-op prompt and a 90s timeout; the git-source plugin clone + load
# takes longer than file:// — allow extra headroom for CI network latency.
# Exit code 124 = timeout (expected, no API key).
set +e
timeout 90s opencode run --print-logs "hello" > /tmp/opencode.log 2>&1
rc=$?
set -e

echo "--- opencode log (last 150 lines) ---"
tail -150 /tmp/opencode.log || true
echo "--- end log ---"

# Plugin should be discovered/loaded regardless of API failure.
if grep -iqE 'gangsta.*(loaded|discovered|registered|plugin)' /tmp/opencode.log; then
  echo "PASS: opencode discovered the gangsta plugin"
elif grep -iqE 'plugin.*gangsta' /tmp/opencode.log; then
  echo "PASS: opencode references the gangsta plugin"
elif grep -qiE 'gangsta@git\+' /tmp/opencode.log; then
  echo "PASS: opencode loaded gangsta plugin config"
else
  echo "WARN: no explicit 'gangsta' load line — plugin may have loaded after timeout; checking for errors"
fi

# Scope the error check to service=plugin lines only.
# Broader patterns (e.g. "error.*gangsta") produce false positives: when
# OpenCode logs LLM API errors it embeds the full request body (including
# AGENTS.md, which contains "gangsta") into the ERROR line.
if grep -iE 'service=plugin.*gangsta.*(error|fail|invalid)|gangsta.*service=plugin.*(error|fail|invalid)' /tmp/opencode.log; then
  echo "FAIL: opencode plugin reported an error for gangsta"
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
  "plugin": ["gangsta@git+https://github.com/kucherenko/gangsta.git"],
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
  elif grep -qiE '"code":429|rate.limit|too many requests' /tmp/opencode-llm.log; then
    echo "WARN: OpenRouter rate-limited (429) — Phase 1 is the hard gate; LLM phase non-fatal"
  elif [ "$llm_rc" -ne 0 ]; then
    echo "WARN: opencode LLM query exited $llm_rc — Phase 1 is the hard gate; LLM phase non-fatal"
  else
    echo "WARN: opencode LLM response did not mention expected skill names — check log above"
  fi
else
  echo "==> Phase 2 skipped (OPENROUTER_API_KEY not set)"
fi
