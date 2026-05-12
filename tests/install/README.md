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
| skills CLI | `Dockerfile.skills` | No (local path install) | Tested |
| GitHub Copilot CLI | — | Yes (GH auth required) | Not covered — see below |

**Copilot is an honest gap.** Copilot plugin install needs an
authenticated GitHub session, which we will not bake into CI without first
provisioning a scoped token via repository secrets. If it becomes scriptable
without auth gating, add a Dockerfile here and a matrix entry in
`.github/workflows/install-tests.yml`.

**Cursor is covered via the skills CLI test** (`Dockerfile.skills`): the
`skills` CLI installs gangsta skills to `~/.cursor/skills/`, which is the
canonical Cursor global skills path. There is no headless Cursor IDE surface
to exercise beyond verifying the skill files land in the right place.

## Run locally

From the repo root:

```bash
# All agents
for agent in claude-code opencode codex gemini skills; do
  docker build -t gangsta-test-$agent -f tests/install/Dockerfile.$agent tests/install
  docker run --rm -v "$PWD":/plugin:ro gangsta-test-$agent
done

# Single agent
docker build -t gangsta-test-skills -f tests/install/Dockerfile.skills tests/install
docker run --rm -v "$PWD":/plugin:ro gangsta-test-skills
```

The repo is mounted read-only at `/plugin`. Each `run-<agent>.sh` script
follows the user-facing install instructions for that agent and asserts
load/discovery succeeded.
