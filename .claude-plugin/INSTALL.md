# Installing Gangsta for Claude Code

## Install

```
/plugin marketplace add kucherenko/gangsta-marketplace
/plugin install gangsta@gangsta-marketplace
```

Restart Claude Code. The Gangsta framework will bootstrap automatically on session start.

## Verify

Start a new session and say:
> "I want to build a new feature"

The agent should invoke gangsta skills automatically, starting with Reconnaissance.

## Manual Install (Alternative)

1. Clone the repository:
```bash
git clone https://github.com/kucherenko/gangsta.git ~/.gangsta
```

2. In Claude Code, add the plugin from the local path:
```
/plugin install gangsta@file:///path/to/.gangsta/.claude-plugin
```
