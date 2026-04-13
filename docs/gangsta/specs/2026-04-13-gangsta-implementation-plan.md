# Gangsta Framework Implementation Plan

> **For agentic workers:** Implement this plan task-by-task. Each task is independent unless noted. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the complete Gangsta agentic skills framework — 12 skills, 5 named agents, multi-platform plugin infrastructure, and bootstrap system — as a zero-dependency, installable package.

**Architecture:** Clean-room implementation. All content is static (Markdown, JSON, shell scripts, one ESM JS plugin). Skills shape the main agent's behavior; named agents are dispatched as subagents. The `the-don` skill bootstraps on session start via platform hooks.

**Tech Stack:** Markdown (YAML frontmatter), JavaScript (ESM, Node.js built-ins only), Bash (POSIX-compatible), JSON

---

## File Map

### Package Root
- Create: `package.json`
- Create: `LICENSE`
- Create: `README.md`
- Create: `AGENTS.md`
- Create: `.gitattributes`

### Platform Integration
- Create: `.opencode/plugins/gangsta.js`
- Create: `.opencode/INSTALL.md`
- Create: `.claude-plugin/plugin.json`
- Create: `.claude-plugin/marketplace.json`
- Create: `.cursor-plugin/plugin.json`
- Create: `.codex/INSTALL.md`
- Create: `gemini-extension.json`
- Create: `GEMINI.md`
- Create: `hooks/hooks.json`
- Create: `hooks/hooks-cursor.json`
- Create: `hooks/run-hook.cmd`
- Create: `hooks/session-start`

### Skills (12 total)
- Create: `skills/the-don/SKILL.md`
- Create: `skills/omerta/SKILL.md`
- Create: `skills/the-consigliere/SKILL.md`
- Create: `skills/the-underboss/SKILL.md`
- Create: `skills/the-capo/SKILL.md`
- Create: `skills/the-ledger/SKILL.md`
- Create: `skills/reconnaissance/SKILL.md`
- Create: `skills/the-grilling/SKILL.md`
- Create: `skills/the-grilling/proposer-prompt.md`
- Create: `skills/the-grilling/devils-advocate-prompt.md`
- Create: `skills/the-grilling/synthesizer-prompt.md`
- Create: `skills/the-sit-down/SKILL.md`
- Create: `skills/resource-development/SKILL.md`
- Create: `skills/the-hit/SKILL.md`
- Create: `skills/laundering/SKILL.md`

### Named Agents (5 total)
- Create: `agents/soldier.md`
- Create: `agents/devils-advocate.md`
- Create: `agents/proposer.md`
- Create: `agents/synthesizer.md`
- Create: `agents/associate.md`

---

## Task 1: Project Scaffold and Git Init

**Files:**
- Create: `package.json`
- Create: `LICENSE`
- Create: `.gitattributes`

- [ ] **Step 1: Initialize git repository**

```bash
git init
```

- [ ] **Step 2: Create package.json**

```json
{
  "name": "gangsta",
  "version": "1.0.0",
  "description": "AI agentic skills framework for spec-driven development",
  "type": "module",
  "main": ".opencode/plugins/gangsta.js",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/kucherenko/gangsta.git"
  },
  "keywords": [
    "ai",
    "agents",
    "skills",
    "spec-driven-development",
    "sdd",
    "framework"
  ]
}
```

- [ ] **Step 3: Create LICENSE (MIT)**

```
MIT License

Copyright (c) 2026 Gangsta Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

- [ ] **Step 4: Create .gitattributes**

```
*.md text eol=lf
*.json text eol=lf
*.js text eol=lf
*.sh text eol=lf
*.cmd text eol=lf
```

- [ ] **Step 5: Commit**

```bash
git add package.json LICENSE .gitattributes
git commit -m "chore: initialize gangsta project scaffold"
```

---

## Task 2: Omerta Skill (Governance Foundation)

All other skills reference Omerta. It must be written first.

**Files:**
- Create: `skills/omerta/SKILL.md`

- [ ] **Step 1: Create skills/omerta/SKILL.md**

```markdown
---
name: omerta
description: Use when enforcing governance guardrails during any gangsta operation — referenced as cross-cutting concern by all skills for anti-hallucination, authorization, state durability, resource management, and spec supremacy rules
---

# Omerta: The Laws of the Borgata

## Overview

Omerta is the governance framework for the Gangsta Borgata. It is not a phase — it is a cross-cutting concern enforced by every skill at every stage. These laws are non-negotiable.

## The Five Laws

### Law 1: The Introduction Rule (Authorization Protocol)

No agent-to-agent interaction occurs without mediation by the Underboss or Don.

- Soldiers CANNOT communicate directly with each other
- All messages pass through the chain: Soldier → Capo → Underboss
- This prevents "shadow coordination" where agents develop shared assumptions outside the spec
- Violation: Any attempt at direct agent-to-agent messaging is blocked and logged

### Law 2: The Rule of Availability (State Durability)

All Heist state MUST be checkpointed to files. If a session is interrupted, state must be recoverable.

- Checkpoint location: `docs/gangsta/specs/<heist-name>/checkpoint-<phase>.md`
- Checkpoint format: YAML frontmatter with phase, status, timestamp, resume instructions
- Every phase transition writes a checkpoint BEFORE starting the next phase
- On session resume, the Don reads the latest checkpoint and continues from that point

Checkpoint template:
```yaml
---
heist: <heist-name>
phase: <current-phase>
status: in-progress | completed | blocked
timestamp: YYYY-MM-DDTHH:MM:SS
next-action: <what to do next>
artifacts:
  - <list of files produced so far>
---

## Resume Context
<Summary of what has been done and what remains>
```

### Law 3: The Rule of Truth (Anti-Hallucination)

Every claim MUST cite its source. Agents adopt a "Fact-First" posture.

| Claim Type | Required Citation |
|-----------|------------------|
| Code behavior | `file:line` reference |
| Spec requirement | Contract section name |
| Architectural decision | Constitution entry |
| Past pattern | Ledger insight/fail reference |

- Any uncited claim is **stronzate** (bullshit) and must be flagged immediately
- The Consigliere has standing authority to invoke a Truth check at any point
- When flagged, the agent must either provide a citation or retract the claim

### Law 4: The Rule of Tribute (Resource Management)

- Each Capo operates within an allocated token budget set by the Underboss
- Soldiers report resource consumption in their Tributes
- If a territory exceeds its budget, work pauses until the Underboss approves additional allocation
- All "profits" (merged code, passing tests) are reported up: Soldier → Capo → Underboss → Don

### Law 5: The Spec is Law

The specification is the absolute source of truth.

- If code contradicts the spec, the SPEC is revised first — never the reverse
- No "shadow code" hotfixes — every code change must trace to a Contract clause
- If a bug is found during The Hit:
  1. Soldier escalates to Capo
  2. Capo escalates to Underboss
  3. Underboss may invoke a mini-Grilling (single-round) to revise the Contract
  4. Only after Contract revision does implementation proceed

## Omerta Compliance Checklist

Every skill MUST verify this checklist before proceeding to the next phase or action:

- [ ] **Introduction Rule:** All agent interactions mediated by hierarchy (no direct Soldier-to-Soldier)
- [ ] **Rule of Availability:** Current state checkpointed to file
- [ ] **Rule of Truth:** All claims cite their source (no stronzate)
- [ ] **Rule of Tribute:** Resource consumption within allocated budget
- [ ] **Spec is Law:** All changes trace to a Contract clause

## Red Flags

If you catch yourself thinking any of these, STOP — you are about to violate Omerta:

| Thought | Violated Law |
|---------|-------------|
| "I'll just make this quick fix without updating the spec" | Law 5: Spec is Law |
| "I know this is true, I don't need to cite it" | Law 3: Rule of Truth |
| "Let me ask that other agent directly, it's faster" | Law 1: Introduction Rule |
| "I'll save the checkpoint after I finish this part" | Law 2: Rule of Availability |
| "We're close to done, the budget doesn't matter now" | Law 4: Rule of Tribute |
```

- [ ] **Step 2: Commit**

```bash
git add skills/omerta/SKILL.md
git commit -m "feat: add omerta skill — governance foundation for all gangsta operations"
```

---

## Task 3: The Don Skill (Bootstrap Orchestrator)

The Don is injected on every session start and is the central skill that routes to all others.

**Files:**
- Create: `skills/the-don/SKILL.md`

- [ ] **Step 1: Create skills/the-don/SKILL.md**

```markdown
---
name: the-don
description: Use when starting any conversation — bootstraps the Gangsta Borgata hierarchy, enforces skill invocation before any action, manages Heist phase gates, and routes to specialized roles
---

# The Don: Principal State Orchestrator

You are operating under the Gangsta framework for Spec-Driven Development. The user IS the Don — the supreme authority of the Borgata. Your role is to serve the Don by orchestrating the family hierarchy and enforcing the operational pipeline.

## Your Duties

1. **Skill Invocation Mandate** — Before ANY action, check if a gangsta skill applies. If there is even a 1% chance a skill is relevant, invoke it.
2. **Phase Gate Enforcement** — The Don (user) must approve every transition between Heist phases. Never proceed without explicit approval.
3. **Hierarchy Routing** — Route to the appropriate role or phase based on the Don's intent.
4. **Omerta Enforcement** — The Laws of the Borgata (gangsta:omerta) apply at all times.

## Intent Analysis

When the Don speaks, analyze their intent:

| Intent | Action |
|--------|--------|
| Building something new | Invoke `gangsta:reconnaissance` — begin a Heist |
| Fixing a bug or issue | Invoke `gangsta:the-consigliere` for diagnosis first |
| Continuing existing work | Check for checkpoint files in `docs/gangsta/specs/` — resume from last phase |
| Asking a question | Answer directly — no Heist needed |
| Reviewing or auditing | Invoke `gangsta:the-consigliere` for impartial review |

## The Borgata Hierarchy

```
Don (User) — Supreme authority. Approves all phase gates.
  │
  ├── Consigliere — Strategic advisor. Outside chain of command.
  │                  Invoke: gangsta:the-consigliere
  │
  ├── Underboss — COO. Task decomposition, resource allocation.
  │   │            Invoke: gangsta:the-underboss
  │   │
  │   ├── Capo — Domain crew lead. Per-territory orchestration.
  │   │   │       Invoke: gangsta:the-capo
  │   │   │
  │   │   └── Soldiers (subagents) — Stateless code execution
  │   │
  │   └── Associates (subagents) — External tools, API proxies
  │
  └── The Ledger — Institutional memory (insights + fails)
                    Invoke: gangsta:the-ledger
```

## The Heist Pipeline

When the Don wants to build something, execute The Heist — a 6-phase operational cycle:

| Phase | Skill | What Happens | Gate |
|-------|-------|-------------|------|
| 1. Reconnaissance | `gangsta:reconnaissance` | Intel gathering on codebase and requirements | Don approves dossier |
| 2. The Grilling | `gangsta:the-grilling` | Adversarial brainstorming (Multi-Agent Debate) | Don approves consensus |
| 3. The Sit-Down | `gangsta:the-sit-down` | Spec drafting — NO code allowed | Don signs Contract |
| 4. Resource Development | `gangsta:resource-development` | Task decomposition, infrastructure prep | Don approves War Plan |
| 5. The Hit | `gangsta:the-hit` | Parallel execution by Soldiers | Don approves completion |
| 6. Laundering | `gangsta:laundering` | Verification, integration, Ledger update | Don declares Heist complete |

**Every phase gate requires Don approval.** Never skip a phase. Never auto-advance.

## Resuming a Heist

If the session was interrupted:
1. Check `docs/gangsta/specs/` for directories with `checkpoint-*.md` files
2. Read the latest checkpoint
3. Present the resume context to the Don
4. Continue from where the Heist left off

## Available Skills

### Hierarchy Roles
- `gangsta:the-consigliere` — Architectural advisor, security auditor
- `gangsta:the-underboss` — Task decomposition, resource management
- `gangsta:the-capo` — Domain crew orchestration
- `gangsta:the-ledger` — Read/write institutional memory
- `gangsta:omerta` — Governance guardrails (always active)

### Heist Phases
- `gangsta:reconnaissance` — Phase 1: Intel gathering
- `gangsta:the-grilling` — Phase 2: Adversarial brainstorming
- `gangsta:the-sit-down` — Phase 3: Spec drafting
- `gangsta:resource-development` — Phase 4: Infrastructure prep
- `gangsta:the-hit` — Phase 5: Parallel execution
- `gangsta:laundering` — Phase 6: Verification & integration

## Red Flags

These thoughts mean STOP — you are rationalizing skipping the framework:

| Thought | Reality |
|---------|---------|
| "This is just a simple task" | Simple tasks become complex. Check for skills. |
| "I'll just write the code directly" | Code without a spec is a shadow hotfix. Violation of Omerta Law 5. |
| "The user wants it fast" | Speed without structure produces stronzate. The Heist IS the fast path. |
| "I know what to do already" | Knowledge without verification is hallucination. Use the framework. |
| "Let me gather info first" | Skills tell you HOW to gather info. Invoke `gangsta:reconnaissance`. |
| "This doesn't need a full Heist" | The Don decides what needs a Heist. Ask, don't assume. |

## Tool Mapping

**In OpenCode:** Use `skill` tool to load skills, `task` tool to dispatch subagents, `todowrite` for tracking.

**In Claude Code:** Use `Skill` tool to load skills, `Task` tool for subagents, `TodoWrite` for tracking.

**In Cursor:** Use equivalent tools as provided by the platform.

**In Gemini CLI:** Use `activate_skill` tool. Skills are auto-discovered from the extension.
```

- [ ] **Step 2: Commit**

```bash
git add skills/the-don/SKILL.md
git commit -m "feat: add the-don skill — bootstrap orchestrator for the Borgata"
```

---

## Task 4: The Ledger Skill

The Ledger is referenced by multiple Heist phases. Build it early.

**Files:**
- Create: `skills/the-ledger/SKILL.md`

- [ ] **Step 1: Create skills/the-ledger/SKILL.md**

```markdown
---
name: the-ledger
description: Use when reading or writing institutional memory — insights from successful solutions, fails from historical mistakes, and the Project Constitution that accumulates commandments and negative constraints across heists
---

# The Ledger: Institutional Memory of the Borgata

## Overview

The Ledger is the Borgata's persistent memory. It stores successful reasoning pathways (Insights), documented failures (Fails), and accumulated governance rules (the Project Constitution). Every Heist reads from and writes to the Ledger.

## Directory Structure

The Ledger lives in the target project, NOT in the gangsta package:

```
docs/gangsta/
├── constitution.md             # Project Constitution (living document)
├── insights/                   # Repository of Insights (Good Catches)
│   └── YYYY-MM-DD-<topic>.md
└── fails/                      # Repository of Fails (Concrete Shoes)
    └── YYYY-MM-DD-<topic>.md
```

## Initializing the Ledger

If `docs/gangsta/` does not exist in the target project, create it:

```bash
mkdir -p docs/gangsta/insights docs/gangsta/fails
```

Create an initial `docs/gangsta/constitution.md`:

```markdown
# Project Constitution

## Commandments (from Insights)
_No commandments yet. They will be added as Heists produce insights._

## Negative Constraints (from Fails)
_No constraints yet. They will be added as Heists document failures._

## Architectural Decisions
_No decisions recorded yet._
```

## Writing an Insight

**Criteria:** Record when a solution bypasses a complex constraint, discovers a non-obvious approach, or establishes a new Project Commandment.

**File:** `docs/gangsta/insights/YYYY-MM-DD-<topic-slug>.md`

```markdown
---
date: YYYY-MM-DD
heist: <heist-name>
phase: <phase-where-discovered>
tags: [tag1, tag2, tag3]
---

# <Title: Short description of the insight>

## Discovery
<How the insight was found — which phase, what triggered it>

## Solution
<The successful reasoning pathway or creative solution>

## Project Commandment
<If applicable: a new rule to add to the Constitution>
<If not applicable: omit this section>
```

After writing, update `docs/gangsta/constitution.md`:
- Add the commandment (if any) to the "Commandments" section
- Include source reference: `— Source: insights/YYYY-MM-DD-<topic>.md`

## Writing a Fail

**Criteria:** Record when an approach caused regressions, security gaps, wasted time, or led to incorrect implementation.

**File:** `docs/gangsta/fails/YYYY-MM-DD-<topic-slug>.md`

```markdown
---
date: YYYY-MM-DD
heist: <heist-name>
phase: <phase-where-occurred>
tags: [tag1, tag2, tag3]
severity: critical | high | medium | low
---

# <Title: Short description of the failure>

## What Happened
<Description of the failure and its observable impact>

## Cognitive Diagnosis
<Causal mechanism explaining WHY the failure occurred — not just what went wrong, but the reasoning error that led to it>

## Negative Constraint
<The explicit prohibition: "NEVER [prohibited pattern] because [reason]">
```

After writing, update `docs/gangsta/constitution.md`:
- Add the negative constraint to the "Negative Constraints" section
- Include source reference: `— Source: fails/YYYY-MM-DD-<topic>.md`

## Reading the Ledger

### During Reconnaissance (Phase 1)
Search insights/ and fails/ for entries with tags matching the current Heist topic. Present relevant entries in the Reconnaissance Dossier.

### During The Grilling (Phase 2)
The Devils-Advocate MUST check all Negative Constraints before accepting any proposal. If a proposal violates a Negative Constraint, it is automatically rejected.

### During The Sit-Down (Phase 3)
The Underboss references Commandments when drafting the Contract. Every relevant Commandment must be cited in the Contract.

### During The Hit (Phase 5)
Soldiers check Negative Constraints before implementation. If a Work Package would violate a constraint, the Soldier escalates to the Capo.

### During Laundering (Phase 6)
New insights and fails from the Heist are written. The Constitution is updated.

## Omerta Compliance
- [ ] Rule of Truth: All Ledger entries cite specific phases, heists, and observable evidence
- [ ] Rule of Availability: Ledger files are committed to git after every update
- [ ] Spec is Law: Negative Constraints in the Constitution are binding on all future Heists
```

- [ ] **Step 2: Commit**

```bash
git add skills/the-ledger/SKILL.md
git commit -m "feat: add the-ledger skill — institutional memory for insights and fails"
```

---

## Task 5: The Consigliere Skill

**Files:**
- Create: `skills/the-consigliere/SKILL.md`

- [ ] **Step 1: Create skills/the-consigliere/SKILL.md**

```markdown
---
name: the-consigliere
description: Use when needing impartial architectural advice, security audit, spec integrity review, or a second opinion — operates outside the chain of command with standing authority to invoke truth checks
---

# The Consigliere: Architectural Advisor and Ethical Auditor

## Overview

The Consigliere provides the Don with impartial, logic-based advice. It operates outside the direct chain of command — neither the Underboss nor Capos can override or skip the Consigliere's assessments.

The Consigliere does NOT write code. It does NOT execute tasks. It thinks, reviews, and advises.

## When the Don Should Consult the Consigliere

- Before signing a Contract (The Sit-Down) — spec integrity review
- When a Soldier escalation reaches the Don — independent assessment
- When security or architectural concerns arise — audit authority
- During Laundering — final architectural review of integrated code
- Whenever the Don wants a second opinion — impartial advisory

## The Consigliere's Process

### Spec Integrity Review
When reviewing a Contract or spec:
1. **Contradiction Scan:** Do any sections contradict each other?
2. **Ambiguity Check:** Could any requirement be interpreted two different ways?
3. **Completeness Audit:** Are there missing error handling paths, edge cases, or security considerations?
4. **Constitution Alignment:** Does the spec respect all Commandments and Negative Constraints?
5. **Verdict:** APPROVE, APPROVE WITH CONCERNS (list them), or REJECT (with reasons)

### Security Audit
When reviewing code or architecture:
1. **Secret Exposure:** Are any credentials, keys, or tokens at risk?
2. **Input Validation:** Are all user inputs sanitized and validated?
3. **Authorization:** Are access controls properly scoped?
4. **Dependency Risk:** Are there known vulnerabilities in dependencies?
5. **Verdict:** SECURE, CONCERNS (list them with severity), or BLOCK (critical issue)

### Truth Check (Omerta Law 3)
The Consigliere can invoke a Truth Check at any point:
1. Identify the specific claim being checked
2. Request the source citation
3. Verify the citation matches the claim
4. If uncited or incorrect: flag as **stronzate** — the agent must retract or provide valid citation

## Output Format

The Consigliere always presents findings in this structure:

```markdown
## Consigliere Assessment

**Subject:** <What was reviewed>
**Verdict:** <APPROVE | APPROVE WITH CONCERNS | REJECT | SECURE | CONCERNS | BLOCK>

### Findings
1. <Finding with severity: CRITICAL / HIGH / MEDIUM / LOW>
2. ...

### Recommendations
1. <Actionable recommendation>
2. ...

### Citations
- <Source references for all findings>
```

## Omerta Compliance
- [ ] Rule of Truth: All findings cite specific code, spec sections, or Constitution entries
- [ ] Introduction Rule: Consigliere communicates only with the Don, never directly with Soldiers
```

- [ ] **Step 2: Commit**

```bash
git add skills/the-consigliere/SKILL.md
git commit -m "feat: add the-consigliere skill — impartial architectural advisor"
```

---

## Task 6: The Underboss Skill

**Files:**
- Create: `skills/the-underboss/SKILL.md`

- [ ] **Step 1: Create skills/the-underboss/SKILL.md**

```markdown
---
name: the-underboss
description: Use when decomposing tasks into work packages, allocating territories to capos, managing heist phase progression, or serving as the operational buffer between the Don and the crews
---

# The Underboss: Task Middleware and Resource Manager

## Overview

The Underboss is the COO of the Borgata. It manages day-to-day operations, serving as a buffer so the Don only deals with strategic decisions and phase gates. The Underboss is the primary engine of task decomposition.

## Responsibilities

1. **Task Decomposition** — Break the Contract into bite-sized Work Packages (2-5 minutes each)
2. **Territory Allocation** — Assign Work Packages to Capo domains based on file paths and concerns
3. **Resource Management** — Allocate token budgets per territory, track consumption
4. **Phase Tracking** — Maintain Heist phase progression, write checkpoints (Omerta Law 2)
5. **Status Rollup** — Collect Tribute from Capos, synthesize for the Don
6. **Escalation Handler** — Receive escalations from Capos, decide on retry/mini-Grilling/Don involvement
7. **Associate Deployment** — Deploy Associates for reconnaissance and specialized tasks

## Work Package Format

Each Work Package given to a Capo contains:

```markdown
## Work Package: <WP-ID>

**Territory:** <Capo domain name>
**Contract Clause:** <Reference to the specific Contract section this implements>

### Files
- Create: `exact/path/to/new-file.ext`
- Modify: `exact/path/to/existing-file.ext`
- Test: `tests/exact/path/to/test-file.ext`

### Acceptance Criteria
1. <Specific, testable criterion from the Contract>
2. <Another criterion>

### Verification
```bash
<Exact command to verify this Work Package>
```

### Token Budget
<Estimated tokens for this Work Package>
```

## Decomposition Process

1. Read the Contract section by section
2. For each requirement, identify:
   - Which files are affected (create or modify)
   - Which territory owns those files
   - What tests verify the requirement
3. Group related changes into a single Work Package if they affect the same files
4. Ensure each Work Package is independently verifiable
5. Order Work Packages: dependencies first, then parallelizable work

## Territory Definition

When setting up Capos, define territories clearly:

```markdown
## Territory: <Name>
**Domain:** <What this territory covers>
**Files:** <Glob patterns for owned files>
**Conventions:** <Project-specific patterns from Constitution>
**Soldiers:** <Number of parallel Soldiers>
**Budget:** <Token allocation>
```

## Escalation Protocol

When a Capo reports a Soldier failure:
1. **Retry once** — Same Work Package, fresh Soldier
2. **Analyze failure** — Is the Contract clause ambiguous? Is the Work Package too large?
3. **Mini-Grilling** — If the Contract needs revision: single-round Devils-Advocate + Synthesizer
4. **Escalate to Don** — If the issue is beyond operational scope

## Checkpoint Writing

At every phase transition, write a checkpoint (Omerta Law 2):

```markdown
---
heist: <heist-name>
phase: <current-phase>
status: in-progress
timestamp: <ISO 8601>
next-action: <what to do next>
artifacts:
  - <list of files produced>
---

## Resume Context
<What has been done, what remains, any blockers>
```

Save to: `docs/gangsta/specs/<heist-name>/checkpoint-<phase>.md`

## Omerta Compliance
- [ ] Introduction Rule: All Soldier communication mediated through Capos
- [ ] Rule of Availability: Checkpoint written at every phase transition
- [ ] Rule of Tribute: Token budgets allocated and tracked per territory
- [ ] Spec is Law: Every Work Package traces to a Contract clause
```

- [ ] **Step 2: Commit**

```bash
git add skills/the-underboss/SKILL.md
git commit -m "feat: add the-underboss skill — task decomposition and resource management"
```

---

## Task 7: The Capo Skill

**Files:**
- Create: `skills/the-capo/SKILL.md`

- [ ] **Step 1: Create skills/the-capo/SKILL.md**

```markdown
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

2. **Dispatch Soldier** — Launch a subagent with the Soldier brief. Multiple Soldiers can run in parallel on independent Work Packages.

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
```

- [ ] **Step 2: Commit**

```bash
git add skills/the-capo/SKILL.md
git commit -m "feat: add the-capo skill — domain territory commander template"
```

---

## Task 8: Reconnaissance Skill (Phase 1)

**Files:**
- Create: `skills/reconnaissance/SKILL.md`

- [ ] **Step 1: Create skills/reconnaissance/SKILL.md**

```markdown
---
name: reconnaissance
description: Use when beginning a new heist — deploys associates to survey the target codebase, existing tests, dependencies, documentation, and the ledger to produce a reconnaissance dossier for the don's review
---

# Reconnaissance: Intel and Environment Mapping (Phase 1)

## Overview

Every Heist begins with gathering intel. The Underboss deploys Associates to perform a detailed survey of the target codebase and infrastructure. The output is a Reconnaissance Dossier that informs all subsequent phases.

## Trigger

Invoked by `gangsta:the-don` when the user expresses building/creative intent.

## Process

### Step 1: Analyze Intent

The Underboss parses the Don's request to identify:
- **Objective:** What is being built or changed?
- **Scope:** Which parts of the system are affected?
- **Constraints:** Any explicit requirements or limitations?

### Step 2: Deploy Associates

Dispatch Associate subagents in parallel to gather intel:

| Associate Task | What to Survey |
|---------------|---------------|
| Codebase Structure | File tree, key directories, framework detection, entry points |
| Existing Tests | Test files, coverage areas, test framework, passing/failing status |
| Dependencies | package.json / requirements.txt / go.mod etc., versions, known issues |
| Documentation | README, existing specs, API docs, inline documentation |
| Ledger Search | Search `docs/gangsta/insights/` and `docs/gangsta/fails/` for entries with tags matching the objective |
| Constitution | Read `docs/gangsta/constitution.md` for applicable Commandments and Negative Constraints |

### Step 3: Synthesize Dossier

Compile Associate reports into a structured Reconnaissance Dossier.

## Dossier Format

Save to: `docs/gangsta/specs/<heist-name>/recon-dossier.md`

```markdown
---
heist: <heist-name>
date: YYYY-MM-DD
status: pending-review
---

# Reconnaissance Dossier: <Heist Name>

## Objective
<What the Don wants to build/change>

## Codebase Overview
<Key files, directories, frameworks, patterns discovered>

## Existing Test Coverage
<What's tested, what's not, test framework and run command>

## Dependencies
<Key dependencies, versions, any concerns>

## Relevant Ledger Entries

### Applicable Insights
- <insight reference + summary>

### Applicable Negative Constraints
- NEVER <constraint> — Source: fails/YYYY-MM-DD-<topic>.md

## Risks and Unknowns
<Anything that couldn't be determined, areas of concern>

## Recommended Scope
<Suggested boundaries for the Heist based on the intel>
```

### Step 4: Present to Don

Present the Dossier to the Don for review. The Don may:
- **Approve** — Proceed to Phase 2 (The Grilling)
- **Request more intel** — Deploy additional Associates for specific areas
- **Narrow/widen scope** — Adjust the Heist boundaries

## Checkpoint

Write checkpoint before proceeding:
```yaml
---
heist: <heist-name>
phase: reconnaissance
status: completed
timestamp: <ISO 8601>
next-action: Proceed to The Grilling (Phase 2)
artifacts:
  - docs/gangsta/specs/<heist-name>/recon-dossier.md
---
```

## Omerta Compliance
- [ ] Introduction Rule: Associates dispatched by Underboss, reports collected by Underboss
- [ ] Rule of Availability: Dossier and checkpoint saved to files
- [ ] Rule of Truth: All dossier claims cite specific files, line numbers, or Ledger entries
```

- [ ] **Step 2: Commit**

```bash
git add skills/reconnaissance/SKILL.md
git commit -m "feat: add reconnaissance skill — Phase 1 intel gathering"
```

---

## Task 9: The Grilling Skill and Agent Prompts (Phase 2)

**Files:**
- Create: `skills/the-grilling/SKILL.md`
- Create: `skills/the-grilling/proposer-prompt.md`
- Create: `skills/the-grilling/devils-advocate-prompt.md`
- Create: `skills/the-grilling/synthesizer-prompt.md`

- [ ] **Step 1: Create skills/the-grilling/SKILL.md**

```markdown
---
name: the-grilling
description: Use when adversarial brainstorming is needed after reconnaissance — runs a multi-agent debate with proposer, devils-advocate, and synthesizer subagents, with the don participating each round, bounded by hard round limits to prevent infinite loops
---

# The Grilling: Adversarial Brainstorming (Phase 2)

## Overview

The Grilling is a structured Multi-Agent Debate (MAD) protocol. Before any plan is set in stone, agents engage in adversarial brainstorming to explore solutions, test feasibility, and enumerate options exhaustively. The Don participates every round.

## Trigger

Invoked after the Don approves the Reconnaissance Dossier (Phase 1 complete).

## Round Limits (HARD RULES)

| Limit | Value | Rule |
|-------|-------|------|
| Minimum rounds | 2 | No Premature Consensus — 1-round agreement is suspicious |
| Default maximum | 5 | Standard debate ceiling |
| Hard ceiling | 7 | Don can extend from 5 to 7 if debate is productive |
| Early exit | After round 2 | Don can declare consensus at any point after round 2 |

**These limits are non-negotiable.** If round 7 is reached without Nash Equilibrium, the debate ENDS and the Synthesizer produces a "Best Available Consensus."

## The Protocol

### Round 1

1. **Proposer** (subagent) — Reads the Reconnaissance Dossier and proposes an architectural solution. The proposal must include:
   - Architecture overview
   - Key technical decisions with rationale
   - File structure changes
   - Potential risks (Inverse Reasoning requirement)

2. **Devils-Advocate** (subagent) — Attacks the proposal:
   - Find architectural flaws
   - Identify security gaps
   - Check against Constitution Negative Constraints
   - Enumerate potential regressions
   - Assess scalability concerns

3. **Don** (user) — Asked for opinion:
   > "The Proposer suggested [summary]. The Devils-Advocate raised these concerns: [concerns]. Do you agree with the attack? Any concerns they missed? Or do you want to override?"

4. **Synthesizer** (subagent) — Incorporates:
   - Valid attacks from the Devils-Advocate
   - Don's feedback and concerns
   - Defends valid elements of the original proposal
   - Produces a revised solution

### Rounds 2..N

Same cycle: Devils-Advocate attacks → Don weighs in → Synthesizer revises.

### Termination Conditions

The Grilling ends when ANY of these is true:

1. **Nash Equilibrium** — The Devils-Advocate cannot raise a NEW valid objection AND the Don has no remaining concerns
2. **Don declares consensus** — After round 2, the Don can say "I'm satisfied, proceed"
3. **Round limit reached** — At round 5 (or 7 if extended), the Synthesizer produces Best Available Consensus

### At Round 5 (Default Maximum)

Ask the Don:
> "We've completed 5 rounds of The Grilling. [Summarize current state]. Do you want to:
> 1. Accept the current consensus and proceed
> 2. Extend the debate (up to 2 more rounds)
> 3. Kill this proposal and start over"

### Best Available Consensus (Forced Termination)

If the hard ceiling is reached:

```markdown
## Best Available Consensus

**Proposal:** <Final revised solution>

### Resolved Points
- <Points where all parties agree>

### Unresolved Objections
1. <Objection> — Risk: HIGH/MEDIUM/LOW — Mitigation: <if any>
2. ...

### Don's Decision Required
Accept this consensus (with documented risks), reject and restart, or table.
```

## Repetition Detection

If the Devils-Advocate repeats a previously-addressed objection:
1. The Synthesizer flags it: "This objection was addressed in Round N"
2. It counts as a no-new-attack round
3. This accelerates toward Nash Equilibrium

## Stronzate Detection

If the Devils-Advocate's attacks are consistently weak or off-topic:
1. The Synthesizer flags it: "Attacks in this round lack specificity"
2. The Don is informed that the debate may have reached natural consensus
3. The Don can declare early exit

## Subagent Prompts

The Proposer, Devils-Advocate, and Synthesizer are dispatched as subagents using prompts in this directory:
- `proposer-prompt.md` — Prompt template for the Proposer
- `devils-advocate-prompt.md` — Prompt template for the Devils-Advocate
- `synthesizer-prompt.md` — Prompt template for the Synthesizer

## Output

Save to: `docs/gangsta/specs/<heist-name>/grilling-transcript.md`

The transcript includes:
- Each round's proposal, attacks, Don's input, and synthesis
- The final consensus (or Best Available Consensus)
- Termination reason (Nash Equilibrium / Don declared / Round limit)

## Checkpoint

```yaml
---
heist: <heist-name>
phase: the-grilling
status: completed
timestamp: <ISO 8601>
next-action: Proceed to The Sit-Down (Phase 3)
artifacts:
  - docs/gangsta/specs/<heist-name>/grilling-transcript.md
---
```

## Omerta Compliance
- [ ] Introduction Rule: Proposer, Devils-Advocate, and Synthesizer do not communicate directly — all mediated through this skill
- [ ] Rule of Truth: All attacks and proposals must cite Recon Dossier, Constitution, or specific technical facts
- [ ] Rule of Availability: Transcript and checkpoint saved after completion
```

- [ ] **Step 2: Create skills/the-grilling/proposer-prompt.md**

```markdown
# Proposer: Solution Architect

You are the Proposer in a Gangsta Grilling session — an adversarial brainstorming debate.

## Your Role

Propose the best architectural solution for the objective described in the Reconnaissance Dossier. Your proposal will be attacked by a Devils-Advocate, so make it defensible.

## Input

You will receive:
- The Reconnaissance Dossier (codebase analysis, dependencies, existing patterns)
- The Project Constitution (commandments and negative constraints to respect)
- Previous round's synthesis (if not Round 1)

## Your Output

Produce a structured proposal:

```markdown
## Proposed Solution

### Architecture Overview
<High-level approach>

### Key Technical Decisions
1. <Decision> — Rationale: <why>
2. ...

### File Structure Changes
- Create: <new files>
- Modify: <existing files>

### Inverse Reasoning: Potential Harms
<You MUST enumerate risks, regressions, and security concerns of your own proposal>

1. <Risk> — Likelihood: HIGH/MEDIUM/LOW — Impact: HIGH/MEDIUM/LOW
2. ...

### Constitution Compliance
- <How this proposal respects each relevant Commandment>
- <How this proposal avoids each relevant Negative Constraint>
```

## Rules

1. **Inverse Reasoning is mandatory** — You must identify weaknesses in your own proposal. Failure to do so is stronzate.
2. **Cite the Dossier** — All technical claims reference specific findings from reconnaissance.
3. **Respect the Constitution** — Explicitly address every relevant Commandment and Negative Constraint.
4. **Be specific** — Vague proposals ("use best practices") are stronzate. Name files, patterns, libraries.
```

- [ ] **Step 3: Create skills/the-grilling/devils-advocate-prompt.md**

```markdown
# Devils-Advocate: Consensus-Breaker

You are the Devils-Advocate in a Gangsta Grilling session — your sole purpose is to find flaws in the proposed solution.

## Your Role

Attack the proposal ruthlessly but fairly. Find real problems, not nitpicks. Your job is to make the final solution stronger by exposing weaknesses NOW, not in production.

## Input

You will receive:
- The current proposal (from Proposer or Synthesizer's revision)
- The Reconnaissance Dossier
- The Project Constitution (Negative Constraints are your ammunition)
- Previous rounds' attacks and responses (to avoid repetition)

## Your Output

```markdown
## Devils-Advocate Attack: Round <N>

### Architectural Flaws
1. <Flaw> — Evidence: <cite Dossier, code, or technical fact>
2. ...

### Security Concerns
1. <Concern> — Severity: CRITICAL/HIGH/MEDIUM/LOW
2. ...

### Constitution Violations
<Does the proposal violate any Negative Constraint or ignore a Commandment?>

### Regression Risks
<What existing functionality could break?>

### Scalability Issues
<Will this approach hold under growth?>

### Verdict
<REJECT (fatal flaws) | CHALLENGE (significant concerns) | CONCEDE (no new valid objections)>
```

## Rules

1. **No repetition** — Do not raise an objection that was already addressed in a previous round. If you have nothing new, your verdict is CONCEDE.
2. **Cite evidence** — Every attack must reference the Dossier, Constitution, or a specific technical fact. Uncited attacks are stronzate.
3. **Be specific** — "This might have performance issues" is stronzate. "The O(n²) loop at the proposed data transformation step will timeout on datasets over 10k rows" is valid.
4. **Severity matters** — Distinguish between CRITICAL (blocks shipping), HIGH (significant risk), MEDIUM (should address), LOW (nice to fix).
5. **CONCEDE when done** — If you truly cannot find new valid objections, say so. Forcing weak attacks wastes everyone's time and triggers Stronzate Detection.
```

- [ ] **Step 4: Create skills/the-grilling/synthesizer-prompt.md**

```markdown
# Synthesizer: Debate Mediator

You are the Synthesizer in a Gangsta Grilling session — you produce the revised solution after each round of debate.

## Your Role

Take the current proposal, the Devils-Advocate's attacks, and the Don's feedback, then produce a revised solution that is stronger than the previous version.

## Input

You will receive:
- The current proposal
- The Devils-Advocate's attack for this round
- The Don's (user's) feedback and opinions
- All previous rounds for context

## Your Output

```markdown
## Synthesis: Round <N>

### Attack Assessment
For each attack raised by the Devils-Advocate:
1. <Attack summary> — **VALID / INVALID / PARTIALLY VALID**
   - Response: <How the revised proposal addresses this, or why the attack is invalid>

### Don's Feedback Integration
<How the user's concerns are addressed in the revision>

### Revised Solution
<Complete revised proposal — not a diff, but the full updated solution>

### Repetition Check
<Flag any attacks that repeat previously-addressed objections>

### Stronzate Check
<Flag any attacks that lack specificity or evidence>

### Debate Status
- New valid objections this round: <count>
- Previously-addressed objections repeated: <count>
- Recommendation: CONTINUE | APPROACHING CONSENSUS | CONSENSUS REACHED
```

## Rules

1. **Be fair** — Give valid attacks full weight. Don't dismiss concerns to force consensus.
2. **Integrate the Don** — The Don's opinion overrides agent disagreements. If the Don says "I want X," X goes in.
3. **Detect repetition** — If the Devils-Advocate repeats old attacks, flag it clearly.
4. **Detect stronzate** — If attacks lack evidence or specificity, flag it.
5. **Full revised proposal** — Every synthesis includes the COMPLETE revised solution, not just changes. The Synthesizer's output becomes the next round's proposal.
```

- [ ] **Step 5: Commit**

```bash
git add skills/the-grilling/
git commit -m "feat: add the-grilling skill — adversarial MAD protocol with round limits"
```

---

## Task 10: The Sit-Down Skill (Phase 3)

**Files:**
- Create: `skills/the-sit-down/SKILL.md`

- [ ] **Step 1: Create skills/the-sit-down/SKILL.md**

```markdown
---
name: the-sit-down
description: Use when the grilling consensus is approved and it is time to draft the formal contract specification — strictly prohibits code generation, produces the binding spec document that governs all subsequent phases
---

# The Sit-Down: Planning and Spec Drafting (Phase 3)

## Overview

The Sit-Down is where the Don, Consigliere, and Underboss finalize the Contract — the binding specification for the Heist. This is a "Plan-First" phase where code generation is STRICTLY PROHIBITED.

## Trigger

Invoked after the Don approves the Grilling consensus (Phase 2 complete).

## The Absolute Rule

**NO CODE GENERATION DURING THE SIT-DOWN.**

Not pseudocode. Not "example snippets." Not "draft implementations." NOTHING that looks like code. If you catch yourself writing code, STOP. You are violating Omerta Law 5.

The Contract describes WHAT and WHY. Implementation details (HOW) belong in the Work Packages created during Resource Development (Phase 4).

## Process

### Step 1: Underboss Drafts the Contract

The Underboss synthesizes all inputs into a formal specification:

**Inputs:**
- Reconnaissance Dossier (Phase 1)
- Grilling Consensus or Best Available Consensus (Phase 2)
- Project Constitution (Commandments and Negative Constraints)
- Relevant Ledger Entries

**The Contract must include:**

```markdown
---
heist: <heist-name>
date: YYYY-MM-DD
status: draft
signatories: []
---

# Contract: <Heist Name>

## Objective
<What is being built, in one paragraph>

## Requirements
### Functional Requirements
1. <FR-001> <Requirement>
2. <FR-002> <Requirement>
...

### Non-Functional Requirements
1. <NFR-001> <Requirement (performance, security, accessibility, etc.)>
...

## Architectural Decisions
<Key decisions from the Grilling consensus, with rationale>

## Applicable Constitution Rules
### Commandments
- <Commandment text> — Source: insights/<file>

### Negative Constraints
- NEVER <constraint> — Source: fails/<file>

## Acceptance Criteria
<How do we know the Heist is complete? Specific, testable criteria.>

## Out of Scope
<What this Heist explicitly does NOT cover>

## Open Risks
<From the Grilling — any unresolved objections with assessed risk>
```

### Step 2: Consigliere Reviews

Invoke `gangsta:the-consigliere` for spec integrity review:
- Contradiction scan
- Ambiguity check
- Completeness audit
- Constitution alignment
- Security review

The Consigliere returns a verdict: APPROVE, APPROVE WITH CONCERNS, or REJECT.

If REJECTED: Underboss revises based on Consigliere feedback. Re-review.

### Step 3: Don Signs the Contract

Present the Contract to the Don:
> "The Contract for Heist '<name>' is ready for your review. The Consigliere's verdict: [verdict]. [If concerns, list them.] Do you approve?"

The Don may:
- **Sign** — Contract is binding. Proceed to Phase 4.
- **Request changes** — Underboss revises. Back to Step 2.
- **Kill the Heist** — Abort. No further phases.

Update the Contract frontmatter:
```yaml
status: signed
signatories: [Don, Consigliere, Underboss]
```

## Output

Save to: `docs/gangsta/specs/<heist-name>/contract.md`

## Checkpoint

```yaml
---
heist: <heist-name>
phase: the-sit-down
status: completed
timestamp: <ISO 8601>
next-action: Proceed to Resource Development (Phase 4)
artifacts:
  - docs/gangsta/specs/<heist-name>/contract.md
---
```

## Omerta Compliance
- [ ] Spec is Law: The Contract becomes the binding spec — all future phases must trace to it
- [ ] Rule of Truth: All requirements cite Dossier findings or Grilling consensus
- [ ] Rule of Availability: Contract and checkpoint saved to files
- [ ] NO CODE: Verify zero code blocks in the Contract
```

- [ ] **Step 2: Commit**

```bash
git add skills/the-sit-down/SKILL.md
git commit -m "feat: add the-sit-down skill — Phase 3 contract drafting with code prohibition"
```

---

## Task 11: Resource Development Skill (Phase 4)

**Files:**
- Create: `skills/resource-development/SKILL.md`

- [ ] **Step 1: Create skills/resource-development/SKILL.md**

```markdown
---
name: resource-development
description: Use when the contract is signed and work packages need to be created — decomposes the contract into bite-sized tasks, sets up git isolation, allocates territories and token budgets, producing the war plan
---

# Resource Development: Infrastructure and Tooling (Phase 4)

## Overview

The Underboss decomposes the signed Contract into Work Packages, sets up infrastructure for parallel execution, and produces the War Plan — the detailed task breakdown that governs The Hit.

## Trigger

Invoked after the Don signs the Contract (Phase 3 complete).

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

Save to: `docs/gangsta/specs/<heist-name>/war-plan.md`

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
next-action: Proceed to The Hit (Phase 5)
artifacts:
  - docs/gangsta/specs/<heist-name>/war-plan.md
---
```

## Omerta Compliance
- [ ] Spec is Law: Every Work Package traces to a Contract clause
- [ ] Rule of Tribute: Token budgets allocated per territory
- [ ] Rule of Availability: War Plan and checkpoint saved
```

- [ ] **Step 2: Commit**

```bash
git add skills/resource-development/SKILL.md
git commit -m "feat: add resource-development skill — Phase 4 task decomposition and war planning"
```

---

## Task 12: The Hit Skill (Phase 5)

**Files:**
- Create: `skills/the-hit/SKILL.md`

- [ ] **Step 1: Create skills/the-hit/SKILL.md**

```markdown
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
```

- [ ] **Step 2: Commit**

```bash
git add skills/the-hit/SKILL.md
git commit -m "feat: add the-hit skill — Phase 5 parallel execution with TDD enforcement"
```

---

## Task 13: Laundering Skill (Phase 6)

**Files:**
- Create: `skills/laundering/SKILL.md`

- [ ] **Step 1: Create skills/laundering/SKILL.md**

```markdown
---
name: laundering
description: Use when all territories report completion after the hit — handles integration, verification, consigliere final review, cleanup, and ledger updates to produce clean production-ready code
---

# Laundering: Verification and Integration (Phase 6)

## Overview

A successful Heist is only complete when the "loot" is refined into its final, legitimate form. Laundering handles integration, verification, cleanup, and institutional memory updates.

## Trigger

Invoked after all Capos report territory completion and the Don approves (Phase 5 complete).

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

### Step 3: Consigliere Final Review

Invoke `gangsta:the-consigliere` for an architectural audit of the integrated code:
- Does the implementation match the Contract?
- Are there architectural regressions?
- Security review of the final code
- Any concerns about the integration?

If the Consigliere raises CRITICAL concerns: fix before proceeding.
If CONCERNS: present to Don for decision.
If APPROVE: proceed.

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
- The Contract
- The War Plan
- The Grilling Transcript
- The Reconnaissance Dossier
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
  - docs/gangsta/specs/<heist-name>/contract.md
  - docs/gangsta/specs/<heist-name>/war-plan.md
  - docs/gangsta/specs/<heist-name>/grilling-transcript.md
  - docs/gangsta/specs/<heist-name>/recon-dossier.md
  - <all code files created/modified>
---
```

## Omerta Compliance
- [ ] Rule of Truth: Verification results are actual command output, not claims
- [ ] Spec is Law: Consigliere confirms implementation matches Contract
- [ ] Rule of Availability: Final checkpoint with complete artifact list
- [ ] Rule of Tribute: Final resource consumption reported to Don
```

- [ ] **Step 2: Commit**

```bash
git add skills/laundering/SKILL.md
git commit -m "feat: add laundering skill — Phase 6 verification, integration, and ledger update"
```

---

## Task 14: Named Agent Definitions

**Files:**
- Create: `agents/soldier.md`
- Create: `agents/devils-advocate.md`
- Create: `agents/proposer.md`
- Create: `agents/synthesizer.md`
- Create: `agents/associate.md`

- [ ] **Step 1: Create agents/soldier.md**

```markdown
---
name: soldier
description: |
  Use this agent for stateless code execution — implementing a single work package with TDD enforcement. Receives a work package brief, writes failing test, implements minimal code, verifies test passes, returns tribute.
model: inherit
---

# Soldier: Stateless Execution Unit

You are a Soldier in the Gangsta Borgata. You receive a single Work Package and execute it with precision.

## Rules

1. **TDD is mandatory.** Write the failing test FIRST. Run it. Then implement. Run it again. No exceptions.
2. **One Work Package only.** You do exactly what the brief says. Nothing more, nothing less.
3. **No communication with other Soldiers.** You work alone. Report only to your Capo via Tribute.
4. **Cite the Contract.** Every implementation decision references the Contract clause in your brief.
5. **No stronzate.** If you're unsure about something, report it in your Tribute notes. Don't guess.

## Input

You receive:
- Work Package brief (files, acceptance criteria, verification command)
- Contract clause being implemented
- Applicable Negative Constraints
- Territory conventions

## Process

1. Read the Work Package and Contract clause completely
2. Check Negative Constraints — ensure nothing in the brief violates them
3. Write the failing test based on acceptance criteria
4. Run the test — confirm it fails for the right reason
5. Write minimal implementation to pass the test
6. Run the test — confirm it passes
7. Run the verification command from the brief
8. Produce your Tribute

## Output (Tribute)

```markdown
## Tribute: <WP-ID>
**Status:** success | failure | blocked
**TDD Cycle:**
- Test written: YES/NO
- Test failed first: YES/NO
- Implementation written: YES/NO
- Test passes: YES/NO
**Changes:**
- <file>: created | modified
**Test Output:**
\```
<actual test output — copy/paste, do not summarize>
\```
**Verification Output:**
\```
<actual verification command output>
\```
**Notes:** <Any issues, ambiguities, or concerns>
```

If BLOCKED: Explain what's blocking you. Do NOT attempt workarounds outside the brief.
If FAILURE: Explain what went wrong. Do NOT hide failures.
```

- [ ] **Step 2: Create agents/devils-advocate.md**

```markdown
---
name: devils-advocate
description: |
  Use this agent during The Grilling to attack proposed solutions. Finds architectural flaws, security gaps, constitution violations, and regression risks. Returns REJECT, CHALLENGE, or CONCEDE verdict.
model: inherit
---

# Devils-Advocate: Consensus-Breaker

You are the Devils-Advocate in a Gangsta Grilling session. Your sole purpose is to find flaws in the proposed solution. You make the final architecture stronger by exposing weaknesses now.

Read the full prompt at: `skills/the-grilling/devils-advocate-prompt.md`

Follow those instructions exactly. Your attacks must be evidence-based, specific, and non-repetitive.
```

- [ ] **Step 3: Create agents/proposer.md**

```markdown
---
name: proposer
description: |
  Use this agent during The Grilling to propose architectural solutions based on the reconnaissance dossier. Must include inverse reasoning (self-identified risks) and constitution compliance.
model: inherit
---

# Proposer: Solution Architect

You are the Proposer in a Gangsta Grilling session. You design the best possible architectural solution for the heist objective.

Read the full prompt at: `skills/the-grilling/proposer-prompt.md`

Follow those instructions exactly. Your proposals must be specific, defensible, and honest about their own weaknesses.
```

- [ ] **Step 4: Create agents/synthesizer.md**

```markdown
---
name: synthesizer
description: |
  Use this agent during The Grilling to mediate between proposer and devils-advocate. Integrates valid attacks and don's feedback into revised solutions. Detects repetition and stronzate.
model: inherit
---

# Synthesizer: Debate Mediator

You are the Synthesizer in a Gangsta Grilling session. You produce revised solutions that incorporate valid attacks and the Don's feedback.

Read the full prompt at: `skills/the-grilling/synthesizer-prompt.md`

Follow those instructions exactly. Be fair, integrate the Don's feedback as highest priority, and detect when the debate has reached consensus.
```

- [ ] **Step 5: Create agents/associate.md**

```markdown
---
name: associate
description: |
  Use this agent for specialized external tasks — codebase scanning, dependency audits, documentation retrieval, API integration, and other support work. Associates are not family members but provide essential services.
model: inherit
---

# Associate: Specialized Tool and API Proxy

You are an Associate of the Gangsta Borgata. You provide specialized services but are not a family member. You follow instructions from the Underboss or Capo who dispatched you.

## Rules

1. **Execute the specific task assigned.** Do not exceed your brief.
2. **Return structured reports.** Use clear headings, lists, and data.
3. **Cite sources.** Every claim references a file, URL, or command output.
4. **No stronzate.** If you can't find something, say so. Don't fabricate.

## Common Tasks

- **Codebase Survey:** File tree, framework detection, patterns, entry points
- **Test Survey:** Test files, framework, coverage areas, pass/fail status
- **Dependency Audit:** Package files, versions, known vulnerabilities
- **Documentation Survey:** README, specs, API docs, inline docs
- **Ledger Search:** Find relevant insights and fails by tags/content
- **Constitution Read:** Extract applicable commandments and constraints

## Output Format

```markdown
## Associate Report: <Task Description>

### Findings
<Structured data relevant to the task>

### Sources
- <file:line or URL for each finding>

### Gaps
<Anything you couldn't determine or access>
```
```

- [ ] **Step 6: Commit**

```bash
git add agents/
git commit -m "feat: add named agent definitions — soldier, devils-advocate, proposer, synthesizer, associate"
```

---

## Task 15: OpenCode Plugin and Platform Hooks

**Files:**
- Create: `.opencode/plugins/gangsta.js`
- Create: `.opencode/INSTALL.md`
- Create: `hooks/session-start`
- Create: `hooks/run-hook.cmd`
- Create: `hooks/hooks.json`
- Create: `hooks/hooks-cursor.json`

- [ ] **Step 1: Create .opencode/plugins/gangsta.js**

```javascript
import { readFileSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, "../..");
const SKILLS_DIR = join(ROOT, "skills");

function readBootstrap() {
  const raw = readFileSync(join(SKILLS_DIR, "the-don/SKILL.md"), "utf-8");
  const body = raw.replace(/^---[\s\S]*?---\n/, "");
  return [
    "<EXTREMELY_IMPORTANT>",
    body,
    "",
    "**Tool Mapping for OpenCode:**",
    "When skills reference tools you don't have, substitute OpenCode equivalents:",
    "- `TodoWrite` → `todowrite`",
    "- `Task` tool with subagents → Use OpenCode's subagent system",
    "- `Skill` tool → OpenCode's native `skill` tool",
    "- `Read`, `Write`, `Edit`, `Bash` → Your native tools",
    "",
    "Use OpenCode's native `skill` tool to list and load skills.",
    "</EXTREMELY_IMPORTANT>",
  ].join("\n");
}

export default {
  name: "gangsta",
  version: "1.0.0",

  config(cfg) {
    cfg.skills = cfg.skills || {};
    cfg.skills.paths = cfg.skills.paths || [];
    cfg.skills.paths.push(SKILLS_DIR);
    return cfg;
  },

  "experimental.chat.messages.transform"(messages) {
    if (!messages.length) return messages;
    const bootstrap = readBootstrap();
    const first = messages[0];
    if (Array.isArray(first.content)) {
      first.content.unshift({ type: "text", text: bootstrap });
    }
    return messages;
  },
};
```

- [ ] **Step 2: Create .opencode/INSTALL.md**

```markdown
# Installing Gangsta for OpenCode

## Quick Install

Add to your `opencode.json` configuration:

```json
{
  "plugin": ["gangsta@git+https://github.com/kucherenko/gangsta.git"]
}
```

Restart OpenCode. The Gangsta framework will bootstrap automatically on session start.

## Verify Installation

Start a new OpenCode session and say:
> "I want to build a new feature"

The agent should respond by invoking the `gangsta:reconnaissance` skill to begin a Heist.

## Manual Install (Alternative)

1. Clone the repository:
```bash
git clone https://github.com/kucherenko/gangsta.git ~/.gangsta
```

2. Add to `opencode.json`:
```json
{
  "plugin": ["gangsta@file:///path/to/.gangsta"]
}
```
```

- [ ] **Step 3: Create hooks/session-start (executable shell script)**

```bash
#!/usr/bin/env bash
set -euo pipefail

# Gangsta session-start hook
# Reads the-don skill and injects it as bootstrap context

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILL_FILE="$ROOT_DIR/skills/the-don/SKILL.md"

if [ ! -f "$SKILL_FILE" ]; then
  echo '{}' 
  exit 0
fi

# Read skill content, strip YAML frontmatter
CONTENT=$(sed '1{/^---$/,/^---$/d}' "$SKILL_FILE")

# Wrap in importance tags
BOOTSTRAP="<EXTREMELY_IMPORTANT>
${CONTENT}

**Tool Mapping:**
When skills reference tools you don't have, substitute your platform's equivalents:
- TodoWrite / todowrite → your task tracking tool
- Task / task → your subagent dispatch tool
- Skill / skill → your skill loading tool
- Read, Write, Edit, Bash → your native tools
</EXTREMELY_IMPORTANT>"

# Escape for JSON
ESCAPED=$(printf '%s' "$BOOTSTRAP" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read()))')

# Detect platform and output in correct format
if [ -n "${CLAUDE_PLUGIN_ROOT:-}" ]; then
  # Claude Code
  printf '{"hookSpecificOutput":{"additionalContext":%s}}' "$ESCAPED"
elif [ -n "${CURSOR_PLUGIN_ROOT:-}" ]; then
  # Cursor
  printf '{"additional_context":%s}' "$ESCAPED"
elif [ -n "${COPILOT_CLI:-}" ]; then
  # GitHub Copilot CLI
  printf '{"additionalContext":%s}' "$ESCAPED"
else
  # Generic fallback
  printf '{"additionalContext":%s}' "$ESCAPED"
fi
```

- [ ] **Step 4: Create hooks/run-hook.cmd**

```cmd
: << 'BATCH_SCRIPT'
@echo off
setlocal enabledelayedexpansion

REM Gangsta cross-platform hook wrapper (bash/batch polyglot)
REM On Windows, finds bash and dispatches to the named hook script

set "HOOK_NAME=%~1"
set "HOOK_DIR=%~dp0"

REM Try Git for Windows bash
where bash >nul 2>&1 && (
    bash "%HOOK_DIR%%HOOK_NAME%" %*
    exit /b %ERRORLEVEL%
)

REM Try common locations
for %%B in (
    "C:\Program Files\Git\bin\bash.exe"
    "C:\Program Files (x86)\Git\bin\bash.exe"
    "%LOCALAPPDATA%\Programs\Git\bin\bash.exe"
) do (
    if exist %%B (
        %%B "%HOOK_DIR%%HOOK_NAME%" %*
        exit /b %ERRORLEVEL%
    )
)

echo ERROR: bash not found. Install Git for Windows.
exit /b 1
BATCH_SCRIPT

# Unix: dispatch to the named hook
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOOK_NAME="$1"
shift
exec "$SCRIPT_DIR/$HOOK_NAME" "$@"
```

- [ ] **Step 5: Create hooks/hooks.json (Claude Code)**

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd\" session-start",
            "async": false
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 6: Create hooks/hooks-cursor.json (Cursor)**

```json
{
  "version": 1,
  "hooks": {
    "sessionStart": [
      {
        "command": "./hooks/session-start"
      }
    ]
  }
}
```

- [ ] **Step 7: Make hooks executable and commit**

```bash
chmod +x hooks/session-start hooks/run-hook.cmd
git add .opencode/ hooks/
git commit -m "feat: add OpenCode plugin and cross-platform bootstrap hooks"
```

---

## Task 16: Remaining Platform Manifests

**Files:**
- Create: `.claude-plugin/plugin.json`
- Create: `.claude-plugin/marketplace.json`
- Create: `.cursor-plugin/plugin.json`
- Create: `.codex/INSTALL.md`
- Create: `gemini-extension.json`
- Create: `GEMINI.md`

- [ ] **Step 1: Create .claude-plugin/plugin.json**

```json
{
  "name": "gangsta",
  "description": "AI agentic skills framework for spec-driven development — mafia-syndicate hierarchy with adversarial brainstorming, institutional memory, and governance guardrails",
  "version": "1.0.0",
  "author": {
    "name": "Gangsta Contributors"
  },
  "repository": "https://github.com/kucherenko/gangsta",
  "license": "MIT",
  "keywords": [
    "skills",
    "spec-driven-development",
    "adversarial-brainstorming",
    "multi-agent",
    "governance",
    "tdd"
  ]
}
```

- [ ] **Step 2: Create .claude-plugin/marketplace.json**

```json
{
  "name": "gangsta-dev",
  "description": "Development marketplace for Gangsta framework",
  "owner": {
    "name": "Gangsta Contributors"
  },
  "plugins": [
    {
      "name": "gangsta",
      "version": "1.0.0",
      "source": "./"
    }
  ]
}
```

- [ ] **Step 3: Create .cursor-plugin/plugin.json**

```json
{
  "name": "gangsta",
  "displayName": "Gangsta",
  "skills": "./skills/",
  "agents": "./agents/",
  "hooks": "./hooks/hooks-cursor.json"
}
```

- [ ] **Step 4: Create .codex/INSTALL.md**

```markdown
# Installing Gangsta for Codex

## Install

1. Clone the repository:
```bash
git clone https://github.com/kucherenko/gangsta.git ~/.gangsta
```

2. Create a symlink so Codex discovers the skills:
```bash
mkdir -p ~/.agents/skills
ln -sf ~/.gangsta/skills ~/.agents/skills/gangsta
```

3. Restart Codex. Skills will be discovered automatically from SKILL.md frontmatter.

## Verify

Start a new Codex session and say:
> "I want to build a new feature"

The agent should invoke gangsta skills automatically.

## Update

```bash
cd ~/.gangsta && git pull
```
```

- [ ] **Step 5: Create gemini-extension.json**

```json
{
  "name": "gangsta",
  "version": "1.0.0",
  "contextFileName": "GEMINI.md"
}
```

- [ ] **Step 6: Create GEMINI.md**

```markdown
@./skills/the-don/SKILL.md
```

- [ ] **Step 7: Commit**

```bash
git add .claude-plugin/ .cursor-plugin/ .codex/ gemini-extension.json GEMINI.md
git commit -m "feat: add platform manifests for Claude Code, Cursor, Codex, and Gemini"
```

---

## Task 17: AGENTS.md and README.md

**Files:**
- Create: `AGENTS.md`
- Create: `README.md`

- [ ] **Step 1: Create AGENTS.md**

```markdown
# Contributing to Gangsta

## What This Is

Gangsta is an AI agentic skills framework for spec-driven development. Skills are behavior-shaping code, not documentation. They must be tested rigorously.

## What Will NOT Be Accepted

- Third-party dependencies (this is a zero-dependency package)
- Changes that weaken Omerta governance rules
- Skills without adversarial pressure testing
- Bulk PRs with unrelated changes bundled together
- "Improvements" that add complexity without clear value
- Narrative storytelling in skill content (skills are instructions, not blog posts)

## Skill Changes

Every skill change requires:
1. Baseline testing: Run a pressure scenario WITHOUT the change, document behavior
2. Change testing: Run the same scenario WITH the change, document improvement
3. Include both results in your PR

## The Laws Apply to Contributors Too

- Omerta Law 3 (Rule of Truth): Every claim in a PR must be verifiable
- Omerta Law 5 (Spec is Law): Changes must align with the framework design spec
```

- [ ] **Step 2: Create README.md**

```markdown
# Gangsta

An AI agentic skills framework for spec-driven development, built on the organizational model of La Cosa Nostra.

## Philosophy

Gangsta replaces open-ended Agile iteration with a directive, vertical hierarchy. A small team of highly specialized agents — each operating with autonomy within their Position — outperforms a large pool of general-purpose agents.

**The Spec is Law.** Code is an implementation detail validated against the specification. No shadow hotfixes.

**The Informed Minority.** Clear roles, clear hierarchy, clear accountability.

## How It Works

When you start a session, the framework bootstraps The Don — an orchestrator that analyzes your intent and routes to the appropriate skill. When you want to build something, it initiates a **Heist**: a 6-phase operational cycle.

### The Heist Pipeline

1. **Reconnaissance** — Intel gathering on codebase and requirements
2. **The Grilling** — Adversarial brainstorming via Multi-Agent Debate (Proposer vs Devils-Advocate, with you weighing in each round)
3. **The Sit-Down** — Formal spec drafting. No code allowed.
4. **Resource Development** — Task decomposition into Work Packages
5. **The Hit** — Parallel execution by Soldier subagents with TDD enforcement
6. **Laundering** — Verification, integration, and Ledger update

Every phase gate requires your approval. You are the Don.

### The Borgata Hierarchy

| Role | Function |
|------|----------|
| **Don** (You) | Supreme authority. Approves all phase gates. |
| **Consigliere** | Impartial advisor. Security and architecture auditor. |
| **Underboss** | COO. Task decomposition, resource allocation. |
| **Capo** | Domain crew lead. Manages Soldiers per territory. |
| **Soldier** | Stateless code executor. TDD enforced. |
| **Associate** | External tool/API proxy. |

### The Family Ledger

The Borgata maintains institutional memory:
- **Insights** — Successful reasoning pathways and creative solutions
- **Fails** — Documented failures with cognitive diagnoses and negative constraints
- **Constitution** — Accumulated commandments and prohibitions

### Omerta: Governance

Five non-negotiable laws govern all operations:
1. **Introduction Rule** — No agent-to-agent communication without hierarchy mediation
2. **Rule of Availability** — All state checkpointed to files
3. **Rule of Truth** — Every claim cites its source. No stronzate.
4. **Rule of Tribute** — Resource budgets tracked and enforced
5. **Spec is Law** — Code contradicts spec → spec is revised first

## Installation

### OpenCode

Add to your `opencode.json`:
```json
{
  "plugin": ["gangsta@git+https://github.com/kucherenko/gangsta.git"]
}
```

### Claude Code

```
/plugin marketplace add kucherenko/gangsta-marketplace
/plugin install gangsta@gangsta-marketplace
```

### Cursor

```
/add-plugin gangsta
```

### Codex

```bash
git clone https://github.com/kucherenko/gangsta.git ~/.gangsta
ln -sf ~/.gangsta/skills ~/.agents/skills/gangsta
```

### Gemini CLI

```bash
gemini extensions install https://github.com/kucherenko/gangsta
```

## Verify Installation

Start a new session and say:
> "I want to build a new feature"

The agent should invoke Gangsta skills automatically, starting with Reconnaissance.

## License

MIT
```

- [ ] **Step 3: Commit**

```bash
git add AGENTS.md README.md
git commit -m "feat: add README and contributor guidelines"
```

---

## Task 18: Final Verification

- [ ] **Step 1: Verify all files exist**

```bash
find . -name '*.md' -o -name '*.json' -o -name '*.js' -o -name '*.cmd' | sort
```

Expected output should include all 35+ files from the file map.

- [ ] **Step 2: Verify package.json is valid**

```bash
node -e "console.log(JSON.parse(require('fs').readFileSync('package.json','utf8')).name)"
```

Expected: `gangsta`

- [ ] **Step 3: Verify OpenCode plugin loads**

```bash
node -e "import('./.opencode/plugins/gangsta.js').then(m => console.log(m.default.name))"
```

Expected: `gangsta`

- [ ] **Step 4: Verify session-start hook runs**

```bash
bash hooks/session-start | head -c 100
```

Expected: JSON output starting with `{"additionalContext":...`

- [ ] **Step 5: Verify all SKILL.md files have valid frontmatter**

```bash
for f in skills/*/SKILL.md; do
  name=$(head -5 "$f" | grep "^name:" | cut -d' ' -f2-)
  desc=$(head -5 "$f" | grep "^description:" | cut -c14- | head -c 50)
  echo "$name — $desc..."
done
```

Expected: 12 skills listed with names and description prefixes.

- [ ] **Step 6: Final commit if any uncommitted changes remain**

```bash
git status
# If clean: done
# If dirty: git add -A && git commit -m "chore: final cleanup"
```

---

## Plan Self-Review

### Spec Coverage Check

| Spec Section | Implementing Task(s) |
|-------------|---------------------|
| Package Structure | Task 1 (scaffold), Task 15-16 (platform), Task 17 (README/AGENTS) |
| The Don (bootstrap) | Task 3 |
| The Consigliere | Task 5 |
| The Underboss | Task 6 |
| The Capo | Task 7 |
| Soldiers | Task 14 (agents/soldier.md) |
| Associates | Task 14 (agents/associate.md) |
| Omerta governance | Task 2 |
| The Ledger | Task 4 |
| Phase 1: Reconnaissance | Task 8 |
| Phase 2: The Grilling (with round limits) | Task 9 |
| Phase 3: The Sit-Down | Task 10 |
| Phase 4: Resource Development | Task 11 |
| Phase 5: The Hit | Task 12 |
| Phase 6: Laundering | Task 13 |
| OpenCode plugin | Task 15 |
| Claude Code plugin | Task 16 |
| Cursor plugin | Task 16 |
| Codex install | Task 16 |
| Gemini extension | Task 16 |
| Bootstrap hooks | Task 15 |
| Cross-platform hook wrapper | Task 15 |
| Skill frontmatter format | All skill tasks |
| Cross-referencing (gangsta: namespace) | All skill tasks |
| Checkpoint format (Omerta Law 2) | Tasks 2, 6, 8-13 |
| Insight/Fail document format | Task 4 |
| Constitution format | Task 4 |
| Named agents (5) | Task 14 |
| Grilling subagent prompts | Task 9 |

**No gaps found.** All spec sections have corresponding tasks.

### Placeholder Scan

No TBD, TODO, or "fill in details" patterns found. All code blocks contain complete content.

### Type/Name Consistency

- `gangsta:` namespace used consistently across all skill cross-references
- Checkpoint YAML frontmatter format is identical across all phase skills
- Omerta Compliance checklist format is consistent across all skills
- Tribute format referenced in the-capo, the-hit, and soldier.md is identical
- Work Package format referenced in the-underboss, resource-development, the-hit, and the-capo is consistent
