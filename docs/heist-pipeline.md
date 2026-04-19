# The Heist Pipeline

When the Don wants to build something, The Heist begins — a 6-phase operational cycle. Every phase gate requires Don approval. No phase is skipped.

| Phase | Skill | Trigger | Artifact | Gate |
|-------|-------|---------|----------|------|
| 1. Reconnaissance | `reconnaissance` | Don expresses building intent | Recon Dossier | Don approves dossier |
| 2. The Grilling | `the-grilling` | Dossier approved | Grilling Conclusions (in-context) | Don declares consensus |
| 3. The Sit-Down | `the-sit-down` | Grilling consensus approved | Signed Contract | Don signs Contract |
| 4. Resource Development | `resource-development` | Contract signed | Execution Plan | Don approves Execution Plan |
| 5. The Hit | `the-hit` | Execution Plan approved | Implemented code + Reports | Don approves completion |
| 6. Laundering | `laundering` | Hit complete | Clean, verified code | Don declares Heist complete |

---

## Phase 1: Reconnaissance

**Skill:** `reconnaissance` | **Trigger:** Don expresses building or creative intent

The Underboss deploys Associates to survey the codebase and gather intel. No assumptions, no guessing — only verified findings.

### Steps

1. **Analyze Intent** — Parse the Don's request: What is being built? Which parts of the system are affected? What constraints apply?

2. **Deploy Associates in parallel** to survey:
   - Codebase structure (file tree, frameworks, entry points)
   - Existing tests (coverage, framework, pass/fail status)
   - Dependencies (versions, known issues)
   - Documentation (README, specs, inline docs)
   - Ledger (`docs/gangsta/insights/`, `docs/gangsta/fails/`) for relevant past entries
   - Constitution (`docs/gangsta/constitution.md`) for applicable Commandments and Negative Constraints

3. **Synthesize Dossier** — Compile all Associate reports into a structured Reconnaissance Dossier.

4. **Present to Don** — Don reviews the Dossier and may approve, request more intel, or adjust scope.

### Artifact

`docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md`

```markdown
---
heist: <heist-name>
date: YYYY-MM-DD
status: pending-review
---

# Reconnaissance Dossier: <Heist Name>

## Objective
## Codebase Overview
## Existing Test Coverage
## Dependencies
## Relevant Ledger Entries
### Applicable Insights
### Applicable Negative Constraints
## Risks and Unknowns
## Recommended Scope
```

### Gate

Don approves → proceed to The Grilling

---

## Phase 2: The Grilling

**Skill:** `the-grilling` | **Trigger:** Don approves the Reconnaissance Dossier

A structured Multi-Agent Debate (MAD). Three subagents argue the solution before any plan is committed. The Don participates every round.

### Round Structure

1. **Proposer** — Reads the Dossier, proposes an architectural solution with rationale, file changes, and identified risks.

2. **Devils-Advocate** — Attacks the proposal: architectural flaws, security gaps, Constitution violations, regressions, scalability concerns.

3. **Don** — Asked one question at a time (never bundled). Weighs in on the attack and the proposal.

4. **Synthesizer** — Incorporates valid attacks and Don feedback. Produces a revised solution.

Rounds 2–N repeat the same cycle: Devils-Advocate attacks → Don weighs in → Synthesizer revises.

### Round Limits (Non-Negotiable)

| Limit | Value |
|-------|-------|
| Minimum rounds | 2 |
| Default maximum | 5 |
| Hard ceiling | 7 (Don can extend from 5) |
| Early exit | After round 2 if Don declares consensus |

### Termination Conditions

- **Nash Equilibrium** — Devils-Advocate raises no new valid objection AND Don has no remaining concerns
- **Don declares consensus** — After round 2, Don can end the debate
- **Round limit reached** — Synthesizer produces Best Available Consensus with documented unresolved objections

### Output

Grilling Conclusions (held in-context, not saved to file). Passed directly to The Sit-Down.

```
Grilling Conclusions contain:
  - Key Decisions (each decision + rationale)
  - Rejected Alternatives (each option + why discarded)
  - Unresolved Objections (risks acknowledged but accepted)
  - Termination Reason
```

### Gate

Don approves consensus → proceed to The Sit-Down

---

## Phase 3: The Sit-Down

**Skill:** `the-sit-down` | **Trigger:** Don approves the Grilling consensus

The formal Contract is drafted. **Code generation is strictly prohibited.** The Contract describes WHAT and WHY — never HOW.

### Steps

1. **Underboss drafts the Contract** — Synthesizing:
   - Reconnaissance Dossier
   - Grilling Conclusions
   - Project Constitution (Commandments + Negative Constraints)
   - Relevant Ledger Entries

2. **Consigliere reviews** (`the-consigliere`):
   - Contradiction scan
   - Ambiguity check
   - Completeness audit
   - Constitution alignment
   - Security review
   - Verdict: APPROVE, APPROVE WITH CONCERNS, or REJECT

3. **Don signs the Contract** — If changes are requested, Underboss revises and Consigliere re-reviews.

### Artifact

`docs/gangsta/<heist-name>/specs/YYYY-MM-DD-contract.md`

```markdown
---
heist: <heist-name>
date: YYYY-MM-DD
status: signed
signatories: [Don, Consigliere, Underboss]
---

# Contract: <Heist Name>

## Objective
## Functional Requirements (FR-001, FR-002, ...)
## Non-Functional Requirements (NFR-001, ...)
## Architectural Decisions
## Grilling Conclusions
### Key Decisions
### Rejected Alternatives
### Unresolved Objections
## Applicable Constitution Rules
### Commandments
### Negative Constraints
## Acceptance Criteria
## Out of Scope
## Open Risks
```

### Gate

Don signs Contract → proceed to Resource Development

---

## Phase 4: Resource Development

**Skill:** `resource-development` | **Trigger:** Don signs the Contract

The Underboss decomposes the Contract into Work Packages and produces the Execution Plan governing The Hit.

### Steps

1. **Decompose Contract** — For each requirement, identify affected files, territory ownership, acceptance criteria, verification command, and token budget. Each Work Package must be **independent**, **verifiable**, **bite-sized** (2–5 min), and **traceable** to a Contract clause.

2. **Define Territories** — Group Work Packages by domain. Each territory has a Crew Lead, glob patterns for owned files, Worker count, and token budget.

3. **Set up isolation** — Create a Heist branch (`heist/<heist-name>`). Optionally create worktrees per territory using `safehouse-worktrees`.

4. **Verify prerequisites**:
   - All existing tests pass on baseline
   - Dependencies available
   - File paths valid
   - No merge conflicts

5. **Produce Execution Plan** — Compile territories, Work Packages, execution order (parallelizable vs. dependent), and baseline verification.

### Artifact

`docs/gangsta/<heist-name>/plans/YYYY-MM-DD-execution-plan.md`

```markdown
---
heist: <heist-name>
date: YYYY-MM-DD
total-work-packages: <N>
territories: <N>
---

# Execution Plan: <Heist Name>

## Territories
### Territory: <Name>
**Crew Lead Domain:** <description>
**Files:** <globs>
**Workers:** <N parallel>
**Budget:** <tokens>

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

## Execution Order
1. Independent (parallel): WP-001, WP-002
2. Depends on group 1: WP-003 (needs WP-001)

## Baseline Verification
- Tests: PASS
- Dependencies: OK
- Branch: heist/<heist-name>
```

### Gate

Don approves Execution Plan → proceed to The Hit

---

## Phase 5: The Hit

**Skill:** `the-hit` | **Trigger:** Don approves the Execution Plan

Workers implement Work Packages in parallel. TDD is enforced — no implementation without a failing test first.

### Steps

1. **Underboss distributes** — Sends each Crew Lead their territory definition, Work Packages, relevant Contract sections, and Constitution rules.

2. **Crew Leads dispatch Workers** — Each independent Work Package gets a Worker subagent. Multiple Workers run in parallel within a territory.

3. **TDD enforcement** — Every Worker follows `drill-tdd` (Red-Green-Refactor):
   - Write failing test based on acceptance criteria
   - Run test — verify it fails for the right reason
   - Write minimal implementation to pass
   - Run test — verify it passes
   - A Worker that writes implementation before tests has its Report rejected

4. **Report collection** — Each Worker returns:
   ```markdown
   ## Report: <WP-ID>
   **Status:** success | failure | blocked
   **TDD Cycle:**
   - Test written: YES/NO
   - Test failed first: YES/NO
   - Implementation written: YES/NO
   - Test passes: YES/NO
   **Changes:** <files created/modified>
   **Test Output:** <actual command output>
   **Notes:** <issues, deviations>
   ```

5. **Crew Lead reviews Reports** — Verifies acceptance criteria, TDD compliance, test passage, conventions. Accepts, rejects with feedback, or escalates.

6. **Status rollup** — Crew Leads report territory status to Underboss. Underboss produces progress table for Don.

7. **Escalation handling** — Worker failure:
   - Crew Lead retries with a fresh Worker
   - Retry fails → Crew Lead escalates to Underboss
   - Underboss runs mini-Grilling if Contract is ambiguous
   - Underboss escalates to Don if beyond operational scope

8. **Completion** — All territories complete. Underboss verifies all Work Packages accepted, all tests passing.

Checkpoints are written after each significant batch — not just at the end.

### Gate

Don approves completion → proceed to Laundering

---

## Phase 6: Laundering

**Skill:** `laundering` | **Trigger:** Don approves Hit completion

The loot is refined into production-ready form. Integration, verification, cleanup, and institutional memory update.

### Steps

1. **Integration** — Merge all territory branches/worktrees into the Heist branch. Escalate non-trivial conflicts to mini-Grilling.

2. **Verification** — Run the full suite (tests, linter, type checker). All checks must pass. Uses `sweep-verification` — every passing claim requires fresh command output.

3. **Consigliere final review** — Invoke `the-consigliere` for architectural audit:
   - Does implementation match the Contract?
   - Architectural regressions?
   - Security review
   - Verdict: APPROVE / CONCERNS (present to Don) / CRITICAL (fix before proceeding)

   Dispatch `audit-review` for independent code-level review alongside the Consigliere.

4. **Cleanup** — Run formatter/linter with auto-fix. Remove debug logging. Clean temporary test fixtures.

5. **Evidence disposal** — Remove temporary operational files and internal run logs. Permanent records are kept.

6. **Ledger update** — Invoke `the-ledger`:
   - Write Insights for notable solutions or patterns
   - Write Fails for failures, regressions, or mistakes
   - Update the Constitution
   - Ask the Don for any additional entries

7. **Don's final approval** — Present: all tests pass, Consigliere verdict, Ledger updates, code clean. Don declares Heist complete. Final commit and optional merge to main.

### Permanent Artifacts (Never Deleted)

- `docs/gangsta/<heist-name>/specs/YYYY-MM-DD-contract.md`
- `docs/gangsta/<heist-name>/plans/YYYY-MM-DD-execution-plan.md`
- `docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md`

### Gate

Don declares Heist complete
