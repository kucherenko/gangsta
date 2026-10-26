#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

echo "Gangsta validation"
echo "=================="

# Check skill structure
echo ""
echo "Checking skill structure..."
for dir in skills/*/; do
  if [ ! -f "${dir}SKILL.md" ]; then
    echo "  FAIL: Missing SKILL.md in ${dir}"
    FAIL=$((FAIL + 1))
  else
    echo "  OK:   ${dir}SKILL.md"
    PASS=$((PASS + 1))
  fi
done

# Check CHANGELOG
echo ""
echo "Checking CHANGELOG.md..."
if [ ! -s CHANGELOG.md ]; then
  echo "  FAIL: CHANGELOG.md is missing or empty"
  FAIL=$((FAIL + 1))
else
  echo "  OK:   CHANGELOG.md present"
  PASS=$((PASS + 1))
fi

echo ""
echo "Checking pi.dev extension structure..."
for pi_file in .pi/extensions/gangsta/index.ts \
               .pi/extensions/gangsta/package.json; do
  if [ ! -s "$pi_file" ]; then
    echo "  FAIL: Missing or empty ${pi_file}"
    FAIL=$((FAIL + 1))
  else
    echo "  OK:   ${pi_file}"
    PASS=$((PASS + 1))
  fi
done

# Check Antigravity plugin (plugin.json, rules/AGENTS.md includes and size cap, agy validator)
echo ""
echo "Checking Antigravity plugin..."
if bash scripts/check-antigravity-plugin.sh; then
  PASS=$((PASS + 1))
else
  FAIL=$((FAIL + 1))
fi

# Check OpenCode plugin (V1 + V2 contract, skill/agent registration)
echo ""
echo "Checking OpenCode plugin..."
if command -v node >/dev/null 2>&1; then
  if node scripts/check-opencode-plugin.mjs; then
    PASS=$((PASS + 1))
  else
    FAIL=$((FAIL + 1))
  fi
else
  echo "  SKIP: node not found"
fi

# Summary
echo ""
echo "=================="
echo "Results: ${PASS} passed, ${FAIL} failed"

if [ $FAIL -gt 0 ]; then
  exit 1
fi