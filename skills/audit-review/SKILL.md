---
name: audit-review
description: Use when completing tasks, implementing major features, or before merging — dispatches the-inspector to audit the books before the job is closed
---

# The Audit: Requesting Code Review

## Overview

Dispatch the-inspector to catch issues before they compound. The inspector gets precisely crafted context for evaluation — never the session's history. This keeps the inspector focused on the work product, not the thought process, and preserves your context for continued work.

**Core principle:** Audit early, audit often.

## When to Request

**Mandatory:**
- After each task in parallel execution (The Hit)
- After completing a major feature
- Before merge to main

**Optional but valuable:**
- When stuck (fresh perspective)
- Before refactoring (baseline check)
- After fixing complex bug

## How to Request

### 1. Get Git SHAs

```bash
BASE_SHA=$(git rev-parse HEAD~1)  # or origin/main
HEAD_SHA=$(git rev-parse HEAD)
```

### 2. Dispatch the-inspector

Use the Task tool to dispatch the `the-inspector` agent. Fill the template at `the-inspector-prompt.md` in this skill directory with the following placeholders:

- `{WHAT_WAS_IMPLEMENTED}` — What you just built
- `{PLAN_OR_REQUIREMENTS}` — What it should do (Contract clause, spec section)
- `{BASE_SHA}` — Starting commit
- `{HEAD_SHA}` — Ending commit
- `{DESCRIPTION}` — Brief summary of the changes

### 3. Act on Findings

| Severity | Action |
|----------|--------|
| **Critical** | Fix immediately. Do not proceed until resolved. |
| **Important** | Fix before proceeding to the next task. |
| **Minor** | Note for later. Don't block progress. |
| **Wrong** | Push back with technical reasoning. |

## Example

```
[Just completed implementing auth middleware]

1. Get SHAs:
   BASE_SHA=$(git log --oneline | grep "previous task" | head -1 | awk '{print $1}')
   HEAD_SHA=$(git rev-parse HEAD)

2. Dispatch the-inspector:
   WHAT_WAS_IMPLEMENTED: JWT auth middleware with role-based access
   PLAN_OR_REQUIREMENTS: Contract section 3.2 — Authentication
   BASE_SHA: a7981ec
   HEAD_SHA: 3df7661
   DESCRIPTION: Added auth middleware, role guards, token validation

3. Inspector returns:
   Strengths: Clean separation, real tests
   Issues:
     Important: Missing token expiry check
     Minor: Magic number for token TTL
   Assessment: Ready with fixes

4. Fix important issue, proceed to next task.
```

## Integration with Heist Pipeline

- **The Hit:** Audit after each Capo's territory completion
- **Laundering:** Final audit before the Don's approval
- **Ad-hoc work:** Audit before merge

## Red Flags

**Never:**
- Skip audit because "it's simple"
- Ignore Critical issues
- Proceed with unfixed Important issues
- Argue with valid technical feedback without evidence

**If inspector is wrong:**
- Push back with technical reasoning
- Show code/tests that prove it works
- Use `gangsta:receiving-orders` for processing feedback rigorously

## Omerta Compliance
- [ ] Rule of Truth: Inspector reviews actual diffs, not claims
- [ ] Introduction Rule: Inspector communicates through the audit skill, not directly with Soldiers
