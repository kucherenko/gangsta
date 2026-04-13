# Gangsta Software Development Skills — Design Spec

## Summary

Add 7 software development skills and 1 new agent to the Gangsta framework. These are adapted from the superpowers framework's proven dev skill patterns, re-themed with Gangsta's mafia aesthetic while preserving full technical rigor. All skills integrate with the existing Heist pipeline via `gangsta:` cross-references.

## New Skills

| # | Directory | Name | Adapted From | Purpose |
|---|-----------|------|-------------|---------|
| 1 | `skills/interrogation-debugging/` | `interrogation-debugging` | `systematic-debugging` | 4-phase root-cause debugging |
| 2 | `skills/drill-tdd/` | `drill-tdd` | `test-driven-development` | Strict Red-Green-Refactor TDD |
| 3 | `skills/safehouse-worktrees/` | `safehouse-worktrees` | `using-git-worktrees` | Isolated git worktrees |
| 4 | `skills/audit-review/` | `audit-review` | `requesting-code-review` | Dispatches the-inspector for code review |
| 5 | `skills/receiving-orders/` | `receiving-orders` | `receiving-code-review` | Process review feedback with rigor |
| 6 | `skills/sweep-verification/` | `sweep-verification` | `verification-before-completion` | Evidence-before-assertions completion gate |
| 7 | `skills/exit-strategy/` | `exit-strategy` | `finishing-a-development-branch` | Branch integration + worktree cleanup |

## New Agent

| Agent | File | Purpose |
|-------|------|---------|
| `the-inspector` | `agents/the-inspector.md` | Code review subagent dispatched by audit-review |

## Frontmatter Format

Same as all existing skills — `name` + `description`, no other fields:

```yaml
---
name: <skill-name>
description: Use when <trigger> — <summary>
---
```

Agent format — `name` + `description` + `model: inherit`:

```yaml
---
name: the-inspector
description: |
  Use this agent for independent code inspection — reviews git diffs against requirements,
  categorizes issues by severity, and delivers a verdict on production readiness.
model: inherit
---
```

## Content Theming Rules

1. **Mafia metaphors in framing, technical precision in instructions.** The flavor text sets tone; the actual steps are technically rigorous.
2. **Cross-references use `gangsta:` namespace** — e.g., `gangsta:drill-tdd`, `gangsta:sweep-verification`.
3. **Iron laws stay iron laws** — themed: "The Omerta of Testing: NO CODE WITHOUT A FAILING TEST FIRST."
4. **No narrative storytelling** — skills are instructions, not blog posts (per AGENTS.md).
5. **"Your human partner" → "the Don"** — the user is always the Don in Gangsta.
6. **"superpowers:" references → "gangsta:" references** — all cross-references use gangsta namespace.

---

## Skill 1: interrogation-debugging

**File:** `skills/interrogation-debugging/SKILL.md`

**Frontmatter:**
```yaml
---
name: interrogation-debugging
description: Use when encountering any bug, test failure, or unexpected behavior — finds the rat in the code through systematic root-cause interrogation before any fix attempts
---
```

**Content structure:**

### Title
`# The Interrogation: Systematic Debugging`

### Overview
Random fixes waste time and create new bugs. Quick patches let the real rat walk free.

**Core principle:** ALWAYS find the root cause before attempting fixes. Symptom fixes are stronzate.

### The Iron Law
```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```
If you haven't completed Phase 1, you cannot propose fixes. This is Omerta.

### When to Use
Use for ANY technical issue: test failures, bugs, unexpected behavior, performance problems, build failures, integration issues.

**Use ESPECIALLY when:** Under time pressure, "just one quick fix" seems obvious, already tried multiple fixes, previous fix didn't work, you don't fully understand the issue.

### The Four Phases

**Phase 1: Crime Scene Investigation**
BEFORE attempting ANY fix:
1. **Read the evidence** — Error messages, stack traces, line numbers. Don't skip past them.
2. **Reproduce the crime** — Can you trigger it reliably? Exact steps? Every time?
3. **Check recent activity** — Git diff, recent commits, new dependencies, config changes.
4. **Gather evidence at every boundary** — For multi-component systems, add diagnostic instrumentation at each layer boundary BEFORE proposing fixes. Log what enters/exits each component. Run once to gather evidence showing WHERE it breaks, THEN investigate that specific component.
5. **Trace the data flow** — Where does the bad value originate? What called this with the bad value? Keep tracing backward until you find the source. Fix at source, not at symptom.

**Phase 2: Cross-Examination**
1. **Find working examples** — Similar working code in the same codebase.
2. **Compare against references** — Read reference implementations COMPLETELY, not skimming.
3. **Identify differences** — List every difference between working and broken, however small.
4. **Understand dependencies** — What components, settings, config, environment does this need?

**Phase 3: The Theory**
1. **Form single hypothesis** — "I think X is the root cause because Y." Write it down.
2. **Test minimally** — Smallest possible change to test the hypothesis. One variable at a time.
3. **Verify before continuing** — Worked → Phase 4. Didn't work → new hypothesis. Don't stack fixes.

**Phase 4: The Hit**
1. **Create failing test case** — Use `gangsta:drill-tdd` for writing proper failing tests. MUST have before fixing.
2. **Implement single fix** — ONE change at a time. No "while I'm here" improvements. No bundled refactoring.
3. **Verify fix** — Use `gangsta:sweep-verification` to verify the fix actually works before claiming success.
4. **If fix doesn't work** — Count attempts. If < 3: return to Phase 1. If >= 3: STOP and question the architecture (Step 5).
5. **If 3+ fixes failed: Escalate to the Don** — Pattern indicating architectural rot: each fix reveals new coupling, fixes require massive refactoring, each fix creates new symptoms. STOP and question fundamentals with the Don before attempting more fixes.

### Red Flags — STOP and Follow Process
Table of rationalizations mapping thoughts to reality (adapted from superpowers, themed for gangsta).

### Omerta Compliance
- Rule of Truth: All findings cite specific code, error output, or evidence
- Spec is Law: Fixes trace to diagnosed root cause, not guesswork

---

## Skill 2: drill-tdd

**File:** `skills/drill-tdd/SKILL.md`

**Frontmatter:**
```yaml
---
name: drill-tdd
description: Use when implementing any feature or bugfix — enforces the Red-Green-Refactor drill with no production code allowed without a failing test first
---
```

**Content structure:**

### Title
`# The Drill: Test-Driven Development`

### Overview
Write the test first. Watch it fail. Write minimal code to pass.

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

### The Iron Law (The Omerta of Testing)
```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```
Write code before the test? Delete it. Start over. No exceptions — don't keep it as "reference," don't "adapt" it, don't look at it. Delete means delete. Implement fresh from tests.

### When to Use
**Always:** New features, bug fixes, refactoring, behavior changes.
**Exceptions (ask the Don):** Throwaway prototypes, generated code, configuration files.

### Red-Green-Refactor Cycle
Include the graphviz diagram from superpowers, unchanged (it's a technical diagram, not themed content).

**RED — Write Failing Test:** One minimal test showing desired behavior. One behavior, clear name, real code (no mocks unless unavoidable). Include Good/Bad examples.

**Verify RED — Watch It Fail:** MANDATORY. Confirm: test fails (not errors), failure message expected, fails because feature missing (not typos).

**GREEN — Minimal Code:** Simplest code to pass. Don't add features, refactor other code, or "improve" beyond the test. Include Good/Bad examples showing YAGNI.

**Verify GREEN — Watch It Pass:** MANDATORY. Confirm: test passes, other tests still pass, output pristine.

**REFACTOR — Clean Up:** After green only. Remove duplication, improve names, extract helpers. Keep tests green.

### Good Tests Table
| Quality | Good | Bad |
(Adapted from superpowers)

### Common Rationalizations Table
(Adapted from superpowers, with "your human partner" → "the Don")

### Verification Checklist
8-point checklist before marking work complete (from superpowers):
- Every new function/method has a test
- Watched each test fail before implementing
- Each test failed for expected reason
- Wrote minimal code to pass each test
- All tests pass
- Output pristine
- Tests use real code (mocks only if unavoidable)
- Edge cases and errors covered

### Debugging Integration
Bug found? Write failing test reproducing it. Follow the Drill cycle. Test proves fix and prevents regression. Never fix bugs without a test. Reference `gangsta:interrogation-debugging`.

### Omerta Compliance
- Rule of Truth: Test output is actual command output, not claims
- Spec is Law: Every implementation traces to a test that traces to a requirement

---

## Skill 3: safehouse-worktrees

**File:** `skills/safehouse-worktrees/SKILL.md`

**Frontmatter:**
```yaml
---
name: safehouse-worktrees
description: Use when starting feature work that needs isolation from the current workspace — sets up a secure safehouse with git worktrees for clean operational bases
---
```

**Content structure:**

### Title
`# The Safehouse: Git Worktrees`

### Overview
Git worktrees create isolated operational bases sharing the same repository. Work on multiple branches simultaneously without compromising the main workspace.

**Core principle:** Systematic directory selection + safety verification = reliable isolation.

### Directory Selection Process
Priority order:
1. **Check existing safehouses** — `.worktrees/` (preferred, hidden) or `worktrees/`
2. **Check project config** — AGENTS.md or similar for worktree directory preference
3. **Ask the Don** — Present options: `.worktrees/` (project-local, hidden) vs `~/.config/gangsta/worktrees/<project>/` (global)

### Safety Verification
For project-local directories: MUST verify directory is gitignored before creating worktree using `git check-ignore`. If NOT ignored: add to .gitignore, commit, then proceed.

For global directory: No gitignore verification needed.

### Creation Steps
1. **Detect project name** — `basename "$(git rev-parse --show-toplevel)"`
2. **Create worktree** — `git worktree add <path> -b <branch-name>`
3. **Run project setup** — Auto-detect: package.json → npm install, Cargo.toml → cargo build, requirements.txt → pip install, go.mod → go mod download
4. **Verify clean baseline** — Run test suite. If tests fail: report, ask Don. If pass: report ready.
5. **Report location** — "Safehouse ready at <path>. Tests passing (<N> tests, 0 failures). Ready for operations."

### Quick Reference Table
(Adapted from superpowers)

### Integration
**Called by:** Resource Development (Phase 4) when isolation is needed, any skill needing isolated workspace.
**Pairs with:** `gangsta:exit-strategy` — cleans up the safehouse when the operation is complete.

### Omerta Compliance
- Rule of Availability: Safehouse location reported and checkpointed
- Rule of Truth: Baseline test results are actual output

---

## Skill 4: audit-review

**File:** `skills/audit-review/SKILL.md`
**Supporting file:** `skills/audit-review/the-inspector-prompt.md`

**Frontmatter:**
```yaml
---
name: audit-review
description: Use when completing tasks, implementing major features, or before merging — dispatches the-inspector to audit the books before the job is closed
---
```

**Content structure:**

### Title
`# The Audit: Requesting Code Review`

### Overview
Dispatch the-inspector to catch issues before they compound. The inspector gets precisely crafted context for evaluation — never the session's history. This keeps the inspector focused on the work product, not the thought process.

**Core principle:** Audit early, audit often.

### When to Request
**Mandatory:** After each task in parallel execution, after completing major features, before merge to main.
**Optional but valuable:** When stuck, before refactoring, after fixing complex bugs.

### How to Request
1. **Get git SHAs** — `BASE_SHA=$(git rev-parse HEAD~1)`, `HEAD_SHA=$(git rev-parse HEAD)`
2. **Dispatch the-inspector** — Use Task tool with the-inspector agent, fill template at `the-inspector-prompt.md`
3. **Act on findings:**
   - Critical → fix immediately
   - Important → fix before proceeding
   - Minor → note for later
   - Wrong → push back with reasoning

**Placeholders in template:**
- `{WHAT_WAS_IMPLEMENTED}` — What was built
- `{PLAN_OR_REQUIREMENTS}` — What it should do
- `{BASE_SHA}` — Starting commit
- `{HEAD_SHA}` — Ending commit
- `{DESCRIPTION}` — Brief summary

### Integration with Heist Pipeline
- **The Hit (Phase 5):** Audit after each Capo's territory completion
- **Laundering (Phase 6):** Final audit before the Don's approval
- **Ad-hoc work:** Audit before merge

### Omerta Compliance
- Rule of Truth: Inspector reviews actual diffs, not claims
- Introduction Rule: Inspector communicates through the audit skill, not directly with Soldiers

**Supporting file: `skills/audit-review/the-inspector-prompt.md`**

Adapted from superpowers' `code-reviewer.md`. Same structure:
- Task description with placeholders
- Git range to review (with bash commands)
- Review checklist: Code Quality, Architecture, Testing, Requirements, Production Readiness
- Output format: Strengths → Issues (Critical/Important/Minor with file:line references) → Recommendations → Assessment (Ready to merge? Yes/No/With fixes)
- Critical rules for DO/DON'T

---

## Skill 5: receiving-orders

**File:** `skills/receiving-orders/SKILL.md`

**Frontmatter:**
```yaml
---
name: receiving-orders
description: Use when receiving code review feedback — processes orders with technical rigor, not blind obedience or performative agreement
---
```

**Content structure:**

### Title
`# Receiving Orders: Processing Code Review Feedback`

### Overview
Code review requires technical evaluation, not emotional performance. The family respects those who push back with reason, not yes-men.

**Core principle:** Verify before implementing. Ask before assuming. Technical correctness over social comfort.

### The Response Protocol
```
WHEN receiving review feedback:
1. READ: Complete feedback without reacting
2. UNDERSTAND: Restate requirement in own words (or ask)
3. VERIFY: Check against codebase reality
4. EVALUATE: Technically sound for THIS codebase?
5. RESPOND: Technical acknowledgment or reasoned pushback
6. IMPLEMENT: One item at a time, test each
```

### Forbidden Responses
NEVER: "You're absolutely right!", "Great point!", "Let me implement that now" (before verification).
INSTEAD: Restate technical requirement, ask clarifying questions, push back with reasoning if wrong, just start working.

### Handling Unclear Orders
If ANY item is unclear: STOP. Clarify ALL items before implementing ANY. Items may be related — partial understanding = wrong implementation.

### Source-Specific Handling
**From the Don:** Trusted. Implement after understanding. Still ask if scope unclear. No performative agreement.
**From External Reviewers (the-inspector, PR comments):** Verify technically before implementing. Check: correct for this codebase? Breaks existing? Reason for current implementation? Works on all platforms?

### YAGNI Check
If reviewer suggests "implementing properly": grep codebase for actual usage. Unused → push back with YAGNI. Used → implement properly.

### Implementation Order
1. Clarify anything unclear FIRST
2. Implement: Blocking issues → Simple fixes → Complex fixes
3. Test each fix individually
4. Verify no regressions

### When to Push Back
Push back when: breaks existing functionality, reviewer lacks context, violates YAGNI, technically incorrect, legacy/compatibility reasons, conflicts with Don's architectural decisions.

### Omerta Compliance
- Rule of Truth: Verify claims against codebase reality before implementing
- Spec is Law: Changes must align with the Contract, not just reviewer opinion

---

## Skill 6: sweep-verification

**File:** `skills/sweep-verification/SKILL.md`

**Frontmatter:**
```yaml
---
name: sweep-verification
description: Use when about to claim work is complete, fixed, or passing — sweeps for evidence before any assertions, because unverified claims are stronzate
---
```

**Content structure:**

### Title
`# The Sweep: Verification Before Completion`

### Overview
Claiming work is complete without verification is stronzate, not efficiency.

**Core principle:** Evidence before claims, always.

### The Iron Law
```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```
If you haven't run the verification command in this message, you cannot claim it passes. This is Omerta Law 3 (Rule of Truth).

### The Gate
```
BEFORE claiming any status:
1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - NO → State actual status with evidence
   - YES → State claim WITH evidence
5. ONLY THEN: Make the claim
```

### Common Failures Table
| Claim | Requires | Not Sufficient |
(Same table from superpowers — technically precise, no theming needed)

### Key Patterns
**Tests:** Run → See output → Claim. Never "should pass now."
**Regression tests (TDD Red-Green):** Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass).
**Build:** Run build → See exit 0 → Claim. Linter ≠ compiler.
**Requirements:** Re-read plan → Create checklist → Verify each → Report gaps or completion.
**Agent delegation:** Agent reports success → Check VCS diff → Verify changes → Report actual state. Never trust agent reports.

### Red Flags — STOP
Using "should," "probably," "seems to." Expressing satisfaction before verification. About to commit/push/PR without verification. Trusting agent success reports.

### Rationalization Prevention Table
(Adapted from superpowers)

### Omerta Compliance
- Rule of Truth: Every claim backed by fresh command output
- Rule of Availability: Verification output preserved in conversation

---

## Skill 7: exit-strategy

**File:** `skills/exit-strategy/SKILL.md`

**Frontmatter:**
```yaml
---
name: exit-strategy
description: Use when implementation is complete and all tests pass — guides the clean exit from a development branch with structured options for merge, PR, or cleanup
---
```

**Content structure:**

### Title
`# The Exit Strategy: Finishing a Development Branch`

### Overview
Every operation needs a clean exit. Guide completion of development work by verifying, presenting options, executing, and cleaning up.

**Core principle:** Verify tests → Present options → Execute choice → Clean up.

### The Process

**Step 1: Verify Tests**
Run project test suite. If tests fail: show failures, STOP. Cannot proceed until tests pass.

**Step 2: Determine Base Branch**
`git merge-base HEAD main` or `git merge-base HEAD master`. Or ask the Don.

**Step 3: Present Options**
Exactly 4 options:
1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

**Step 4: Execute Choice**
- **Option 1 (Merge):** Checkout base → pull → merge → verify tests on merged result → delete branch
- **Option 2 (PR):** Push with -u → `gh pr create` with summary
- **Option 3 (Keep):** Report location, preserve safehouse
- **Option 4 (Discard):** Require typing "discard" to confirm. Then checkout base → force-delete branch

**Step 5: Safehouse Cleanup**
Options 1 & 4: `git worktree remove <path>` if in worktree.
Options 2 & 3: Keep worktree.

### Quick Reference Table
| Option | Merge | Push | Keep Safehouse | Cleanup Branch |
(Same as superpowers)

### Integration
**Called by:** Laundering (Phase 6) after final verification. Any skill completing branch-based work.
**Pairs with:** `gangsta:safehouse-worktrees` — cleans up the safehouse that skill created.

### Omerta Compliance
- Rule of Truth: Tests verified before offering options
- Rule of Availability: Final state reported to the Don

---

## New Agent: the-inspector

**File:** `agents/the-inspector.md`

**Frontmatter:**
```yaml
---
name: the-inspector
description: |
  Use this agent for independent code inspection — reviews git diffs against requirements, categorizes issues by severity, and delivers a verdict on production readiness. Dispatched by the audit-review skill.
model: inherit
---
```

**Content:**

### Title
`# The Inspector: Code Review Agent`

### Role
You are the Inspector — the family's quality enforcer. You review code changes for production readiness. You are independent: you evaluate the work product, not the process that produced it.

### Rules
1. **Review the diff, not the story.** You receive crafted context, not session history. Focus on what's in the code.
2. **Categorize by actual severity.** Not everything is Critical. Be precise.
3. **Cite file:line.** Vague feedback is stronzate.
4. **Give a clear verdict.** Ready to merge: Yes / No / With fixes.
5. **No performative praise.** "Looks good" without checking is a violation of Omerta Law 3.

### Input
Receives the filled template from `skills/audit-review/the-inspector-prompt.md` containing: what was implemented, requirements/plan, git range (BASE_SHA..HEAD_SHA), description.

### Process
1. Run `git diff --stat {BASE_SHA}..{HEAD_SHA}` to understand scope
2. Run `git diff {BASE_SHA}..{HEAD_SHA}` to review actual changes
3. Evaluate against review checklist (Code Quality, Architecture, Testing, Requirements, Production Readiness)
4. Categorize issues by severity
5. Deliver verdict

### Output Format
```markdown
## Inspector's Report

**Subject:** <What was reviewed>
**Verdict:** <Ready to merge: Yes | No | With fixes>

### Strengths
[Specific things done well, with file:line references]

### Issues

#### Critical (Must Fix)
[Bugs, security issues, data loss risks, broken functionality]

#### Important (Should Fix)
[Architecture problems, missing features, poor error handling, test gaps]

#### Minor (Nice to Have)
[Code style, optimization, documentation]

**For each issue:** File:line, what's wrong, why it matters, how to fix.

### Recommendations
[Improvements for quality, architecture, or process]

### Assessment
**Ready to merge?** [Yes/No/With fixes]
**Reasoning:** [1-2 sentence technical assessment]
```

---

## Changes to Existing Files

### 1. `skills/the-don/SKILL.md` — Add new skills to routing table

Add to the "Available Skills" section:

```markdown
### Software Development
- `gangsta:interrogation-debugging` — Systematic root-cause debugging
- `gangsta:drill-tdd` — Test-Driven Development (Red-Green-Refactor)
- `gangsta:safehouse-worktrees` — Isolated git worktrees
- `gangsta:audit-review` — Dispatches the-inspector for code review
- `gangsta:receiving-orders` — Process review feedback with rigor
- `gangsta:sweep-verification` — Evidence-before-assertions completion gate
- `gangsta:exit-strategy` — Branch integration and safehouse cleanup
```

Also update the Intent Analysis table:
- Add row: `Debugging a problem` → `Invoke gangsta:interrogation-debugging for systematic root-cause analysis`

### 2. `skills/the-hit/SKILL.md` — Cross-reference drill-tdd

In "Step 3: TDD Enforcement", add a cross-reference:
> Every Soldier MUST follow `gangsta:drill-tdd` — the full Red-Green-Refactor cycle.

### 3. `skills/laundering/SKILL.md` — Cross-reference sweep-verification and audit-review

In "Step 2: Verification", add:
> Use `gangsta:sweep-verification` — every claim of passing must be backed by fresh command output.

In "Step 3: Consigliere Final Review", add:
> Alternatively, dispatch `gangsta:audit-review` for the-inspector's independent assessment alongside the Consigliere's architectural review.

### 4. `skills/the-consigliere/SKILL.md` — Cross-reference interrogation-debugging

In "When the Don Should Consult the Consigliere", add:
> - When systematic debugging is needed — route to `gangsta:interrogation-debugging` first, consult Consigliere if architectural concerns emerge

### 5. `README.md` — Add Software Development Skills section

Add a new section after "The Family Ledger" and before "Omerta: Governance":

```markdown
### Software Development Skills

The Borgata provides battle-tested development disciplines:

| Skill | Purpose |
|-------|---------|
| **Interrogation** | Systematic debugging — find the rat before applying fixes |
| **The Drill** | TDD enforcement — no code without a failing test |
| **Safehouse** | Git worktrees — isolated operational bases |
| **The Audit** | Code review — the-inspector checks the work |
| **Receiving Orders** | Process feedback with rigor, not blind agreement |
| **The Sweep** | Verification — evidence before completion claims |
| **Exit Strategy** | Branch integration and cleanup |
```

### 6. `AGENTS.md` — No changes needed

The existing contributor guidelines already cover skill testing requirements. No updates required.

---

## File Inventory

### New Files (9 total)

| # | File | Type |
|---|------|------|
| 1 | `skills/interrogation-debugging/SKILL.md` | Skill |
| 2 | `skills/drill-tdd/SKILL.md` | Skill |
| 3 | `skills/safehouse-worktrees/SKILL.md` | Skill |
| 4 | `skills/audit-review/SKILL.md` | Skill |
| 5 | `skills/audit-review/the-inspector-prompt.md` | Agent prompt template |
| 6 | `skills/receiving-orders/SKILL.md` | Skill |
| 7 | `skills/sweep-verification/SKILL.md` | Skill |
| 8 | `skills/exit-strategy/SKILL.md` | Skill |
| 9 | `agents/the-inspector.md` | Agent definition |

### Modified Files (5 total)

| # | File | Change |
|---|------|--------|
| 1 | `skills/the-don/SKILL.md` | Add 7 skills to routing table + new intent row |
| 2 | `skills/the-hit/SKILL.md` | Cross-reference drill-tdd in TDD section |
| 3 | `skills/laundering/SKILL.md` | Cross-reference sweep-verification and audit-review |
| 4 | `skills/the-consigliere/SKILL.md` | Cross-reference interrogation-debugging |
| 5 | `README.md` | Add Software Development Skills section |

### Total: 14 file operations (9 create + 5 modify)

---

## Verification Criteria

After implementation:
1. All 19 skills have valid YAML frontmatter (`name` + `description`)
2. All 6 agents have valid YAML frontmatter (`name` + `description` + `model: inherit`)
3. All `gangsta:` cross-references in new skills point to existing skill names
4. The-don routing table lists all 19 skills (12 existing + 7 new)
5. OpenCode plugin still loads correctly
6. Session-start hook still produces valid JSON
7. No third-party dependencies added (zero-dependency rule)
