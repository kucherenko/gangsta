---
name: go
description: Sign and execute the most recent (or named) autonomous Heist's Hit + Laundering phases
args:
  - name: feature
    required: false
    description: Optional feature name; if omitted, reads docs/gangsta/.last-heist
flags:
  - name: retries
    type: integer
    default: 3
    min: 1
    max: 10
  - name: best-effort
    type: boolean
    default: true
---

# /gangsta:go

The human-Don signing event. Flips a Heist out of `pending-don-confirmation` purgatory into `confirmed` state, then runs the Hit + Laundering phases under `gangsta:autonomous-mode`. Phases 1-4 (Reconnaissance, Grilling, Sit-Down, Resource-Development) are NOT re-run.

## Resolution Algorithm

Resolve the target Heist directory under `docs/gangsta/<feature>/`:

- **With `feature` arg:** REQUIRE an exact directory match at `docs/gangsta/<feature>/`. **Exact match only.** No fuzzy match. No Levenshtein distance. No auto-correct. No closest-suggestion behavior. If the directory does not exist, hard-error and abort. Suggesting alternatives is FORBIDDEN.
- **Without `feature` arg:** read `docs/gangsta/.last-heist`. The file contains the feature slug of the most recently created pending Heist. Hard-error if the file is missing, empty, or points to a non-existent directory under `docs/gangsta/`.

On any resolution failure: emit a hard error and abort. Do not prompt. Do not guess.

## Signing Event

Once the Heist directory is resolved, perform the signing flips atomically before executing any phase:

1. **Contract frontmatter flip** — open the Contract document under the resolved Heist directory. Locate the YAML frontmatter and rewrite:
   - `signed-by: don-proxy` → `signed-by: don`
   - `status: pending-don-confirmation` → remove `status: pending-don-confirmation`
   - Add `confirmed: <ISO-8601 UTC timestamp>` (e.g. `2026-04-28T14:38:00Z`)

2. **Ledger entry flip** — scan the ledger for entries whose `heist:` key matches the resolved feature slug. For each matched entry, rewrite the same fields:
   - `signed-by: don-proxy` → `signed-by: don`
   - `status: pending-don-confirmation` → removed
   - Add `confirmed: <ISO-8601 UTC timestamp>` (same timestamp as the Contract flip)

3. **Atomicity** — all flips (Contract + every matched ledger entry) MUST be applied before any phase executes. If any flip fails, abort and leave the file system in its pre-flip state.

After successful flips, the Heist is no longer `pending-don-confirmation`. It is `signed-by: don, confirmed: <timestamp>`.

## Phases Executed (post-signing)

Under `gangsta:autonomous-mode`, in order:

1. **the-Hit** — dispatch via `skills/the-hit/SKILL.md`. Uses the Plan produced during Phase 4. Honors `retries` flag (default 3, range 1-10) and `best-effort` flag (default true).
2. **Laundering** — invoke via `skills/laundering/SKILL.md`. Integration, verification, Consigliere final review, ledger update.

Phases 1-4 are NOT re-run. The Plan and Contract are read-only inputs at this point.

## Termination Conditions

Abort the run on any of:

- **don-proxy REJECT** — if the don-proxy review path emits REJECT during Hit execution under autonomous-mode.
- **Consigliere REJECT** — Laundering's Consigliere final review returns REJECT.
- **Retry exhaustion** — Worker retries exceed the `retries` flag value.
- **Constitutional Floor abort** — universal abort path applies across all phases. The Constitutional Floor is non-negotiable; any breach terminates the run regardless of phase.

On abort, emit the failure cause and the partial state. The Contract and ledger remain `signed-by: don, confirmed: <timestamp>` — signing is not reversed by execution failure.

## Outputs

- **Contract** — frontmatter is `signed-by: don, confirmed: <ISO-8601>`; `pending-don-confirmation` is removed.
- **Ledger entries** — every matched entry by `heist:` key is `signed-by: don, confirmed: <ISO-8601>`; `pending-don-confirmation` is removed.
- **`docs/gangsta/.last-heist`** — cleared after successful signing (this Heist has exited the `pending-don-confirmation` queue, so the pointer is stale).
- **Inline summary** — emitted to stdout: resolved feature slug, confirmation timestamp, Hit outcome, Laundering outcome, and any abort cause.

## References

- `skills/autonomous-mode/SKILL.md` — autonomous execution governance
- `skills/don-proxy/SKILL.md` — don-proxy signing semantics that `/gangsta:go` overrides
- `skills/the-hit/SKILL.md` — Hit phase execution
- `skills/laundering/SKILL.md` — Laundering phase execution
