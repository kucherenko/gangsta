---
name: abort
description: Reject a pending-don-confirmation Heist; relocates its directory to docs/gangsta/.aborted/ with marker
args:
  - name: feature
    required: true
    description: Feature name to abort; must exist at docs/gangsta/<feature>/
---

# /gangsta:abort

Rejects a Heist that is awaiting Don confirmation by relocating its working directory under `docs/gangsta/.aborted/` and writing an abort marker. Aborted Heists are physically retained but excluded from all active ledger reads.

## Resolution

- The `feature` argument is REQUIRED. If absent, hard error.
- Resolution is **exact-match-only** against `docs/gangsta/<feature>/` (no fuzzy match, no prefix match, no case-insensitive match — consistent with `/gangsta:go`).
- Hard error conditions (no partial action permitted):
  - `docs/gangsta/<feature>/` does not exist.
  - `docs/gangsta/<feature>/` already resides under `docs/gangsta/.aborted/`.
  - `feature` resolves to a path containing `..` or otherwise escaping `docs/gangsta/`.

## Move Semantics (FR-019)

- **Source:** `docs/gangsta/<feature>/`
- **Destination:** `docs/gangsta/.aborted/<feature>-<ISO-8601-timestamp>/`
  - Timestamp is UTC, second-precision, `YYYYMMDDTHHMMSSZ` form, embedded in the directory name so the same `feature` may be re-attempted later without collision.
- The relocation MUST be atomic on the filesystem (single rename / single mv). No partial state is permitted: either the directory is fully relocated and the marker written, or nothing changed.
- Create `docs/gangsta/.aborted/` if it does not yet exist, before the move.

## Abort Marker

After the move, write `docs/gangsta/.aborted/<feature>-<timestamp>/abort-marker.md` at the new location.

Marker frontmatter (required):

```yaml
---
signed-by: don
rejected: <ISO-8601>
original-path: docs/gangsta/<feature>
---
```

Marker body is free-text and may document the reason for the abort. The body MAY be empty.

## State Cleanup

- If `docs/gangsta/.last-heist` exists and its contents resolve to the aborted feature, clear `docs/gangsta/.last-heist` (FR-019). Clearing means truncating the file to empty or removing it; either is acceptable, but the chosen behavior must be deterministic.
- If `docs/gangsta/.last-heist` points at a different feature, leave it untouched.
- Ledger entries (`insights/`, `fails/`) keyed to this Heist remain physically present on disk. They are NOT deleted, NOT moved, and NOT rewritten. Their effective invisibility is enforced at read time — see § Ledger Exclusion below.

## Ledger Exclusion (FR-020)

Subsequent reads of the ledger by `gangsta:the-ledger` and by the Reconnaissance phase of any future Heist MUST exclude entries whose `heist:` frontmatter key resolves to a directory currently under `docs/gangsta/.aborted/`.

- The exclusion is **content-addressed by `heist:` key**, not by file path. An entry is excluded iff `docs/gangsta/.aborted/<heist-key>-*/` exists for any timestamp suffix.
- Excluded entries MUST NOT influence insights surfaced to the Don, MUST NOT count toward fails matched against new work, and MUST NOT be referenced by reconnaissance dossiers.
- The exclusion is read-side only; aborted ledger files remain on disk for forensic review.

## Acceptance

- AC-014 / FR-019: Aborting a pending-confirmation Heist atomically relocates the artifact tree to `docs/gangsta/.aborted/<feature>-<ISO-8601>/` with `abort-marker.md` written, removing the Heist from active state without data loss.
- AC-015 / FR-019: `.last-heist` is cleared if and only if it points at the aborted feature; pointers to other features are preserved.
- FR-020: After abort, `gangsta:the-ledger` reads and Reconnaissance dossiers exclude entries whose `heist:` key resolves to a directory under `.aborted/`. Aborted files remain on disk for forensic review.
- Re-running a feature with the same name after abort does not collide, due to the timestamped destination directory.

## References

- `skills/autonomous-mode/SKILL.md` — pending-don-confirmation gate semantics.
- `skills/the-ledger/SKILL.md` — ledger read protocol; consumers MUST honor the aborted-exclusion rule defined above.
