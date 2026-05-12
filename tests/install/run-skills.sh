#!/usr/bin/env bash
# skills CLI install test (npx skills add kucherenko/gangsta).
# The repo is mounted read-only at /plugin; we install from the local path to
# avoid a network dependency on GitHub in CI.
#
# Agents under test: cursor and claude-code (representative sample).
# Both are installed globally so paths are deterministic regardless of CWD.
#
# Cursor global path: ~/.agents/skills/ (shared agents dir used by skills CLI)
# Claude Code global path: ~/.claude/skills/
set -euo pipefail

REPO=/plugin
CURSOR_SKILLS="$HOME/.agents/skills"   # skills CLI installs cursor here globally
CLAUDE_SKILLS="$HOME/.claude/skills"
MIN_SKILLS=5

echo "=== Phase 1: skills CLI install ==="

skills add "$REPO" --global -a cursor -a claude-code -y --copy \
  2>&1 | tee /tmp/skills-output.txt

echo "--- skills add output (tail 20) ---"
tail -20 /tmp/skills-output.txt || true
echo "--- end ---"

# Assert cursor skills installed
if [ -d "$CURSOR_SKILLS" ]; then
  count=$(find "$CURSOR_SKILLS" -name SKILL.md | wc -l | tr -d ' ')
  if [ "$count" -ge "$MIN_SKILLS" ]; then
    echo "PASS: cursor — $count SKILL.md files installed to $CURSOR_SKILLS"
  else
    echo "FAIL: cursor — expected at least $MIN_SKILLS SKILL.md files, found $count"
    exit 1
  fi
else
  echo "FAIL: cursor skills directory not created: $CURSOR_SKILLS"
  exit 1
fi

# Assert claude-code skills installed
if [ -d "$CLAUDE_SKILLS" ]; then
  count=$(find "$CLAUDE_SKILLS" -name SKILL.md | wc -l | tr -d ' ')
  if [ "$count" -ge "$MIN_SKILLS" ]; then
    echo "PASS: claude-code — $count SKILL.md files installed to $CLAUDE_SKILLS"
  else
    echo "FAIL: claude-code — expected at least $MIN_SKILLS SKILL.md files, found $count"
    exit 1
  fi
else
  echo "FAIL: claude-code skills directory not created: $CLAUDE_SKILLS"
  exit 1
fi

echo "=== Phase 1: PASS ==="

# ---------------------------------------------------------------------------
# Phase 2: LLM skill query via OpenRouter (optional)
# ---------------------------------------------------------------------------
# Phase 2 is WARN-not-FAIL: free-tier rate limits are non-fatal.
# ---------------------------------------------------------------------------
if [ -n "${OPENROUTER_API_KEY:-}" ]; then
  echo "==> Phase 2: LLM skill query via OpenRouter (Node.js direct call)"
  MODEL="${OPENROUTER_MODEL:-meta-llama/llama-3.3-70b-instruct:free}"

  set +e
  node - <<NODEJS > /tmp/skills-llm.log 2>&1
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
  tail -30 /tmp/skills-llm.log || true
  echo "--- end ---"

  if grep -qiE 'reconnaissance|grilling|sit.down|omerta|heist|laundering' /tmp/skills-llm.log; then
    echo "PASS: LLM response references gangsta skills"
  elif grep -qiE '"code":429|rate.limit|too many requests' /tmp/skills-llm.log; then
    echo "WARN: OpenRouter rate-limited (429) — Phase 1 is the hard gate; LLM phase non-fatal"
  elif [ "$llm_rc" -ne 0 ]; then
    echo "WARN: LLM query exited $llm_rc — Phase 1 is the hard gate; LLM phase non-fatal"
  else
    echo "WARN: LLM response did not mention expected skill names — check log above"
  fi
else
  echo "==> Phase 2 skipped (OPENROUTER_API_KEY not set)"
fi
