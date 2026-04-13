# Installing Gangsta for Codex

## Install

1. Clone the repository:
```bash
git clone https://github.com/kucherenko/gangsta.git ~/.gangsta
```

2. Create a symlink so Codex discovers the skills:
```bash
mkdir -p ~/.agents/skills
ln -sf ~/.gangsta/skills ~/.agents/skills/gangsta
```

3. Restart Codex. Skills will be discovered automatically from SKILL.md frontmatter.

## Verify

Start a new Codex session and say:
> "I want to build a new feature"

The agent should invoke gangsta skills automatically.

## Update

```bash
cd ~/.gangsta && git pull
```
