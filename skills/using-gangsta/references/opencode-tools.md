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

OpenCode's `task` tool accepts a `subagent_type` parameter:

| Claude Code agent | OpenCode equivalent |
|-------------------|---------------------|
| General-purpose | `"fixer"` — fast implementation specialist |
| Explore / research | `"explorer"` — codebase search and pattern matching |
| Code review | `"oracle"` — strategic advisor, code review |
| Architecture / design | `"oracle"` — architecture decisions, engineering guidance |
| Multi-model council | `"council"` — synthesizes responses from multiple models |
| Named plugin agents (e.g. `gangsta:soldier`) | Use `"fixer"` with the agent's prompt content included in the task prompt |

## Named agent dispatch

Gangsta skills reference named agent types like `gangsta:soldier` or `gangsta:devils-advocate`. OpenCode does not have a named agent registry — `task` creates agents from built-in types.

When a skill says to dispatch a named agent type:

1. Find the agent's prompt file (e.g., `agents/soldier.md`)
2. Read the prompt content
3. Fill any template placeholders
4. Dispatch a `fixer` (for execution tasks) or `explorer` (for research tasks) with the filled content as the prompt

## Background tasks

OpenCode supports background task execution for parallel work:

| Tool | Purpose |
|------|---------|
| `background_task` | Launch a task that runs asynchronously |
| `background_output` | Get results from a completed background task |
| `background_cancel` | Cancel running background tasks |

Use these for skills like `gangsta:the-hit` that dispatch parallel Soldier work.

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
