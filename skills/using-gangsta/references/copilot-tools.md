# Copilot CLI Tool Mapping

Skills use Claude Code tool names as the canonical reference. When you encounter these in a skill, use the Copilot CLI equivalent:

| Skill references | Copilot CLI equivalent |
|-----------------|----------------------|
| `Read` (file reading) | `view` |
| `Write` (file creation) | `create` |
| `Edit` (file editing) | `edit` |
| `Bash` (run commands) | `bash` |
| `Grep` (search file content) | `grep` |
| `Glob` (search files by name) | `glob` |
| `Skill` tool (invoke a skill) | `skill` |
| `WebFetch` | `web_fetch` |
| `Task` tool (dispatch subagent) | `task` (see [Agent types](#agent-types)) |
| Multiple `Task` calls (parallel) | Multiple `task` calls |
| Task status/output | `read_agent`, `list_agents` |
| `TodoWrite` (task tracking) | `sql` with built-in `todos` table — see [Displaying plan / todos](#displaying-plan--todos) |
| `WebSearch` | No equivalent — use `web_fetch` with a search engine URL |
| `question` / `ask_user` (ask the Don to choose) | No native tool — see [Asking the Don to choose](#asking-the-don-to-choose) |
| Pause-and-prompt mid-task | End turn and wait — see [Interacting with the Don mid-task](#interacting-with-the-don-mid-task) |

## Displaying plan / todos

Copilot CLI persists todos in a session SQLite `todos` table via the `sql` tool. Write rows to add/update/complete items; the UI reflects changes on the next `sql` query.

Example:

```sql
INSERT INTO todos (content, status, priority) VALUES ('Map codebase', 'in_progress', 'high');
UPDATE todos SET status = 'completed' WHERE content = 'Map codebase';
```

Use `report_intent` to update the UI status line with the current phase when the todo list alone is not enough.

## Asking the Don to choose

Copilot CLI has **no structured `question`/`ask_user` tool**. When a skill requires the Don to select a variant, confirm a path, or answer a question:

1. Emit the options as a **numbered list** in plain text.
2. **End the turn immediately** — do not call `bash`, `task`, or any other tool after the question.
3. The Don's next message is the answer; their reply resumes the turn.

Example:

```
Which approach should I take?

1. Add a cache layer in the repo (smallest diff, fits YAGNI).
2. Refactor to a worker pool (more code, scales later).
3. Do nothing — output is actually fine.
```

Never block on a tool call waiting for input. Copilot CLI does not expose one, and calling a tool after the question will keep the turn running instead of yielding to the Don.

## Interacting with the Don mid-task

| Mode | How to interact |
|------|-----------------|
| Interactive Copilot CLI | End the turn with a plain-text question; the Don's reply resumes the session |
| Async shell sessions (`bash async: true`) | Background work only — not for Don input; check `read_bash` for output, `stop_bash` to terminate |

Use `store_memory` to persist context the Don contributed mid-task so future sessions inherit it. Approvals and permission prompts are separate from skill questions and surface through Copilot CLI's native permission UI.

## Agent types

Copilot CLI's `task` tool accepts an `agent_type` parameter:

| Claude Code agent | Copilot CLI equivalent |
|-------------------|----------------------|
| General-purpose | `"general-purpose"` |
| Explore / research | `"explore"` |
| Named plugin agents (e.g. `gangsta:soldier`) | Discovered automatically from installed plugins |

## Async shell sessions

Copilot CLI supports persistent async shell sessions, which have no direct Claude Code equivalent:

| Tool | Purpose |
|------|---------|
| `bash` with `async: true` | Start a long-running command in the background |
| `write_bash` | Send input to a running async session |
| `read_bash` | Read output from an async session |
| `stop_bash` | Terminate an async session |
| `list_bash` | List all active shell sessions |

## Additional Copilot CLI tools

| Tool | Purpose |
|------|---------|
| `store_memory` | Persist facts about the codebase for future sessions |
| `report_intent` | Update the UI status line with current intent |
| `sql` | Query the session's SQLite database (todos, metadata) |
| `fetch_copilot_cli_documentation` | Look up Copilot CLI documentation |
| GitHub MCP tools (`github-mcp-server-*`) | Native GitHub API access (issues, PRs, code search) |
