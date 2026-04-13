# Heist Document Reorganization — Design Spec

## Summary

Reorganize heist-generated documents from a flat `docs/gangsta/specs/<heist>/` structure into purpose-based subfolders with date-prefixed filenames. Eliminate the standalone grilling transcript by merging its conclusions into the contract. Ledger structure is untouched.

## Problem

The current structure dumps all heist artifacts into a single `specs/` folder:

```
docs/gangsta/specs/<heist-name>/
├── checkpoint-grilling.md
├── checkpoint-reconnaissance.md
├── contract.md
├── grilling-transcript.md
└── recon-dossier.md
```

Issues:
1. No date context — artifacts have no temporal ordering
2. Flat layout — checkpoints, research, and specs are mixed together
3. Too many files — the grilling transcript duplicates what matters in the contract

## New Directory Structure

```
docs/gangsta/<heist-name>/
├── recon/
│   └── YYYY-MM-DD-recon-dossier.md
├── specs/
│   └── YYYY-MM-DD-contract.md
├── plans/
│   └── YYYY-MM-DD-war-plan.md
└── checkpoints/
    ├── YYYY-MM-DD-checkpoint-reconnaissance.md
    ├── YYYY-MM-DD-checkpoint-grilling.md
    ├── YYYY-MM-DD-checkpoint-sit-down.md
    └── YYYY-MM-DD-checkpoint-resource-dev.md
```

Key changes:
- Heist root moves from `docs/gangsta/specs/<heist>/` to `docs/gangsta/<heist>/`
- 4 purpose-based subfolders: `recon/`, `specs/`, `plans/`, `checkpoints/`
- All filenames get `YYYY-MM-DD-` prefix (date the artifact is created)
- `grilling-transcript.md` eliminated — conclusions merge into contract

## Artifact Changes

| Phase | Before | After | Content Change |
|-------|--------|-------|----------------|
| Reconnaissance | `specs/<heist>/recon-dossier.md` | `<heist>/recon/YYYY-MM-DD-recon-dossier.md` | None |
| The Grilling | `specs/<heist>/grilling-transcript.md` | **Eliminated** | Conclusions become a section in the contract |
| The Sit-Down | `specs/<heist>/contract.md` | `<heist>/specs/YYYY-MM-DD-contract.md` | Gains "Grilling Conclusions" section |
| Resource Dev | `specs/<heist>/war-plan.md` | `<heist>/plans/YYYY-MM-DD-war-plan.md` | None |
| Checkpoints | `specs/<heist>/checkpoint-<phase>.md` | `<heist>/checkpoints/YYYY-MM-DD-checkpoint-<phase>.md` | None |

Net result: 5+ files per heist reduced to 4+ files, better organized.

## Contract Template Update

The contract gains a new section to absorb grilling output:

```markdown
## Grilling Conclusions

Summary of key decisions and trade-offs from the adversarial review:

- [Decision 1]: [rationale]
- [Decision 2]: [rationale]
- ...

Rejected alternatives:
- [Alternative]: [why rejected]
```

## Skills Requiring Modification

8 skill files contain hardcoded document paths that must be updated:

### 1. `skills/reconnaissance/SKILL.md`
- Change output path from `docs/gangsta/specs/<heist-name>/recon-dossier.md` to `docs/gangsta/<heist-name>/recon/YYYY-MM-DD-recon-dossier.md`
- Update `mkdir -p` command if present

### 2. `skills/the-grilling/SKILL.md`
- Remove instruction to write `grilling-transcript.md`
- Add instruction: produce a "Grilling Conclusions" summary (decisions, rationale, rejected alternatives) that will be included in the contract
- The grilling process itself is unchanged — only the output artifact changes

### 3. `skills/the-sit-down/SKILL.md`
- Change output path from `docs/gangsta/specs/<heist-name>/contract.md` to `docs/gangsta/<heist-name>/specs/YYYY-MM-DD-contract.md`
- Add "Grilling Conclusions" section to contract template
- Update `mkdir -p` command if present

### 4. `skills/resource-development/SKILL.md`
- Change output path from `docs/gangsta/specs/<heist-name>/war-plan.md` to `docs/gangsta/<heist-name>/plans/YYYY-MM-DD-war-plan.md`
- Update `mkdir -p` command if present

### 5. `skills/omerta/SKILL.md`
- Change checkpoint path from `docs/gangsta/specs/<heist-name>/checkpoint-<phase>.md` to `docs/gangsta/<heist-name>/checkpoints/YYYY-MM-DD-checkpoint-<phase>.md`

### 6. `skills/the-underboss/SKILL.md`
- Same checkpoint path update as omerta

### 7. `skills/laundering/SKILL.md`
- Update final artifact list to reference new paths
- Remove `grilling-transcript.md` from artifact checklist

### 8. `skills/the-don/SKILL.md`
- Change checkpoint scanning from `docs/gangsta/specs/` to `docs/gangsta/`
- Update resume-heist logic to look for checkpoints in `<heist>/checkpoints/`

## What Does NOT Change

- Ledger structure: `docs/gangsta/insights/`, `docs/gangsta/fails/`, `docs/gangsta/constitution.md`
- The 6-phase Heist pipeline flow
- All agent prompt files (`agents/*.md`)
- The grilling debate process itself (only its output format changes)
- Skill frontmatter format
- Plugin files (`.opencode/`, `.claude-plugin/`, `.cursor-plugin/`)
- Hooks

## Testing

Each skill modification requires:
1. Read the skill, identify all path references
2. Update paths to new structure
3. Verify no old path patterns remain (grep for `specs/<heist` patterns)
4. Verify internal cross-references between skills still resolve
