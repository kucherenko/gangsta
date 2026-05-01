# Gangsta Extension for pi.dev — Installation Guide

## Prerequisites

- [pi.dev](https://pi.dev) installed and available in your environment
- Your project uses pi as the coding agent

## Installation

The extension lives in `.pi/extensions/gangsta/` and is project-local. To use it:

**Option A — Commit to your repo (recommended):**
The `.pi/extensions/gangsta/` directory is already present in this repo. Commit it alongside your project files. pi.dev auto-discovers extensions from `.pi/extensions/` in the working directory at startup.

**Option B — Copy to another project:**
Copy the `.pi/extensions/gangsta/` directory into your project's `.pi/extensions/` folder.

No `npm install` or compilation step is required. pi loads TypeScript directly via [jiti](https://github.com/unjs/jiti), so the extension works out of the box.

**Zero runtime dependencies:** The extension `package.json` declares `"dependencies": {}`. Nothing to install.

## Usage

After installation, the following slash commands are available in pi:

| Command | Description |
|---------|-------------|
| `/gangsta:heist` | Begin a new Heist — the full spec-driven development pipeline |
| `/gangsta:go` | Resume a paused Heist phase |
| `/gangsta:abort` | Abort the current Heist operation |

### Quick Start

1. Open your project in pi.dev
2. Type `/gangsta:heist` to begin a new Heist
3. Describe what you want to build — the Don (you) approves each phase gate

## Known Risks

### Path Resolution under jiti (Severity: MEDIUM)

Command files use `__dirname` to locate resources relative to the extension source. Under jiti, `__dirname` may resolve to a temporary cache directory rather than the actual source file location, causing file reads to fail.

**Workaround:** Always invoke pi from the project root directory where `.pi/extensions/gangsta/` resides.

### Notification Channel Behavior (Severity: LOW)

Command output is delivered via `ctx.ui.notify()`. Depending on the pi.dev version, this may render as a UI toast notification rather than injecting content directly into the agent conversation thread. If this occurs, the output may not be visible in the agent context.

**Workaround:** Verify rendering behavior after install by running a test command and confirming the output appears in the conversation.

### Bootstrap Prompt Drift (Severity: MEDIUM)

The condensed Gangsta framework instructions embedded in `index.ts` are a snapshot captured at the time of authoring. They will not automatically update when Gangsta skills are upgraded or modified.

**Workaround:** When upgrading the Gangsta skills package, manually review and sync the bootstrap prompt in `index.ts` to reflect any material changes to the framework.
