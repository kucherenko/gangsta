---
name: reconnaissance
description: Use when beginning a new heist — deploys associates to survey the target codebase, existing tests, dependencies, documentation, and the ledger to produce a reconnaissance dossier for the don's review
---

# Reconnaissance: Intel and Environment Mapping

## Overview

Every Heist begins with gathering intel. The Underboss deploys Associates to perform a detailed survey of the target codebase and infrastructure. The output is a Reconnaissance Dossier that informs all subsequent phases.

## Trigger

Invoked when the Don expresses building or creative intent.

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

Save to: `docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md`

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
- **Approve** — Proceed to The Grilling
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
next-action: Proceed to The Grilling
artifacts:
  - docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md
---
```

## Omerta Compliance
- [ ] Introduction Rule: Associates dispatched by Underboss, reports collected by Underboss
- [ ] Rule of Availability: Dossier and checkpoint saved to files
- [ ] Rule of Truth: All dossier claims cite specific files, line numbers, or Ledger entries
