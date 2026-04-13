# Installing Gangsta for OpenCode

## Quick Install

Add to your `opencode.json` configuration:

```json
{
  "plugin": ["gangsta@git+https://github.com/user/gangsta.git"]
}
```

Restart OpenCode. The Gangsta framework will bootstrap automatically on session start.

## Verify Installation

Start a new OpenCode session and say:
> "I want to build a new feature"

The agent should respond by invoking the `gangsta:reconnaissance` skill to begin a Heist.

## Manual Install (Alternative)

1. Clone the repository:
```bash
git clone https://github.com/user/gangsta.git ~/.gangsta
```

2. Add to `opencode.json`:
```json
{
  "plugin": ["gangsta@file:///path/to/.gangsta"]
}
```
