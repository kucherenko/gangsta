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

echo "==> All Claude Code install checks passed"
