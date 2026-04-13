---
name: resource-development
description: Use when the contract is signed and work packages need to be created — decomposes the contract into bite-sized tasks, sets up git isolation, allocates territories and token budgets, producing the war plan
---

# Resource Development: Infrastructure and Tooling

## Overview

The Underboss decomposes the signed Contract into Work Packages, sets up infrastructure for parallel execution, and produces the War Plan — the detailed task breakdown that governs The Hit.

## Trigger

Invoked after the Don signs the Contract (The Sit-Down complete).

## Process

### Step 1: Decompose Contract into Work Packages

For each requirement in the Contract:
1. Identify affected files (create/modify)
2. Determine territory ownership (which Capo)
3. Define acceptance criteria (from Contract)
4. Write verification command
5. Estimate token budget

Each Work Package must be:
- **Independent** — Can be implemented without waiting for other Work Packages (within the same territory, order may matter)
- **Verifiable** — Has a specific test or command that proves it works
- **Bite-sized** — 2-5 minutes of Soldier work
- **Traceable** — References a specific Contract clause

### Step 2: Define Territories

Group Work Packages by domain and define Capo territories:

```markdown
## Territory: <Name>
**Domain:** <Description>
**Files:** <Glob patterns>
**Work Packages:** WP-001, WP-003, WP-007
**Soldiers:** <Parallel count>
**Budget:** <Token allocation>
```

### Step 3: Set Up Isolation

If the project uses git:
- Create a branch for the Heist: `heist/<heist-name>`
- Optionally create worktrees per territory for true parallel work

If not:
- Document the isolation strategy (directory copies, etc.)

### Step 4: Verify Prerequisites

Before The Hit begins:
- [ ] All existing tests pass on the current baseline
- [ ] Required dependencies are available
- [ ] File paths in Work Packages are valid
- [ ] No merge conflicts with the base branch

### Step 5: Produce War Plan

Compile everything into the War Plan.

## War Plan Format

Save to: `docs/gangsta/<heist-name>/plans/YYYY-MM-DD-war-plan.md`

```markdown
---
heist: <heist-name>
date: YYYY-MM-DD
total-work-packages: <N>
territories: <N>
estimated-total-budget: <tokens>
---

# War Plan: <Heist Name>

## Territories

### Territory: <Name 1>
**Capo Domain:** <description>
**Files:** <globs>
**Soldiers:** <N parallel>
**Budget:** <tokens>

### Territory: <Name 2>
...

## Work Packages

### WP-001: <Title>
**Territory:** <Name>
**Contract Clause:** FR-001
**Files:**
- Create: `path/to/file`
- Test: `tests/path/to/test`
**Acceptance Criteria:**
1. <criterion>
**Verification:** `<command>`
**Budget:** <tokens>
**Dependencies:** None | WP-XXX

### WP-002: <Title>
...

## Execution Order
1. Independent packages (can run in parallel): WP-001, WP-002, WP-005
2. Depends on group 1: WP-003 (needs WP-001)
3. ...

## Baseline Verification
- Tests: <PASS/FAIL — must be PASS>
- Dependencies: <OK/MISSING>
- Branch: heist/<heist-name> created from <base>
```

### Step 6: Don Approves War Plan

Present to the Don:
> "War Plan ready. <N> Work Packages across <N> territories. Estimated budget: <tokens>. Ready to execute The Hit?"

## Checkpoint

```yaml
---
heist: <heist-name>
phase: resource-development
status: completed
timestamp: <ISO 8601>
next-action: Proceed to The Hit
artifacts:
  - docs/gangsta/<heist-name>/plans/YYYY-MM-DD-war-plan.md
---
```

## Omerta Compliance
- [ ] Spec is Law: Every Work Package traces to a Contract clause
- [ ] Rule of Tribute: Token budgets allocated per territory
- [ ] Rule of Availability: War Plan and checkpoint saved
