# Codex Tool Mapping

Skills use Claude Code tool names as the canonical reference. When you encounter these in a skill, use the Codex equivalent:

| Skill references | Codex equivalent |
|-----------------|------------------|
| `Task` tool (dispatch subagent) | `spawn_agent` (see [Named agent dispatch](#named-agent-dispatch)) |
| Multiple `Task` calls (parallel) | Multiple `spawn_agent` calls |
| Task returns result | `wait` |
| Task completes automatically | `close_agent` to free slot |
| `TodoWrite` (task tracking) | `update_plan` — see [Displaying plan / todos](#displaying-plan--todos) |
| `Skill` tool (invoke a skill) | Skills load natively — just follow the instructions |
| `Read`, `Write`, `Edit` (files) | Use your native file tools |
| `Bash` (run commands) | Use your native shell tools |
| `question` / `ask_user` (ask the Don to choose) | No native tool — see [Asking the Don to choose](#asking-the-don-to-choose) |
| Pause-and-prompt mid-task | End turn and wait — see [Interacting with the Don mid-task](#interacting-with-the-don-mid-task) |

## Displaying plan / todos

Codex exposes three surfaces for plan/todo display:

| Surface | When to use |
|---------|-------------|
| `update_plan` tool | Mutate the in-TUI plan panel from a skill — add/update/complete items |
| `/plan` slash command | Toggle plan mode for multi-step planning in the composer |
| `/goal` slash command | Set a persistent objective whose progress renders above the composer while it runs |

When a skill says "create a todowrite per item", call `update_plan` with the items. The plan panel reflects the changes without further action.

## Asking the Don to choose

Codex has **no structured `question`/`ask_user` tool** like OpenCode's `question` or Gemini's `ask_user`. When a skill requires the Don to select a variant, confirm a path, or answer a question:

1. Emit the options as a **numbered list** in plain text.
2. **End the turn immediately** — do not call `update_plan`, `spawn_agent`, or any other tool after the question.
3. The Don's next message is the answer; their reply resumes the turn.

Example:

```
Which approach should I take?

1. Add a cache layer in the repo (smallest diff, fits YAGNI).
2. Refactor to a worker pool (more code, scales later).
3. Do nothing — output is actually fine.
```

Never block on a tool call waiting for input. The CLI does not expose one, and calling a tool after the question will keep the turn running instead of yielding to the Don.

## Interacting with the Don mid-task

Codex offers two interaction surfaces, depending on how the session runs:

| Mode | How to interact |
|------|-----------------|
| Interactive `codex` | End the turn with a plain-text question; the Don's reply resumes the session |
| Non-interactive `codex exec` | No mid-task input — skills that pause for the Don will fail; pre-supply choices in the prompt or run interactive |

Sandbox and approval prompts are **separate from skill questions**. Codex renders an approval overlay when a tool needs permission. If a subagent in another thread needs approval, the overlay labels the source thread; press `o` to open that thread before you approve, reject, or answer.

To inspect or steer running subagents in the interactive TUI:

| Command | Purpose |
|---------|---------|
| `/agent` | Switch between active subagent threads and inspect their work |
| `/status` | Show task ID, context usage, and rate limits |
| `/compact` | Compact the current task's context if it is getting full |
| `/fork` | Copy the current task into a new task or worktree before diverging |

Subagents inherit the parent turn's permission mode and live runtime overrides (`/permissions`, `--yolo`), even if the agent's TOML file sets different defaults.

## Subagent dispatch requires multi-agent support

Add to your Codex config (`~/.codex/config.toml`):

```toml
[features]
multi_agent = true
```

This enables `spawn_agent`, `wait`, and `close_agent` for skills like `gangsta:the-hit` and `gangsta:resource-development`.

## Named agent dispatch

Gangsta skills reference named agent types like `gangsta:soldier` or `gangsta:devils-advocate`. Codex does not have a named agent registry — `spawn_agent` creates generic agents from built-in roles (`default`, `explorer`, `worker`).

When a skill says to dispatch a named agent type:

1. Find the agent's prompt file (e.g., `agents/soldier.md` or `agents/devils-advocate.md`)
2. Read the prompt content
3. Fill any template placeholders
4. Spawn a `worker` agent with the filled content as the `message`

| Skill instruction | Codex equivalent |
|-------------------|------------------|
| `Task tool (gangsta:soldier)` | `spawn_agent(agent_type="worker", message=...)` with `soldier.md` content |
| `Task tool (general-purpose)` with inline prompt | `spawn_agent(message=...)` with the same prompt |

### Message framing

The `message` parameter is user-level input, not a system prompt. Structure it for maximum instruction adherence:

```
Your task is to perform the following. Follow the instructions below exactly.

<agent-instructions>
[filled prompt content from the agent's .md file]
</agent-instructions>

Execute this now. Output ONLY the structured response following the format
specified in the instructions above.
```

- Use task-delegation framing ("Your task is...") rather than persona framing ("You are...")
- Wrap instructions in XML tags — the model treats tagged blocks as authoritative
- End with an explicit execution directive to prevent summarization of the instructions

## Environment Detection

Skills that create worktrees or finish branches should detect their environment with read-only git commands before proceeding:

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
```

- `GIT_DIR != GIT_COMMON` — already in a linked worktree (skip creation)
- `BRANCH` empty — detached HEAD (cannot branch/push/PR from sandbox)

See `gangsta:safehouse-worktrees` Step 0 and `gangsta:exit-strategy` Step 1 for how each skill uses these signals.

## Codex App Finishing

When the sandbox blocks branch/push operations (detached HEAD in an externally managed worktree), the agent commits all work and informs the user to use the App's native controls:

- **"Create branch"** — names the branch, then commit/push/PR via App UI
- **"Hand off to local"** — transfers work to the user's local checkout

The agent can still run tests, stage files, and output suggested branch names, commit messages, and PR descriptions for the user to copy.
