# OpenCode Tool Mapping

Skills use Claude Code tool names as the canonical reference. When you encounter these in a skill, use the OpenCode equivalent:

| Skill references | OpenCode 2.x | OpenCode 1.x |
|-----------------|--------------|--------------|
| `Skill` tool (invoke a skill) | `skill` | `skill` |
| `Task` tool (dispatch subagent) | `subagent` (see [Agent types](#agent-types)) | `task` (see [Agent types](#agent-types)) |
| Multiple `Task` calls (parallel) | Multiple `subagent` calls in one message | Multiple `task` calls in one message |
| `TodoWrite` (task tracking) | `todowrite` | `todowrite` |
| `Read` (file reading) | `read` | `read` |
| `Write` (file creation) | `write` | `write` |
| `Edit` (file editing) | `edit` | `edit` |
| `Bash` (run commands) | `shell` | `bash` |
| `Grep` (search file content) | `grep` | `grep` |
| `Glob` (search files by name) | `glob` | `glob` |
| `WebFetch` | `webfetch` | `webfetch` |
| `WebSearch` | `websearch` | `websearch_web_search_exa` |
| `AskUserQuestion` (ask the Don) | `question` | `question` |

Check which generation you are running in by looking at your tool list: OpenCode 2.x exposes `subagent` and `shell`; OpenCode 1.x exposes `task` and `bash`.

## Agent types

The subagent tool takes the agent name as a parameter: `agent` on OpenCode 2.x (`subagent` tool), `subagent_type` on OpenCode 1.x (`task` tool). The value must exactly match a registered agent name — a built-in, a custom agent from `~/.config/opencode/agents/` or `.opencode/agents/`, or one registered by the Gangsta plugin.

### Gangsta custom agents

The Gangsta plugin registers these named subagents. **Always use these specific names** when dispatching within Gangsta skills:

| Agent name | When to use |
|------------|-------------|
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

OpenCode 1.x supports background task execution for parallel work (OpenCode 2.x runs parallel `subagent` calls in one message instead):

| Tool | Purpose |
|------|---------|
| `background_task` | Launch a task that runs asynchronously |
| `background_output` | Get results from a completed background task |
| `background_cancel` | Cancel running background tasks |

Use these for skills like `gangsta:the-hit` that dispatch parallel Worker tasks.

## Displaying plan / todos

OpenCode renders the active `todowrite` list in the UI as the agent works. Skills that say "create a todowrite per item" should call `todowrite` with the structured items — the list updates live without further action.

For long-running parallel work, `background_task` + `background_output` keep noisy output off the main thread while the todo list tracks overall progress.

## Asking the Don to choose

Use the `question` tool when a skill requires the Don to pick a variant, confirm a path, or answer a question. Every option object MUST have both `label` and `description` as non-null strings (see [Question tool schema](#question-tool-schema)).

The `question` tool **yields the turn** — OpenCode waits for the Don's reply before resuming. Do not call other tools in the same message after `question`; the Don's answer is the next turn.

## Interacting with the Don mid-task

| Surface | When to use |
|---------|-------------|
| `question` tool | Ask the Don to choose, confirm, or answer — turn yields until reply |
| Plain-text question at end of turn | Fallback when `question` is unavailable — emit numbered list, end turn, wait for next message |
| `todowrite` status | Signal progress without blocking — `in_progress` / `completed` / `pending` |

Avoid blocking on `background_output` for user input — background tasks are for async work, not Don interaction.

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

Available on OpenCode 1.x; on 2.x use them only if they appear in your tool list.

| Tool | Purpose |
|------|---------|
| `lsp_goto_definition` | Jump to symbol definition |
| `lsp_find_references` | Find all usages of a symbol |
| `lsp_diagnostics` | Get language server errors/warnings |
| `lsp_rename` | Rename symbol across workspace |
| `ast_grep_search` | AST-aware code pattern search |
| `ast_grep_replace` | AST-aware code pattern replacement |
| `auto_continue` | Toggle auto-continuation for incomplete todos |
