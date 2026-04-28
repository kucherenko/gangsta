---
heist: autonomous-pipeline-commands
phase: the-sit-down
status: completed
timestamp: 2026-04-28T00:00:00Z
next-action: Proceed to Resource Development (auto-advance per the-sit-down:164)
artifacts:
  - docs/gangsta/autonomous-pipeline-commands/recon/2026-04-28-recon-dossier.md
  - docs/gangsta/autonomous-pipeline-commands/grilling/2026-04-28-grilling-conclusions.md
  - docs/gangsta/autonomous-pipeline-commands/specs/2026-04-28-contract.md
contract-status: signed
consigliere-verdict: APPROVE WITH CONCERNS (all 7 findings addressed before signing)
signatories: [Don, Consigliere, Underboss]
---

## Resume Context

Contract signed. Approach C used (single Contract document with PR1/PR2 scope sections). All Grilling decisions encoded as 25 FRs / 7 NFRs / 9 ADs / 22 ACs. Consigliere review produced 7 findings (2 MEDIUM, 4 LOW, 1 NIT); all 7 fixes applied before signing.

## Binding Architecture

- Two new skills: `gangsta:autonomous-mode`, `gangsta:don-proxy` (distinct skills; don-proxy is NOT amendment to Consigliere)
- Universal Constitutional Floor on don-proxy across all six phases
- Sit-Down Dual-Veto, either-REJECT-terminal (symmetric, no precedence)
- `/gangsta:heist`, `/gangsta:go` (exact-match only, `.last-heist` pointer), `/gangsta:abort`
- Mini-Grilling cannot mutate Contract (deviation report only)
- Two-PR delivery; `/gangsta:purge-aborted` deferred post-PR2

## Resource Development Inputs
- 25 FRs partitioned across PR1 (skills+policy) and PR2 (commands+mechanism)
- 4 pressure-test scenarios required in PR1 description
- Acceptance Criteria 1-22 are the verification matrix

## Open Risks Carried Forward
- Risk-001 [MEDIUM] Token cost of mandatory Grilling — accepted with `--rounds=1` floor
- Risk-002 [MEDIUM] Single end-of-/heist review gate — accepted with progressive log + /abort path
- Risk-003 [LOW] Constitutional Floor depends on don-proxy honoring rule — pressure-tested by AC-016
- Risk-004 [LOW] `.aborted/` indefinite retention — future /purge-aborted command

## Auto-advance
Per `skills/the-sit-down/SKILL.md:164` MANDATORY auto-advance, immediately invoking `gangsta:resource-development` to decompose the Contract into work packages. Do NOT pause; do NOT prompt for confirmation.
