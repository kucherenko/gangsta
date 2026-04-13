---
name: interrogation-debugging
description: Use when encountering any bug, test failure, or unexpected behavior — finds the rat in the code through systematic root-cause interrogation before any fix attempts
---

# The Interrogation: Systematic Debugging

## Overview

Random fixes waste time and create new bugs. Quick patches let the real rat walk free.

**Core principle:** ALWAYS find the root cause before attempting fixes. Symptom fixes are stronzate.

**Violating the letter of this process is violating the spirit of debugging.**

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed The Brief, you cannot propose fixes. This is Omerta.

## When to Use

Use for ANY technical issue:
- Test failures
- Bugs in production
- Unexpected behavior
- Performance problems
- Build failures
- Integration issues

**Use this ESPECIALLY when:**
- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried multiple fixes
- Previous fix didn't work
- You don't fully understand the issue

**Don't skip when:**
- Issue seems simple (simple bugs have root causes too)
- You're in a hurry (rushing guarantees rework)
- The Don wants it fixed NOW (systematic is faster than thrashing)

## The Four Phases

You MUST complete each phase before proceeding to the next.

### The Brief

**BEFORE attempting ANY fix:**

1. **Read the Evidence**
   - Don't skip past errors or warnings
   - They often contain the exact solution
   - Read stack traces completely
   - Note line numbers, file paths, error codes

2. **Reproduce the Crime**
   - Can you trigger it reliably?
   - What are the exact steps?
   - Does it happen every time?
   - If not reproducible → gather more data, don't guess

3. **Check Recent Activity**
   - What changed that could cause this?
   - Git diff, recent commits
   - New dependencies, config changes
   - Environmental differences

4. **Gather Evidence at Every Boundary**

   **WHEN system has multiple components (CI → build → signing, API → service → database):**

   **BEFORE proposing fixes, add diagnostic instrumentation:**

   For EACH component boundary:
   - Log what data enters the component
   - Log what data exits the component
   - Verify environment/config propagation
   - Check state at each layer

   Run once to gather evidence showing WHERE it breaks.
   THEN analyze evidence to identify the failing component.
   THEN investigate that specific component.

5. **Trace the Data Flow**

   **WHEN error is deep in the call stack:**

   - Where does the bad value originate?
   - What called this with the bad value?
   - Keep tracing backward until you find the source
   - Fix at source, not at symptom

### Cross-Examination

**Find the pattern before fixing:**

1. **Find Working Examples**
   - Locate similar working code in the same codebase
   - What works that's similar to what's broken?

2. **Compare Against References**
   - If implementing a pattern, read the reference implementation COMPLETELY
   - Don't skim — read every line
   - Understand the pattern fully before applying

3. **Identify Differences**
   - What's different between working and broken?
   - List every difference, however small
   - Don't assume "that can't matter"

4. **Understand Dependencies**
   - What other components does this need?
   - What settings, config, environment?
   - What assumptions does it make?

### The Theory

**Scientific method:**

1. **Form Single Hypothesis**
   - State clearly: "I think X is the root cause because Y"
   - Write it down
   - Be specific, not vague

2. **Test Minimally**
   - Make the SMALLEST possible change to test the hypothesis
   - One variable at a time
   - Don't fix multiple things at once

3. **Verify Before Continuing**
   - Did it work? Yes → The Hit
   - Didn't work? Form NEW hypothesis
   - DON'T add more fixes on top

4. **When You Don't Know**
   - Say "I don't understand X"
   - Don't pretend to know
   - Ask for help or research more

### The Hit

**Fix the root cause, not the symptom:**

1. **Create Failing Test Case**
   - Simplest possible reproduction
   - Automated test if possible
   - One-off test script if no framework
   - MUST have before fixing
   - Use `gangsta:drill-tdd` for writing proper failing tests

2. **Implement Single Fix**
   - Address the root cause identified
   - ONE change at a time
   - No "while I'm here" improvements
   - No bundled refactoring

3. **Verify Fix**
   - Test passes now?
   - No other tests broken?
   - Issue actually resolved?
   - Use `gangsta:sweep-verification` to verify before claiming success

4. **If Fix Doesn't Work**
   - STOP
   - Count: How many fixes have you tried?
   - If < 3: Return to The Brief, re-analyze with new information
   - **If ≥ 3: STOP and escalate (Step 5 below)**
   - DON'T attempt Fix #4 without architectural discussion

5. **If 3+ Fixes Failed: Escalate to the Don**

   **Pattern indicating architectural rot:**
   - Each fix reveals new shared state/coupling/problem in a different place
   - Fixes require "massive refactoring" to implement
   - Each fix creates new symptoms elsewhere

   **STOP and question fundamentals:**
   - Is this pattern fundamentally sound?
   - Are we sticking with it through sheer inertia?
   - Should we refactor architecture vs. continue fixing symptoms?

   **Discuss with the Don before attempting more fixes.**

   This is NOT a failed hypothesis — this is a wrong architecture.

## Red Flags — STOP and Follow Process

If you catch yourself thinking:

| Thought | Reality |
|---------|---------|
| "Quick fix for now, investigate later" | Investigate NOW. Quick fixes compound. |
| "Just try changing X and see" | That's guessing, not debugging. The Brief. |
| "Add multiple changes, run tests" | Can't isolate what worked. One at a time. |
| "Skip the test, I'll manually verify" | Manual verification is not evidence. |
| "It's probably X, let me fix that" | "Probably" means you haven't investigated. |
| "I don't fully understand but this might work" | Might = guessing. The Brief. |
| "One more fix attempt" (after 2+) | 3 failures = architectural problem. Escalate. |
| "Here are the main problems: [list]" | Listing without investigating = stronzate. |
| Proposing solutions before tracing data flow | STOP. Trace first, propose second. |

**ALL of these mean: STOP. Return to The Brief.**

## The Don's Signals You're Doing It Wrong

Watch for these redirections:
- "Is that not happening?" — You assumed without verifying
- "Will it show us...?" — You should have added evidence gathering
- "Stop guessing" — You're proposing fixes without understanding
- "Think harder" — Question fundamentals, not just symptoms
- "We're stuck?" (frustrated) — Your approach isn't working

**When you see these:** STOP. Return to The Brief.

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue is simple, don't need process" | Simple issues have root causes too. Process is fast for simple bugs. |
| "Emergency, no time for process" | Systematic debugging is FASTER than guess-and-check thrashing. |
| "Just try this first, then investigate" | First fix sets the pattern. Do it right from the start. |
| "I'll write test after confirming fix works" | Untested fixes don't stick. Test first proves it. |
| "Multiple fixes at once saves time" | Can't isolate what worked. Causes new bugs. |
| "Reference too long, I'll adapt the pattern" | Partial understanding guarantees bugs. Read it completely. |
| "I see the problem, let me fix it" | Seeing symptoms ≠ understanding root cause. |
| "One more fix attempt" (after 2+ failures) | 3+ failures = architectural problem. Escalate to the Don. |

## Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **The Brief** | Read errors, reproduce, check changes, gather evidence | Understand WHAT and WHY |
| **Cross-Examination** | Find working examples, compare | Identify differences |
| **The Theory** | Form hypothesis, test minimally | Confirmed or new hypothesis |
| **The Hit** | Create test, fix, verify | Bug resolved, tests pass |

## When Investigation Reveals No Root Cause

If systematic investigation reveals the issue is truly environmental, timing-dependent, or external:

1. You've completed the process
2. Document what you investigated
3. Implement appropriate handling (retry, timeout, error message)
4. Add monitoring/logging for future investigation

**But:** 95% of "no root cause" cases are incomplete investigation.

## Related Skills

- **gangsta:drill-tdd** — For creating failing test case (The Hit, Step 1)
- **gangsta:sweep-verification** — Verify fix worked before claiming success

## Omerta Compliance
- [ ] Rule of Truth: All findings cite specific code, error output, or evidence
- [ ] Spec is Law: Fixes trace to diagnosed root cause, not guesswork
