# Installing Gangsta for OpenCode

## Prerequisites

- [OpenCode.ai](https://opencode.ai) installed

## Installation

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

## Pinning a Version

Update `opencode.json` and re-run `bun add` with the tag:

```json
{
  "plugin": ["gangsta@git+https://github.com/kucherenko/gangsta.git#gangsta-v1.7.0"]
}
```

```bash
cd ~/.config/opencode && bun add gangsta@git+https://github.com/kucherenko/gangsta.git#gangsta-v1.7.0
```

## Updating

Re-run `bun add` to pull the latest version:

```bash
cd ~/.config/opencode && bun add gangsta@git+https://github.com/kucherenko/gangsta.git
```

Then restart OpenCode.

## Migrating from the Old Clone-Based Install

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

Gangsta registers the following subagent roles, dispatched by skills at runtime via `@mention` syntax:

| `@mention` | `subagent_type` | Dispatched By | Purpose |
|------------|----------------|---------------|---------|
| `@associate` | `associate` | Underboss (Reconnaissance) | Intel gathering — codebase scanning, dependency audits, documentation retrieval |
| `@soldier` | `soldier` | Crew Lead (The Hit) | Work package implementation with mandatory TDD |
| `@the-inspector` | `the-inspector` | Audit Review | Independent code review against requirements |
| `@proposer` | `proposer` | The Grilling | Proposes architectural solutions for debate |
| `@devils-advocate` | `devils-advocate` | The Grilling | Attacks proposals and surfaces flaws |
| `@synthesizer` | `synthesizer` | The Grilling | Mediates debate and produces revised solutions |

## Tool Mapping

Skills are written for Claude Code as the canonical reference. When running in OpenCode, use these equivalents:

| Claude Code | OpenCode |
|-------------|----------|
| `Skill` tool | Native `skill` tool |
| `TodoWrite` | `todowrite` |
| `Task` (subagent dispatch) | `@mention` syntax (e.g. `@associate`, `@soldier`) |
| `Read` / `Write` / `Edit` | Native file tools |
| `Bash` | `bash` |
| `Glob` / `Grep` | Native search tools |

## Troubleshooting

### Plugin not loading

1. Check logs: `opencode run --print-logs "hello" 2>&1 | grep -i gangsta`
2. Verify the plugin line in your `opencode.json`
3. Make sure you're running a recent version of OpenCode

### Skills not found

1. Use the `skill` tool to list what's discovered
2. Confirm the plugin is loading (see above)

## Getting Help

- Report issues: https://github.com/kucherenko/gangsta/issues
