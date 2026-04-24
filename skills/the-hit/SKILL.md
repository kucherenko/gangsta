---
name: the-hit
description: Use when the execution plan is approved and it is time for parallel execution — dispatches workers through crew leads to implement work packages with TDD enforcement, report collection, and escalation protocols
---

# The Hit: Execution and Parallel Coding

## Overview

Workers and Crew Leads implement the Work Packages defined in the Execution Plan. Crews work simultaneously on their assigned territories, providing Reports (status updates) to the Underboss.

## Trigger

Invoked after the Don approves the Execution Plan (Resource Development complete).

## Process

### Step 1: Underboss Distributes Work Packages

For each territory, the Underboss sends the Crew Lead:
- The territory definition
- The assigned Work Packages (ordered by dependency)
- The relevant Contract sections
- The applicable Constitution rules

### Step 2: Crew Leads Dispatch Workers

Each Crew Lead (invoke `gangsta:the-capo`) processes their Work Packages:

1. For each independent Work Package, dispatch a Worker subagent with `subagent_type: "soldier"` (do NOT use `"general"` or `"general-purpose"` — these are not valid in a Gangsta Agents installation), providing:
   - The Work Package brief
   - The Contract clause being implemented
   - Applicable Negative Constraints
   - Territory conventions

2. Workers work in parallel within their territory (up to the allocated Worker count)

### Step 3: TDD Enforcement

Every Worker MUST follow `gangsta:drill-tdd` — the full Red-Green-Refactor cycle:

1. **Write failing test** — Based on the acceptance criteria
2. **Run test** — Verify it fails for the right reason
3. **Write minimal implementation** — Just enough to pass the test
4. **Run test** — Verify it passes
5. **Report** — Return Report to Crew Lead

A Worker that writes implementation before tests has its Report REJECTED.

### Step 4: Report Collection

Each Worker returns a Report:

```markdown
## Report: <WP-ID>
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

### Step 5: Crew Lead Reviews Reports

The Crew Lead reviews each Report (invoke `gangsta:the-capo`):
- Acceptance criteria met?
- TDD cycle followed?
- Tests passing?
- Convention compliance?

Accept, reject with feedback, or escalate.

### Step 6: Status Rollup

Crew Leads report territory status to the Underboss. The Underboss synthesizes for the Don:

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

When a Worker fails:
1. **Crew Lead retries** — Fresh Worker, same Work Package
2. **Crew Lead escalates to Underboss** — If retry fails or Contract is ambiguous
3. **Underboss mini-Grilling** — Single-round: Devils-Advocate attacks the proposed fix, Don weighs in, Synthesizer produces revised Contract clause
4. **Underboss escalates to Don** — If beyond operational scope

### Step 8: Completion

When all Crew Leads report territory completion:
1. Underboss verifies: all Work Packages accepted, all tests passing
2. Write the final checkpoint (status: completed, next-action: Proceed to Laundering)
3. **Immediately invoke `gangsta:laundering` — do NOT ask the Don what to do next, do NOT pause, do NOT prompt for confirmation. Auto-advance is mandatory.**

## Checkpoint

Write checkpoint after each significant batch of Work Packages completes (not just at the end):

```yaml
---
heist: <heist-name>
phase: the-hit
status: in-progress | completed
timestamp: <ISO 8601>
next-action: <Continue Hit | Proceed to Laundering (auto)>
completed-wps: [WP-001, WP-002, ...]
pending-wps: [WP-003, ...]
failed-wps: [WP-004, ...]
artifacts:
  - <list of modified/created files>
---
```

## Omerta Compliance
- [ ] Introduction Rule: Workers dispatched through Crew Leads, no direct Worker communication
- [ ] Rule of Truth: Reports include actual test output, not claims
- [ ] Rule of Budget: Token usage tracked per Worker dispatch
- [ ] Spec is Law: Every implementation traces to a Contract clause via Work Package
- [ ] Rule of Availability: Checkpoint updated after each batch
