---
heist: autonomous-pipeline-commands
phase: the-hit
wave: 2-5 (final)
date: 2026-04-28
status: complete
---

# The Hit — Final Checkpoint (Waves 2-5)

## Wave Summary

| Wave | WPs | Branch | Outcome |
|---|---|---|---|
| 1 | WP-001, 002, 010, 011 | pr1 | committed (db26918) |
| 2 | WP-003..009 | pr1 | committed (caea00c) |
| 2.5 | docs (recon/grilling/sit-down/resource-dev/checkpoints + pressure-test-plan) | pr1 | committed (a1fefa3) |
| 3 | WP-012, 013, 014 | pr2 | committed (da7ea33) |
| 4 | WP-015, 016, 017 | pr2 | committed (474e9b7) |
| 5 | WP-018 + Inspector fixes | pr2 | committed (992c6bb) |

## Branches

- `heist/autonomous-pipeline-commands-pr1` @ a1fefa3 (3 commits, 1763 lines added across 20 files)
- `heist/autonomous-pipeline-commands-pr2` @ 992c6bb (3 commits, 286 lines added across 6 files; stacks on PR1)

## Acceptance Criteria

All 22 ACs from the Contract verified by Underboss sweep:

- AC-001..005 (PR1): autonomous-mode skill, don-proxy skill w/ Constitutional Floor, six carve-outs, using-gangsta amendment, Constitution seed — all PASS with file:line evidence.
- AC-006..018, AC-022 (PR2): three commands with valid frontmatter, plugin/manifest/validate wiring, exact-match-only `/go`, `.aborted/` relocation, atomic don-proxy→don flip, Hit+Laundering scope only, validate.sh 30/0 — all PASS.
- AC-019: pressure-test-plan.md present with 4 mandatory scenarios (deadlock, fuzzy-match TOCTOU, walk-away abort, Constitutional Floor enforcement) — present in PR1 tree; AC-019 final clearance requires the four results pasted into the GitHub PR1 description (PR-author responsibility).
- AC-020: NFR-001 zero-deps verified; `git diff master..HEAD -- package.json bun.lock package-lock.json yarn.lock` returns empty.
- AC-021: NFR-002 zero fenced code blocks in skills/autonomous-mode/SKILL.md and skills/don-proxy/SKILL.md.

## Inspector Audits

Both PRs audited via `general` subagent reading `agents/the-inspector.md` as role prompt (the-inspector subagent type not registered in this OpenCode session — workaround used per Don directive).

| PR | Task ID | Critical | Important | Minor | Verdict |
|---|---|---|---|---|---|
| PR1 | ses_22bdc6f70ffexkHCzAccfrv2mX | 0 | 0 | 3 | Ready: Yes |
| PR2 | ses_22bdc1b47ffeKpYxmGrVi9XFPb | 0 | 0 | 3 | Ready: Yes |

PR1 Minor items deferred to ledger follow-ups (touch already-committed PR1 carve-outs):
- the-sit-down/SKILL.md:170 wording duplication w/ autonomous-mode:78 (FR-011 smell, no current drift)
- laundering/SKILL.md:86 ledger frontmatter protocol duplicates autonomous-mode:142
- constitution.md sections 9, 13 — empty placeholder bodies

PR2 Minor items addressed in commit 992c6bb:
- abort.md Acceptance section: AC-006 mis-citation fixed; rewritten with AC-014/015/FR-019/FR-020 references.
- validate.sh: command-frontmatter check tightened to require non-empty `description:` (FR-023a). Negative-case verified.

PR2 Minor item deferred:
- go.md:60 `.last-heist` clearing on success — sensible inference but not strictly bound to FR-018. Documented as ledger follow-up.

## Underboss Verification

- validate.sh: **30 passed / 0 failed** on PR2 HEAD (was 22 baseline + 8 new checks added by WP-017).
- node --check on .opencode/plugins/gangsta.js: OK.
- node parse of .claude-plugin/plugin.json: 3 commands, name/version preserved.
- git diff package.json bun.lock: zero bytes.

## Don Override Recorded

- drill-tdd skill not invoked for the implementation phase: artifacts are markdown manifests (commands/, SKILL.md, JSON) and one shell extension. Verification was scripted via validate.sh + grep + node --check + negative-case testing rather than xUnit-style red/green. Don approved this override at Sit-Down. To be recorded as Ledger Insight in Laundering.

## Subagent Workaround Recorded

- `soldier` and `the-capo` subagent types not registered in this OpenCode plugin instance; only `explore` and `general` are available. Workers were dispatched as `general` subagents reading their role files (agents/soldier.md, agents/the-inspector.md) as their primary prompt. Output quality remained acceptable. To be recorded as Ledger Fail/Insight in Laundering for future Heists running on environments where the subagent registry differs from the Borgata default.

## Ready for Phase 6

The Hit phase is complete. Both branches are stable with passing validation, clean Inspector audits, and full AC coverage. Next: invoke `gangsta:laundering` for integration verification, Consigliere final review, and Ledger update.
