#!/usr/bin/env bash
# Inside-container test for OpenCode 2.x plugin install.
# Installs the mounted checkout through the `plugins` config key documented in
# .opencode/INSTALL.md, first as a directory plugin and then as an npm package
# (which resolves the entry through package.json "exports", like the documented
# `opencode plugin add gangsta@git+https://...` flow). Each time it asserts that
# the plugin is active and that Gangsta agents and skills are registered.
set -euo pipefail

PLUGIN_DIR="${PLUGIN_DIR:-/plugin}"

echo "==> opencode --version"
opencode --version

# Run from a neutral project directory so the checkout's own .opencode/ folder
# is not discovered a second time as a project-local plugin. Each phase uses
# its own project so the location boots cold with the new config.
configure() {
  local spec="$1" project="$2"
  mkdir -p "$HOME/.config/opencode" "$project"
  cat > "$HOME/.config/opencode/opencode.json" <<JSON
{
  "plugins": [$spec]
}
JSON
  echo "==> Configured opencode.json:"
  cat "$HOME/.config/opencode/opencode.json"
}

# A cold location activates plugins asynchronously; poll until the agent list
# is populated instead of trusting the first response.
assert_registered() {
  local project="$1" expected_source="$2"
  cd "$project"

  echo "==> opencode debug agents (poll until plugins activate)"
  for attempt in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
    opencode debug agents > /tmp/agents.json 2>/tmp/agents.err || true
    if grep -q '"id": "soldier"' /tmp/agents.json; then break; fi
    sleep 3
  done
  echo "--- agents ---"
  grep -o '"id": "[^"]*"' /tmp/agents.json || true
  echo "--- end ---"

  for agent in associate soldier the-inspector proposer devils-advocate synthesizer; do
    if ! grep -q "\"id\": \"$agent\"" /tmp/agents.json; then
      echo "FAIL: agent '$agent' not registered"
      cat /tmp/agents.err || true
      exit 1
    fi
  done
  echo "PASS: all 6 Gangsta agents registered"

  echo "==> opencode api plugin.list"
  opencode api plugin.list -H "x-opencode-directory:$project" > /tmp/plugins.json
  node -e '
    const expected = process.argv[1];
    const d = JSON.parse(require("fs").readFileSync("/tmp/plugins.json", "utf8"));
    const p = d.data.find((x) => x.id === "gangsta");
    if (!p) throw new Error("gangsta plugin missing from inventory: " + JSON.stringify(d.data.map((x) => x.id)));
    if (p.state.status !== "active") throw new Error("gangsta plugin state: " + JSON.stringify(p.state));
    if (p.source.type !== expected) throw new Error("gangsta plugin source " + p.source.type + ", expected " + expected);
    console.log("PASS: gangsta plugin active (source: " + p.source.type + ")");
  ' "$expected_source"

  echo "==> opencode api skill.list"
  opencode api skill.list -H "x-opencode-directory:$project" > /tmp/skills.json
  node -e '
    const fs = require("fs");
    const dir = process.argv[1];
    const expected = fs.readdirSync(dir + "/skills").filter((id) => fs.existsSync(dir + "/skills/" + id + "/SKILL.md"));
    const d = JSON.parse(fs.readFileSync("/tmp/skills.json", "utf8"));
    const missing = expected.filter((id) => !d.data.some((s) => s.id === id && s.path.endsWith("/skills/" + id + "/SKILL.md")));
    if (missing.length) throw new Error("skills missing from skill.list: " + missing.join(","));
    console.log("PASS: all " + expected.length + " gangsta skills registered");
  ' "$PLUGIN_DIR"
}

echo "=== Phase 1a: directory plugin (root index.js) ==="
configure "{ \"package\": \"$PLUGIN_DIR\" }" "$HOME/project-directory"
assert_registered "$HOME/project-directory" local

echo "=== Phase 1b: npm package install (package.json exports) ==="
configure "\"gangsta@file:$PLUGIN_DIR\"" "$HOME/project-package"
assert_registered "$HOME/project-package" package

echo "==> OpenCode 2.x install check passed (Phase 1)"

# ---------------------------------------------------------------------------
# Phase 2: LLM skill query — not run for OpenCode 2.x.
# ---------------------------------------------------------------------------
# OpenCode 2.x stores provider credentials through `opencode auth`, not the
# 1.x auth.json file used by run-opencode-v1.sh. Phase 1 (plugin active,
# agents and skills registered through the real plugin host) is the gate.
# ---------------------------------------------------------------------------
echo "==> Phase 2 skipped for OpenCode 2.x (Phase 1 is the gate)"
