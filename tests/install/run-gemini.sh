#!/usr/bin/env bash
# Inside-container test for Gemini CLI extension install.
set -euo pipefail

echo "==> gemini --version"
gemini --version || true

echo "==> gemini extensions install /plugin (local path)"
# Gemini supports installing from a local path. This goes through the same
# manifest validation that the documented `git+https://...` install uses.
if gemini extensions install /plugin 2>&1 | tee /tmp/gemini-install.log; then
  echo "PASS: extension install completed"
else
  echo "FAIL: extension install rejected the manifest"
  exit 1
fi

echo "==> gemini extensions list"
if gemini extensions list 2>&1 | tee /tmp/gemini-list.log; then
  if grep -qi gangsta /tmp/gemini-list.log; then
    echo "PASS: gangsta extension is listed"
  else
    echo "FAIL: gangsta not in extensions list"
    exit 1
  fi
else
  echo "FAIL: gemini extensions list failed"
  exit 1
fi

echo "==> Gemini extension install check passed"
