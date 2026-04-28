---
name: autonomous-mode
description: Use ONLY when invoked via the `/gangsta:heist` or `/gangsta:go` commands (see `commands/heist.md` and `commands/go.md`) — orchestrates the Heist pipeline autonomously with `gangsta:don-proxy` substituting for the human Don across all six phases until the real Don signs via `/gangsta:go` or rejects via `/gangsta:abort`.
---

# Autonomous Mode: Don-Proxy-Driven Heist Pipeline

## Overview

This skill governs the autonomous variant of the Heist pipeline. It is invoked exclusively by two commands:

- `/gangsta:heist <feature>` — runs the Plan stage (Reconnaissance → the-Grilling → the-Sit-Down → Resource-Development) autonomously.
- `/gangsta:go [feature]` — runs the Execution stage (the-Hit → Laundering) autonomously after the real Don signs.

The default Heist pipeline (gated, human-Don-driven, one approval gate per phase) operates unchanged when these commands are not invoked. This skill MUST NOT be loaded by any other entry point. If a host skill is operating outside `/gangsta:heist` or `/gangsta:go`, ignore the carve-out references in those skills and follow the host skill as written.

### Distinction from the Default Heist

| Aspect | Default Heist | Autonomous Mode |
|---|---|---|
| Per-phase approval | Human Don at each gate | `gangsta:don-proxy` at each gate |
| Sit-Down sign-off | Don signs | don-proxy signs (status `pending-don-confirmation`) |
| Terminal authority | Don | Real Don retains terminal authority via `/go`, `/abort`, and the Consigliere's existing terminal veto in the Sit-Down |
| Auto-advance | the-sit-down:164, the-hit:110 | Same two, plus per-phase auto-advance under don-proxy non-REJECT |
| Constitutional Floor | N/A (Don decides) | Mandatory don-proxy rejection of artifacts violating Omerta or Negative Constraints |

### Constitutional Floor Supremacy

Anywhere this skill describes don-proxy behavior, the Constitutional Floor (Omerta laws in `skills/omerta/SKILL.md` plus active Negative Constraints in `docs/gangsta/constitution.md`) overrides any boldness preference. A don-proxy REJECT under the Constitutional Floor is terminal in any phase: the heist halts immediately, the verdict is written to `autonomous-log.md`, and the heist directory is left in place for Don inspection. Resumption requires a fresh `/gangsta:heist` invocation. Mid-flight retry of a Constitutional-Floor REJECT is NOT permitted regardless of the `--best-effort` setting.

## Per-Phase Interaction Schemas

Each subsection below defines, for one host skill: when don-proxy is invoked, what triggers a REJECT, what artifacts are produced, and what host-skill rules are PRESERVED unchanged. Implementation details belonging to host skills are NOT duplicated here — only the autonomous-mode delta.

### Reconnaissance

**Host skill:** `skills/reconnaissance/SKILL.md`

**don-proxy invocation:** Once, after the Recon Dossier is written and before progression to the-Grilling. don-proxy reads the Dossier and either approves (boldness above the floor) or REJECTs.

**REJECT triggers:**
- Dossier proposes or implies any approach that violates an Omerta law (Constitutional Floor).
- Dossier proposes or implies any approach that violates an active Negative Constraint in `docs/gangsta/constitution.md`.
- Dossier is materially incomplete (missing target survey, ledger pull, or dependency check).

**Artifacts produced:** Recon Dossier (host skill output) + a per-phase entry appended to `docs/gangsta/<feature>/autonomous-log.md` recording: phase, don-proxy verdict, citation, ISO-8601 timestamp.

**Preserved unchanged:** All host-skill rules for associate dispatch, dossier format, target survey, ledger pull, and dependency check operate as written.

**On REJECT:** `/gangsta:heist` stops. No Grilling, no Sit-Down. Heist directory left in place.

**On non-REJECT:** Auto-advance to the-Grilling.

### the-Grilling

**Host skill:** `skills/the-grilling/SKILL.md`

**don-proxy invocation:** Once per round, replacing the human Don's per-round participation slot. don-proxy reads the round's proposer/devil's-advocate/synthesizer outputs and contributes a single-line position-statement plus a continue/converge signal. don-proxy also issues a final verdict at consensus time.

**REJECT triggers:**
- A Grilling consensus that endorses an approach violating Omerta or a Negative Constraint (Constitutional Floor).
- A Grilling that converges below the round floor without addressing required adversarial pressure (e.g. mandatory adversarial review skipped in spirit). The mandatory-Grilling rule (no flag exists to bypass adversarial brainstorming) is non-negotiable.

**Artifacts produced:** Grilling conclusions document (host skill output) + appended `autonomous-log.md` entries per round and at consensus.

**Preserved unchanged:** The one-question-at-a-time rule, the round ceiling (1–7), the proposer / devil's-advocate / synthesizer subagent contract, and the rounds-floor of 1.

**On REJECT:** `/gangsta:heist` stops. No Sit-Down. Heist directory left in place.

**On non-REJECT:** Auto-advance to the-Sit-Down.

### the-Sit-Down

**Host skill:** `skills/the-sit-down/SKILL.md`

**don-proxy invocation:** Twice. First, at the approach-selection step — don-proxy selects from the 2–3 proposed approaches (instead of prompting the human Don). Second, at the contract-signing step — don-proxy reviews the drafted Contract alongside the Consigliere and renders a verdict.

**Dual-Veto Protocol:** In autonomous mode, signing requires non-REJECT verdicts from BOTH `gangsta:the-consigliere` (spec integrity) AND `gangsta:don-proxy` (boldness/strategic fit + Constitutional Floor). The two vetoes are SYMMETRIC and there is NO precedence between them: either REJECT is terminal. There is no tie-break, no escalation, no re-vote.

**REJECT triggers (don-proxy side):**
- Contract introduces a Negative Constraint violation (e.g. third-party dependency, weakening of Omerta, narrative storytelling in skill content, bundled unrelated changes).
- Contract endorses an approach inconsistent with the boldness preference AND no rationale survives challenge — only above the Constitutional Floor.
- Contract is structurally incomplete (missing FRs, NFRs, ACs, or Open Risks sections).

**REJECT triggers (Consigliere side):** As defined in `gangsta:the-consigliere` — contradiction, ambiguity, completeness, constitution alignment, security.

**Artifacts produced:** Signed Contract written with frontmatter `signed-by: don-proxy`, `status: pending-don-confirmation`, `signatories: [don-proxy, Consigliere, Underboss]`. Consigliere verdict and don-proxy verdict appended to `autonomous-log.md`.

**Auto-advance:** The host-skill auto-advance at `skills/the-sit-down/SKILL.md:164` fires in autonomous mode when don-proxy SIGN AND Consigliere non-REJECT. It does NOT fire if either authority REJECTs.

**Preserved unchanged:** The Absolute Rule (no code generation in the Contract), the 2–3 approaches requirement, the Consigliere review pass, the Contract structure (Objective, Requirements, Architectural Decisions, Grilling Conclusions, Applicable Constitution Rules, Acceptance Criteria, Out of Scope, Open Risks).

**On either REJECT:** Heist aborts. The autonomous-log records the rejecting authority and citation. Heist directory left in place for Don inspection. Resumption requires `/gangsta:heist` re-invocation; the don-proxy verdict cannot be appealed mid-flight.

**On dual non-REJECT:** Auto-advance to Resource-Development.

### Resource-Development

**Host skill:** `skills/resource-development/SKILL.md`

**don-proxy invocation:** Once, after the Execution Plan is drafted and before `/gangsta:heist` exits. don-proxy reviews the Plan for Constitutional-Floor violations introduced by Work Package decomposition, territory allocation, or budget assumptions.

**REJECT triggers:**
- A Work Package directs work that would violate Omerta (e.g. checkpoint suppression, ledger silencing) or an active Negative Constraint.
- Territory allocation creates a path that weakens Omerta governance.
- Token budget assumptions assume disabling a mandatory phase.

**Artifacts produced:** Execution Plan (host skill output) + final `autonomous-log.md` entries closing out `/gangsta:heist`. Plan frontmatter records `signed-by: don-proxy`, `status: pending-don-confirmation`.

**Preserved unchanged:** The host-skill Plan format, Work Package schema (Contract clauses, files, acceptance criteria, verification command, budget, dependencies), territory definitions, isolation strategy, and execution order.

**On REJECT:** `/gangsta:heist` stops. Heist directory left in place.

**On non-REJECT:** `/gangsta:heist` writes `docs/gangsta/.last-heist`, emits the inline summary listing all artifact paths and the `autonomous-log.md` reference, and exits. The Hit does NOT auto-start. The real Don must run `/gangsta:go` (or `/gangsta:abort`) to proceed.

### the-Hit

**Host skill:** `skills/the-hit/SKILL.md`

**don-proxy invocation:** When a Worker failure escalates from Crew Lead to Underboss and triggers the mini-Grilling at the host-skill escalation chain, don-proxy participates as the Don substitute in that single-round mini-Grilling.

**Mini-Grilling Constraint:** Under autonomous mode, the mini-Grilling produces a **deviation report only** and SHALL NOT mutate the signed Contract on disk. The signed Contract is byte-identical before and after the mini-Grilling. If the deviation report concludes that a Contract amendment is required, the Hit halts and `/gangsta:go` surfaces a fresh-Sit-Down requirement to the real Don. Mid-Hit Contract revision by don-proxy is forbidden — that backdoor would let don-proxy edit a Consigliere-reviewed Contract without Consigliere oversight.

**REJECT triggers:**
- Deviation report endorses an amendment that violates Omerta or a Negative Constraint (Constitutional Floor).
- Worker output evidences a path that violates Omerta (e.g. hidden test failures, fabricated reports).

**Artifacts produced:** Deviation report (when mini-Grilling fires), per-batch checkpoint entries, and `autonomous-log.md` entries. The signed Contract is NOT modified.

**Preserved unchanged:** TDD enforcement (`gangsta:drill-tdd`), Worker dispatch through Crew Leads (`gangsta:the-capo`), Report format including actual test output, the host-skill auto-advance to Laundering at the host-skill completion step, all Omerta compliance items.

**On REJECT:** Heist halts. Heist directory left in place. `/gangsta:go` surfaces the REJECT to the Don.

**On non-REJECT:** Auto-advance to Laundering as defined by the host skill.

### Laundering

**Host skill:** `skills/laundering/SKILL.md`

**don-proxy invocation:** Once, at the final-declaration step. don-proxy reviews the integration verdict, sweep results, and ledger entries proposed by Laundering.

**Ledger Frontmatter Protocol:** Ledger entries (insights, fails, constitution updates) written by `gangsta:laundering` under autonomous mode SHALL include frontmatter:

- `signed-by: don-proxy`
- `status: pending-don-confirmation`
- `heist: <feature>`
- `date: <ISO-8601>`

Three lifecycle states for autonomous-mode ledger entries:

1. **pending-don-confirmation** — written by Laundering during `/gangsta:go`. Visible to active ledger reads but flagged as unconfirmed.
2. **confirmed** — flipped by `/gangsta:go` at signing time: `signed-by: don`, `confirmed: <ISO-8601>` replaces the pending fields. `heist:` and `date:` preserved.
3. **rejected** — relocated by `/gangsta:abort` together with the heist directory to `docs/gangsta/.aborted/<feature>-<ISO-8601>/`. Subsequent ledger reads exclude entries whose `heist:` resolves under `.aborted/`.

**REJECT triggers:**
- Integration verdict conceals a Sweep failure (Omerta Rule of Truth).
- Proposed ledger entries weaken Omerta or a Negative Constraint.
- Final declaration suppresses an Open Risk that materialized during the Hit.

**Artifacts produced:** Final declaration, ledger entries with the autonomous frontmatter above, and the closing `autonomous-log.md` entry for the heist.

**Preserved unchanged:** Sweep verification, Audit-Review pass, ledger-prompt behavior, integration verdict format, final-declaration structure.

**On REJECT:** Heist halts. Heist directory left in place. The Don sees the REJECT in the `/gangsta:go` summary and may invoke `/gangsta:abort`.

**On non-REJECT:** `/gangsta:go` exits with the inline summary. Real-Don confirmation is achieved via the next `/gangsta:go` (which performs the `pending-don-confirmation` → `confirmed` flip on signing) or repudiation via `/gangsta:abort`.

## State Files

### `docs/gangsta/.last-heist`

Plain-text single-line file. Contains exactly one absolute filesystem path: the most recent autonomous heist directory written by `/gangsta:heist`. No JSON, no YAML, no trailing metadata. Written at `/gangsta:heist` success. Read by `/gangsta:go` when invoked without arguments. Cleared by `/gangsta:abort` if it points at the aborted feature.

### `docs/gangsta/<feature>/autonomous-log.md`

Progressive per-phase decision log. Written incrementally during `/gangsta:heist` and `/gangsta:go` execution. Each entry records: ISO-8601 timestamp, phase name, actor (`don-proxy` / `Consigliere` / `Underboss`), verdict (`APPROVE` / `APPROVE-WITH-CONCERNS` / `REJECT` / `SIGN`), citation (Omerta law, Negative Constraint source, or rationale), and artifact pointers. The progressive write is the Risk-002 mitigation: the Don can monitor decisions as they happen rather than reviewing a single end-of-`/heist` summary.

### `docs/gangsta/<feature>/pressure-test-plan.md`

Baseline + change scenario document required for skill changes per `AGENTS.md:18-21`. Authored as part of PR1 work for any heist that touches a skill. Format: per-scenario Setup, Baseline (current behavior), Change (post-implementation behavior), Verification.

## Cost Profile

Autonomous mode is positioned as a **structured fast path**, not as a token-cost reduction. The mandatory Grilling (no flag exists to bypass adversarial brainstorming) means a default `/gangsta:heist` dispatches multiple subagents per round and may exceed gated-mode token spend on small heists.

- **`--rounds=1` floor:** the minimum-cost configuration. Single Grilling round, single proposer / devil's-advocate / synthesizer pass.
- **`--rounds=3` default:** matches the `gangsta:the-grilling` ceiling band (1–7). Default is chosen for adversarial robustness.
- **`--rounds=7` ceiling:** matches the host-skill ceiling. Beyond this is rejected at command parse time.

The fast-path framing replaces any "speed" claim. Speed without structure produces stronzate; the structured fast path preserves discipline at minimum cost.

## Concurrent `/gangsta:heist` — Out of Scope

Two simultaneous `/gangsta:heist` invocations on the same repository are UNDEFINED behavior under the single-Don assumption. No lock file, no concurrency guard, no atomic-write protocol is delivered. A future change may introduce concurrency control if observed in practice; until then, callers MUST serialize their `/gangsta:heist` invocations.

## Omerta Compliance

- [ ] Chain of Command: Real Don retains terminal authority via `/gangsta:go` (sign), `/gangsta:abort` (reject), and the Consigliere's terminal veto in the Sit-Down.
- [ ] Rule of Availability: All checkpoints, ledger entries, and aborted-heist artifacts persisted to disk and recoverable. `autonomous-log.md` written progressively.
- [ ] Rule of Truth: All `signed-by` frontmatter accurately reflects the signing authority — `don-proxy` while pending, `don` after `/gangsta:go`, `don` on the abort marker after `/gangsta:abort`. Forged signatures are forbidden.
- [ ] Spec is Law: The Contract is binding for all post-signature phases. The mini-Grilling under the-Hit cannot mutate it; Contract amendment requires a fresh Sit-Down with fresh Consigliere review.
- [ ] Constitutional Floor Supremacy: don-proxy boldness operates only above the Floor. Omerta and Negative Constraints override boldness in every phase.
