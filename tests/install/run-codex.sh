#!/usr/bin/env bash
# Codex install per .codex/INSTALL.md (clone + symlink).
# The repo is mounted at /plugin; we simulate ~/.gangsta with a copy so the
# symlink target matches the documented path.
set -euo pipefail

mkdir -p "$HOME/.gangsta"
cp -r /plugin/. "$HOME/.gangsta/"

mkdir -p "$HOME/.agents/skills"
ln -sf "$HOME/.gangsta/skills" "$HOME/.agents/skills/gangsta"

# Assertions: symlink exists, resolves, and at least one SKILL.md is reachable.
test -L "$HOME/.agents/skills/gangsta" \
  || { echo "FAIL: symlink not created"; exit 1; }

test -d "$HOME/.agents/skills/gangsta/" \
  || { echo "FAIL: symlink does not resolve to a directory"; exit 1; }

count=$(find -L "$HOME/.agents/skills/gangsta" -name SKILL.md | wc -l)
if [ "$count" -lt 5 ]; then
  echo "FAIL: expected at least 5 SKILL.md files, found $count"
  exit 1
fi

echo "PASS: Codex install reachable; $count SKILL.md files discoverable"
