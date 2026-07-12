---
name: laundering
description: Use when all territories report completion after the hit — handles integration, verification, consigliere final review, cleanup, and ledger updates to produce clean production-ready code
---

# Laundering: Verification and Integration

## Overview

A successful Heist is only complete when the "loot" is refined into its final, legitimate form. Laundering handles integration, verification, cleanup, and institutional memory updates.

## Trigger

Invoked after all Crew Leads report territory completion and the Don approves (The Hit complete).

## Process

### Step 1: Integration

Merge all territory branches/worktrees into the Heist branch:

```bash
# If using worktrees per territory
git merge territory/<name> --no-ff
```

Resolve any conflicts. If conflicts are non-trivial, escalate to the Underboss for a mini-Grilling.

### Step 2: Verification

Run the full verification suite:

```bash
# Run all tests
<project test command>

# Run linter
<project lint command>

# Run type checker (if applicable)
<project type check command>
```

**All checks must pass.** If any fail:
1. Identify which Work Package introduced the failure
2. The responsible Crew Lead dispatches a Worker to fix it
3. Re-run verification

Use `gangsta:sweep-verification` — every claim of passing must be backed by fresh command output.

**Identifier Scan (Blocking Gate):** Scan all project files outside `docs/gangsta/` for Gangsta-internal spec identifiers using the pattern `\b(FR|NFR|WP)-\d+\b` (matches FR-001, NFR-042, WP-007, FR-1, etc.).

```bash
grep -rn --include="*.md" --include="*.ts" --include="*.js" --include="*.py" --include="*.go" --include="*.rb" --include="*.java" --include="*.txt" -E "\b(FR|NFR|WP)-[0-9]+" . --exclude-dir=docs/gangsta
```

- Any match is a **blocking defect**. Remove the identifier from the deliverable and re-run the scan before declaring the Heist clean.
- Exception: if a match is a legitimate project identifier unrelated to Gangsta planning, record the matching string, the file path, and a one-sentence justification in this laundering checkpoint. The Don MUST acknowledge the exception as part of the checkpoint review sign-off before this gate is cleared.

### Step 3: Technical Debt Audit

A blocking gate. Five sub-checks. Every violation MUST be fixed or, with the Don's explicit approval, recorded as a documented exception (source: file, line, rationale) — same exception protocol as the Identifier Scan.

Run them BEFORE the Consigliere's architectural review so the Consigliere sees the cleaned code, not the raw hit output.

#### 3.1 Copy/Paste Detection (jscpd)

If `jscpd` is installed, run it against the modified files. If not installed, run an equivalent token-based duplication scan or skip with a note in the checkpoint that this sub-check was not run.

```bash
npx jscpd <modified file paths> --format "all" --ignore "**/*.md,**/*.json,**/docs/gangsta/**" --reporters json,console --threshold 0
```

Defaults (override with the project's `.jscpd.json` if present):
- `min-lines`: 5
- `min-tokens`: 35
- `threshold`: 0 (zero duplication above the minimum block size)

Any clone cluster above the minimum is a blocking defect. Fix by extracting shared code, parameterizing the variation, or removing the dead duplicate. If the duplication is structurally unavoidable (e.g. two genuinely distinct types with the same shape), record the file paths, the clone cluster ID, and a one-sentence justification, and surface it to the Don for exception sign-off.

#### 3.2 Long Files

For every file created or modified during the Hit, count the source lines (excluding blank lines and comments):

```bash
for f in <modified files>; do wc -l "$f"; done
```

Thresholds:
- **≤ 300 lines:** OK.
- **301–500 lines:** flagged for review. The Underboss names the file and asks: is there a single responsibility that justifies the length? If yes, document the justification. If no, extract a module before proceeding.
- **> 500 lines:** blocking. Refactor into smaller modules — split by responsibility. The only escape is a Contract clause that mandates a single file (e.g. a vendored SDK shim) and the Don's explicit approval.

Record the post-refactor line count in the checkpoint.

#### 3.3 Test Coverage

Run the project's coverage command. If the project has no coverage tooling, skip with a note — do not invent one.

```bash
<project coverage command — e.g. npm run test:coverage, pytest --cov, go test -cover>
```

Two checks:

1. **Floor:** If the project's coverage config declares a threshold (e.g. `--coverageThreshold` in `jest.config.*`, `fail_under` in `.coveragerc`), the run must meet it. Failure is a blocking defect — add tests until the threshold passes.
2. **Delta:** New or modified code must not lower the project's overall coverage below the pre-Heist baseline. Capture the baseline number from the Resource Development step (or `git stash` and re-run if missing). If coverage on modified lines dropped, write the missing tests before proceeding.

Record the final coverage number in the checkpoint.

#### 3.4 Clean Architecture Audit

The Consigliere will cover this architecturally in Step 4 — this sub-check is the mechanical pre-filter. For every modified file, verify:

1. **Direction of dependency:** the file imports only from lower layers (domain → application → infrastructure → delivery). An import from a higher layer into a lower one is a blocking defect unless the Contract explicitly approves the inversion.
2. **No business logic in delivery or infrastructure layers:** controllers, CLI handlers, route bindings, DB adapters, and network clients must contain only marshalling and delegation. Business rules belong in domain/application code.
3. **Single responsibility:** the filename declares one responsibility and the contents honor it. A file that does two unrelated jobs is a blocking defect.

If the project has no formal layering, this sub-check passes by default — note "no formal architecture layers in this project" in the checkpoint.

#### 3.5 Clean Code Audit

Run the project's linter with auto-fix disabled first; review the violations:

```bash
<project lint command — no auto-fix>
```

Beyond the linter, scan the modified files for these mechanical clean-code violations:

1. **Dead code:** unused imports, unreachable branches, commented-out code, unused private functions. Remove. (Debug logging is handled in Step 4 cleanup; this is for leftover scaffolding.)
2. **Long functions:** any function longer than 50 lines (excluding blank lines and comments) is flagged. Extract sub-functions until each does one thing. If a 50+ line function is genuinely one operation (e.g. a table-driven test case), document it inline.
3. **Deep nesting:** any code path exceeding 4 levels of nesting (`if`/`for`/`while`/`try`) is a blocking defect. Flatten with early returns, guard clauses, or extracted helpers.
4. **Magic numbers:** test-scoped literals are fine; production code literals with no name must be extracted to a named constant or config value. A literal that already names itself by being in a self-describing expression (e.g. `setTimeout(fn, 0)`) is exempt.
5. **Naming:** any identifier that requires a comment to explain what it does is a blocking defect — rename. Abbreviations except well-known domain terms are blocking.

Any violation is a blocking defect unless the Contract explicitly accepts it. Surface the violation list, the fix (or the documented exception), and the post-fix lint output in the checkpoint.

#### Audit Output

```markdown
## Technical Debt Audit

| Sub-check | Result | Details |
|-----------|--------|---------|
| Copy/Paste (jscpd) | PASS / N clone clusters fixed / SKIPPED (tool unavailable) | <details> |
| Long Files | PASS / N refactored / N documented | <files, before → after line counts> |
| Test Coverage | PASS / N threshold failures fixed | <baseline → final coverage %> |
| Clean Architecture | PASS / N violations fixed / No formal layers | <details> |
| Clean Code | PASS / N violations fixed | <lint output, before → after> |

### Documented Exceptions
- <file>:<line> — <sub-check> — <rationale> — [Don acknowledged: YES/NO]
```

### Step 4: Consigliere Final Review

Invoke `gangsta:the-consigliere` for an architectural audit of the integrated code:
- Does the implementation match the Contract?
- Are there architectural regressions?
- Security review of the final code
- Any concerns about the integration?

If the Consigliere raises CRITICAL concerns: fix before proceeding.
If CONCERNS: present to Don for decision.
If APPROVE: proceed.

For an independent code-level review alongside the Consigliere's architectural assessment, dispatch `gangsta:audit-review`.

### Step 5: Automated Cleanup

- Run project formatter/linter with auto-fix
- Remove any debug logging added during The Hit
- Clean up any temporary test fixtures not needed in production

### Step 6: Evidence Disposal

Remove operational artifacts:
- Temporary files created during The Hit
- Internal run logs from Worker dispatches
- Draft/intermediate checkpoint files (keep only the final state)

Do NOT remove:
- The Contract (`docs/gangsta/<heist-name>/specs/YYYY-MM-DD-contract.md`)
- The Execution Plan (`docs/gangsta/<heist-name>/plans/YYYY-MM-DD-execution-plan.md`)
- The Reconnaissance Dossier (`docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md`)
- These are permanent records of the Heist

### Step 7: Ledger Update

Invoke `gangsta:the-ledger` to record the Heist's lessons:

**Insights** — For each notable solution or pattern discovered:
- Write to `docs/gangsta/insights/YYYY-MM-DD-<topic>.md`
- Update Constitution with new Commandments

**Fails** — For each failure, regression, or mistake encountered:
- Write to `docs/gangsta/fails/YYYY-MM-DD-<topic>.md`
- Update Constitution with new Negative Constraints

Ask the Don:
> "The Heist is nearly complete. Were there any insights or failures you want to record in the Ledger?"

### Step 8: Don's Final Approval

Present to the Don:
> "Laundering complete for Heist '<name>'.
> - All tests pass
> - Coverage: <baseline → final>
> - Technical Debt Audit: <list of fixed violations; documented exceptions if any>
> - Consigliere verdict: [verdict]
> - Ledger updated: [N] insights, [N] fails
> - Code is clean and ready for production
>
> Do you declare this Heist complete?"

The Don may:
- **Declare complete** — Heist is done. Final commit and optional merge to main.
- **Request changes** — Back to specific steps.
- **Kill** — Discard the Heist branch.

## Final Checkpoint

```yaml
---
heist: <heist-name>
phase: laundering
status: completed
timestamp: <ISO 8601>
next-action: Heist complete. Merge to main or archive.
artifacts:
  - docs/gangsta/<heist-name>/specs/YYYY-MM-DD-contract.md
  - docs/gangsta/<heist-name>/plans/YYYY-MM-DD-execution-plan.md
  - docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md
  - <all code files created/modified>
technical-debt-audit:
  copy-paste: PASS | N-fixed | SKIPPED <reason>
  long-files: PASS | N-refactored <files>
  test-coverage: <baseline% → final%>
  clean-architecture: PASS | N-fixed | no-formal-layers
  clean-code: PASS | N-fixed
  documented-exceptions: <file:line — sub-check — rationale>
---
```

## Omerta Compliance
- [ ] Rule of Truth: Verification results are actual command output, not claims
- [ ] Spec is Law: Consigliere confirms implementation matches Contract
- [ ] Rule of Availability: Final checkpoint with complete artifact list
- [ ] Rule of Budget: Final resource consumption reported to Don
- [ ] Technical Debt Audit: All five sub-checks run (or documented-skipped with reason); blocking violations fixed or excepted with Don sign-off; audit output recorded in checkpoint
