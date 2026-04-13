---
name: laundering
description: Use when all territories report completion after the hit — handles integration, verification, consigliere final review, cleanup, and ledger updates to produce clean production-ready code
---

# Laundering: Verification and Integration

## Overview

A successful Heist is only complete when the "loot" is refined into its final, legitimate form. Laundering handles integration, verification, cleanup, and institutional memory updates.

## Trigger

Invoked after all Capos report territory completion and the Don approves (The Hit complete).

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
2. The responsible Capo dispatches a Soldier to fix it
3. Re-run verification

Use `gangsta:sweep-verification` — every claim of passing must be backed by fresh command output.

### Step 3: Consigliere Final Review

Invoke `gangsta:the-consigliere` for an architectural audit of the integrated code:
- Does the implementation match the Contract?
- Are there architectural regressions?
- Security review of the final code
- Any concerns about the integration?

If the Consigliere raises CRITICAL concerns: fix before proceeding.
If CONCERNS: present to Don for decision.
If APPROVE: proceed.

For an independent code-level review alongside the Consigliere's architectural assessment, dispatch `gangsta:audit-review`.

### Step 4: Automated Cleanup

- Run project formatter/linter with auto-fix
- Remove any debug logging added during The Hit
- Clean up any temporary test fixtures not needed in production

### Step 5: Evidence Disposal

Remove operational artifacts:
- Temporary files created during The Hit
- Internal run logs from Soldier dispatches
- Draft/intermediate checkpoint files (keep only the final state)

Do NOT remove:
- The Contract (`docs/gangsta/<heist-name>/specs/YYYY-MM-DD-contract.md`)
- The War Plan (`docs/gangsta/<heist-name>/plans/YYYY-MM-DD-war-plan.md`)
- The Reconnaissance Dossier (`docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md`)
- These are permanent records of the Heist

### Step 6: Ledger Update

Invoke `gangsta:the-ledger` to record the Heist's lessons:

**Insights** — For each notable solution or pattern discovered:
- Write to `docs/gangsta/insights/YYYY-MM-DD-<topic>.md`
- Update Constitution with new Commandments

**Fails** — For each failure, regression, or mistake encountered:
- Write to `docs/gangsta/fails/YYYY-MM-DD-<topic>.md`
- Update Constitution with new Negative Constraints

Ask the Don:
> "The Heist is nearly complete. Were there any insights or failures you want to record in the Ledger?"

### Step 7: Don's Final Approval

Present to the Don:
> "Laundering complete for Heist '<name>'.
> - All tests pass
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
  - docs/gangsta/<heist-name>/plans/YYYY-MM-DD-war-plan.md
  - docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md
  - <all code files created/modified>
---
```

## Omerta Compliance
- [ ] Rule of Truth: Verification results are actual command output, not claims
- [ ] Spec is Law: Consigliere confirms implementation matches Contract
- [ ] Rule of Availability: Final checkpoint with complete artifact list
- [ ] Rule of Tribute: Final resource consumption reported to Don
