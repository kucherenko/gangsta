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

After installation, the Gangsta bootstrap system prompt is appended to every pi.dev session. The framework skills auto-load via the `skill` tool when the agent identifies matching intent (building, fixing, debugging, reviewing). No slash commands are required — the agent invokes skills directly based on your request.

### Quick Start

1. Open your project in pi.dev
2. Describe what you want to build — e.g., "I want to build a new feature"
3. The Gangsta framework bootstraps The Don — an orchestrator that analyzes your intent and routes to the appropriate skill, starting a Heist: a 6-phase operational cycle (Reconnaissance → The Grilling → The Sit-Down → Resource Development → The Hit → Laundering)
4. You are the Don — you approve each phase gate

## Known Risks

### Bootstrap Prompt Drift (Severity: MEDIUM)

The condensed Gangsta framework instructions embedded in `index.ts` are a snapshot captured at the time of authoring. They will not automatically update when Gangsta skills are upgraded or modified.

**Workaround:** When upgrading the Gangsta skills package, manually review and sync the bootstrap prompt in `index.ts` to reflect any material changes to the framework.
