# Installing Gangsta for Cursor

## Install

```
/add-plugin gangsta
```

Or manually clone and link:

1. Clone the repository:
```bash
git clone https://github.com/kucherenko/gangsta.git ~/.gangsta
```

2. Add the plugin path in Cursor settings, or symlink:
```bash
ln -sf ~/.gangsta/.cursor-plugin ~/.cursor/plugins/gangsta
```

3. Restart Cursor. The Gangsta framework will bootstrap automatically on session start.

## Verify

Start a new session and say:
> "I want to build a new feature"

The agent should invoke gangsta skills automatically, starting with Reconnaissance.

## Update

```bash
cd ~/.gangsta && git pull
```
