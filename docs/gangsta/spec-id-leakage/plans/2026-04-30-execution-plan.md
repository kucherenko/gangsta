---
heist: spec-id-leakage
date: 2026-04-30
total-work-packages: 4
territories: 1
estimated-total-budget: 8000
---

# Execution Plan: Spec Identifier Leakage Prevention

## Territories

### Territory: Skills Documentation
**Crew Lead Domain:** Gangsta framework skill files and constitutional documents
**Files:** `docs/gangsta/constitution.md`, `skills/*/SKILL.md`
**Workers:** 4 parallel
**Budget:** 8000 tokens

## Work Packages

### WP-001: Add NC-002 to constitution.md
**Territory:** Skills Documentation
**Contract Clause:** FR-001, FR-002, FR-003, FR-007
**Files:**
- Modify: `docs/gangsta/constitution.md`
**Acceptance Criteria:**
1. NC-002 entry exists under `## Negative Constraints`
2. Scope is exactly FR-xxx, NFR-xxx, WP-xxx — no AC-xxx or AD-xxx
3. Entry carries source annotation `— Source: spec-id-leakage Heist`
4. Entry is imperative (NEVER…) with no narrative prose
5. NC-001 is unchanged
**Verification:** `grep -n "NC-002" docs/gangsta/constitution.md`
**Budget:** 1500 tokens
**Dependencies:** None

### WP-002: Add prevention guidance to resource-development/SKILL.md
**Territory:** Skills Documentation
**Contract Clause:** FR-004
**Files:**
- Modify: `skills/resource-development/SKILL.md`
**Acceptance Criteria:**
1. Prevention guidance block appears in the Work Package brief template section
2. Guidance explicitly names canonical forms: FR-xxx, NFR-xxx, WP-xxx (where xxx is one or more digits)
3. Guidance instructs workers not to reproduce these identifiers in deliverables
4. Addition is labeled prevention guidance (not a gate)
5. Addition reads as an imperative directive, not narrative prose
**Verification:** `grep -n "FR-\|NFR-\|prevention" skills/resource-development/SKILL.md`
**Budget:** 2000 tokens
**Dependencies:** None

### WP-003: Add prevention guidance to the-hit/SKILL.md
**Territory:** Skills Documentation
**Contract Clause:** FR-005
**Files:**
- Modify: `skills/the-hit/SKILL.md`
**Acceptance Criteria:**
1. Prevention guidance checklist item appears in the worker dispatch section (Step 2)
2. Item explicitly names canonical forms: FR-xxx, NFR-xxx, WP-xxx
3. Item instructs workers not to reproduce identifiers in source code, tests, comments, or documentation
4. Addition is labeled prevention guidance (not a gate)
5. Addition reads as an imperative directive, not narrative prose
**Verification:** `grep -n "FR-\|NFR-\|prevention" skills/the-hit/SKILL.md`
**Budget:** 2000 tokens
**Dependencies:** None

### WP-004: Add identifier scan blocking gate to laundering/SKILL.md
**Territory:** Skills Documentation
**Contract Clause:** FR-006
**Files:**
- Modify: `skills/laundering/SKILL.md`
**Acceptance Criteria:**
1. Blocking gate checklist item appears in the Step 2 Verification section
2. Scan scope is all project files outside `docs/gangsta/`
3. Pattern `\b(FR|NFR|WP)-\d+\b` named explicitly
4. Any match declared a blocking defect requiring removal and re-verification
5. Exception mechanism present: agent records matching string + file path + one-sentence
   justification; Don acknowledges as part of checkpoint review sign-off
6. Canonical identifier examples named (e.g., FR-001, NFR-042, WP-007)
7. Addition reads as imperative directives, not narrative prose
**Verification:** `grep -n "FR|NFR|WP\|blocking\|scan" skills/laundering/SKILL.md`
**Budget:** 2500 tokens
**Dependencies:** None

## Execution Order

1. All packages are independent — run WP-001, WP-002, WP-003, WP-004 in parallel

## Baseline Verification
- Tests: N/A — framework is zero-dependency markdown; no test suite
- Dependencies: OK — all changes are markdown text edits only
- Branch: `heist/spec-id-leakage` created from `master`
