# OpenCode Tool Mapping

Skills use Claude Code tool names as the canonical reference. When you encounter these in a skill, use the OpenCode equivalent:

| Skill references | OpenCode equivalent |
|-----------------|---------------------|
| `Skill` tool (invoke a skill) | `skill` |
| `Task` tool (dispatch subagent) | `task` (see [Agent types](#agent-types)) |
| Multiple `Task` calls (parallel) | Multiple `task` calls in one message |
| `TodoWrite` (task tracking) | `todowrite` |
| `Read` (file reading) | `read` |
| `Write` (file creation) | `write` |
| `Edit` (file editing) | `edit` |
| `Bash` (run commands) | `bash` |
| `Grep` (search file content) | `grep` |
| `Glob` (search files by name) | `glob` |
| `WebFetch` | `webfetch` |
| `WebSearch` | `websearch_web_search_exa` |

## Agent types

OpenCode's `task` tool accepts a `subagent_type` parameter. The value must exactly match a registered agent name — either a built-in or a custom agent defined in `~/.config/opencode/agents/` or `.opencode/agents/`.

### Gangsta custom agents

The Gangsta framework ships with named agents. **Always use these specific names** when dispatching within Gangsta skills:

| `subagent_type` | When to use |
|-----------------|-------------|
| `"associate"` | Reconnaissance intel work — codebase scanning, dependency audits, documentation retrieval |
| `"soldier"` | Stateless code execution — implementing a single work package with TDD |
| `"the-inspector"` | Independent code review — reviewing diffs against requirements |
| `"proposer"` | The Grilling — proposes architectural solutions |
| `"devils-advocate"` | The Grilling — attacks proposals and identifies flaws |
| `"synthesizer"` | The Grilling — mediates and produces revised solutions |

### Built-in OpenCode agents

OpenCode also ships with `"general"` (full tool access) and `"explore"` (read-only search). These are valid **only if not disabled** in the project's `opencode.json`. Gangsta installations typically disable them in favor of the named agents above.

**Never use `"general-purpose"`, `"fixer"`, `"explorer"`, `"oracle"`, or `"council"` — these are never valid and will always fail.**

## Background tasks

OpenCode supports background task execution for parallel work:

| Tool | Purpose |
|------|---------|
| `background_task` | Launch a task that runs asynchronously |
| `background_output` | Get results from a completed background task |
| `background_cancel` | Cancel running background tasks |

Use these for skills like `gangsta:the-hit` that dispatch parallel Soldier work.

## Question tool schema

When using the `question` tool to ask the Don, every option object MUST have both fields as non-null strings:

| Field | Type | Notes |
|-------|------|-------|
| `label` | string | Concise display text, 1-5 words |
| `description` | string | Explanation of what this choice means — **NEVER null** |

**`description` is required and must be a non-null string**, even for obvious choices:

```
Bad:  { label: "Yes" }
Bad:  { label: "Yes", description: null }
Good: { label: "Yes", description: "I agree with this proposal" }
Good: { label: "No",  description: "I reject this — do not proceed" }
```

Omitting or nulling `description` causes a schema validation error at runtime.

## Additional OpenCode tools

| Tool | Purpose |
|------|---------|
| `lsp_goto_definition` | Jump to symbol definition |
| `lsp_find_references` | Find all usages of a symbol |
| `lsp_diagnostics` | Get language server errors/warnings |
| `lsp_rename` | Rename symbol across workspace |
| `ast_grep_search` | AST-aware code pattern search |
| `ast_grep_replace` | AST-aware code pattern replacement |
| `auto_continue` | Toggle auto-continuation for incomplete todos |
