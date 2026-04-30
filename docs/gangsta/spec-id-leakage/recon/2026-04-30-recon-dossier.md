---
heist: spec-id-leakage
date: 2026-04-30
status: pending-review
---

# Reconnaissance Dossier: Spec Identifier Leakage Prevention

## Objective

Prevent Gangsta-internal spec identifiers (FR-xxx, NFR-xxx, WP-xxx, AC-xxx, AD-xxx) from
appearing in project-facing artifacts outside `docs/gangsta/` — specifically in source code,
test files, README files, and any other deliverables that ship with or document a user's
project. Add a Negative Constraint to the Constitution and update the skills responsible for
the leakage pathway.

## Codebase Overview

**Framework:** gangsta — zero-dependency AI agentic skills framework for spec-driven development.

**Skills directory:** `skills/` — 21 skills, each a single `SKILL.md`.

**Identifier lifecycle (leak pathway):**

```
The Sit-Down → Contract (docs/gangsta/.../specs/*.md)
                defines FR-xxx / NFR-xxx

  ↓ Resource Development
  Execution Plan (docs/gangsta/.../plans/*.md)
  embeds FR-xxx in each Work Package brief (resource-development/SKILL.md:97)

    ↓ The Hit
    Workers receive WP briefs containing FR-NNN — no instruction prohibiting
    them from writing those identifiers into code comments, test annotations,
    or project README files (the-hit/SKILL.md:30-35)

      ↓ Laundering
      Cleanup checklist does not scrub identifier references Workers may have
      embedded in project source (laundering/SKILL.md:66-69, 73-81)
```

**Confirmed real-world leak:** `overseer/README.md` contained 11 lines with FR-xxx/NFR-xxx
references (FR-028, FR-017, FR-018, FR-025a, FR-026, FR-027, FR-029, NFR-008, NFR-001);
`tests/fixtures/synthetic/parse/README.md` had FR-008, NFR-009, WP-011;
`tests/fixtures/vendored/README.md` had WP-024. All cleaned manually on 2026-04-30.

## Existing Test Coverage

No tests exist that assert the absence of spec identifiers in project artifacts. This is a
governance/documentation concern, not a code behavior concern — tests are not the right
enforcement mechanism. Enforcement is through skill instructions and Constitution constraints.

## Dependencies

Zero runtime dependencies (framework invariant). Skill changes are pure markdown edits.

## Relevant Ledger Entries

### Applicable Insights
- None. Ledger is empty (`docs/gangsta/insights/` and `docs/gangsta/fails/` both empty).

### Applicable Negative Constraints
- NC-001: NEVER weaken or bypass Omerta Law 2 (checkpoints non-negotiable) in any
  autonomous-mode pathway — no overlap with this Heist.

## Risks and Unknowns

- **R1 (LOW):** Other skills beyond the-hit / laundering could also be dispatch points for
  workers who might embed identifiers. The four high-risk skills (the-hit, resource-development,
  the-sit-down, laundering) cover the full pipeline — the-grilling produces no identifiers yet.
- **R2 (LOW):** Workers might also embed identifiers in code comments (not just README/tests).
  The prohibition must cover all project files, not just docs.
- **R3 (NEGLIGIBLE):** Constitution amendment requires Laundering-phase write, which is part of
  this Heist's scope — no conflict.

## Recommended Scope

Four targeted changes, all in the gangsta repo:

1. **`skills/the-hit/SKILL.md`** — Add an explicit prohibition in Worker dispatch instructions:
   workers MUST NOT embed FR-/NFR-/WP-/AC-/AD-xxx identifiers in source code comments, test
   annotations, or project-facing docs. Traceability lives in the Execution Plan and Reports,
   not in deliverables.

2. **`skills/laundering/SKILL.md`** — Add a cleanup check step: scan for and remove any
   spec identifier references (FR-/NFR-/WP-xxx) that workers embedded in project source files
   outside `docs/gangsta/`.

3. **`skills/resource-development/SKILL.md`** — Add a note to the WP template section
   clarifying that FR-xxx references in Work Package briefs are planning artifacts only — they
   are internal to the Execution Plan and must not propagate into project deliverables.

4. **`docs/gangsta/constitution.md`** — Add NC-002: NEVER embed Gangsta-internal spec
   identifiers (FR-xxx, NFR-xxx, WP-xxx, AC-xxx, AD-xxx) in project-facing files outside
   `docs/gangsta/` — Source: spec-id-leakage Heist.

Out of scope: changes to `the-sit-down` (Contract format is internal, not a leak point
itself) and `the-grilling` (no identifiers created at that phase).
