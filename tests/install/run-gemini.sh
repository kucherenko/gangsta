#!/usr/bin/env bash
# Inside-container test for Gemini CLI extension install.
set -euo pipefail

echo "==> gemini --version"
gemini --version || true

echo "==> gemini extensions install /plugin (local path)"
# Gemini supports installing from a local path. This goes through the same
# manifest validation that the documented `git+https://...` install uses.
# --consent skips the extension security prompt; 'y' piped to stdin answers
# the folder-trust prompt that --consent does not cover.
printf 'y\n' | gemini extensions install /plugin --consent 2>&1 | tee /tmp/gemini-install.log
install_rc=${PIPESTATUS[0]}
if [ "$install_rc" -eq 0 ]; then
  echo "PASS: extension install completed"
else
  echo "FAIL: extension install rejected the manifest (exit $install_rc)"
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

# ---------------------------------------------------------------------------
# Phase 2: LLM skill query — NOT SUPPORTED for Gemini CLI
# ---------------------------------------------------------------------------
# Gemini CLI is tightly coupled to the Google AI API (Gemini models only).
# It does not support OPENAI_BASE_URL, ANTHROPIC_BASE_URL, or any OpenRouter
# routing. There is no documented way to point it at a third-party provider.
#
# Phase 2 is therefore skipped unconditionally for this agent.
# Phase 1 (manifest validation + extension install + list) remains the
# coverage gate for Gemini.
# ---------------------------------------------------------------------------
echo "==> Phase 2 skipped (Gemini CLI does not support OpenRouter; Google AI API only)"
