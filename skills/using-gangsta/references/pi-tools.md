# pi.dev Tool Mapping

Skills use Claude Code tool names as the canonical reference. When you encounter these in a skill, use the pi.dev equivalent:

| Skill references | pi.dev equivalent |
|-----------------|-------------------|
| `Skill` tool (invoke a skill) | `pi.registerCommand()` — expose skills as `/name` slash commands |
| `Task` tool (dispatch subagent) | No native dispatch — use the LLM's native multi-step reasoning (see [Agent types](#agent-types)) |
| Multiple `Task` calls (parallel) | Sequence multi-step reasoning; pi.dev has no parallel subagent dispatch |
| `TodoWrite` (task tracking) | `pi.appendEntry()` to persist task state — see [Displaying plan / todos](#displaying-plan--todos) |
| `Read` (file reading) | `fs.readFileSync(path, 'utf8')` or `fs.promises.readFile(path, 'utf8')` |
| `Write` (file creation) | `fs.writeFileSync(path, content)` or `fs.promises.writeFile(path, content)` |
| `Edit` (file editing) | Read file with `fs.readFileSync`, replace content, write back with `fs.writeFileSync` |
| `Bash` (run commands) | `pi.exec(cmd, args)` — e.g. `pi.exec("git", ["status"])` |
| `Grep` (search file content) | `pi.exec("grep", ["-r", pattern, dir])` or use Node.js `fs` + string search |
| `Glob` (search files by name) | `pi.exec("find", [dir, "-name", pattern])` or use Node.js `fs` recursive traversal |
| `WebFetch` | `fetch(url)` (Node.js native) or `pi.exec("curl", ["-s", url])` |
| `WebSearch` | `pi.exec("curl", [...])` against a search API endpoint |
| `question` / `ask_user` (ask the Don to choose) | No native tool — see [Asking the Don to choose](#asking-the-don-to-choose) |
| Pause-and-prompt mid-task | End turn and wait — see [Interacting with the Don mid-task](#interacting-with-the-don-mid-task) |

## Displaying plan / todos

pi.dev does not render a structured todo UI. Persist task state with `pi.appendEntry()`:

```js
pi.appendEntry("[ ] Map codebase");
pi.appendEntry("[x] Map codebase  // completed");
```

Since there is no live todo panel, skills that need visible progress must call `pi.appendEntry()` after each item transitions state. Keep entries short — they double as the session log.

## Asking the Don to choose

pi.dev has **no structured `question`/`ask_user` tool**. When a skill requires the Don to select a variant, confirm a path, or answer a question:

1. Emit the options as a **numbered list** in plain text via the chat response.
2. **End the turn immediately** — do not call `pi.exec`, `pi.appendEntry`, or any other API after the question.
3. The Don's next message is the answer; their reply resumes the turn.

Example:

```
Which approach should I take?

1. Add a cache layer in the repo (smallest diff, fits YAGNI).
2. Refactor to a worker pool (more code, scales later).
3. Do nothing — output is actually fine.
```

Never block on a tool call waiting for input. pi.dev does not expose one, and calling an API after the question will keep the turn running instead of yielding to the Don.

## Interacting with the Don mid-task

| Mode | How to interact |
|------|-----------------|
| Interactive pi.dev chat | End the turn with a plain-text question; the Don's reply resumes the session |
| Registered slash command | `/gangsta-recon` etc. for entry-point invocation — not for mid-task questions |

pi.dev has no native subagent dispatch, so there is no parallel work to manage while waiting for the Don. Interaction is purely the question → reply cycle.

## Agent types

pi.dev does not have a native subagent dispatch mechanism equivalent to Claude Code's `Task` tool. Gangsta roles (associate, soldier, inspector, etc.) must be approximated through:

- **Multi-step reasoning**: break the task into sequential LLM reasoning steps within the same session
- **Slash commands**: register each Gangsta role as a `/command` via `pi.registerCommand()` so users can invoke them explicitly
- **Separate sessions**: for true isolation, open a new pi.dev session and pass context via shared files or `pi.appendEntry()`

### Gangsta role mapping

| Gangsta role | pi.dev approach |
|--------------|----------------|
| `associate` (reconnaissance) | Inline multi-step reasoning; read codebase with `fs` APIs |
| `soldier` (implementation) | Inline execution within the current session |
| `the-inspector` (code review) | Register as `/gangsta-inspect` slash command via `pi.registerCommand()` |
| `proposer` / `devils-advocate` / `synthesizer` (grilling) | Sequential reasoning passes within the session |

## Background tasks

pi.dev does not have a built-in background task tool. Approximate async work with:

| Approach | Purpose |
|----------|---------|
| `pi.exec("node", ["script.js"])` | Run a Node.js script as a child process |
| Node.js `child_process.spawn()` | Non-blocking process execution with stream handling |
| `pi.appendEntry()` | Persist intermediate state between reasoning steps |

For skills like `gangsta:the-hit` that expect parallel Worker dispatch, execute work packages sequentially and track state with `pi.appendEntry()`.

## Registering slash commands

Skills that expose entry points should be registered as slash commands:

```js
// In your pi.dev extension factory function:
pi.registerCommand("gangsta-recon", {
  description: "Run Gangsta reconnaissance on the current project",
  handler: async (args, ctx) => {
    // skill logic here
  }
});
```

Commands are invoked as `/gangsta-recon` in the pi.dev chat interface.

## Additional pi.dev APIs

| API | Purpose |
|-----|---------|
| `pi.exec(cmd, args)` | Run shell commands synchronously via the extension process |
| `pi.appendEntry(text)` | Append a text entry to the session log / memory |
| `pi.registerCommand(opts)` | Register a slash command accessible from the chat UI |
| Node.js `fs` module | Full file system access (read, write, stat, readdir, etc.) |
| Node.js `path` module | Path manipulation utilities |
| Node.js `child_process` | Spawn child processes for async or streaming shell execution |
| Node.js `fetch` | HTTP requests for web content and API calls |
