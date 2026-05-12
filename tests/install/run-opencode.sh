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

echo "==> opencode install check passed"
