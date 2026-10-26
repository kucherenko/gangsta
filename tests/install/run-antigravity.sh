#!/usr/bin/env bash
# Inside-container test for Antigravity CLI plugin install.
# Mirrors the README flow (`agy plugin install <repo>`), using the mounted
# checkout as the install source so the code under test is this checkout.
# Assertions parse the CLI's --json output rather than its human-readable text.
set -euo pipefail

PLUGIN_DIR="${PLUGIN_DIR:-/plugin}"

echo "==> agy --version"
agy --version

# Run agy, capturing its exit code separately from tee so a failure still
# reaches the FAIL diagnostic below (same pattern as run-gemini.sh).
run() {
  local log="$1"; shift
  set +e
  "$@" 2>&1 | tee "$log"
  local rc=${PIPESTATUS[0]}
  set -e
  return "$rc"
}

echo "==> agy plugin validate $PLUGIN_DIR --json"
# Non-strict: strict mode also warns about root AGENTS.md / GEMINI.md /
# hooks/hooks.json, which exist for the other supported platforms and are
# intentionally not Antigravity rules or hooks.
if ! run /tmp/agy-validate.json agy plugin validate "$PLUGIN_DIR" --json; then
  echo "FAIL: agy plugin validate exited non-zero"
  exit 1
fi
node -e '
  const r = JSON.parse(require("fs").readFileSync("/tmp/agy-validate.json", "utf8"));
  const errors = (r.findings || []).filter((f) => f.severity === "error");
  if (errors.length) throw new Error("validator errors: " + JSON.stringify(errors));
  const c = r.components || {};
  if (!(c.skills >= 5)) throw new Error("expected at least 5 skills, got " + c.skills);
  if (c.agents !== 6) throw new Error("expected 6 agents, got " + c.agents);
  if (c.rules !== 1) throw new Error("expected 1 rule, got " + c.rules);
  console.log(`PASS: plugin.json validates (skills ${c.skills}, agents ${c.agents}, rules ${c.rules})`);
'

echo "==> agy plugin install $PLUGIN_DIR"
if ! run /tmp/agy-install.log agy plugin install "$PLUGIN_DIR"; then
  echo "FAIL: agy plugin install exited non-zero"
  exit 1
fi
echo "PASS: plugin installed"

echo "==> agy plugin list --json"
if ! run /tmp/agy-list.json agy plugin list --json; then
  echo "FAIL: agy plugin list exited non-zero"
  exit 1
fi
node -e '
  const list = JSON.parse(require("fs").readFileSync("/tmp/agy-list.json", "utf8"));
  const plugins = Array.isArray(list) ? list : list.plugins || [];
  const p = plugins.find((x) => x.name === "gangsta");
  if (!p) throw new Error("gangsta not in plugin list: " + JSON.stringify(plugins.map((x) => x.name)));
  if (p.enabled === false || p.disabled === true) throw new Error("gangsta plugin is disabled: " + JSON.stringify(p));
  const c = p.components || p;
  const count = (v) => (Array.isArray(v) ? v.length : typeof v === "number" ? v : NaN);
  if (!(count(c.skills) >= 5)) throw new Error("expected at least 5 skills in list, got " + JSON.stringify(c.skills));
  if (count(c.agents) !== 6) throw new Error("expected 6 agents in list, got " + JSON.stringify(c.agents));
  if (count(c.rules) !== 1) throw new Error("expected 1 rule in list, got " + JSON.stringify(c.rules));
  console.log(`PASS: gangsta plugin enabled (skills ${count(c.skills)}, agents ${count(c.agents)}, rules ${count(c.rules)})`);
'

echo "==> agy agents"
if ! run /tmp/agy-agents.log agy agents; then
  echo "FAIL: agy agents exited non-zero"
  exit 1
fi
for agent in associate soldier the-inspector proposer devils-advocate synthesizer; do
  if ! grep -qx "$agent" /tmp/agy-agents.log; then
    echo "FAIL: agent '$agent' not listed"
    exit 1
  fi
done
echo "PASS: all 6 Gangsta subagents listed"

echo "==> Antigravity CLI install check passed (Phase 1)"

# ---------------------------------------------------------------------------
# Phase 2: LLM skill query — not run for Antigravity CLI.
# ---------------------------------------------------------------------------
# Antigravity CLI talks only to Google's backend with a signed-in Google
# account; there is no third-party provider routing. Phase 1 (manifest valid,
# plugin installed, skills/agents/rule registered) is the gate.
# ---------------------------------------------------------------------------
echo "==> Phase 2 skipped (Antigravity CLI requires a Google sign-in)"
