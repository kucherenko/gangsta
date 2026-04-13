---
name: the-hit
description: Use when the war plan is approved and it is time for parallel execution — dispatches soldiers through capos to implement work packages with TDD enforcement, tribute collection, and escalation protocols
---

# The Hit: Execution and Parallel Coding (Phase 5)

## Overview

Soldiers and Capos implement the Work Packages defined in the War Plan. Crews work simultaneously on their assigned territories, providing Tributes (status updates) to the Underboss.

## Trigger

Invoked after the Don approves the War Plan (Phase 4 complete).

## Process

### Step 1: Underboss Distributes Work Packages

For each territory, the Underboss sends the Capo:
- The territory definition
- The assigned Work Packages (ordered by dependency)
- The relevant Contract sections
- The applicable Constitution rules

### Step 2: Capos Dispatch Soldiers

Each Capo (invoke `gangsta:the-capo`) processes their Work Packages:

1. For each independent Work Package, dispatch a Soldier subagent with:
   - The Work Package brief
   - The Contract clause being implemented
   - Applicable Negative Constraints
   - Territory conventions

2. Soldiers work in parallel within their territory (up to the allocated Soldier count)

### Step 3: TDD Enforcement

Every Soldier MUST follow the TDD cycle:

1. **Write failing test** — Based on the acceptance criteria
2. **Run test** — Verify it fails for the right reason
3. **Write minimal implementation** — Just enough to pass the test
4. **Run test** — Verify it passes
5. **Report** — Return Tribute to Capo

A Soldier that writes implementation before tests has its Tribute REJECTED.

### Step 4: Tribute Collection

Each Soldier returns a Tribute:

```markdown
## Tribute: <WP-ID>
**Status:** success | failure | blocked
**TDD Cycle:**
- Test written: YES/NO
- Test failed first: YES/NO
- Implementation written: YES/NO
- Test passes: YES/NO
**Changes:**
- <file path>: <created/modified>
**Test Output:**
```
<actual test output>
```
**Notes:** <issues, concerns, deviations>
```

### Step 5: Capo Reviews Tributes

The Capo reviews each Tribute (invoke `gangsta:the-capo`):
- Acceptance criteria met?
- TDD cycle followed?
- Tests passing?
- Convention compliance?

Accept, reject with feedback, or escalate.

### Step 6: Status Rollup

Capos report territory status to the Underboss. The Underboss synthesizes for the Don:

```markdown
## Heist Progress: <Heist Name>

| Territory | Completed | In Progress | Failed | Budget Used |
|-----------|-----------|-------------|--------|-------------|
| Frontend  | 3/5       | 1           | 1      | 60%         |
| Backend   | 4/4       | 0           | 0      | 45%         |
| ...       |           |             |        |             |

**Overall:** <N>/<Total> Work Packages complete
```

### Step 7: Escalation Handling

When a Soldier fails:
1. **Capo retries** — Fresh Soldier, same Work Package
2. **Capo escalates to Underboss** — If retry fails or Contract is ambiguous
3. **Underboss mini-Grilling** — Single-round: Devils-Advocate attacks the proposed fix, Don weighs in, Synthesizer produces revised Contract clause
4. **Underboss escalates to Don** — If beyond operational scope

### Step 8: Completion

When all Capos report territory completion:
1. Underboss verifies: all Work Packages accepted, all tests passing
2. Present to Don: "The Hit is complete. All <N> Work Packages implemented. Ready for Laundering?"

## Checkpoint

Write checkpoint after each significant batch of Work Packages completes (not just at the end):

```yaml
---
heist: <heist-name>
phase: the-hit
status: in-progress | completed
timestamp: <ISO 8601>
next-action: <Continue Hit | Proceed to Laundering>
completed-wps: [WP-001, WP-002, ...]
pending-wps: [WP-003, ...]
failed-wps: [WP-004, ...]
artifacts:
  - <list of modified/created files>
---
```

## Omerta Compliance
- [ ] Introduction Rule: Soldiers dispatched through Capos, no direct Soldier communication
- [ ] Rule of Truth: Tributes include actual test output, not claims
- [ ] Rule of Tribute: Token usage tracked per Soldier dispatch
- [ ] Spec is Law: Every implementation traces to a Contract clause via Work Package
- [ ] Rule of Availability: Checkpoint updated after each batch
