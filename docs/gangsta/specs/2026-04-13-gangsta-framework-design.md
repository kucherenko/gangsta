# Gangsta: AI Agentic Skills Framework for Spec-Driven Development

## Overview

Gangsta is a zero-dependency agentic skills framework that implements a mafia-syndicate organizational model for spec-driven development (SDD). It replaces Agile's flat consensus with a directive, vertical hierarchy and replaces sprints with "Heists" — finite, high-intensity operational cycles that move a specification from intent to "made" code.

The framework is built on two core principles:

1. **The Centrality of the Specification:** The spec is absolute law. Code is an implementation detail validated against it. No shadow code hotfixes — if code is wrong, the spec is revised first.

2. **The Informed Minority Principle:** A small team of highly specialized agents with clear roles outperforms a large pool of general-purpose agents. Each agent operates with "autonomy within their Position."

Gangsta ships as a multi-platform plugin installable on OpenCode, Claude Code, Cursor, Codex, Gemini CLI, and GitHub Copilot CLI. It is tested primarily on OpenCode.

---

## Architecture

### Package Structure

```
gangsta/
├── package.json                    # name: "gangsta", type: "module", zero deps
├── README.md                       # Overview, install, philosophy
├── LICENSE                         # MIT
├── AGENTS.md                       # Contributor guidelines
│
├── .opencode/                      # OpenCode platform support
│   ├── INSTALL.md
│   └── plugins/
│       └── gangsta.js              # OpenCode plugin entry point
│
├── .claude-plugin/                 # Claude Code platform support
│   ├── plugin.json
│   └── marketplace.json
│
├── .cursor-plugin/                 # Cursor platform support
│   └── plugin.json
│
├── .codex/                         # Codex platform support
│   └── INSTALL.md
│
├── gemini-extension.json           # Gemini CLI extension
├── GEMINI.md                       # Gemini bootstrap (@references)
│
├── hooks/                          # Lifecycle hooks (bootstrap injection)
│   ├── hooks.json                  # Claude Code hooks config
│   ├── hooks-cursor.json           # Cursor hooks config
│   ├── run-hook.cmd                # Cross-platform hook wrapper (bash/batch polyglot)
│   └── session-start               # Bootstrap: injects the-don skill
│
├── skills/                         # The Borgata: role and phase skills
│   ├── the-don/                    # Principal orchestrator (bootstrap skill)
│   │   └── SKILL.md
│   ├── the-consigliere/            # Architectural advisor & ethical auditor
│   │   └── SKILL.md
│   ├── the-underboss/              # Task middleware & resource manager
│   │   └── SKILL.md
│   ├── the-capo/                   # Domain crew lead template
│   │   └── SKILL.md
│   ├── the-grilling/               # Phase 2: Adversarial brainstorming (MAD)
│   │   ├── SKILL.md
│   │   ├── devils-advocate-prompt.md
│   │   ├── proposer-prompt.md
│   │   └── synthesizer-prompt.md
│   ├── reconnaissance/             # Phase 1: Intel & environment mapping
│   │   └── SKILL.md
│   ├── the-sit-down/               # Phase 3: Planning & spec drafting
│   │   └── SKILL.md
│   ├── resource-development/       # Phase 4: Infrastructure & tooling
│   │   └── SKILL.md
│   ├── the-hit/                    # Phase 5: Parallel execution
│   │   └── SKILL.md
│   ├── laundering/                 # Phase 6: Verification & integration
│   │   └── SKILL.md
│   ├── the-ledger/                 # Insights & fails management
│   │   └── SKILL.md
│   └── omerta/                     # Governance & guardrails
│       └── SKILL.md
│
├── agents/                         # Named agent definitions (subagents)
│   ├── soldier.md                  # Stateless code execution unit
│   ├── devils-advocate.md          # Grilling: consensus-breaker
│   ├── proposer.md                 # Grilling: solution proposer
│   ├── synthesizer.md              # Grilling: debate synthesizer
│   └── associate.md                # External tool/API proxy
│
└── docs/                           # Template for project-local docs
    └── gangsta/
        ├── specs/                  # Design specs & contracts
        ├── insights/               # Repository of Insights
        └── fails/                  # Repository of Fails
```

### Design Decisions

- **Zero dependencies, no build step.** Pure static content: Markdown, shell scripts, one small JS plugin.
- **ESM-only.** `"type": "module"` in package.json.
- **`the-don` is the bootstrap skill.** Injected on every session start via platform hooks. Equivalent to superpowers' `using-superpowers` but implements the Borgata hierarchy.
- **Skills = behavior-shaping prompts in the main thread.** Don, Consigliere, Underboss, Capo, Omerta, Ledger, and all Heist phases.
- **Agents = dispatched subagents.** Soldier, Devils-Advocate, Proposer, Synthesizer, Associate.
- **The Ledger lives in the target project** (`docs/gangsta/`), not in the gangsta package.

---

## The Borgata: Agent Roles and Hierarchy

### Role Interaction Model

```
User (IS the Don — supreme authority)
    │
    ├── Consigliere (skill) ── Advises on architecture, security, spec integrity
    │                          Operates outside the chain of command
    │                          Has veto power on security concerns
    │
    ├── Underboss (skill) ── Decomposes tasks, allocates to Capos
    │   │                    Manages token budgets (Rule of Tribute)
    │   │                    Tracks Heist phase progression
    │   │
    │   ├── Capo (skill template) ── Domain-specific orchestrator
    │   │   │                        Applied per territory (frontend, backend, DB, etc.)
    │   │   │
    │   │   ├── Soldier (subagent) ── Stateless code generation & testing
    │   │   ├── Soldier (subagent) ── Stateless implementation
    │   │   └── ...
    │   │
    │   └── Associate (subagent) ── External API/tool proxy
    │
    └── The Ledger (skill) ── Reads/writes insights and fails
```

### The Don: Principal State Orchestrator

**Type:** Skill (bootstrap, injected on session start)

The Don is the main agent's operating mode. It does NOT write code or perform research. It provides:

1. **Skill invocation mandate** — Before any action, check if a gangsta skill applies.
2. **Phase gate enforcement** — User must approve transitions between Heist phases.
3. **Hierarchy routing** — Decides when to invoke Consigliere, Underboss, or Heist phases.
4. **Introduction Rule enforcement** — No agent-to-agent communication without Don or Underboss mediation.

On session start, the Don analyzes the user's intent:
- Creative/building intent → Invoke reconnaissance skill (begin Heist)
- Bug/issue → Invoke the-consigliere for diagnosis
- Existing heist in progress → Resume from last phase checkpoint
- Simple question → Answer directly (no heist needed)

### The Consigliere: Architectural Advisor and Ethical Auditor

**Type:** Skill (invoked by the Don for strategic decisions)

The Consigliere occupies a position outside the direct chain of command. When invoked:
- Reviews the current spec/plan with a critical eye
- Flags security concerns the Underboss might overlook
- Provides the Don (user) with an impartial second opinion
- Does NOT execute tasks or write code
- Has standing authority to invoke Truth checks (Omerta Law 3) at any point

### The Underboss: Task Middleware and Resource Manager

**Type:** Skill (primary engine of task decomposition)

The Underboss acts as COO of the Borgata:
- Manages day-to-day work as a buffer for the Don
- Decomposes the Contract into Work Packages
- Allocates territories to Capos with token budgets
- Tracks Heist phase progression and status rollups
- Deploys Associates for reconnaissance and specialized tasks

### Caporegimes: Territory Commanders (Crew Leads)

**Type:** Skill template (instantiated per domain)

Each Capo is responsible for a specific "territory" — a microservice, a frontend library, a database layer, etc. The Underboss creates domain-specific Capo contexts:

```markdown
## Territory: Frontend (React)
Files: src/components/**, src/hooks/**, src/pages/**
Conventions: [project-specific patterns from Constitution]
Soldiers allocated: 2 parallel
Token budget: [allocated by Underboss]
```

The Capo orchestrates Soldiers for their domain, reviews Tributes against the Contract, and reports progress to the Underboss.

### Soldiers: Stateless Execution Units

**Type:** Named agent (dispatched as subagent)

Soldiers are stateless units optimized for code generation and unit testing. They:
- Receive a single Work Package + relevant Contract section
- Write failing test first (TDD enforced)
- Implement minimal code to pass the test
- Return a Tribute (status + code changes + test results)
- Cannot communicate with other Soldiers directly (Introduction Rule)

### Associates: Specialized Tools and API Proxies

**Type:** Named agent (dispatched as subagent)

Associates are not "family members" but provide essential access:
- External API integrations
- Codebase scanning and analysis
- Dependency audits
- Documentation retrieval
- Specialized sub-agent capabilities

---

## The Digital Heist: Operational Pipeline

The Heist is a finite, 6-phase operational cycle. Each phase has defined actors, outputs, and a gate requiring Don (user) approval before proceeding.

### Phase 1: Reconnaissance (Intel & Environment Mapping)

**Skill:** `gangsta:reconnaissance`
**Actor:** Underboss dispatches Associates

1. Underboss analyzes the user's intent statement
2. Dispatches Associate subagents in parallel to survey:
   - Codebase structure (file tree, key patterns, frameworks)
   - Existing tests and coverage
   - Dependencies and versions
   - Existing specs/docs
   - The Ledger (relevant past insights and fails)
3. Associates return structured "intel reports"
4. Underboss synthesizes into a **Reconnaissance Dossier**

**Output:** Reconnaissance Dossier saved to `docs/gangsta/specs/<heist-name>/recon-dossier.md`

**Gate:** Don reviews dossier. Approves or requests more intel.

### Phase 2: The Grilling (Adversarial Brainstorming / Multi-Agent Debate)

**Skill:** `gangsta:the-grilling`
**Actors:** Proposer, Devils-Advocate, Synthesizer (subagents), User (Don)

The Grilling is a structured Multi-Agent Debate (MAD) protocol with hard limits to prevent infinite loops:

**Round Limits:**
- **Minimum:** 2 rounds (No Premature Consensus rule — 1-round agreement is suspicious)
- **Default maximum:** 5 rounds
- **Hard ceiling:** 7 rounds (the Don can extend from 5 to 7 if debate is productive)
- **Early exit:** The Don can declare consensus at any point after round 2

If the hard ceiling is reached without Nash Equilibrium, the Synthesizer produces a **"Best Available Consensus"** — documenting the final proposal, any unresolved objections, and their assessed risk. The Don then decides whether to accept, reject, or table the proposal.

```
Round 1:
  Proposer ─── Proposes architectural solution based on Recon dossier
  Devils-Advocate ─── Attacks the proposal (flaws, regressions, security gaps)
  User (Don) ─── Asked for opinion and concerns
  Synthesizer ─── Incorporates valid attacks, defends valid elements, revises

Round 2..N (max 5, extendable to 7):
  Devils-Advocate ─── Attacks the revised solution
  User ─── Asked for opinion again
  Synthesizer ─── Revises

  Terminates when ANY of:
    a) Nash Equilibrium: no agent can raise a NEW valid objection AND user has no concerns
    b) Don declares consensus (after round 2+)
    c) Round limit reached → Synthesizer produces Best Available Consensus
```

**Rules of the Grilling:**
- **The Devils Advocate:** At least one agent acts as consensus-breaker whose sole purpose is finding flaws.
- **Nash Equilibrium Consensus:** Debate does not end until no agent can raise a new valid objection — but is bounded by round limits.
- **Inverse Reasoning:** Agents must enumerate potential "harms" (regressions, security gaps) and analyze consequences before proposing a final path.
- **No Premature Consensus:** If only 1 round occurs, the skill flags this as suspicious and forces another challenge.
- **Repetition Detection:** If the Devils-Advocate repeats a previously-addressed objection, it counts as a no-new-attack round and accelerates toward Nash Equilibrium.
- **User Veto:** The Don can kill any proposal at any point.
- **Stronzate Detection:** If attacks are weak/repetitive, the Synthesizer flags it.

**Output:** Grilling Transcript with final consensus, saved to `docs/gangsta/specs/<heist-name>/grilling-transcript.md`

**Gate:** Don approves the consensus solution.

### Phase 3: The Sit-Down (Planning & Spec Drafting)

**Skill:** `gangsta:the-sit-down`
**Actors:** Don (approval), Consigliere (review), Underboss (drafting)

1. Underboss drafts the **Contract** (formal specification) based on:
   - Reconnaissance Dossier
   - Grilling consensus
   - Project Constitution (if it exists)
   - Relevant Ledger entries
2. Consigliere reviews the Contract for:
   - Spec integrity (no contradictions, no ambiguity)
   - Security audit (no exposed secrets, no unsafe patterns)
   - Architectural consistency with existing codebase
3. Don reviews and signs off

**CODE GENERATION IS STRICTLY PROHIBITED DURING THIS PHASE.**

**Output:** The Contract saved to `docs/gangsta/specs/<heist-name>/contract.md`

**Gate:** Don signs the Contract.

### Phase 4: Resource Development (Infrastructure & Tooling)

**Skill:** `gangsta:resource-development`
**Actor:** Underboss

1. Decomposes the Contract into **Work Packages** — bite-sized tasks (2-5 minutes each) assigned to territories
2. Sets up isolation: git worktrees or branches for parallel execution
3. Verifies prerequisites: tests pass on clean baseline, dependencies available
4. Allocates resources: Soldier count per Capo, token budgets

**Output:** War Plan saved to `docs/gangsta/specs/<heist-name>/war-plan.md`

Each Work Package contains:
- Territory assignment (which Capo)
- File paths affected
- Acceptance criteria (from the Contract)
- Verification command
- Token budget estimate

**Gate:** Don approves the War Plan.

### Phase 5: The Hit (Execution & Parallel Coding)

**Skill:** `gangsta:the-hit`
**Actors:** Capos (skills), Soldiers (subagents)

1. Each Capo receives their Work Packages
2. Capo dispatches Soldiers in parallel within territory
3. Each Soldier:
   - Receives single Work Package + relevant Contract section
   - Writes failing test first (TDD enforced)
   - Implements minimal code to pass the test
   - Returns a **Tribute** (status: success/failure + code changes + test results)
4. Capo reviews each Tribute against the Contract
5. Regular status rollup: Soldier → Capo → Underboss → Don

**Parallel execution model:**
- Soldiers within a territory work on independent Work Packages simultaneously
- Different territories (Capos) execute in parallel
- If a Soldier fails, the Capo can retry or escalate to the Underboss
- Escalation may trigger a **mini-Grilling** to revise the Contract. A mini-Grilling is a single-round, scoped version of The Grilling: Devils-Advocate attacks the proposed fix, User weighs in, Synthesizer produces a revised Contract clause. No multi-round loop required.

**Gate:** All Capos report territory completion. Don approves to proceed.

### Phase 6: Laundering (Verification & Integration)

**Skill:** `gangsta:laundering`
**Actors:** Underboss, Consigliere (review), Associates (tools)

1. **Integration:** Merge all territory branches/worktrees
2. **Verification:** Run full test suite, linting, type checking
3. **Consigliere Final Review:** Architectural audit of integrated code
4. **Laundering:** Automated refactoring and linting cleanup
5. **Evidence Disposal:** Remove temporary files, internal run logs, intermediate artifacts
6. **Ledger Update:**
   - New insights → `docs/gangsta/insights/YYYY-MM-DD-<topic>.md`
   - New fails → `docs/gangsta/fails/YYYY-MM-DD-<topic>.md`
   - New commandments/constraints → `docs/gangsta/constitution.md`
7. **Don Approval:** User reviews the final result

**Output:** Clean, "made" code. Updated Ledger and Constitution.

**Gate:** Don declares the Heist complete.

---

## The Family Ledger: Persistent Institutional Memory

### Directory Structure (in target project)

```
docs/gangsta/
├── constitution.md                     # Project Constitution (living document)
├── insights/                           # Repository of Insights (Good Catches)
│   ├── YYYY-MM-DD-<topic>.md
│   └── ...
└── fails/                              # Repository of Fails (Concrete Shoes)
    ├── YYYY-MM-DD-<topic>.md
    └── ...
```

### Insight Document Format

```yaml
---
date: YYYY-MM-DD
heist: <heist-name>
phase: <phase-where-discovered>
tags: [tag1, tag2, tag3]
---
```

Body contains:
- **Discovery:** How the insight was found
- **Solution:** The successful reasoning pathway or creative solution
- **Project Commandment:** If applicable, a new rule for the Constitution

Criteria: Any solution that bypasses a complex constraint or establishes a new Project Commandment is recorded. Future heists retrieve relevant insights via tag/content similarity.

### Fail Document Format

```yaml
---
date: YYYY-MM-DD
heist: <heist-name>
phase: <phase-where-occurred>
tags: [tag1, tag2, tag3]
severity: critical | high | medium | low
---
```

Body contains:
- **What Happened:** Description of the failure
- **Cognitive Diagnosis:** Causal mechanism explaining WHY the failure occurred
- **Negative Constraint:** The explicit prohibition generated for the Constitution

### Project Constitution

A living document that accumulates over time:

```markdown
# Project Constitution

## Commandments (from Insights)
1. [Commandment text] — Source: insights/YYYY-MM-DD-<topic>.md
...

## Negative Constraints (from Fails)
1. NEVER [prohibited pattern] — Source: fails/YYYY-MM-DD-<topic>.md
...

## Architectural Decisions
- [Decision and rationale]
...
```

### Ledger Usage Across Phases

| Phase | Ledger Operation |
|-------|-----------------|
| Reconnaissance | Associates search for entries related to current heist |
| The Grilling | Devils-Advocate checks proposals against Negative Constraints |
| The Sit-Down | Underboss references Commandments when drafting Contract |
| The Hit | Soldiers check Negative Constraints before implementation |
| Laundering | New insights and fails are written; Constitution updated |

---

## Omerta: Governance and Guardrails

The Laws of the Borgata — a cross-cutting concern referenced by every skill.

### Law 1: The Introduction Rule (Authorization Protocol)

No agent-to-agent interaction without mediation by the Underboss or Don. Soldiers cannot communicate directly — all messages pass through Capo → Underboss. Prevents "shadow coordination" and context drift.

### Law 2: The Rule of Availability (State Durability)

All Heist state must be checkpointed to files. If a session is interrupted:
- Current phase, inputs, and outputs are recoverable
- State files: `docs/gangsta/specs/<heist-name>/checkpoint-<phase>.md`
- YAML frontmatter with phase, status, timestamp, and resume instructions

### Law 3: The Rule of Truth (Anti-Hallucination)

Every claim must cite its source:
- Code claims → `file:line`
- Spec claims → Contract section reference
- Architectural claims → Constitution entry
- Uncited claims ("stronzate") are flagged immediately
- Consigliere has standing authority to invoke Truth checks at any point

### Law 4: The Rule of Tribute (Resource Management)

- Each Capo operates within an allocated token budget
- Soldiers report resource consumption in Tributes
- Budget overruns require Underboss approval
- All "profits" (merged code, passing tests) are reported up the hierarchy

### Law 5: The Spec is Law

- If code contradicts the spec, the spec is revised first
- No shadow code hotfixes — every change traces to a Contract clause
- Bugs during The Hit trigger escalation: Soldier → Capo → Underboss → mini-Grilling → Contract revision

### Enforcement Model

Omerta is not a phase — it is a cross-cutting concern. Each skill includes an Omerta compliance checklist:

```markdown
## Omerta Compliance
- [ ] Introduction Rule: All agent interactions mediated by hierarchy
- [ ] Rule of Truth: All claims cite source
- [ ] Rule of Tribute: Resource consumption within budget
- [ ] Spec is Law: All changes trace to Contract clause
```

---

## Platform Integration

### Bootstrap Flow

```
Session Start → Platform Hook fires → session-start script reads the-don/SKILL.md
    → Strips YAML frontmatter → Wraps in <EXTREMELY_IMPORTANT> tags
    → Adds platform-specific tool mapping
    → Injects into conversation context
```

### Per-Platform Implementation

| Platform | Plugin Entry | Bootstrap Mechanism | Install Method |
|----------|-------------|---------------------|----------------|
| OpenCode | `.opencode/plugins/gangsta.js` | `config` hook + `chat.messages.transform` | `opencode.json` plugin config |
| Claude Code | `.claude-plugin/plugin.json` | `SessionStart` hook → `session-start` script | `/plugin install` |
| Cursor | `.cursor-plugin/plugin.json` | `sessionStart` hook → `session-start` script | `/add-plugin` |
| Codex | Manual symlink | Native skill discovery at startup | `git clone` + symlink |
| Gemini CLI | `gemini-extension.json` | `GEMINI.md` with `@` references | `gemini extensions install` |
| Copilot CLI | Plugin marketplace | Hook injection | `copilot plugin install` |

### OpenCode Plugin (Primary)

```javascript
// .opencode/plugins/gangsta.js
import { readFileSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, "../..");
const SKILLS_DIR = join(ROOT, "skills");

function readBootstrap() {
  const content = readFileSync(join(SKILLS_DIR, "the-don/SKILL.md"), "utf-8");
  const body = content.replace(/^---[\s\S]*?---\n/, "");
  return `<EXTREMELY_IMPORTANT>\n${body}\n</EXTREMELY_IMPORTANT>`;
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

### Skill Frontmatter Spec

All skills use YAML frontmatter compatible with agentskills.io:

```yaml
---
name: skill-name-with-hyphens
description: Use when [triggering conditions]. Max 500 chars. Third person.
---
```

### Cross-Referencing

Skills reference each other using namespaced colon syntax:
- `gangsta:the-grilling` — invoke this skill
- `gangsta:omerta` — enforce these rules

No `@` file references (avoids force-loading and context bloat).

### Session-Start Script

Shell script that:
1. Detects platform via environment variables (`CLAUDE_PLUGIN_ROOT`, `CURSOR_PLUGIN_ROOT`, `COPILOT_CLI`)
2. Reads `skills/the-don/SKILL.md`
3. Strips YAML frontmatter
4. Wraps body in `<EXTREMELY_IMPORTANT>` tags
5. Appends tool mapping notes for the detected platform
6. Outputs JSON in the platform's expected format:
   - Claude Code: `{ "hookSpecificOutput": { "additionalContext": "..." } }`
   - Cursor: `{ "additional_context": "..." }`
   - Copilot CLI: `{ "additionalContext": "..." }`

---

## Skill Summary Table

### Hierarchy Skills (Main Thread)

| Skill | Name | Trigger |
|-------|------|---------|
| `the-don` | The Don | Session start (bootstrap) |
| `the-consigliere` | The Consigliere | Strategic decisions, security review |
| `the-underboss` | The Underboss | Task decomposition, resource allocation |
| `the-capo` | The Capo | Domain-specific crew orchestration |
| `omerta` | Omerta | Cross-cutting governance (always active) |
| `the-ledger` | The Ledger | Read/write insights and fails |

### Heist Phase Skills (Main Thread)

| Skill | Phase | Trigger |
|-------|-------|---------|
| `reconnaissance` | 1 | Building intent detected |
| `the-grilling` | 2 | After Recon dossier approved |
| `the-sit-down` | 3 | After Grilling consensus approved |
| `resource-development` | 4 | After Contract signed |
| `the-hit` | 5 | After War Plan approved |
| `laundering` | 6 | After all territories complete |

### Named Agents (Subagents)

| Agent | Role | Dispatched By |
|-------|------|--------------|
| `soldier` | Stateless code execution | Capo |
| `devils-advocate` | Consensus-breaker | The Grilling |
| `proposer` | Solution proposer | The Grilling |
| `synthesizer` | Debate synthesizer | The Grilling |
| `associate` | External tool/API proxy | Underboss, Capo |

---

## What This Spec Does NOT Cover (Future Work)

- Semantic search for Ledger entries (currently relies on tag matching and content grep)
- Token budget tracking implementation details (mechanism TBD per platform)
- Visual companion for The Grilling (browser-based debate visualization)
- Metrics and analytics for Heist performance
- Multi-project Borgata (cross-project insights sharing)
