# Installing Gangsta for OpenCode

Gangsta ships one plugin that supports both OpenCode generations:

| OpenCode | Package | Config key | Section |
|----------|---------|------------|---------|
| 2.x (`@opencode/cli`) | `@opencode/plugin` API | `plugins` | [OpenCode 2.x](#opencode-2x) |
| 1.4.0 – 1.x (`opencode-ai`) | `@opencode-ai/plugin` API | `plugin` | [OpenCode 1.x](#opencode-1x) |
| 1.0 – 1.3 | legacy function export | `plugin` | pin `#gangsta-v1.11.6` (see [OpenCode 1.x](#opencode-1x)) |

Check your version with `opencode --version`.

## OpenCode 2.x

### Install

Run:

```bash
opencode plugin add gangsta@git+https://github.com/kucherenko/gangsta.git
```

This installs the package and adds it to the `plugins` array of your global config (`~/.config/opencode/opencode.json`). Equivalent manual config:

```json
{
  "plugins": ["gangsta@git+https://github.com/kucherenko/gangsta.git"]
}
```

OpenCode installs the package itself at startup; no `bun add` step is needed. Restart OpenCode. Skills and agents are available immediately.

Verify by asking:
> "show me all skills"

Or from the shell:

```bash
opencode debug agents | grep -E '"id": "(associate|soldier|the-inspector)"'
```

### Pinning a version

Append a release tag to the git spec (any release from the one that added OpenCode 2.x support onward):

```json
{
  "plugins": ["gangsta@git+https://github.com/kucherenko/gangsta.git#gangsta-v<version>"]
}
```

### Updating

```bash
opencode plugin update
```

Then restart OpenCode.

### Project-local install

To enable Gangsta for one project only, add the same `plugins` entry to `.opencode/opencode.json` in that project.

### Migrating from OpenCode 1.x

1. Rename the `plugin` key in `opencode.json` to `plugins` (OpenCode 2.x reads only `plugins`).
2. Remove the manually installed copy: `cd ~/.config/opencode && bun remove gangsta` (OpenCode 2.x manages the package in its own cache).
3. Restart OpenCode.

## OpenCode 1.x

Requires OpenCode 1.4.0 or newer. OpenCode 1.0–1.3 loaded plugins by calling every export as a function and cannot load the current dual-format module; on those versions pin the last release with the old export shape: `gangsta@git+https://github.com/kucherenko/gangsta.git#gangsta-v1.11.6`.

Add gangsta to `~/.config/opencode/opencode.json`:

```json
{
  "plugin": ["gangsta@git+https://github.com/kucherenko/gangsta.git"]
}
```

Then install the plugin package by running:

```bash
cd ~/.config/opencode && bun add gangsta@git+https://github.com/kucherenko/gangsta.git
```

Restart OpenCode. Skills and agents will be available immediately.

Verify by asking:
> "show me all skills"

### Pinning a version

Update `opencode.json` and re-run `bun add` with the tag:

```json
{
  "plugin": ["gangsta@git+https://github.com/kucherenko/gangsta.git#gangsta-v1.7.0"]
}
```

```bash
cd ~/.config/opencode && bun add gangsta@git+https://github.com/kucherenko/gangsta.git#gangsta-v1.7.0
```

### Updating

Re-run `bun add` to pull the latest version:

```bash
cd ~/.config/opencode && bun add gangsta@git+https://github.com/kucherenko/gangsta.git
```

Then restart OpenCode.

### Migrating from the old clone-based install

If you previously installed via `git clone` + manual `skills.paths`:

```bash
# Remove the cloned repo
rm -rf ~/.gangsta
```

Remove from `opencode.json`:
```json
{
  "plugin": ["gangsta@file:///Users/you/.gangsta"],   // remove
  "skills": {
    "paths": ["~/.gangsta/skills"]                    // remove
  }
}
```

Then follow the installation steps above.

## Agents

Gangsta registers the following subagent roles, dispatched by skills at runtime through the subagent tool (`subagent` on OpenCode 2.x, `task` on 1.x) or `@mention` syntax:

| `@mention` | Agent name | Dispatched By | Purpose |
|------------|------------|---------------|---------|
| `@associate` | `associate` | Underboss (Reconnaissance) | Intel gathering — codebase scanning, dependency audits, documentation retrieval |
| `@soldier` | `soldier` | Crew Lead (The Hit) | Work package implementation with mandatory TDD |
| `@the-inspector` | `the-inspector` | Audit Review | Independent code review against requirements |
| `@proposer` | `proposer` | The Grilling | Proposes architectural solutions for debate |
| `@devils-advocate` | `devils-advocate` | The Grilling | Attacks proposals and surfaces flaws |
| `@synthesizer` | `synthesizer` | The Grilling | Mediates debate and produces revised solutions |

On OpenCode 2.x, agents you define yourself under the same name (in `opencode.json` or `agents/*.md`) take precedence over the Gangsta definitions.

## Tool Mapping

Skills are written for Claude Code as the canonical reference. When running in OpenCode, use these equivalents (full table in `skills/using-gangsta/references/opencode-tools.md`):

| Claude Code | OpenCode 2.x | OpenCode 1.x |
|-------------|--------------|--------------|
| `Skill` tool | `skill` | `skill` |
| `TodoWrite` | `todowrite` | `todowrite` |
| `Task` (subagent dispatch) | `subagent` tool, `agent` = name above | `task` tool or `@mention` |
| `Bash` | `shell` | `bash` |
| `Read` / `Write` / `Edit` | Native file tools | Native file tools |
| `Glob` / `Grep` | Native search tools | Native search tools |
| `AskUserQuestion` | `question` | `question` |

## Troubleshooting

### Plugin not loading

OpenCode 2.x:

1. `opencode plugin list` shows the configured plugins and their state.
2. `opencode debug config` lists the config files OpenCode read; confirm the one with `plugins` is there.
3. Logs: `opencode --standalone --print-logs --log-level warn run "hello" 2>&1 | grep -i gangsta`

OpenCode 1.x:

1. Check logs: `opencode run --print-logs "hello" 2>&1 | grep -i gangsta`
2. Verify the `plugin` line in your `opencode.json`
3. Make sure you're running a recent version of OpenCode

### Skills not found

1. Use the `skill` tool to list what's discovered
2. Confirm the plugin is loading (see above)

## Getting Help

- Report issues: https://github.com/kucherenko/gangsta/issues
