---
name: safehouse-worktrees
description: Use when starting feature work that needs isolation from the current workspace — sets up a secure safehouse with git worktrees for clean operational bases
---

# The Safehouse: Git Worktrees

## Overview

Git worktrees create isolated operational bases sharing the same repository. Work on multiple branches simultaneously without compromising the main workspace.

**Core principle:** Systematic directory selection + safety verification = reliable isolation.

**Announce at start:** "Setting up a safehouse for isolated operations."

## Directory Selection Process

Follow this priority order:

### 1. Check Existing Safehouses

```bash
# Check in priority order
ls -d .worktrees 2>/dev/null     # Preferred (hidden)
ls -d worktrees 2>/dev/null      # Alternative
```

**If found:** Use that directory. If both exist, `.worktrees/` wins.

### 2. Check Project Config

```bash
grep -i "worktree.*director" AGENTS.md 2>/dev/null
```

**If preference specified:** Use it without asking.

### 3. Ask the Don

If no directory exists and no config preference:

```
No safehouse directory found. Where should I set up?

1. .worktrees/ (project-local, hidden)
2. ~/.config/gangsta/worktrees/<project-name>/ (global location)

Which would you prefer?
```

## Safety Verification

### For Project-Local Directories (.worktrees or worktrees)

**MUST verify directory is gitignored before creating safehouse:**

```bash
# Check if directory is ignored (respects local, global, and system gitignore)
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
```

**If NOT ignored:**
1. Add appropriate line to `.gitignore`
2. Commit the change immediately
3. Proceed with safehouse creation

**Why critical:** Prevents accidentally committing safehouse contents to repository.

### For Global Directory (~/.config/gangsta/worktrees)

No `.gitignore` verification needed — outside project entirely.

## Creation Steps

### 1. Detect Project Name

```bash
project=$(basename "$(git rev-parse --show-toplevel)")
```

### 2. Create Safehouse

```bash
# Determine full path
case $LOCATION in
  .worktrees|worktrees)
    path="$LOCATION/$BRANCH_NAME"
    ;;
  ~/.config/gangsta/worktrees/*)
    path="~/.config/gangsta/worktrees/$project/$BRANCH_NAME"
    ;;
esac

# Create worktree with new branch
git worktree add "$path" -b "$BRANCH_NAME"
cd "$path"
```

### 3. Run Project Setup

Auto-detect and run appropriate setup:

```bash
# Node.js
if [ -f package.json ]; then npm install; fi

# Rust
if [ -f Cargo.toml ]; then cargo build; fi

# Python
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi

# Go
if [ -f go.mod ]; then go mod download; fi
```

### 4. Verify Clean Baseline

Run tests to ensure safehouse starts clean:

```bash
# Use project-appropriate command
npm test / cargo test / pytest / go test ./...
```

**If tests fail:** Report failures, ask the Don whether to proceed or investigate.

**If tests pass:** Report ready.

### 5. Report Location

```
Safehouse ready at <full-path>
Tests passing (<N> tests, 0 failures)
Ready for operations.
```

## Quick Reference

| Situation | Action |
|-----------|--------|
| `.worktrees/` exists | Use it (verify ignored) |
| `worktrees/` exists | Use it (verify ignored) |
| Both exist | Use `.worktrees/` |
| Neither exists | Check AGENTS.md → Ask the Don |
| Directory not ignored | Add to .gitignore + commit |
| Tests fail during baseline | Report failures + ask the Don |
| No package.json/Cargo.toml | Skip dependency install |

## Common Mistakes

### Skipping ignore verification
- **Problem:** Safehouse contents get tracked, pollute git status
- **Fix:** Always use `git check-ignore` before creating project-local safehouse

### Assuming directory location
- **Problem:** Creates inconsistency, violates project conventions
- **Fix:** Follow priority: existing > config > ask

### Proceeding with failing tests
- **Problem:** Can't distinguish new bugs from pre-existing issues
- **Fix:** Report failures, get explicit permission from the Don

### Hardcoding setup commands
- **Problem:** Breaks on projects using different tools
- **Fix:** Auto-detect from project files

## Red Flags

**Never:**
- Create safehouse without verifying it's ignored (project-local)
- Skip baseline test verification
- Proceed with failing tests without asking the Don
- Assume directory location when ambiguous

**Always:**
- Follow directory priority: existing > config > ask
- Verify directory is ignored for project-local
- Auto-detect and run project setup
- Verify clean test baseline

## Integration

**Called by:**
- **Resource Development (Phase 4)** — When isolation is needed for implementation
- Any skill needing an isolated workspace

**Pairs with:**
- **gangsta:exit-strategy** — Cleans up the safehouse when the operation is complete

## Omerta Compliance
- [ ] Rule of Availability: Safehouse location reported and checkpointed
- [ ] Rule of Truth: Baseline test results are actual output, not claims
