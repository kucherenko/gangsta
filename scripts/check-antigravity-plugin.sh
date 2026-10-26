#!/usr/bin/env bash
# Checks the Antigravity plugin layout: plugin.json at the repo root, the
# always-on rule in rules/AGENTS.md, that every @[label](path) include in the
# rule resolves, and that the expanded rule stays under Antigravity's 24,000-byte
# per-rule cap (rules are truncated silently beyond it). When the `agy` CLI is
# installed, its own validator runs as well.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RULE="$ROOT/rules/AGENTS.md"
RULE_CAP=24000
status=0

ok()   { echo "  OK:   $1"; }
fail() { echo "  FAIL: $1"; status=1; }

# plugin.json: must parse and name the plugin "gangsta". Field set is left to agy.
if [ ! -s "$ROOT/plugin.json" ]; then
  fail "plugin.json missing"
elif command -v node >/dev/null 2>&1; then
  if node -e 'const m = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8")); if (m.name !== "gangsta") process.exit(1)' "$ROOT/plugin.json" 2>/dev/null; then
    ok "plugin.json (name: gangsta)"
  else
    fail "plugin.json does not parse or name is not gangsta"
  fi
else
  echo "  SKIP: node not found (plugin.json not parsed)"
fi

# rules/AGENTS.md: present, includes resolve, expanded size under the cap.
if [ ! -s "$RULE" ]; then
  fail "rules/AGENTS.md missing"
else
  expanded=$(wc -c < "$RULE")
  while IFS= read -r target; do
    [ -z "$target" ] && continue
    file="$(dirname "$RULE")/$target"
    if [ -f "$file" ]; then
      ok "rule include resolves: $target"
      expanded=$((expanded + $(wc -c < "$file")))
    else
      fail "rule include missing: $target"
    fi
  done < <(grep -oE '@\[[^]]+\]\([^)]+\)' "$RULE" | sed -E 's/^@\[[^]]+\]\(([^)]+)\)$/\1/')
  if [ "$expanded" -lt "$RULE_CAP" ]; then
    ok "rule expands to ${expanded} bytes (cap ${RULE_CAP})"
  else
    fail "rule expands to ${expanded} bytes, over Antigravity's ${RULE_CAP}-byte cap"
  fi
fi

# agy's own validator, when available.
if command -v agy >/dev/null 2>&1 && command -v node >/dev/null 2>&1; then
  if agy plugin validate "$ROOT" --json > /tmp/agy-validate.json 2>/dev/null \
     && node -e '
       const r = JSON.parse(require("fs").readFileSync("/tmp/agy-validate.json", "utf8"));
       const errors = (r.findings || []).filter((f) => f.severity === "error");
       if (errors.length) { console.error(JSON.stringify(errors)); process.exit(1); }
       const c = r.components || {};
       if (!(c.skills >= 5 && c.agents === 6 && c.rules === 1)) { console.error(JSON.stringify(c)); process.exit(1); }
       console.log(`  OK:   agy plugin validate (skills ${c.skills}, agents ${c.agents}, rules ${c.rules})`);
     '; then
    :
  else
    fail "agy plugin validate reported errors or unexpected component counts"
  fi
else
  echo "  SKIP: agy not found (plugin validator not run)"
fi

exit $status
