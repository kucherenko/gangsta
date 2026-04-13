# Heist Document Reorganization — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorganize heist document output paths from flat `docs/gangsta/specs/<heist>/` to purpose-based subfolders (`recon/`, `specs/`, `plans/`, `checkpoints/`) with date-prefixed filenames, and eliminate the standalone grilling transcript.

**Architecture:** All document paths are natural-language instructions in skill Markdown files. Each skill that produces output hardcodes its save path. We update 8 skill files to use the new path structure and modify the grilling skill to output a conclusions summary instead of a standalone transcript.

**Tech Stack:** Markdown (skill files only — zero code changes)

---

## File Inventory

All changes are modifications to existing files:

| File | Change Summary |
|------|---------------|
| `skills/reconnaissance/SKILL.md` | Output path + artifact reference |
| `skills/the-grilling/SKILL.md` | Remove transcript output, add conclusions output |
| `skills/the-sit-down/SKILL.md` | Output path + add Grilling Conclusions section to contract template |
| `skills/resource-development/SKILL.md` | Output path + artifact reference |
| `skills/omerta/SKILL.md` | Checkpoint path |
| `skills/the-underboss/SKILL.md` | Checkpoint save path |
| `skills/laundering/SKILL.md` | Artifact list + evidence disposal list |
| `skills/the-don/SKILL.md` | Checkpoint scanning path for resume |

---

### Task 1: Update reconnaissance skill

**Files:**
- Modify: `skills/reconnaissance/SKILL.md:44` (output path)
- Modify: `skills/reconnaissance/SKILL.md:100` (checkpoint artifact reference)

- [ ] **Step 1: Update the dossier output path**

Change line 44 from:
```
Save to: `docs/gangsta/specs/<heist-name>/recon-dossier.md`
```
to:
```
Save to: `docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md`
```

- [ ] **Step 2: Update the checkpoint artifact reference**

Change line 100 from:
```
  - docs/gangsta/specs/<heist-name>/recon-dossier.md
```
to:
```
  - docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md
```

- [ ] **Step 3: Verify no old path patterns remain**

Run: `grep -n 'specs/<heist-name>/recon' skills/reconnaissance/SKILL.md`
Expected: No output (zero matches)

- [ ] **Step 4: Commit**

```bash
git add skills/reconnaissance/SKILL.md
git commit -m "recon: update dossier output path to docs/gangsta/<heist>/recon/"
```

---

### Task 2: Update the-grilling skill

**Files:**
- Modify: `skills/the-grilling/SKILL.md:134-155` (output section + checkpoint)

- [ ] **Step 1: Replace the Output section**

Change lines 134-141 from:
```markdown
## Output

Save to: `docs/gangsta/specs/<heist-name>/grilling-transcript.md`

The transcript includes:
- Each round's proposal, attacks, Don's input, and synthesis
- The final consensus (or Best Available Consensus)
- Termination reason (Nash Equilibrium / Don declared / Round limit)
```
to:
```markdown
## Output

The Grilling does NOT produce a standalone transcript file. Instead, the orchestrating agent produces a **Grilling Conclusions** summary at the end of the debate. This summary is passed directly to the next phase (The Sit-Down) for inclusion in the Contract.

The Grilling Conclusions must contain:
- **Key Decisions:** Each architectural/design decision reached, with rationale
- **Rejected Alternatives:** Each option that was considered and discarded, with the reason
- **Unresolved Objections:** Any risks acknowledged but accepted (from Best Available Consensus)
- **Termination Reason:** Nash Equilibrium / Don declared / Round limit

The orchestrating agent holds this summary in context — it is NOT saved as a separate file.
```

- [ ] **Step 2: Update the checkpoint artifact list**

Change lines 145-155 from:
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
to:
```yaml
---
heist: <heist-name>
phase: the-grilling
status: completed
timestamp: <ISO 8601>
next-action: Proceed to The Sit-Down (Phase 3)
artifacts: []
note: Grilling Conclusions passed in-context to The Sit-Down for inclusion in the Contract
---
```

- [ ] **Step 3: Verify no old transcript path remains**

Run: `grep -n 'grilling-transcript' skills/the-grilling/SKILL.md`
Expected: No output (zero matches)

- [ ] **Step 4: Commit**

```bash
git add skills/the-grilling/SKILL.md
git commit -m "grilling: eliminate standalone transcript, output conclusions for contract inclusion"
```

---

### Task 3: Update the-sit-down skill

**Files:**
- Modify: `skills/the-sit-down/SKILL.md:38-79` (contract template — add Grilling Conclusions section)
- Modify: `skills/the-sit-down/SKILL.md:112` (output path)
- Modify: `skills/the-sit-down/SKILL.md:124` (checkpoint artifact reference)

- [ ] **Step 1: Add Grilling Conclusions section to the contract template**

In the contract template (lines 38-79), insert a new section after `## Architectural Decisions` (after line 63). Change:
```markdown
## Architectural Decisions
<Key decisions from the Grilling consensus, with rationale>

## Applicable Constitution Rules
```
to:
```markdown
## Architectural Decisions
<Key decisions from the Grilling consensus, with rationale>

## Grilling Conclusions
### Key Decisions
- <Decision>: <rationale>

### Rejected Alternatives
- <Alternative>: <why rejected>

### Unresolved Objections
- <Objection> — Risk: HIGH/MEDIUM/LOW — Mitigation: <if any>

## Applicable Constitution Rules
```

- [ ] **Step 2: Update the output path**

Change line 112 from:
```
Save to: `docs/gangsta/specs/<heist-name>/contract.md`
```
to:
```
Save to: `docs/gangsta/<heist-name>/specs/YYYY-MM-DD-contract.md`
```

- [ ] **Step 3: Update the checkpoint artifact reference**

Change line 124 from:
```
  - docs/gangsta/specs/<heist-name>/contract.md
```
to:
```
  - docs/gangsta/<heist-name>/specs/YYYY-MM-DD-contract.md
```

- [ ] **Step 4: Verify no old path patterns remain**

Run: `grep -n 'specs/<heist-name>/contract' skills/the-sit-down/SKILL.md`
Expected: No output (zero matches)

- [ ] **Step 5: Commit**

```bash
git add skills/the-sit-down/SKILL.md
git commit -m "sit-down: update contract path, add grilling conclusions section to template"
```

---

### Task 4: Update resource-development skill

**Files:**
- Modify: `skills/resource-development/SKILL.md:69` (war plan output path)
- Modify: `skills/resource-development/SKILL.md:136` (checkpoint artifact reference)

- [ ] **Step 1: Update the war plan output path**

Change line 69 from:
```
Save to: `docs/gangsta/specs/<heist-name>/war-plan.md`
```
to:
```
Save to: `docs/gangsta/<heist-name>/plans/YYYY-MM-DD-war-plan.md`
```

- [ ] **Step 2: Update the checkpoint artifact reference**

Change line 136 from:
```
  - docs/gangsta/specs/<heist-name>/war-plan.md
```
to:
```
  - docs/gangsta/<heist-name>/plans/YYYY-MM-DD-war-plan.md
```

- [ ] **Step 3: Verify no old path patterns remain**

Run: `grep -n 'specs/<heist-name>/war-plan' skills/resource-development/SKILL.md`
Expected: No output (zero matches)

- [ ] **Step 4: Commit**

```bash
git add skills/resource-development/SKILL.md
git commit -m "resource-dev: update war plan path to docs/gangsta/<heist>/plans/"
```

---

### Task 5: Update omerta skill

**Files:**
- Modify: `skills/omerta/SKILL.md:27` (checkpoint path)

- [ ] **Step 1: Update the checkpoint location**

Change line 27 from:
```
- Checkpoint location: `docs/gangsta/specs/<heist-name>/checkpoint-<phase>.md`
```
to:
```
- Checkpoint location: `docs/gangsta/<heist-name>/checkpoints/YYYY-MM-DD-checkpoint-<phase>.md`
```

- [ ] **Step 2: Verify no old path patterns remain**

Run: `grep -n 'specs/<heist-name>/checkpoint' skills/omerta/SKILL.md`
Expected: No output (zero matches)

- [ ] **Step 3: Commit**

```bash
git add skills/omerta/SKILL.md
git commit -m "omerta: update checkpoint path to docs/gangsta/<heist>/checkpoints/"
```

---

### Task 6: Update the-underboss skill

**Files:**
- Modify: `skills/the-underboss/SKILL.md:101` (checkpoint save path)

- [ ] **Step 1: Update the checkpoint save path**

Change line 101 from:
```
Save to: `docs/gangsta/specs/<heist-name>/checkpoint-<phase>.md`
```
to:
```
Save to: `docs/gangsta/<heist-name>/checkpoints/YYYY-MM-DD-checkpoint-<phase>.md`
```

- [ ] **Step 2: Verify no old path patterns remain**

Run: `grep -n 'specs/<heist-name>/checkpoint' skills/the-underboss/SKILL.md`
Expected: No output (zero matches)

- [ ] **Step 3: Commit**

```bash
git add skills/the-underboss/SKILL.md
git commit -m "underboss: update checkpoint save path to new structure"
```

---

### Task 7: Update laundering skill

**Files:**
- Modify: `skills/laundering/SKILL.md:78-83` (evidence disposal "do not remove" list)
- Modify: `skills/laundering/SKILL.md:126-129` (final checkpoint artifact list)

- [ ] **Step 1: Update the evidence disposal "do not remove" list**

Change lines 78-83 from:
```markdown
Do NOT remove:
- The Contract
- The War Plan
- The Grilling Transcript
- The Reconnaissance Dossier
- These are permanent records of the Heist
```
to:
```markdown
Do NOT remove:
- The Contract (`docs/gangsta/<heist-name>/specs/YYYY-MM-DD-contract.md`)
- The War Plan (`docs/gangsta/<heist-name>/plans/YYYY-MM-DD-war-plan.md`)
- The Reconnaissance Dossier (`docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md`)
- These are permanent records of the Heist
```

- [ ] **Step 2: Update the final checkpoint artifact list**

Change lines 126-129 from:
```yaml
artifacts:
  - docs/gangsta/specs/<heist-name>/contract.md
  - docs/gangsta/specs/<heist-name>/war-plan.md
  - docs/gangsta/specs/<heist-name>/grilling-transcript.md
  - docs/gangsta/specs/<heist-name>/recon-dossier.md
```
to:
```yaml
artifacts:
  - docs/gangsta/<heist-name>/specs/YYYY-MM-DD-contract.md
  - docs/gangsta/<heist-name>/plans/YYYY-MM-DD-war-plan.md
  - docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md
```

- [ ] **Step 3: Verify no old path patterns remain**

Run: `grep -n 'specs/<heist-name>/' skills/laundering/SKILL.md`
Expected: No output (zero matches)

Run: `grep -n 'grilling-transcript' skills/laundering/SKILL.md`
Expected: No output (zero matches)

- [ ] **Step 4: Commit**

```bash
git add skills/laundering/SKILL.md
git commit -m "laundering: update artifact paths, remove grilling transcript reference"
```

---

### Task 8: Update the-don skill

**Files:**
- Modify: `skills/the-don/SKILL.md:27` (intent table — checkpoint path)
- Modify: `skills/the-don/SKILL.md:71` (resume heist — scanning path)

- [ ] **Step 1: Update the intent table checkpoint reference**

Change line 27 from:
```
| Continuing existing work | Check for checkpoint files in `docs/gangsta/specs/` — resume from last phase |
```
to:
```
| Continuing existing work | Check for checkpoint files in `docs/gangsta/` — resume from last phase |
```

- [ ] **Step 2: Update the resume heist scanning path**

Change line 71 from:
```
1. Check `docs/gangsta/specs/` for directories with `checkpoint-*.md` files
```
to:
```
1. Check `docs/gangsta/` for heist directories containing `checkpoints/` subdirectories
```

- [ ] **Step 3: Verify no old path patterns remain**

Run: `grep -n 'docs/gangsta/specs/' skills/the-don/SKILL.md`
Expected: No output (zero matches). Note: references to `gangsta:the-sit-down` and other skill names containing "specs" in descriptions are fine — we're only checking for file paths.

- [ ] **Step 4: Commit**

```bash
git add skills/the-don/SKILL.md
git commit -m "don: update checkpoint scanning path for new heist directory structure"
```

---

### Task 9: Final cross-skill verification

- [ ] **Step 1: Grep entire skills directory for old path pattern**

Run: `grep -rn 'docs/gangsta/specs/<heist' skills/`
Expected: No output (zero matches across all skill files)

- [ ] **Step 2: Grep for any remaining grilling-transcript references**

Run: `grep -rn 'grilling-transcript' skills/`
Expected: No output (zero matches)

- [ ] **Step 3: Verify new paths are consistent across skills**

Run: `grep -rn 'docs/gangsta/<heist-name>' skills/`
Expected: All paths follow the pattern:
- `docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md`
- `docs/gangsta/<heist-name>/specs/YYYY-MM-DD-contract.md`
- `docs/gangsta/<heist-name>/plans/YYYY-MM-DD-war-plan.md`
- `docs/gangsta/<heist-name>/checkpoints/YYYY-MM-DD-checkpoint-<phase>.md`

- [ ] **Step 4: Final commit (if any fixups needed)**

Only if verification found inconsistencies that needed fixing.
