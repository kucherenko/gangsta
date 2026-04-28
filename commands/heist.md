---
name: heist
description: Run the autonomous Heist pipeline (Recon -> Grilling -> Sit-Down -> Resource-Development) for a feature; produces signed-by-don-proxy Contract and Plan
args:
  - name: feature
    required: true
    description: Feature name; becomes the docs/gangsta/<feature>/ directory containing all artifacts
flags:
  - name: retries
    type: integer
    default: 3
    min: 1
    max: 10
    description: Max retry attempts per phase before escalation
  - name: rounds
    type: integer
    default: 3
    min: 1
    max: 7
    description: Grilling rounds budget; 1 = fast path (Risk-001 mitigation)
  - name: best-effort
    type: boolean
    default: true
    description: Continue past non-terminal failures with deviation reports
---

# /gangsta:heist

User-invoked slash command that triggers autonomous Heist execution under don-proxy authority.

## Behavior

Executes the upstream Heist phases end-to-end without per-phase Don confirmation. The don-proxy stands in for the Don at each gate and issues APPROVE / REJECT / ESCALATE decisions against the Contract and Constitutional Floor. All artifacts are written to `docs/gangsta/<feature>/` and marked `pending-don-confirmation` until the Don ratifies them out-of-band or via `/gangsta:go`. The downstream phases (the Hit, Laundering) are NOT run by this command — they execute on `/gangsta:go`.

## Phases Executed

1. **Reconnaissance** — survey codebase, tests, dependencies, ledger; produce dossier
2. **Grilling** — adversarial debate bounded by `--rounds` (1 = fast path); produce conclusions
3. **Sit-Down** — draft formal Contract spec (no code); signed by don-proxy as `pending-don-confirmation`
4. **Resource-Development** — decompose Contract into work packages and execution plan; signed by don-proxy as `pending-don-confirmation`

Phases 5 (the Hit) and 6 (Laundering) execute on `/gangsta:go`.

## Flags

- `--retries <int>` (default 3, range 1-10) — per-phase retry budget before escalation
- `--rounds <int>` (default 3, range 1-7) — Grilling rounds; `--rounds 1` engages the fast path (Risk-001 mitigation)
- `--best-effort <bool>` (default true) — when true, the orchestrator continues past non-terminal failures and emits a deviation report; when false, any phase failure aborts immediately

## Outputs

- `docs/gangsta/<feature>/recon-dossier.md` — reconnaissance output
- `docs/gangsta/<feature>/grilling-conclusions.md` — debate synthesis
- `docs/gangsta/<feature>/contract.md` — Contract, signed by don-proxy, status `pending-don-confirmation`
- `docs/gangsta/<feature>/plans/<date>-execution-plan.md` — Plan, signed by don-proxy, status `pending-don-confirmation`
- `docs/gangsta/<feature>/checkpoints/` — per-phase checkpoint state for resume
- `docs/gangsta/.last-heist` — written with the feature name to enable `/gangsta:go` to resume the most recent Heist
- Inline summary emitted to the user listing artifacts produced and the don-proxy decision trail

## Termination Conditions

- **Constitutional Floor abort:** universal-phase guardrail — if the Consigliere or don-proxy issues REJECT for a Constitutional Floor violation at ANY phase, execution aborts immediately and no further phases run. This is non-overridable, even with `--best-effort true`.
- **Don-proxy REJECT** at a phase gate aborts the pipeline.
- **Retry exhaustion** — any phase that exceeds `--retries` attempts triggers ESCALATE and aborts.
- **On abort:** all work produced so far remains under `docs/gangsta/<feature>/` with `pending-don-confirmation` status visible in the Contract/Plan headers, and `docs/gangsta/.last-heist` is still written so the Don can inspect or resume.

## References

- `skills/autonomous-mode/SKILL.md` — orchestrator that drives phase sequencing, retries, and escalation
- `skills/don-proxy/SKILL.md` — proxy decision protocol (APPROVE / REJECT / ESCALATE) and Constitutional Floor enforcement
- Signed Contract path: `docs/gangsta/<feature>/contract.md`
- Signed Plan path: `docs/gangsta/<feature>/plans/<date>-execution-plan.md`
