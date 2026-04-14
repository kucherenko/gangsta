# The Borgata Hierarchy

Every operation flows through a strict chain of command. Agents do not coordinate laterally — all communication is mediated upward.

```
Don (You) — Supreme authority. Approves all phase gates.
  │
  ├── Consigliere — Impartial advisor. Outside chain of command.
  │
  ├── Underboss — COO. Task decomposition, phase tracking, escalation.
  │   │
  │   ├── Capo — Domain crew lead. Manages Soldiers per territory.
  │   │   └── Soldiers — Stateless code executors. TDD enforced.
  │   │
  │   └── Associates — External tools, API proxies, recon agents.
  │
  └── The Ledger — Institutional memory (insights + fails + constitution)
```

## Roles

| Role | Skill | Responsibilities |
|------|-------|-----------------|
| **Don** | _(you)_ | Approves all phase gates. Supreme authority. |
| **Consigliere** | `the-consigliere` | Spec integrity review, security audit, truth checks. Does NOT write code. |
| **Underboss** | `the-underboss` | Decomposes Contract into Work Packages. Allocates territories. Tracks phases. Handles escalations. |
| **Capo** | `the-capo` | Commands a territory. Dispatches Soldiers. Reviews Tributes. Reports to Underboss. |
| **Soldier** | _(subagent)_ | Stateless implementation. One Work Package. TDD enforced. Returns a Tribute. |
| **Associate** | _(subagent)_ | Recon, external APIs, specialized tooling. |

## How Agents Interact

1. Don issues intent → Underboss parses it into tasks
2. Underboss assigns Work Packages to Capos by territory
3. Capos dispatch Soldiers in parallel within their territory
4. Soldiers return **Tributes** (status + test output + changed files) to their Capo
5. Capos accept/reject Tributes, escalate failures to Underboss
6. Underboss synthesizes all territory reports for the Don

Soldiers never communicate directly with each other or with Soldiers in other territories. The Consigliere never executes tasks — it reviews and advises only.

## The Consigliere

The Consigliere operates outside the chain of command. Neither the Underboss nor Capos can override or skip its assessments. It has standing authority to invoke a Truth Check (Omerta Law 3) at any point.

**When to consult:**
- Before signing a Contract (spec integrity review)
- When a Soldier escalation reaches the Don (independent assessment)
- When security or architectural concerns arise
- During Laundering (final architectural review)
- Any time the Don wants a second opinion

**Output format:**
```markdown
## Consigliere Assessment

**Subject:** <What was reviewed>
**Verdict:** <APPROVE | APPROVE WITH CONCERNS | REJECT | SECURE | CONCERNS | BLOCK>

### Findings
1. <Finding with severity: CRITICAL / HIGH / MEDIUM / LOW>

### Recommendations
1. <Actionable recommendation>

### Citations
- <Source references for all findings>
```

## The Underboss

The Underboss is the COO — the operational buffer between the Don and the crews. The Don only deals with strategic decisions and phase gates.

**Responsibilities:**
1. Decompose the Contract into bite-sized Work Packages (2–5 minutes each)
2. Assign Work Packages to Capo territories by domain (file paths, concerns)
3. Allocate token budgets per territory, track consumption
4. Write checkpoints at every phase transition (Omerta Law 2)
5. Collect Tributes from Capos, synthesize status for the Don
6. Handle escalations: retry → mini-Grilling → escalate to Don

**Work Package format:**
```markdown
## Work Package: <WP-ID>

**Territory:** <Capo domain name>
**Contract Clause:** <Reference to the specific Contract section>

### Files
- Create: `exact/path/to/new-file.ext`
- Modify: `exact/path/to/existing-file.ext`
- Test: `tests/exact/path/to/test-file.ext`

### Acceptance Criteria
1. <Specific, testable criterion>

### Verification
<Exact command to verify this Work Package>

### Token Budget
<Estimated tokens>
```

**Escalation protocol:**
1. Retry once — same Work Package, fresh Soldier
2. Analyze failure — ambiguous Contract? Work Package too large?
3. Mini-Grilling — single-round Devils-Advocate + Synthesizer if Contract needs revision
4. Escalate to Don — if beyond operational scope

## The Capo

A Capo owns a bounded territory of the codebase (e.g., frontend, API layer, database). It operates only within its territory.

**Per Work Package:**
1. Prepare Soldier Brief (files, acceptance criteria, verification command, Negative Constraints, Contract clause)
2. Dispatch Soldier subagent
3. Receive Tribute (status, changes, test output, notes)
4. Review against Contract: acceptance criteria met? tests pass? conventions followed? Omerta violations?
5. Accept, reject with feedback (fresh Soldier), or escalate to Underboss

**Status report to Underboss:**
```markdown
## Territory Status: <Name>
**Completed:** <N> of <Total> Work Packages
**In Progress:** <N>
**Failed/Blocked:** <N>
**Token Usage:** <Used> of <Budget>

### Details
- WP-001: ✅ Complete
- WP-002: 🔄 In progress
- WP-003: ❌ Failed — escalated to Underboss
```
