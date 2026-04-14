# The Family Ledger

**Skill:** `the-ledger` | **Location:** `docs/gangsta/` in the project repository

The Borgata's persistent memory. Every Heist reads from and writes to the Ledger.

## Directory Structure

```
docs/gangsta/
├── constitution.md             # Project Constitution (living document)
├── insights/                   # Successful solutions and patterns
│   └── YYYY-MM-DD-<topic>.md
└── fails/                      # Documented failures and mistakes
    └── YYYY-MM-DD-<topic>.md
```

The Ledger lives in the **target project**, not in the gangsta package itself.

### Initializing

If `docs/gangsta/` does not exist:

```bash
mkdir -p docs/gangsta/insights docs/gangsta/fails
```

Create an initial `docs/gangsta/constitution.md`:

```markdown
# Project Constitution

## Commandments (from Insights)
_No commandments yet._

## Negative Constraints (from Fails)
_No constraints yet._

## Architectural Decisions
_No decisions recorded yet._
```

---

## Writing an Insight

Record when a solution bypasses a complex constraint, discovers a non-obvious approach, or establishes a new Project Commandment.

**File:** `docs/gangsta/insights/YYYY-MM-DD-<topic-slug>.md`

```markdown
---
date: YYYY-MM-DD
heist: <heist-name>
phase: <phase-where-discovered>
tags: [tag1, tag2]
---

# <Title: Short description of the insight>

## Discovery
<How the insight was found — which phase, what triggered it>

## Solution
<The successful reasoning pathway or creative solution>

## Project Commandment
<If applicable: a new rule to add to the Constitution>
```

After writing: add the Commandment (if any) to `docs/gangsta/constitution.md` with a source reference:
```
Always <commandment> — Source: insights/YYYY-MM-DD-<topic>.md
```

---

## Writing a Fail

Record when an approach caused regressions, security gaps, wasted time, or led to wrong implementation.

**File:** `docs/gangsta/fails/YYYY-MM-DD-<topic-slug>.md`

```markdown
---
date: YYYY-MM-DD
heist: <heist-name>
phase: <phase-where-occurred>
tags: [tag1, tag2]
severity: critical | high | medium | low
---

# <Title: Short description of the failure>

## What Happened
<The failure and its observable impact>

## Cognitive Diagnosis
<WHY the failure occurred — the reasoning error, not just what went wrong>

## Negative Constraint
NEVER <prohibited pattern> because <reason>
```

After writing: add the Negative Constraint to `docs/gangsta/constitution.md`:
```
NEVER <constraint> — Source: fails/YYYY-MM-DD-<topic>.md
```

---

## When the Ledger is Read

| Phase | What's Read |
|-------|------------|
| **Reconnaissance** | Insights and Fails with tags matching the Heist objective — presented in the Dossier |
| **The Grilling** | Devils-Advocate checks all Negative Constraints; a proposal violating one is automatically rejected |
| **The Sit-Down** | Underboss references Commandments when drafting the Contract; relevant ones must be cited |
| **The Hit** | Soldiers check Negative Constraints before implementation; violation triggers escalation |
| **Laundering** | New Insights and Fails written; Constitution updated with new Commandments and Constraints |

---

## The Project Constitution

`docs/gangsta/constitution.md` is a living document accumulating rules across all Heists:

- **Commandments** — "Always do X" — sourced from Insights
- **Negative Constraints** — "NEVER do Y because Z" — sourced from Fails
- **Architectural Decisions** — Key technical choices made across Heists

Every Heist must respect Constitution rules. Any proposal that violates a Negative Constraint during The Grilling is automatically rejected.

---

## Proactive Memory Capture (Outside Heists)

After significant exchanges outside of a Heist, the agent assesses whether a Ledger entry is warranted and asks the Don.

**Offer an Insight when:**
- A non-obvious approach or API behavior is discovered
- The Don contributes domain knowledge worth preserving
- A creative solution bypasses a complex constraint

**Offer a Fail when:**
- The Don criticizes or rejects an approach the agent provided
- An approach caused rework, confusion, or wasted effort
- A repeated mistake pattern surfaces

**Protocol:**
1. Ask once: "Worth saving to the Ledger as an [insight/fail]?"
2. If yes: write the entry
3. If no: drop it — never ask again for the same topic in the same session
4. Never write a Ledger entry without explicit Don approval

During a Heist, Laundering handles Ledger updates — skip this protocol.
