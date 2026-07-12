# Gemini CLI Tool Mapping

Skills use Claude Code tool names as the canonical reference. When you encounter these in a skill, use the Gemini CLI equivalent:

| Skill references | Gemini CLI equivalent |
|-----------------|----------------------|
| `Read` (file reading) | `read_file` |
| `Write` (file creation) | `write_file` |
| `Edit` (file editing) | `replace` |
| `Bash` (run commands) | `run_shell_command` |
| `Grep` (search file content) | `grep_search` |
| `Glob` (search files by name) | `glob` |
| `TodoWrite` (task tracking) | `write_todos` — see [Displaying plan / todos](#displaying-plan--todos) |
| `Skill` tool (invoke a skill) | `activate_skill` |
| `WebSearch` | `google_web_search` |
| `WebFetch` | `web_fetch` |
| `Task` tool (dispatch subagent) | No equivalent — Gemini CLI does not support subagents |
| `question` / `ask_user` (ask the Don to choose) | `ask_user` — see [Asking the Don to choose](#asking-the-don-to-choose) |
| Pause-and-prompt mid-task | `ask_user` or end turn — see [Interacting with the Don mid-task](#interacting-with-the-don-mid-task) |

## Displaying plan / todos

Gemini CLI offers two todo surfaces:

| Surface | When to use |
|---------|-------------|
| `write_todos` | Minimal structured todo list — add/update/complete items; the UI reflects the list |
| `tracker_create_task` | Richer task management — create, update, list, and visualize tasks with metadata |

Skills that say "create a todowrite per item" should use `write_todos`. Reserve `tracker_create_task` for heist phases that need task linking or visualization beyond a flat list.

## Asking the Don to choose

Use `ask_user` to request structured input when a skill requires the Don to pick a variant, confirm a path, or answer a question. `ask_user` yields the turn — Gemini CLI waits for the Don's reply before resuming.

Do not call other tools after `ask_user` in the same turn; the Don's answer is the next turn.

## Interacting with the Don mid-task

| Surface | When to use |
|---------|-------------|
| `ask_user` | Ask the Don to choose, confirm, or answer — turn yields until reply |
| Plain-text question at end of turn | Fallback when `ask_user` is unavailable — emit numbered list, end turn, wait |
| `enter_plan_mode` / `exit_plan_mode` | Switch to read-only research mode before making changes; surfaces intent without blocking |

Gemini CLI has no subagent dispatch, so skills that pause for the Don have no parallel work to manage — interaction is purely the question → reply cycle.

## No subagent support

Gemini CLI has no equivalent to Claude Code's `Task` tool. Skills that rely on subagent dispatch (`gangsta:the-hit`, `gangsta:resource-development`) will fall back to single-session sequential execution. The agent should execute each Worker's task inline rather than dispatching parallel subagents.

## Additional Gemini CLI tools

These tools are available in Gemini CLI but have no Claude Code equivalent:

| Tool | Purpose |
|------|---------|
| `list_directory` | List files and subdirectories |
| `save_memory` | Persist facts to GEMINI.md across sessions |
| `ask_user` | Request structured input from the user |
| `tracker_create_task` | Rich task management (create, update, list, visualize) |
| `enter_plan_mode` / `exit_plan_mode` | Switch to read-only research mode before making changes |
