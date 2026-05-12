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
# `claude -p` validates model names against known Claude identifiers and
# rejects free OpenRouter models (e.g. meta-llama/*). We use Node.js (already
# present in the image) to call the OpenRouter chat completions endpoint
# directly, passing the first 8 KB of AGENTS.md as system context so the LLM
# can answer about gangsta skills.
# Phase 2 is WARN-not-FAIL: free-tier rate limits are non-fatal.
# ---------------------------------------------------------------------------
if [ -n "${OPENROUTER_API_KEY:-}" ]; then
  echo "==> Phase 2: LLM skill query via OpenRouter (Node.js direct call)"
  MODEL="${OPENROUTER_MODEL:-meta-llama/llama-3.3-70b-instruct:free}"
  set +e
  node - <<NODEJS > /tmp/claude-llm.log 2>&1
const https = require('https');
const fs   = require('fs');
const agents = fs.readFileSync('/plugin/AGENTS.md', 'utf8').slice(0, 8000);
const body = JSON.stringify({
  model: process.env.OPENROUTER_MODEL || 'meta-llama/llama-3.3-70b-instruct:free',
  messages: [
    { role: 'system', content: agents },
    { role: 'user',   content: 'List all available gangsta skills by name.' }
  ]
});
const opts = {
  hostname: 'openrouter.ai', path: '/api/v1/chat/completions', method: 'POST',
  headers: {
    'Authorization': 'Bearer ' + process.env.OPENROUTER_API_KEY,
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(body)
  }
};
const req = https.request(opts, (res) => {
  let d = ''; res.on('data', c => d += c); res.on('end', () => process.stdout.write(d));
});
req.on('error', e => { console.error(e.message); process.exit(1); });
req.setTimeout(60000, () => { req.destroy(); console.error('timeout'); process.exit(1); });
req.write(body); req.end();
NODEJS
  llm_rc=$?
  set -e

  echo "--- LLM response (tail 30) ---"
  tail -30 /tmp/claude-llm.log || true
  echo "--- end ---"

  if grep -qiE 'reconnaissance|grilling|sit.down|omerta|heist|laundering' /tmp/claude-llm.log; then
    echo "PASS: LLM response references gangsta skills"
  elif grep -qiE '"code":429|rate.limit|too many requests' /tmp/claude-llm.log; then
    echo "WARN: OpenRouter rate-limited (429) — Phase 1 is the hard gate; LLM phase non-fatal"
  elif [ "$llm_rc" -ne 0 ]; then
    echo "WARN: LLM query exited $llm_rc — Phase 1 is the hard gate; LLM phase non-fatal"
  else
    echo "WARN: LLM response did not mention expected skill names — check log above"
  fi
else
  echo "==> Phase 2 skipped (OPENROUTER_API_KEY not set)"
fi
