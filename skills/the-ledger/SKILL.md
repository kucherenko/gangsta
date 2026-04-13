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

### During Reconnaissance
Search insights/ and fails/ for entries with tags matching the current Heist topic. Present relevant entries in the Reconnaissance Dossier.

### During The Grilling
The Devils-Advocate MUST check all Negative Constraints before accepting any proposal. If a proposal violates a Negative Constraint, it is automatically rejected.

### During The Sit-Down
The Underboss references Commandments when drafting the Contract. Every relevant Commandment must be cited in the Contract.

### During The Hit
Soldiers check Negative Constraints before implementation. If a Work Package would violate a constraint, the Soldier escalates to the Capo.

### During Laundering
New insights and fails from the Heist are written. The Constitution is updated.

## Omerta Compliance
- [ ] Rule of Truth: All Ledger entries cite specific phases, heists, and observable evidence
- [ ] Rule of Availability: Ledger files are committed to git after every update
- [ ] Spec is Law: Negative Constraints in the Constitution are binding on all future Heists
