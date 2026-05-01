# pi.dev Tool Mapping

Skills use Claude Code tool names as the canonical reference. When you encounter these in a skill, use the pi.dev equivalent:

| Skill references | pi.dev equivalent |
|-----------------|-------------------|
| `Skill` tool (invoke a skill) | `pi.registerCommand()` — expose skills as `/name` slash commands |
| `Task` tool (dispatch subagent) | No native dispatch — use the LLM's native multi-step reasoning (see [Agent types](#agent-types)) |
| Multiple `Task` calls (parallel) | Sequence multi-step reasoning; pi.dev has no parallel subagent dispatch |
| `TodoWrite` (task tracking) | `pi.appendEntry()` to persist task state in session |
| `Read` (file reading) | `fs.readFileSync(path, 'utf8')` or `fs.promises.readFile(path, 'utf8')` |
| `Write` (file creation) | `fs.writeFileSync(path, content)` or `fs.promises.writeFile(path, content)` |
| `Edit` (file editing) | Read file with `fs.readFileSync`, replace content, write back with `fs.writeFileSync` |
| `Bash` (run commands) | `pi.exec(cmd, args)` — e.g. `pi.exec("git", ["status"])` |
| `Grep` (search file content) | `pi.exec("grep", ["-r", pattern, dir])` or use Node.js `fs` + string search |
| `Glob` (search files by name) | `pi.exec("find", [dir, "-name", pattern])` or use Node.js `fs` recursive traversal |
| `WebFetch` | `fetch(url)` (Node.js native) or `pi.exec("curl", ["-s", url])` |
| `WebSearch` | `pi.exec("curl", [...])` against a search API endpoint |

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
