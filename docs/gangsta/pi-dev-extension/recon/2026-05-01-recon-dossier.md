---
heist: pi-dev-extension
date: 2026-05-01
status: pending-review
---

# Reconnaissance Dossier: pi.dev Extension

## Objective

Build a pi.dev coding agent extension for the Gangsta Agents Framework that integrates Gangsta skills, commands, and the hierarchy prompt into the pi.dev runtime — following the same multi-platform adapter pattern already established for Claude Code, Cursor, OpenCode, and Gemini.

## Codebase Overview

### Existing Platform Adapter Pattern

Gangsta ships platform-specific adapter directories at the repo root. Each adapter integrates Gangsta's skill files and prompt content into the host platform's extension/plugin mechanism:

| Platform | Directory | Mechanism |
|---|---|---|
| Claude Code | `.claude-plugin/` | JSON manifest declaring commands (heist, go, abort) |
| Cursor | `.cursor-plugin/` | JSON manifest pointing to skills/, agents/, hooks/ |
| OpenCode | `.opencode/` | JS plugin file (`plugins/gangsta.js`) via `@opencode-ai/plugin` |
| Gemini CLI | `gemini-extension.json` | JSON config, contextFileName: GEMINI.md |
| Codex | `.codex/INSTALL.md` | Manual installation guide only |

The new pi.dev extension follows this pattern: a new `.pi/` directory at repo root.

### Relevant Source Files

- `package.json` (root): `name: gangsta`, `version: 1.8.1`, `type: module`, zero runtime deps — constraint binding on root-level package.json
- `.opencode/package.json`: demonstrates that platform-subdirs CAN have their own deps (has `@opencode-ai/plugin`)
- `.opencode/plugins/gangsta.js`: reference implementation for a programmatic JS/TS-based extension adapter
- `skills/using-gangsta/SKILL.md`: master system prompt injection logic; contains the "Using Gangsta" instructions
- `commands/heist.md`, `commands/go.md`, `commands/abort.md`: the three slash commands to expose
- `AGENTS.md`, `GEMINI.md`: full-context injection files (platform-specific variants of the system prompt)

### Extension Entry Points

Skills live in `skills/*/SKILL.md` (21 skills). Agents live in `agents/*.md`. Commands in `commands/*.md`.

## pi.dev Extension Architecture

### How pi.dev Extensions Work

- TypeScript files loaded via jiti (no compilation step)
- Export a default factory: `export default function(pi: ExtensionAPI) { ... }`
- Auto-discovered from: `~/.pi/agent/extensions/` (global) or `.pi/extensions/` (project-local)
- Can also be packaged as npm/git packages declared in `settings.json`

### Key Capabilities Available

| Capability | pi.dev API | Gangsta Use |
|---|---|---|
| System prompt injection | `pi.on("before_agent_start", ...)` | Inject "Using Gangsta" instructions |
| Skill/prompt contribution | `pi.on("resources_discover", ...)` | Contribute skill files as pi skills |
| Slash commands | `pi.registerCommand("gangsta:heist", ...)` | Expose `/gangsta:heist`, `/gangsta:go`, `/gangsta:abort` |
| Tool registration | `pi.registerTool(...)` | Future: Gangsta-specific tools if needed |
| Session state | `pi.appendEntry(...)` + `session_start` | Persist heist state across forks |
| Package metadata | `package.json` with `pi.extensions` field | Distribution as pi package |

### Target Extension Structure

```
.pi/
  extensions/
    gangsta/
      index.ts           ← main entry point (factory function)
      package.json       ← pi.extensions field + any deps
  INSTALL.md             ← setup instructions for pi.dev users
```

## Existing Test Coverage

No unit test framework exists. Validation is via `scripts/validate.sh` which checks:
- Each `skills/*/` dir has a `SKILL.md`
- Required skills are non-empty
- Required commands exist
- YAML frontmatter in commands
- CHANGELOG.md is non-empty

The new extension will need validate.sh additions to check the `.pi/` adapter exists.

## Dependencies

- Root `package.json`: zero runtime dependencies (binding constraint)
- `.pi/extensions/gangsta/package.json`: may reference `@mariozechner/pi-coding-agent` for TypeScript types (devDependency only — types not needed at runtime since jiti loads TS directly)
- jiti handles TypeScript transpilation at runtime — no build step required

## Relevant Ledger Entries

### Applicable Insights
- None directly applicable (no prior pi.dev or extension work in ledger)

### Applicable Negative Constraints
- **NC-001**: NEVER weaken or bypass Omerta Law 2 (checkpoints non-negotiable) in any autonomous-mode pathway — not directly applicable to this extension work
- **NC-002**: NEVER reproduce Gangsta-internal spec identifiers (FR-xxx, NFR-xxx, WP-xxx) in project-facing artifacts outside `docs/gangsta/` — binding on all new source files, including the extension code
- **C-001**: Pre-document the 7 standing framework template files as scan exceptions before running the identifier scan — binding on Laundering phase

## Risks and Unknowns

| Risk | Severity | Notes |
|---|---|---|
| `resources_discover` path format for skills | Medium | Need to verify if pi expects a specific directory structure or glob pattern for skill files |
| `pi.dev` package availability on npm | Low | `@mariozechner/pi-coding-agent` used for types — verify package exists and is public |
| System prompt size | Medium | `skills/using-gangsta/SKILL.md` is large; pi may have context window pressure; may need a condensed version |
| AGENTS.md zero-dep constraint interpretation | Low | Precedent from `.opencode/` confirms platform subdirs can have their own package.json — constraint is root-level only |
| `validate.sh` needs updating | Low | Must add `.pi/` structure check to the existing validation script |
| pi.dev distribution model | Medium | Unclear if Gangsta should distribute as `npm:gangsta` pi package or project-local `.pi/` — both paths should be supported |
| Tool mapping reference file | Low | `skills/using-gangsta/` has references for Claude Code, OpenCode, Gemini, Cursor, Codex — need to add `pi-tools.md` |

## Recommended Scope

**In scope:**
1. `.pi/extensions/gangsta/index.ts` — extension factory: system prompt injection via `before_agent_start`, skill contribution via `resources_discover`, command registration for `/gangsta:heist`, `/gangsta:go`, `/gangsta:abort`
2. `.pi/extensions/gangsta/package.json` — `pi.extensions` field, optional type-only devDep
3. `.pi/INSTALL.md` — installation guide for pi.dev users
4. `skills/using-gangsta/references/pi-tools.md` — tool mapping reference for pi.dev platform
5. `scripts/validate.sh` — add `.pi/` structure check
6. `CHANGELOG.md` — document new platform support

**Out of scope (future heists):**
- Custom Gangsta-specific pi tools (file operations, checkpoint tools)
- npm package distribution (can be addressed after initial adapter works)
- OAuth or custom provider registration
- TUI widgets for heist status display
