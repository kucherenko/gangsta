---
name: exit-strategy
description: Use when implementation is complete and all tests pass — guides the clean exit from a development branch with structured options for merge, PR, or cleanup
---

# The Exit Strategy: Finishing a Development Branch

## Overview

Every operation needs a clean exit. Guide completion of development work by verifying, presenting options, executing, and cleaning up.

**Core principle:** Verify tests → Present options → Execute choice → Clean up.

**Announce at start:** "Initiating exit strategy for this branch."

## The Process

### Step 1: Verify Tests

**Before presenting options, verify tests pass:**

```bash
# Run project's test suite
npm test / cargo test / pytest / go test ./...
```

**If tests fail:**
```
Tests failing (<N> failures). Must fix before exiting:

[Show failures]

Cannot proceed with merge/PR until tests pass.
```

Stop. Don't proceed to Step 2.

**If tests pass:** Continue to Step 2.

### Step 2: Determine Base Branch

```bash
# Try common base branches
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

Or ask the Don: "This branch split from main — is that correct?"

### Step 3: Present Options

Present exactly these 4 options:

```
Implementation complete. What's the exit strategy?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

**Don't add explanation** — keep options concise.

### Step 4: Execute Choice

#### Option 1: Merge Locally

```bash
# Switch to base branch
git checkout <base-branch>

# Pull latest
git pull

# Merge feature branch
git merge <feature-branch>

# Verify tests on merged result
<test command>

# If tests pass
git branch -d <feature-branch>
```

Then: Cleanup safehouse (Step 5)

#### Option 2: Push and Create PR

```bash
# Push branch
git push -u origin <feature-branch>

# Create PR
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets of what changed>

## Test Plan
- [ ] <verification steps>
EOF
)"
```

Then: Report PR URL to the Don. Preserve safehouse.

#### Option 3: Keep As-Is

Report: "Keeping branch <name>. Safehouse preserved at <path>."

**Don't cleanup safehouse.**

#### Option 4: Discard

**Confirm first:**
```
This will permanently delete:
- Branch <name>
- All commits: <commit-list>
- Safehouse at <path>

Type 'discard' to confirm.
```

Wait for exact confirmation from the Don.

If confirmed:
```bash
git checkout <base-branch>
git branch -D <feature-branch>
```

Then: Cleanup safehouse (Step 5)

### Step 5: Safehouse Cleanup

**For Options 1, 2, 4:**

Check if in a safehouse (worktree):
```bash
git worktree list | grep $(git branch --show-current)
```

If yes:
```bash
git worktree remove <worktree-path>
```

**For Option 3:** Keep safehouse.

## Quick Reference

| Option | Merge | Push | Keep Safehouse | Cleanup Branch |
|--------|-------|------|---------------|----------------|
| 1. Merge locally | ✓ | - | - | ✓ |
| 2. Create PR | - | ✓ | ✓ | - |
| 3. Keep as-is | - | - | ✓ | - |
| 4. Discard | - | - | - | ✓ (force) |

## Common Mistakes

### Skipping test verification
- **Problem:** Merge broken code, create failing PR
- **Fix:** Always verify tests before offering options

### Open-ended questions
- **Problem:** "What should I do next?" → ambiguous
- **Fix:** Present exactly 4 structured options

### Automatic safehouse cleanup
- **Problem:** Remove safehouse when it might still be needed (Option 2, 3)
- **Fix:** Only cleanup for Options 1 and 4

### No confirmation for discard
- **Problem:** Accidentally delete work
- **Fix:** Require the Don to type "discard" to confirm

## Red Flags

**Never:**
- Proceed with failing tests
- Merge without verifying tests on result
- Delete work without the Don's confirmation
- Force-push without explicit request

**Always:**
- Verify tests before offering options
- Present exactly 4 options
- Get typed confirmation for Option 4
- Clean up safehouse for Options 1 & 4 only

## Integration

**Called by:**
- **Laundering (Phase 6)** — After final verification
- Any skill completing branch-based work

**Pairs with:**
- **gangsta:safehouse-worktrees** — Cleans up the safehouse that skill created

## Omerta Compliance
- [ ] Rule of Truth: Tests verified before offering options
- [ ] Rule of Availability: Final state reported to the Don
