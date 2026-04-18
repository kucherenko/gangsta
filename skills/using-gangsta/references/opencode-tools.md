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

OpenCode's `task` tool accepts a `subagent_type` parameter. The built-in subagents are:

| Subagent | When to use |
|----------|-------------|
| `"general"` | Complex research, multi-step tasks, analysis, synthesis — has full tool access (except todo) |
| `"explore"` | Fast, read-only codebase search — finding files, searching keywords, answering questions about code |

**Do not use `"fixer"`, `"explorer"`, `"oracle"`, or `"council"` — these are not valid OpenCode agent types and will fail.**

Custom agents defined in `~/.config/opencode/agents/` or `.opencode/agents/` are also valid — use their filename (without `.md`) as the `subagent_type`.

## Named agent dispatch

Gangsta skills reference named agent types like `gangsta:soldier` or `gangsta:devils-advocate`. OpenCode does not have a named agent registry — `task` creates agents from built-in types.

When a skill says to dispatch a named agent type:

1. Find the agent's prompt file (e.g., `agents/soldier.md`)
2. Read the prompt content
3. Fill any template placeholders
4. Dispatch a `general` subagent with the filled content as the prompt

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
