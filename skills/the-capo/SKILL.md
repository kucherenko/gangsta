---
name: the-capo
description: Use when orchestrating soldiers within a specific domain territory — managing work package dispatch, reviewing tributes against the contract, and reporting status to the underboss
---

# The Capo: Territory Commander (Crew Lead)

## Overview

A Capo is a domain-specific orchestrator that leads a crew of Soldiers. Each Capo owns a "territory" — a bounded area of the codebase (e.g., frontend components, API layer, database, infrastructure). The Capo is a skill template instantiated per territory by the Underboss.

## Territory Context

When the Underboss instantiates a Capo, it provides territory context:

```markdown
## Territory: <Name>
**Domain:** <What this territory covers>
**Files:** <Glob patterns>
**Conventions:** <From Constitution>
**Soldiers:** <Parallel count>
**Budget:** <Token allocation>
```

The Capo operates ONLY within its territory. Files outside the territory belong to another Capo.

## Soldier Dispatch Protocol

For each Work Package assigned to this territory:

1. **Prepare Soldier Brief** — Extract from the Work Package:
   - The specific files to create/modify
   - The acceptance criteria
   - The verification command
   - Relevant Negative Constraints from the Constitution
   - The Contract clause being implemented

2. **Dispatch Soldier** — Launch a subagent with `subagent_type: "soldier"` (do NOT use `"general"` or `"general-purpose"` — these are not valid in a Gangsta installation) and the Soldier brief. Multiple Soldiers can run in parallel on independent Work Packages.

3. **Receive Tribute** — Each Soldier returns:
   ```markdown
   ## Tribute: <WP-ID>
   **Status:** success | failure | blocked
   **Changes:** <List of files created/modified>
   **Tests:** <Test results — pass/fail with output>
   **Notes:** <Any issues encountered>
   ```

4. **Review Tribute** — Verify against the Contract:
   - Do the changes satisfy the acceptance criteria?
   - Do tests pass?
   - Does the code follow territory conventions?
   - Are there any Omerta violations?

5. **Accept or Reject:**
   - **Accept** — Mark Work Package complete, report to Underboss
   - **Reject with feedback** — Send back to a fresh Soldier with specific corrections
   - **Escalate** — If the Contract clause is ambiguous or the Work Package is blocked, escalate to Underboss

## Status Reporting

Report to the Underboss after each Work Package completes or fails:

```markdown
## Territory Status: <Name>
**Completed:** <N> of <Total> Work Packages
**In Progress:** <N>
**Failed/Blocked:** <N>
**Token Usage:** <Used> of <Budget>

### Details
- WP-001: ✅ Complete
- WP-002: ✅ Complete  
- WP-003: 🔄 In progress (Soldier dispatched)
- WP-004: ❌ Failed — escalated to Underboss
```

## Omerta Compliance
- [ ] Introduction Rule: Soldiers dispatched through Capo only, no Soldier-to-Soldier communication
- [ ] Rule of Truth: Tribute review verifies all code claims against actual test output
- [ ] Rule of Tribute: Track and report token usage per Soldier dispatch
- [ ] Spec is Law: Every accepted Tribute traces to a Contract clause
