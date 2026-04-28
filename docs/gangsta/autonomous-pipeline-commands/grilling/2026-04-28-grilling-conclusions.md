---
heist: autonomous-pipeline-commands
phase: grilling
date: 2026-04-28
status: consensus-reached
rounds: 2
verdict: APPROACHING CONSENSUS — proceed to Sit-Down
---

# Grilling Conclusions — autonomous-pipeline-commands

Two adversarial rounds. Devils-Advocate produced 9 Round-1 fatal flaws and 11 Round-2 findings (3 CRITICAL). Don ruled on all blocking questions. All CRITICAL/HIGH findings resolved. No findings repeated across rounds. Consensus reached.

## Final Agreed Architecture

### Two new skills
- **`gangsta:autonomous-mode`** — orchestrates `/heist` and `/go`. Owns per-phase don-proxy interaction schemas (centralized, six subsections). State files: `docs/gangsta/.last-heist`, `docs/gangsta/<feature>/autonomous-log.md`, `docs/gangsta/<feature>/pressure-test-plan.md`.
- **`gangsta:don-proxy`** — distinct from Consigliere. Surrogate Don for autonomous gates. Persona: bold, decisive — bounded by **Constitutional Floor** (non-negotiable, applies across ALL phases): MUST reject any artifact violating Omerta laws or active Negative Constraints in `docs/gangsta/constitution.md`.

### Three new commands
- **`/gangsta:heist <feature>`** — runs Recon → Grilling → Sit-Down → Resource-Dev autonomously. Writes `docs/gangsta/.last-heist` on success. Inline summary at completion.
- **`/gangsta:go [feature]`** — signing event. Flips Contract + ledger frontmatter from `signed-by: don-proxy, status: pending-don-confirmation` to `signed-by: don, confirmed: <ISO-8601>`. Then runs Hit → Laundering. **Exact directory match only** (no fuzzy match). Falls back to `.last-heist` if no arg.
- **`/gangsta:abort <feature>`** — moves heist dir to `docs/gangsta/.aborted/<feature>-<timestamp>/` with `abort-marker.md` (`signed-by: don, rejected: <ts>`). Clears `.last-heist` if pointed to feature.

### CLI flags
- `/heist`: `--retries=N` (1-10, default 3), `--rounds=N` (1-7, matches the-grilling ceiling, default 3), `--best-effort=true`
- `/go`: `--retries=N`, `--best-effort=true`
- `--no-grilling` DROPPED (mandatory grilling)

### Six skill carve-outs (one-line references)
In `reconnaissance`, `the-grilling`, `the-sit-down` (lines 154 and 164), `resource-development`, `the-hit` (line 102), `laundering`:

> **Autonomous Mode:** When invoked under `gangsta:autonomous-mode`, see § Per-Phase Interaction Schemas → \<Phase\> in that skill. Otherwise this skill operates as written.

### using-gangsta:144 amendment
Preserves existing auto-advances (`the-sit-down:164`, `the-hit:110`); adds clause that autonomous-mode triggers do not bypass Omerta L1 (real Don retains terminal authority via `/go`/`/abort`).

### Sit-Down Dual-Veto Protocol
Both Consigliere and don-proxy must non-REJECT. Either REJECT is **terminal** → abort heist. Auto-advance at `the-sit-down:164` fires on **don-proxy signature with Consigliere non-REJECT**.

### Hit Phase Constraint
Mini-Grilling (`the-hit:102`) under autonomous mode cannot mutate Contract. Produces deviation report only. Contract amendments require fresh Sit-Down with Consigliere review.

### Ledger Protocol
Autonomous entries written to real `docs/gangsta/insights/` and `fails/` with `signed-by: don-proxy, status: pending-don-confirmation`. `/go` flips status. `/abort` relocates to `.aborted/` (excluded from active ledger reads).

### Delivery (two PRs)
- **PR1:** `gangsta:autonomous-mode` skill, `gangsta:don-proxy` skill, six carve-outs, using-gangsta:144 amendment, `docs/gangsta/constitution.md` init, baseline + change pressure-test plan in PR description (per AGENTS.md:18-21).
- **PR2:** `commands/heist.md`, `commands/go.md`, `commands/abort.md`; `.opencode/plugins/gangsta.js` extension to register `cfg.command.paths` (with directory-discovery fallback); `.claude-plugin/plugin.json` `commands` field; `scripts/validate.sh` extended for command frontmatter validation.
- **Future PR (post-PR2):** `/gangsta:purge-aborted` command for `.aborted/` cleanup. NOT in PR2.

## Don Decisions Across Rounds

### Round 1
- Q1: Two new skills (autonomous-mode + don-proxy) over single skill or amendment-only
- Q2: Mandatory Grilling (drop `--no-grilling`)
- Q3: Reject `signatories: [autonomous-mode]` forged signature; use Consigliere/don-proxy proxy signature
- Q4: Drop `proposed-ledger/` two-tier; use real ledger with `signed-by` frontmatter
- Q5: New skill `gangsta:don-proxy` (NOT amend Consigliere)
- Q6: Inline summary at end of /heist; Don then runs next command in chat
- Q7: `/go` itself is the signing event

### Round 2
- Q1: Accept all 8 DA minimum fixes verbatim (Consigliere terminal veto; drop fuzzy-match for `.last-heist` exact-match; constitutional floor; /abort command; centralize per-phase schemas; pressure tests in PR1; --rounds 1-7; auto-advance fires on don-proxy sig)
- Q2: Constitutional Floor applies to **ALL phases** (universal, not just Sit-Down)
- Q3: Concurrent `/heist` is out-of-scope; document only (no lock file)
- Q4: `.aborted/` indefinite retention; future `/gangsta:purge-aborted` command (separate post-PR2)

## Resolved Concerns Map

### Round 1 Devils-Advocate findings (9) — all resolved
1. Consigliere-override of Omerta → Round 1 Q1: don-proxy is separate skill; Round 2 Fix #1: Consigliere terminal veto
2. Headless Grilling = shadow coordination → don-proxy participates as sanctioned principal
3. `/approve` 3rd command → dropped; `/go` is signing event
4. Forged signatories → real signature `signed-by: don-proxy, proxy-for: don`
5. Proposed-ledger two-tier complexity → dropped; real ledger with frontmatter
6. `--no-grilling` abuse → flag dropped
7. Bulk PR violation → split PR1/PR2
8. Auto-advance precedent contradiction → using-gangsta:144 amendment with explicit carve-out
9. Six carve-outs blast radius → centralized in autonomous-mode § Per-Phase Interaction Schemas

### Round 2 Devils-Advocate findings (11) — all resolved
1. Don-proxy/Consigliere deadlock → Consigliere terminal veto (Fix #1)
2. /go fuzzy-match TOCTOU → `.last-heist` + exact match (Fix #2)
3. Don-proxy no constitutional floor → § Constitutional Floor universal (Fix #3 + Q2)
4. No reject UX → `/gangsta:abort` (Fix #4)
5. Carve-out drift → centralized schemas (Fix #5)
6. Pressure-test mandate → PR1 description (Fix #6)
7. --rounds=5 vs grilling-7 regression → range 1-7 (Fix #7)
8. the-sit-down:164 auto-advance ambiguity → fires on don-proxy sig + Consigliere non-REJECT (Fix #8)
9. Ledger pollution before /go → `pending-don-confirmation` + abort relocation (Fix #4+#8)
10. the-hit:102 mini-Grilling backdoor → deviation-report-only; no Contract mutation
11. Bulk PR concern → two-PR split retained; post-PR2 deferral for /purge-aborted

## Open Concerns Acknowledged but Acceptable
- **Token cost of mandatory Grilling**: bounded by `--rounds=1` floor. Speed claim restated as "structured fast path" not "minimum-token path."
- **Single end-of-/heist review**: bounded by progressive `autonomous-log.md` + `/abort` escape valve.

## Nash Equilibrium
Achieved. DA Round 2 produced 11 new findings (proves Round 1 was not premature consensus). Don accepted all 8 minimum fixes verbatim. No CRITICAL or HIGH findings unresolved. New mechanisms (terminal veto, .last-heist, abort, floor) each have documented mitigations or are bounded by existing Omerta laws. Round 3 would produce diminishing-return findings.

## Recommendation
**APPROACHING CONSENSUS — proceed to Sit-Down (Phase 3).**
