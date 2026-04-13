# Installing Gangsta for OpenCode

## Quick Install

Clone the repository to a stable location, then add both a `plugin` and `skills.paths` entry to your `opencode.json`:

```bash
git clone https://github.com/kucherenko/gangsta.git ~/.gangsta
```

```json
{
  "plugin": ["gangsta@file:///Users/you/.gangsta"],
  "skills": {
    "paths": ["~/.gangsta/skills"]
  }
}
```

Replace `/Users/you/.gangsta` with the actual clone path. The `~` shorthand works in `skills.paths`.

Restart OpenCode. The Gangsta framework will bootstrap automatically on session start.

## Verify Installation

Start a new OpenCode session and say:
> "show me all skills"

You should see the Gangsta skills listed (the-don, reconnaissance, the-hit, etc.).

Then say:
> "I want to build a new feature"

The agent should invoke `gangsta:reconnaissance` to begin a Heist.
