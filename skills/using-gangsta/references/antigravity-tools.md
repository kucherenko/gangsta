# Antigravity CLI Tool Mapping

Skills use Claude Code tool names as the canonical reference. When you encounter these in a skill, use the Antigravity CLI (`agy`) equivalent:

| Skill references | Antigravity CLI equivalent |
|-----------------|----------------------------|
| `Skill` tool (invoke a skill) | `read_file` on the skill's `SKILL.md` — see [Loading skills](#loading-skills) |
| `Task` tool (dispatch subagent) | `invoke_subagent` (see [Agent types](#agent-types)) |
| Multiple `Task` calls (parallel) | Multiple `invoke_subagent` calls; results arrive as messages |
| `TodoWrite` (task tracking) | No native todo tool — see [Displaying plan / todos](#displaying-plan--todos) |
| `Read` (file reading) | `read_file` |
| `Write` (file creation) | `write_file` |
| `Edit` (file editing) | `edit_file` |
| `Bash` (run commands) | `run_command` |
| `Grep` (search file content) | `run_command` with `rg` or `grep` |
| `Glob` (search files by name) | `run_command` with `fd` or `find` |
| `WebFetch` | `run_command` with `curl` |
| `WebSearch` | `search_web` |
| `AskUserQuestion` (ask the Don to choose) | `ask_question` — see [Asking the Don to choose](#asking-the-don-to-choose) |
| Pause-and-prompt mid-task | `ask_question` or end turn — see [Interacting with the Don mid-task](#interacting-with-the-don-mid-task) |

## Loading skills

Antigravity lists every installed skill (name and description) in your context at session start. There is no skill-activation tool: when a skill applies, `read_file` its `SKILL.md` and follow it. The Gangsta skills live under the plugin's `skills/<name>/SKILL.md`; the path is shown next to each skill in your skill list.

## Agent types

`invoke_subagent` takes `TypeName` (the subagent to run), `Role`, `Prompt`, `Model` and `Workspace`. `TypeName` must exactly match a registered subagent name.

### Gangsta custom agents

The Gangsta plugin registers these subagents. **Always use these specific names** as `TypeName` when dispatching within Gangsta skills:

| `TypeName` | When to use |
|------------|-------------|
| `"associate"` | Reconnaissance intel work — codebase scanning, dependency audits, documentation retrieval |
| `"soldier"` | Stateless code execution — implementing a single work package with TDD |
| `"the-inspector"` | Independent code review — reviewing diffs against requirements |
| `"proposer"` | The Grilling — proposes architectural solutions |
| `"devils-advocate"` | The Grilling — attacks proposals and identifies flaws |
| `"synthesizer"` | The Grilling — mediates and produces revised solutions |

### Built-in Antigravity subagents

Antigravity also ships `"self"`, `"research"` and `"image-generator"`, and `define_subagent` can create a transient type mid-session. Prefer the named Gangsta agents above inside Gangsta skills.

`Workspace` controls where the subagent works: `inherit` (same workspace as you), `branch` (an isolated git worktree) or `share`. Use `inherit` unless the skill asks for a safehouse worktree (`gangsta:safehouse-worktrees`).

Subagents do not inherit your conversation; put everything they need in `Prompt`. Their results come back as messages, and you are woken when they finish — there is no separate wait tool.

## Displaying plan / todos

Antigravity CLI has no `TodoWrite` equivalent. When a skill says "create a todowrite per item", keep the checklist in your reply as a Markdown task list and update it as items complete:

```
- [x] Write failing test for parser
- [ ] Implement parser
- [ ] Run full suite
```

`manage_task` manages background tasks, not todo lists; do not use it for plan display.

## Asking the Don to choose

Use `ask_question` when a skill requires the Don to pick a variant, confirm a path, or answer a question. `ask_question` **yields the turn** — Antigravity waits for the Don's reply before resuming. Do not call other tools in the same message after `ask_question`; the Don's answer is the next turn.

## Interacting with the Don mid-task

| Surface | When to use |
|---------|-------------|
| `ask_question` | Ask the Don to choose, confirm, or answer — turn yields until reply |
| Plain-text question at end of turn | Fallback in print mode (`agy -p`), where no mid-task input is possible |
| Markdown task list in the reply | Signal progress without blocking |

Permission prompts for commands and file writes are separate from skill questions; the Don approves them in the CLI, and subagent approvals appear in the `/agents` panel.
