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

echo ""
echo "Checking required skills (autonomous-pipeline)..."
for required in skills/autonomous-mode/SKILL.md skills/don-proxy/SKILL.md; do
  if [ ! -s "$required" ]; then
    echo "  FAIL: Missing or empty ${required}"
    FAIL=$((FAIL + 1))
  else
    echo "  OK:   ${required}"
    PASS=$((PASS + 1))
  fi
done

echo ""
echo "Checking required commands..."
for cmd in commands/heist.md commands/go.md commands/abort.md; do
  if [ ! -s "$cmd" ]; then
    echo "  FAIL: Missing or empty ${cmd}"
    FAIL=$((FAIL + 1))
  else
    echo "  OK:   ${cmd}"
    PASS=$((PASS + 1))
  fi
done

echo ""
echo "Checking command frontmatter..."
for cmd in commands/*.md; do
  [ -f "$cmd" ] || continue
  # Must start with --- and contain both name: and description: lines within the frontmatter block (FR-023a)
  if head -1 "$cmd" | grep -q '^---$' \
     && awk '/^---$/{c++; next} c==1 && /^name:[[:space:]]*[^[:space:]]/{found=1; exit} END{exit !found}' "$cmd" \
     && awk '/^---$/{c++; next} c==1 && /^description:[[:space:]]*[^[:space:]]/{found=1; exit} END{exit !found}' "$cmd"; then
    echo "  OK:   ${cmd} frontmatter"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: ${cmd} missing valid frontmatter, name, or description"
    FAIL=$((FAIL + 1))
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

# Summary
echo ""
echo "=================="
echo "Results: ${PASS} passed, ${FAIL} failed"

if [ $FAIL -gt 0 ]; then
  exit 1
fi