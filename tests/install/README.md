# Plugin install tests

Container-based smoke tests that verify Gangsta installs cleanly into every
supported AI coding agent **using the exact steps from the install docs**.

These tests exist because a manifest-validation bug
(`Validation errors: commands: Invalid input`) shipped to users in v1.1.0 —
no CI step had ever tried to actually install the plugin. We are not letting
that happen again.

## Agents covered

| Agent | Image | Auth required | Status |
|---|---|---|---|
| Claude Code | `Dockerfile.claude-code` | No (validate + `--init-only`) | Tested |
| OpenCode | `Dockerfile.opencode` | No (plugin-load only) | Tested |
| Codex | `Dockerfile.codex` | No (filesystem-only install) | Tested |
| Gemini CLI | `Dockerfile.gemini` | No (extension install only) | Tested |
| GitHub Copilot CLI | — | Yes (GH auth required) | Not covered — see below |
| Cursor | — | Desktop IDE, no CLI | Not coverable |

**Copilot and Cursor are honest gaps.** Copilot plugin install needs an
authenticated GitHub session, which we will not bake into CI without first
provisioning a scoped token via repository secrets. Cursor is a GUI; there
is no headless install surface to exercise. If either becomes scriptable
without auth gating, add a Dockerfile here and a matrix entry in
`.github/workflows/install-tests.yml`.

## Run locally

From the repo root:

```bash
# All agents
for agent in claude-code opencode codex gemini; do
  docker build -t gangsta-test-$agent -f tests/install/Dockerfile.$agent tests/install
  docker run --rm -v "$PWD":/plugin:ro gangsta-test-$agent
done

# Single agent
docker build -t gangsta-test-claude-code -f tests/install/Dockerfile.claude-code tests/install
docker run --rm -v "$PWD":/plugin:ro gangsta-test-claude-code
```

The repo is mounted read-only at `/plugin`. Each `run-<agent>.sh` script
follows the user-facing install instructions for that agent and asserts
load/discovery succeeded.
