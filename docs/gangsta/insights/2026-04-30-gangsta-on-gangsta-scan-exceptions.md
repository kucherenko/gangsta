---
date: 2026-04-30
heist: spec-id-leakage
phase: laundering
tags: [identifier-scan, laundering, self-referential-exceptions, gangsta-on-gangsta]
---

# Gangsta-on-Gangsta: Identifier Scan Fires on Framework's Own Template Placeholders

## Discovery

During Laundering for the spec-id-leakage Heist, the newly added blocking gate in
`skills/laundering/SKILL.md` was executed against the gangsta repo itself. The scan pattern
`\b(FR|NFR|WP)-\d+\b` matched 25 locations across 8 files outside `docs/gangsta/`.

Every match was a pre-existing legitimate exception: framework template placeholders
(`WP-001`, `FR-001`, `NFR-001` used as format examples in skill templates), the blocking
gate's own canonical form examples (`FR-001`, `NFR-042`, `WP-007` in laundering/SKILL.md),
and framework documentation files (`docs/heist-pipeline.md`, `docs/hierarchy.md`).

## Solution

All 25 matches were documented as standing exceptions in the laundering checkpoint with
justification. The Don acknowledged them as part of checkpoint review sign-off, clearing the
gate per FR-006d.

For future Heists run on the gangsta repo itself, these 8 files contain standing scan
exceptions that do not require re-evaluation:

| File | Nature of exception |
|------|---------------------|
| `skills/laundering/SKILL.md` | Self-referential: canonical form examples in the gate text |
| `skills/the-sit-down/SKILL.md` | Contract template format markers (`<FR-001>`) |
| `skills/resource-development/SKILL.md` | Execution Plan template format markers |
| `skills/the-capo/SKILL.md` | Status rollup template examples |
| `skills/the-hit/SKILL.md` | Checkpoint template format markers |
| `docs/heist-pipeline.md` | Heist pipeline documentation template placeholders |
| `docs/hierarchy.md` | Hierarchy documentation example status indicators |

## Project Commandment

When running the identifier scan on the gangsta repo itself, pre-document these 7 files as
standing scan exceptions in the laundering checkpoint before executing the scan. Their
matches are inherent to the framework's own template language and do not require individual
justification in each Heist.
