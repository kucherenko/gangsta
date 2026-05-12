#!/usr/bin/env bash
# Validates .claude-plugin/plugin.json against the Claude Code plugin manifest schema.
#
# This guards against bugs like the "Validation errors: commands: Invalid input"
# install failure: bare paths without './' prefix, arrays where strings belong, etc.
#
# Requires: bash, python3 (stdlib), curl. Schema fetched once and cached.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MANIFEST="${REPO_ROOT}/.claude-plugin/plugin.json"
SCHEMA_URL="https://json.schemastore.org/claude-code-plugin-manifest.json"
CACHE_DIR="${REPO_ROOT}/.cache"
SCHEMA_FILE="${CACHE_DIR}/claude-code-plugin-manifest.schema.json"

if [ ! -f "$MANIFEST" ]; then
  echo "FAIL: $MANIFEST not found"
  exit 1
fi

# Lexical JSON sanity first — catches trailing commas, comments, etc.
python3 -m json.tool "$MANIFEST" > /dev/null
echo "OK:   $MANIFEST parses as JSON"

# Reject $schema — Claude Code runtime fails with "Unrecognized key: $schema".
python3 - "$MANIFEST" <<'PY'
import json, sys
data = json.load(open(sys.argv[1]))
if "$schema" in data:
    print('FAIL: $schema key is present — Claude Code will reject the manifest with "Unrecognized key: \\"$schema\\""')
    sys.exit(1)
print("OK:   no $schema key")
PY

# Local path checks the schema cannot express (path existence, './' prefix).
python3 - "$MANIFEST" "$REPO_ROOT" <<'PY'
import json, os, sys
manifest_path, repo_root = sys.argv[1], sys.argv[2]
with open(manifest_path) as f:
    data = json.load(f)

errors = []
path_fields = ("skills", "commands", "agents", "outputStyles")
for field in path_fields:
    value = data.get(field)
    if value is None:
        continue
    items = value if isinstance(value, list) else [value]
    for item in items:
        if not isinstance(item, str):
            errors.append(f"{field}: expected string, got {type(item).__name__}")
            continue
        if not item.startswith("./"):
            errors.append(f"{field}: path '{item}' must start with './'")
        # Strip trailing slash for existence check
        resolved = os.path.normpath(os.path.join(repo_root, item))
        if not os.path.exists(resolved):
            errors.append(f"{field}: path '{item}' does not exist (resolved {resolved})")

if errors:
    print("FAIL: manifest path validation errors:")
    for e in errors:
        print(f"  - {e}")
    sys.exit(1)
print("OK:   manifest path fields use './' prefix and resolve to real files")
PY

# Optional: full JSON-schema validation if jsonschema is installed and schema fetchable.
if python3 -c "import jsonschema" 2>/dev/null; then
  mkdir -p "$CACHE_DIR"
  if [ ! -f "$SCHEMA_FILE" ]; then
    if ! curl -fsSL "$SCHEMA_URL" -o "$SCHEMA_FILE" 2>/dev/null; then
      echo "WARN: could not fetch $SCHEMA_URL — skipping full schema check"
      exit 0
    fi
  fi
  python3 - "$MANIFEST" "$SCHEMA_FILE" <<'PY'
import json, sys
from jsonschema import Draft7Validator
manifest = json.load(open(sys.argv[1]))
schema   = json.load(open(sys.argv[2]))
errors = sorted(Draft7Validator(schema).iter_errors(manifest), key=lambda e: e.path)
if errors:
    print("FAIL: schema validation errors:")
    for e in errors:
        loc = "/".join(str(p) for p in e.path) or "<root>"
        print(f"  - {loc}: {e.message}")
    sys.exit(1)
print("OK:   manifest passes Claude Code plugin schema")
PY
else
  echo "INFO: python3 'jsonschema' not installed — skipped full schema validation"
fi
