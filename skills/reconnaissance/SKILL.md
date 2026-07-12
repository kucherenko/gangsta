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

Dispatch Associate subagents in parallel to gather intel.

**Subagent type:** Use `subagent_type: "associate"` for all Associate dispatches. Do NOT use `"general"` or `"general-purpose"` — these are not valid in a Gangsta installation.

#### Greenfield Mode (empty or near-empty workspace)

Before dispatching the standard survey, count the files in the working directory (excluding `.git`, `docs/gangsta/`, and other meta directories).

**Trigger:** the workspace contains fewer than 5 source files OR no recognizable project manifest (`package.json`, `requirements.txt`, `go.mod`, `Cargo.toml`, `pyproject.toml`, etc.).

When the trigger fires, the reconnaissance objective shifts from "survey the existing code" to "sharpen the IDEA". The standard codebase survey is still run (to capture what little exists), but it is no longer the center. Instead, deploy these associates in parallel:

| Associate Task | What to Investigate |
|---------------|-------------------|
| Idea Framing | Restate the Don's objective in the Don's own words. Identify the problem being solved, who has it, and what evidence (if any) the Don offered. Surface hidden assumptions. |
| Analogues | Search the internet for existing tools, libraries, products, or papers that solve the same or adjacent problems. For each analogue: name, what it does, what it gets right, what it gets wrong, license/hosting model. Use the `webfetch` tool. Produce at least 3 analogues; if fewer than 3 exist, say so and explain why the space is sparse. |
| Prior Art & Patterns | Search the internet for relevant prior art: protocols, data formats, algorithms, design patterns, prior attempts, postmortems. Cite sources (URLs). |
| Constraint & Risk Survey | Enumerate known constraints for the domain: performance ceilings, security concerns, regulatory, accessibility, platform limits. Cite sources. |
| Codebase Structure | (Standard survey — what little exists in the workspace.) |
| Ledger Search | (Standard survey.) |
| Constitution | (Standard survey.) |

The Dossier's `Codebase Overview` section becomes a thin note describing the empty/near-empty state. The bulk of the Dossier moves to new sections — see the Greenfield Dossier Format below.

**Greenfield Dossier Format** (replaces the standard format when greenfield mode fires):

```markdown
---
heist: <heist-name>
date: YYYY-MM-DD
status: pending-review
mode: greenfield
---

# Reconnaissance Dossier: <Heist Name>

## Objective
<What the Don wants to build — restated in Don's words, plus interpreted objective>

## Workspace State
<One paragraph: what currently exists. If empty, say "empty workspace — greenfield".>

## Idea Framing
- Problem: <the actual problem>
- Who has it: <audience>
- Evidence: <what the Don offered; if none, say "no evidence offered — to be grilled">
- Hidden assumptions:
  - <assumption> — risk if wrong: HIGH/MEDIUM/LOW

## Analogues
| Name | What it does | Strengths | Weaknesses | License/Hosting |
|------|--------------|-----------|-----------|-----------------|
| ... | ... | ... | ... | ... |

## Prior Art & Patterns
- <pattern / protocol / algorithm> — <URL> — relevance: <how it applies>

## Constraint & Risk Survey
- <constraint> — source: <URL>

## Existing Test Coverage
<Near-empty in greenfield mode — note what, if anything, exists.>

## Dependencies
<Near-empty in greenfield mode — list any the Don named.>

## Relevant Ledger Entries
### Applicable Insights
- <insight reference + summary>
### Applicable Negative Constraints
- NEVER <constraint> — Source: fails/YYYY-MM-DD-<topic>.md

## Risks and Unknowns
<Domain risks surfaced by the Constraint & Risk Survey; unknowns the analogues search could not resolve.>

## Recommended Scope
<Suggested boundaries — since there is no codebase to constrain scope, scope is the IDEA's own bounds: which analogue features to adopt, which to reject, which sub-problems are in/out.>
```

The Don reviews this dossier the same way. The proceed menu (Step 4) is unchanged.

#### Standard Mode (existing codebase)

When the workspace contains a real codebase (5+ source files OR a recognizable project manifest), run the standard survey below.

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

## Dossier Format (Standard Mode)

Save to: `docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md`

In greenfield mode, use the Greenfield Dossier Format defined above instead.

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

Save the Dossier file (Step 3), then present its contents to the Don in chat.

**DO NOT include the proceed menu in the dossier file.** The menu is a chat message only — present it to the Don after the dossier summary. Present it through the platform's native interactive selection tool (OpenCode `question`, Claude Code `AskUserQuestion`); only fall back to the plain-text numbered list when no such tool exists.

**Required gate — The Sit-Down must not be skipped:**

The Sit-Down (spec drafting and Contract signing) is a required phase. The Don may only choose whether The Grilling runs before it — but The Sit-Down itself must always run.

If the Don requests to skip The Sit-Down, explain that the Contract is required before any implementation work begins and re-present the menu below.

The proceed menu MUST use exactly this option set — do not paraphrase, abbreviate, or add options:

```
How do you want to proceed?

  1. Approve the dossier + run The Grilling → Multi-agent debate on architecture, then The Sit-Down
  2. Approve the dossier + skip The Grilling → Proceed directly to The Sit-Down (spec drafting)
  3. Adjust scope — Add/remove anything from the phases before we commit
  4. Request more intel — Deploy Associates to dig deeper into a specific area
```

**Presentation — use the platform's native selection tool, not plain text:**

- In OpenCode, present these four options via the `question` tool (interactive select/choose UI). Do NOT dump the numbered list as plain text and wait — route it through the selection tool so the Don clicks a variant.
- In Claude Code, use the `AskUserQuestion` tool with the same four options.
- Only fall back to the plain-text numbered menu above when no interactive selection tool is available on the current platform.

Wait for the Don's explicit choice before taking any action.

- Choice 1 → Invoke `gangsta:the-grilling`, then `gangsta:the-sit-down`
- Choice 2 → Invoke `gangsta:the-sit-down`
- Choice 3 → Clarify scope changes, update the dossier, re-present
- Choice 4 → Deploy targeted Associates, update the dossier, re-present

Proceed with one of the choices above to maintain spec integrity (Omerta Law 5).

## Checkpoint

Write checkpoint after the Don approves (choices 1 or 2):
```yaml
---
heist: <heist-name>
phase: reconnaissance
status: completed
timestamp: <ISO 8601>
next-action: <"Proceed to The Sit-Down" | "Proceed to The Grilling">
artifacts:
  - docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md
---
```

## Omerta Compliance
- [ ] Introduction Rule: Associates dispatched by Underboss, reports collected by Underboss
- [ ] Rule of Availability: Dossier and checkpoint saved to files
- [ ] Rule of Truth: All dossier claims cite specific files, line numbers, Ledger entries, OR URLs (greenfield mode). Uncited analogue/prior-art claims are invalid.
- [ ] Spec is Law: Proceed menu presented exactly as specified — no options added, removed, or paraphrased
- [ ] Mandatory Gate: The Sit-Down is never skipped — no path leads directly to The Hit or Resource Development
- [ ] Greenfield Mode: Internet searches (analogues, prior art) require URL citations in the Dossier; fabricated analogues violate Rule of Truth
