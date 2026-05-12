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
# Phase 2: LLM skill query via OpenRouter (optional)
# ---------------------------------------------------------------------------
# @openai/codex uses OpenAI's WebSocket Responses API and does not honour
# OPENAI_BASE_URL, so we cannot route it through OpenRouter. Instead we call
# OpenRouter directly via Node.js (already in the image), passing the first
# 8 KB of AGENTS.md as system context so the model can answer about gangsta.
# Phase 2 is WARN-not-FAIL: free-tier rate limits are non-fatal.
# ---------------------------------------------------------------------------
if [ -n "${OPENROUTER_API_KEY:-}" ]; then
  echo "==> Phase 2: LLM skill query via OpenRouter (Node.js direct call)"
  MODEL="${OPENROUTER_MODEL:-meta-llama/llama-3.3-70b-instruct:free}"

  set +e
  node - <<NODEJS > /tmp/codex-llm.log 2>&1
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
  tail -30 /tmp/codex-llm.log || true
  echo "--- end ---"

  if grep -qiE 'reconnaissance|grilling|sit.down|omerta|heist|laundering' /tmp/codex-llm.log; then
    echo "PASS: Codex LLM response references gangsta skills"
  elif grep -qiE '"code":429|rate.limit|too many requests' /tmp/codex-llm.log; then
    echo "WARN: OpenRouter rate-limited (429) — Phase 1 is the hard gate; LLM phase non-fatal"
  elif [ "$llm_rc" -ne 0 ]; then
    echo "WARN: Codex LLM query exited $llm_rc — Phase 1 is the hard gate; LLM phase non-fatal"
  else
    echo "WARN: LLM response did not mention expected skill names — check log above"
  fi
else
  echo "==> Phase 2 skipped (OPENROUTER_API_KEY not set)"
fi
