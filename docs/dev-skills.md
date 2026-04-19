# Software Development Skills

These skills operate independently of the Heist Pipeline — invoke them whenever their trigger condition applies.

| Skill | Trigger |
|-------|---------|
| [`drill-tdd`](#the-drill-test-driven-development) | Any feature, bugfix, or behavior change |
| [`interrogation-debugging`](#interrogation-systematic-debugging) | Any bug, test failure, or unexpected behavior |
| [`sweep-verification`](#the-sweep-verification-gate) | Before any claim of completion, success, or passing |
| [`audit-review`](#the-audit-code-review) | After major features, before merge, when stuck |
| [`receiving-orders`](#receiving-orders-processing-feedback) | Any code review feedback received |
| [`safehouse-worktrees`](#the-safehouse-git-worktrees) | Feature work requiring branch isolation |
| [`exit-strategy`](#exit-strategy-branch-cleanup) | Implementation complete, all tests pass |

---

## The Drill: Test-Driven Development

**Skill:** `drill-tdd` | **Trigger:** Any feature, bugfix, or behavior change

**Iron Law:** No production code without a failing test first. Write code before the test? Delete it. Start over.

### The Red-Green-Refactor Cycle

#### RED — Write Failing Test

Write one minimal test showing what should happen. One behavior per test. Clear descriptive name. Real code (no mocks unless unavoidable).

**Verify RED:** Run the test. Confirm it fails — not errors. Confirm it fails because the feature is missing, not a typo. **Never skip this step.** If the test passes immediately, you are testing existing behavior — fix the test.

#### GREEN — Write Minimal Code

Write the simplest code to make the test pass. Don't add features. Don't refactor other code. Don't "improve" beyond what the test requires.

**Verify GREEN:** Run the test. Confirm it passes. Confirm all other tests still pass. Output must be clean (no errors, no warnings).

#### REFACTOR — Clean Up

After green only: remove duplication, improve names, extract helpers. Keep tests green throughout. Do not add new behavior.

**Repeat** — next failing test for next behavior.

### Exceptions (ask the Don first)

Throwaway prototypes, generated code, configuration files.

### Red Flags — Delete Code and Start Over

- Code written before test
- Test passes immediately after being written
- Can't explain why the test failed
- "I'll write tests after"
- "Keep as reference, write tests first"
- "Already spent X hours, deleting is wasteful"
- "TDD is dogmatic, I'm being pragmatic"

---

## Interrogation: Systematic Debugging

**Skill:** `interrogation-debugging` | **Trigger:** Any bug, test failure, or unexpected behavior

**Iron Law:** No fixes without root cause investigation first. Complete all four phases in order.

### Phase 1: The Brief

Before attempting any fix:

1. **Read the evidence** — Full error messages, stack traces, line numbers. Don't skim.
2. **Reproduce the crime** — Can you trigger it reliably? Exact steps? Every time?
3. **Check recent activity** — What changed? Git diff, recent commits, new dependencies, config changes.
4. **Gather evidence at every boundary** — For multi-component systems: add diagnostic instrumentation at each component boundary. Log what enters and exits each layer. Run once to see WHERE it breaks.
5. **Trace the data flow** — Where does the bad value originate? Trace backward to the source. Fix at source, not symptom.

### Phase 2: Cross-Examination

1. **Find working examples** — Locate similar working code in the same codebase.
2. **Compare against references** — Read the reference implementation completely. Every line.
3. **Identify differences** — List every difference between working and broken, however small.
4. **Understand dependencies** — What config, environment, assumptions does the broken code make?

### Phase 3: The Theory

1. **Form a single hypothesis** — "I think X is the root cause because Y." Write it down. Be specific.
2. **Test minimally** — Make the smallest possible change to test the hypothesis. One variable at a time.
3. **Verify before continuing** — Did it work? Yes → The Hit. No → form a new hypothesis. Do not add more fixes on top.

### Phase 4: The Hit

1. **Create a failing test** — Simplest possible reproduction. Automated if possible. Must have before fixing.
2. **Implement a single fix** — Address the root cause only. One change. No "while I'm here" improvements.
3. **Verify the fix** — Test passes? No regressions? Use `sweep-verification` before claiming success.

**After 3+ failed fix attempts:** Stop. This is architectural rot. Escalate to the Don — question fundamentals, not just symptoms.

### Red Flags — Stop and Return to The Brief

| Thought | Reality |
|---------|---------|
| "Quick fix for now, investigate later" | Investigate NOW. Quick fixes compound. |
| "Just try changing X and see" | That's guessing, not debugging. |
| "Add multiple changes, run tests" | Can't isolate what worked. One at a time. |
| Proposing solutions before tracing data flow | Trace first, propose second. |
| "One more fix attempt" after 2+ failures | 3 failures = architectural problem. Escalate. |

---

## The Sweep: Verification Gate

**Skill:** `sweep-verification` | **Trigger:** Before ANY claim of completion, success, or passing

**Iron Law:** No completion claims without fresh verification evidence.

### The Gate

1. Identify what command proves the claim
2. Run it — fresh, complete, full output
3. Read the output — check exit code, count failures
4. Verify output confirms the claim
5. Only then make the claim

Skip any step = invalid verification.

### Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check |
| Build succeeds | Build exit 0 | Linter passing |
| Bug fixed | Test passes on original symptom | Code changed |
| Agent completed | VCS diff shows changes | Agent reports "success" |

### Red Flags

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Done!", etc.)
- Trusting agent success reports without checking
- About to commit/push without verification

---

## The Audit: Code Review

**Skill:** `audit-review` | **Trigger:** After major features, before merge, or when stuck

Dispatches `the-inspector` — a fresh subagent with no session history — to review a specific diff. The inspector sees only what was implemented, what it should do, and the exact git SHAs.

### Process

1. Get git SHAs:
   ```bash
   BASE_SHA=$(git rev-parse HEAD~1)
   HEAD_SHA=$(git rev-parse HEAD)
   ```

2. Dispatch the-inspector with:
   - What was implemented
   - The Contract clause it implements
   - `BASE_SHA` and `HEAD_SHA`
   - Brief summary of changes

3. Act on findings by severity:

   | Severity | Action |
   |----------|--------|
   | **Critical** | Fix immediately. Do not proceed. |
   | **Important** | Fix before the next task. |
   | **Minor** | Note for later. |
   | **Wrong** | Push back with technical reasoning (`receiving-orders`). |

### Integration with the Heist

- After each Crew Lead's territory completes (The Hit)
- Before the Don's final approval (Laundering)
- Any time the Don requests a review

---

## Receiving Orders: Processing Feedback

**Skill:** `receiving-orders` | **Trigger:** Any code review feedback received

Technical evaluation over emotional performance. Verify before implementing. Push back with reason when warranted.

### The Protocol

1. **Read** — Complete feedback without reacting
2. **Understand** — Restate requirement in own words (or ask for clarification)
3. **Verify** — Check against codebase reality
4. **Evaluate** — Technically sound for this codebase?
5. **Respond** — Technical acknowledgment or reasoned pushback
6. **Implement** — One item at a time, test each

**If any item is unclear:** Stop. Clarify ALL unclear items before implementing anything. Items may be related — partial understanding produces wrong implementation.

### Forbidden Responses

- "You're absolutely right!"
- "Great point!"
- "Let me implement that now" (before verification)

**Instead:** Restate the technical requirement, ask clarifying questions, push back if wrong, or just start working.

### When to Push Back

- Suggestion breaks existing functionality
- Reviewer lacks full context
- Violates YAGNI (unused feature)
- Technically incorrect for this stack
- Conflicts with the Don's architectural decisions

**How:** Use technical reasoning, not defensiveness. Reference working tests/code. Involve the Don if architectural.

### Acknowledging Correct Feedback

```
✅ "Fixed. [Brief description of what changed]"
✅ "Good catch — [specific issue]. Fixed in [location]."
✅ Just fix it and show in the code.

❌ "You're absolutely right!"
❌ "Thanks for catching that!"
```

---

## The Safehouse: Git Worktrees

**Skill:** `safehouse-worktrees` | **Trigger:** Feature work requiring isolation from the current workspace

Creates isolated operational bases (git worktrees) sharing the same repository.

### Directory Selection (Priority Order)

1. Check for existing `.worktrees/` or `worktrees/` — use if found (`.worktrees/` wins if both exist)
2. Check `AGENTS.md` for a configured preference
3. Ask the Don: `.worktrees/` (project-local, hidden) or `~/.config/gangsta/worktrees/<project>/` (global)

### Safety Verification

For project-local directories, verify the directory is gitignored before creating:

```bash
git check-ignore -q .worktrees
```

If **not** ignored: add to `.gitignore`, commit, then proceed. This prevents accidentally committing safehouse contents.

### Creation Steps

1. Detect project name: `git rev-parse --show-toplevel | xargs basename`
2. Create worktree: `git worktree add <path> -b <branch-name>`
3. Run project setup (auto-detect):
   - Node.js: `npm install`
   - Rust: `cargo build`
   - Python: `pip install -r requirements.txt` or `poetry install`
   - Go: `go mod download`
4. Verify clean baseline — run full test suite
5. Report location and test results to Don

### Pairs With

`exit-strategy` — cleans up the safehouse when the operation is complete.

---

## Exit Strategy: Branch Cleanup

**Skill:** `exit-strategy` | **Trigger:** Implementation complete, all tests pass

Guides the clean exit from a development branch.

### Process

1. **Verify tests** — Run full test suite. If failing: stop, show failures, do not proceed.

2. **Determine base branch** — Where does this branch merge back to?

3. **Present exactly 4 options** to the Don:
   1. Merge back to `<base-branch>` locally
   2. Push and create a Pull Request
   3. Keep the branch as-is (I'll handle it later)
   4. Discard this work

4. **Execute choice:**
   - Option 1: `git checkout <base>` → `git pull` → `git merge <branch>` → verify tests → `git branch -d <branch>`
   - Option 2: `git push -u origin <branch>` → `gh pr create ...` → report PR URL
   - Option 3: Report branch name and safehouse path. No action.
   - Option 4: Require the Don to type `"discard"` to confirm, then `git branch -D <branch>`

5. **Safehouse cleanup:** Remove worktree for options 1 and 4. Preserve for options 2 and 3.

### Rules

- Never proceed with failing tests
- Never merge without re-verifying on the merged result
- Never delete work without typed confirmation from the Don
- Never force-push without explicit request
