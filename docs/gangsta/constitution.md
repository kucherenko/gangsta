# Project Constitution

This file is the Gangsta framework's institutional Constitution. It accumulates **Commandments** (positive rules the framework must uphold) and **Negative Constraints** (things the framework must never do) across Heists. Entries are written exclusively by the Laundering phase at the close of a Heist, with the Don's explicit confirmation. The Constitution is read by every skill that requires invariant rules — particularly `gangsta:don-proxy` when operating in autonomous mode — to ensure cross-Heist invariants are honored.

The Constitution is layered ON TOP of Omerta. See [`skills/omerta/SKILL.md`](../../skills/omerta/SKILL.md) for foundational laws (Authority, Checkpoints, Truth, Resources, Spec Supremacy). Omerta laws are non-negotiable and apply to every operation; the Constitution captures Heist-specific invariants discovered during execution. Where the Constitution and Omerta overlap, Omerta prevails. The Constitution may strengthen Omerta but never weaken it.

## Commandments

Future Heists' Laundering phases append entries here. Format: `- <ID>: <one-line rule> — Source: <heist name>`

- C-001: When an SDK's TypeScript types lag behind its runtime API, use a targeted `(obj as any).method()` cast at the call site and document the gap in INSTALL.md under "Accepted Risks" — Source: pi-dev-extension Heist (insights/2026-05-01-sdk-type-lag-cast-pattern.md)
- C-002: When running the identifier scan on the gangsta repo itself, pre-document the 7 standing framework template files as scan exceptions before executing the scan — their matches are inherent to the framework's own template language and require no per-Heist justification — Source: spec-id-leakage Heist (insights/2026-04-30-gangsta-on-gangsta-scan-exceptions.md)

## Negative Constraints

Future Heists' Laundering phases append entries here. Format: `- <ID>: <one-line prohibition> — Source: <heist name>`

- NC-001: NEVER weaken or bypass Omerta Law 2 (checkpoints non-negotiable) in any autonomous-mode pathway — Source: autonomous-pipeline-commands Heist (Recon Dossier)
- NC-002: NEVER include spec identifiers (FR-xxx, NFR-xxx, WP-xxx) in project-facing artifacts outside `docs/gangsta/` — Source: autonomous-pipeline-commands Heist (Recon Dossier)
- NC-003: NEVER infer an SDK's method signature by analogy with similar patterns — always verify the exact argument shape from documentation or type definitions before implementation — Source: pi-dev-extension Heist (fails/2026-05-01-wrong-registercommand-api-shape.md)
- NC-004: NEVER reproduce Gangsta-internal spec identifiers (FR-xxx, NFR-xxx, WP-xxx, where xxx is one or more digits) in project-facing artifacts outside `docs/gangsta/`, including source code, test files, code comments, and README files — Source: spec-id-leakage Heist

## How Entries Are Added

Entries are added ONLY via `gangsta:laundering` at the close of a Heist, and ONLY with the Don's explicit confirmation. The Constitution is never silently amended, never edited by ad-hoc commits, and never modified outside the Laundering phase. Every entry must cite its source Heist so the provenance of each rule is auditable.
