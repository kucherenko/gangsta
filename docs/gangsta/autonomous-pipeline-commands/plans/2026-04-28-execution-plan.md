---
heist: autonomous-pipeline-commands
date: 2026-04-28
total-work-packages: 18
territories: 4
estimated-total-budget: 95000
contract: docs/gangsta/autonomous-pipeline-commands/specs/2026-04-28-contract.md
delivery: two-prs
---

# Execution Plan: Autonomous Pipeline Commands

This Plan decomposes the signed Contract into 18 Work Packages organized across 4 Territories. Delivery is split into two pull requests per AD-008 / Contract § PR1 Scope and § PR2 Scope.

PR1 = Territory-A (Skills), Territory-B (Carve-outs + Amendment + Constitution + Pressure-Test Plan).
PR2 = Territory-C (Commands), Territory-D (Plugin + Validation).

The two PRs are independently reviewable. PR2 does not technically depend on PR1 being merged first, but its work packages reference skill files PR1 creates; in practice PR1 lands first.

## Territories

### Territory A: Autonomous-Mode + Don-Proxy Skills (PR1)
**Crew Lead Domain:** Authoring the two new skills that own orchestration and decision authority.
**Files:** `skills/autonomous-mode/SKILL.md`, `skills/don-proxy/SKILL.md`
**Workers:** 2 parallel (one skill per Worker)
**Budget:** 22,000 tokens

### Territory B: Carve-outs, Amendment, Constitution, Pressure-Test Plan (PR1)
**Crew Lead Domain:** Surgical edits to six existing skills, the using-gangsta amendment, the Constitution init, and the pressure-test plan artifact.
**Files:** `skills/reconnaissance/SKILL.md`, `skills/the-grilling/SKILL.md`, `skills/the-sit-down/SKILL.md`, `skills/resource-development/SKILL.md`, `skills/the-hit/SKILL.md`, `skills/laundering/SKILL.md`, `skills/using-gangsta/SKILL.md`, `docs/gangsta/constitution.md`, `docs/gangsta/autonomous-pipeline-commands/pressure-test-plan.md`
**Workers:** 3 parallel (carve-outs, amendment+constitution, pressure-test plan)
**Budget:** 18,000 tokens

### Territory C: Commands (PR2)
**Crew Lead Domain:** Three command manifest files with valid YAML frontmatter and concise behavior documentation.
**Files:** `commands/heist.md`, `commands/go.md`, `commands/abort.md`
**Workers:** 3 parallel (one command per Worker)
**Budget:** 15,000 tokens

### Territory D: Plugin Registration + Validate Extension (PR2)
**Crew Lead Domain:** OpenCode plugin extension, Claude plugin manifest update, validate.sh extension.
**Files:** `.opencode/plugins/gangsta.js`, `.claude-plugin/plugin.json`, `scripts/validate.sh`
**Workers:** 2 parallel (plugin code + validation)
**Budget:** 18,000 tokens

Reserved budget for Crew Lead orchestration and integration: 22,000 tokens.

## Work Packages

### PR1 — Territory A: Skills

#### WP-001: Author `skills/autonomous-mode/SKILL.md`
**Territory:** A
**Contract Clauses:** FR-001, FR-002, FR-003, FR-007, FR-008, FR-009, FR-024, FR-025
**Files:**
- Create: `skills/autonomous-mode/SKILL.md`
**Acceptance Criteria (from Contract):**
1. AC-001: file exists, non-empty, contains section "Per-Phase Interaction Schemas" with subsections for Reconnaissance, the-Grilling, the-Sit-Down, Resource-Development, the-Hit, Laundering.
2. Body specifies: per-phase don-proxy invocation triggers, what triggers REJECT per phase, artifacts produced, preserved unchanged rules.
3. Sit-Down subsection encodes Dual-Veto either-REJECT-terminal (FR-007), auto-advance fires on don-proxy sig + Consigliere non-REJECT (FR-008).
4. Hit subsection encodes deviation-report-only mini-Grilling (FR-009).
5. Laundering subsection encodes ledger frontmatter protocol (FR-024) with three states.
6. Section "State Files" documents `.last-heist`, `autonomous-log.md`, `pressure-test-plan.md` (FR-003).
7. Section "Cost Profile" documents `--rounds=1` floor and "structured fast path" framing (Risk-001 mitigation).
8. Section documents concurrent-`/heist` out-of-scope per FR-025.
9. Zero code blocks. No narrative storytelling (NFR-002).
**Verification:**
- `test -s skills/autonomous-mode/SKILL.md`
- `grep -q '^## Per-Phase Interaction Schemas' skills/autonomous-mode/SKILL.md`
- `grep -q '^### Reconnaissance' skills/autonomous-mode/SKILL.md` (and same for other 5 phases)
- `grep -q 'Dual-Veto' skills/autonomous-mode/SKILL.md`
- `grep -q 'last-heist' skills/autonomous-mode/SKILL.md`
- `! grep -q '^```' skills/autonomous-mode/SKILL.md`
**Budget:** 12,000 tokens
**Dependencies:** None

#### WP-002: Author `skills/don-proxy/SKILL.md`
**Territory:** A
**Contract Clauses:** FR-004, FR-005, FR-006
**Files:**
- Create: `skills/don-proxy/SKILL.md`
**Acceptance Criteria:**
1. AC-002: file exists, non-empty, contains section titled exactly "Constitutional Floor (Non-Negotiable)" referencing both `skills/omerta/SKILL.md` and `docs/gangsta/constitution.md`.
2. Constitutional Floor section explicitly states floor applies to ALL six phases (FR-005 universal scope).
3. Section "Identity" declares distinct from `gangsta:the-consigliere` (FR-004).
4. Section "Persona" documents boldness preference operative only above the floor (FR-006); does NOT instruct overriding Omerta or Negative Constraints.
5. Section "Interaction with Consigliere" clarifies co-equal in Sit-Down dual-veto.
6. Section "Real-Don Relationship" clarifies all proxy signatures are pending-don-confirmation until /go or /abort.
7. Zero code blocks. No narrative storytelling.
**Verification:**
- `test -s skills/don-proxy/SKILL.md`
- `grep -q 'Constitutional Floor (Non-Negotiable)' skills/don-proxy/SKILL.md`
- `grep -q 'omerta/SKILL.md' skills/don-proxy/SKILL.md && grep -q 'constitution.md' skills/don-proxy/SKILL.md`
- `grep -qiE 'all (six )?phases|universal' skills/don-proxy/SKILL.md`
- `! grep -q '^```' skills/don-proxy/SKILL.md`
**Budget:** 10,000 tokens
**Dependencies:** None (parallel with WP-001)

### PR1 — Territory B: Carve-outs, Amendment, Constitution, Pressure-Test

#### WP-003: Carve-out — `skills/reconnaissance/SKILL.md`
**Territory:** B
**Contract Clauses:** FR-010
**Files:**
- Modify: `skills/reconnaissance/SKILL.md`
**Acceptance Criteria:**
1. AC-003: file contains the canonical one-line carve-out reference: `**Autonomous Mode:** When invoked under \`gangsta:autonomous-mode\`, see § Per-Phase Interaction Schemas → Reconnaissance in that skill. Otherwise this skill operates as written.`
2. No other content of the skill changed materially (existing rules preserved).
3. Carve-out placed near the top-level skill section that describes the Don-decision gate, not inside an unrelated subsection.
**Verification:**
- `grep -q 'Autonomous Mode.*gangsta:autonomous-mode' skills/reconnaissance/SKILL.md`
- `grep -q 'Per-Phase Interaction Schemas' skills/reconnaissance/SKILL.md`
- `git diff --stat skills/reconnaissance/SKILL.md` shows minimal addition (no large rewrites)
**Budget:** 1,500 tokens
**Dependencies:** WP-001 (the autonomous-mode skill must exist for the reference to be honest)

#### WP-004: Carve-out — `skills/the-grilling/SKILL.md`
**Territory:** B
**Contract Clauses:** FR-010
**Files:**
- Modify: `skills/the-grilling/SKILL.md`
**Acceptance Criteria:**
1. AC-003: canonical carve-out reference inserted, with phase token "the-Grilling".
2. Existing one-question-at-a-time rule (the-grilling:90-102) and rounds ceiling (the-grilling:22) preserved unchanged.
**Verification:**
- `grep -q 'Autonomous Mode.*gangsta:autonomous-mode' skills/the-grilling/SKILL.md`
- `grep -q 'one question at a time' skills/the-grilling/SKILL.md` (regression check)
**Budget:** 1,500 tokens
**Dependencies:** WP-001

#### WP-005: Carve-out — `skills/the-sit-down/SKILL.md` (lines near 154 and 164)
**Territory:** B
**Contract Clauses:** FR-007, FR-008, FR-010
**Files:**
- Modify: `skills/the-sit-down/SKILL.md`
**Acceptance Criteria:**
1. AC-003: at least one canonical carve-out reference inserted near the Consigliere review section (existing line ~154).
2. Carve-out near the auto-advance section (existing line ~164) clarifies that auto-advance under autonomous mode fires on don-proxy signature with Consigliere non-REJECT.
3. Existing Consigliere review and auto-advance behaviors preserved for non-autonomous (default) usage.
**Verification:**
- `grep -c 'gangsta:autonomous-mode' skills/the-sit-down/SKILL.md` returns >= 1
- `grep -q 'auto-advance' skills/the-sit-down/SKILL.md` (existing rule preserved)
- `grep -q 'Consigliere review' skills/the-sit-down/SKILL.md` (existing rule preserved)
**Budget:** 2,000 tokens
**Dependencies:** WP-001

#### WP-006: Carve-out — `skills/resource-development/SKILL.md`
**Territory:** B
**Contract Clauses:** FR-010
**Files:**
- Modify: `skills/resource-development/SKILL.md`
**Acceptance Criteria:**
1. AC-003: canonical carve-out reference with phase token "Resource-Development".
2. Existing approval gate and Plan format preserved.
**Verification:**
- `grep -q 'Autonomous Mode.*gangsta:autonomous-mode' skills/resource-development/SKILL.md`
**Budget:** 1,500 tokens
**Dependencies:** WP-001

#### WP-007: Carve-out — `skills/the-hit/SKILL.md` (line ~102)
**Territory:** B
**Contract Clauses:** FR-009, FR-010
**Files:**
- Modify: `skills/the-hit/SKILL.md`
**Acceptance Criteria:**
1. AC-003: canonical carve-out reference with phase token "the-Hit".
2. Carve-out placed near existing escalation chain (line ~102) clarifies that mini-Grilling under autonomous mode produces deviation report only and cannot mutate Contract.
3. Existing the-hit:110 auto-advance to laundering preserved unchanged.
**Verification:**
- `grep -q 'Autonomous Mode.*gangsta:autonomous-mode' skills/the-hit/SKILL.md`
- `grep -qE 'deviation report|cannot mutate' skills/the-hit/SKILL.md`
- `grep -q 'auto-advance' skills/the-hit/SKILL.md || grep -q 'Laundering' skills/the-hit/SKILL.md` (regression check)
**Budget:** 2,000 tokens
**Dependencies:** WP-001

#### WP-008: Carve-out — `skills/laundering/SKILL.md`
**Territory:** B
**Contract Clauses:** FR-010, FR-024
**Files:**
- Modify: `skills/laundering/SKILL.md`
**Acceptance Criteria:**
1. AC-003: canonical carve-out reference with phase token "Laundering".
2. Carve-out clarifies that ledger entries written under autonomous mode use frontmatter `signed-by: don-proxy, status: pending-don-confirmation, heist: <feature>` per FR-024.
3. Existing final-declaration and ledger-prompt behaviors preserved.
**Verification:**
- `grep -q 'Autonomous Mode.*gangsta:autonomous-mode' skills/laundering/SKILL.md`
- `grep -qE 'pending-don-confirmation|signed-by.*don-proxy' skills/laundering/SKILL.md`
**Budget:** 1,500 tokens
**Dependencies:** WP-001

#### WP-009: Amendment — `skills/using-gangsta/SKILL.md` line 144
**Territory:** B
**Contract Clauses:** FR-012
**Files:**
- Modify: `skills/using-gangsta/SKILL.md`
**Acceptance Criteria:**
1. AC-004: line 144 amended (or surrounding block) preserves existing two auto-advances (the-sit-down:164, the-hit:110) explicitly cited.
2. Amendment permits autonomous-mode auto-advance with terminal-authority safeguards cited (`/go`, `/abort`, Consigliere terminal veto in Sit-Down).
3. Original "Never auto-advance" intent for default Heist preserved (only the new carve-outs are exceptions).
**Verification:**
- `grep -q 'autonomous-mode' skills/using-gangsta/SKILL.md`
- `grep -q 'the-sit-down' skills/using-gangsta/SKILL.md && grep -q 'the-hit' skills/using-gangsta/SKILL.md`
- `grep -q 'Never auto-advance' skills/using-gangsta/SKILL.md` (original rule still cited)
**Budget:** 2,500 tokens
**Dependencies:** WP-001

#### WP-010: Constitution Init — `docs/gangsta/constitution.md`
**Territory:** B
**Contract Clauses:** FR-013
**Files:**
- Create: `docs/gangsta/constitution.md`
**Acceptance Criteria:**
1. AC-005: file exists with sections for Commandments and Negative Constraints and a cross-reference to `skills/omerta/SKILL.md`.
2. Contains at minimum one seed Negative Constraint: "NEVER weaken or bypass Omerta Law 2 (checkpoints non-negotiable) in any autonomous-mode pathway — Source: this Heist's Recon Dossier" (FR-013).
3. Document framing makes clear future Heists' Laundering may add entries.
**Verification:**
- `test -s docs/gangsta/constitution.md`
- `grep -q '^## Commandments' docs/gangsta/constitution.md`
- `grep -q '^## Negative Constraints' docs/gangsta/constitution.md`
- `grep -q 'omerta/SKILL.md' docs/gangsta/constitution.md`
- `grep -q 'Omerta Law 2' docs/gangsta/constitution.md`
**Budget:** 2,500 tokens
**Dependencies:** None

#### WP-011: Pressure-Test Plan — `docs/gangsta/autonomous-pipeline-commands/pressure-test-plan.md`
**Territory:** B
**Contract Clauses:** NFR-004, AC-019
**Files:**
- Create: `docs/gangsta/autonomous-pipeline-commands/pressure-test-plan.md`
**Acceptance Criteria:**
1. Document specifies the four scenarios listed in Contract § PR1 Scope: Deadlock, Fuzzy-match TOCTOU attempt, Walk-away abort, Constitutional Floor enforcement.
2. Each scenario describes Setup, Baseline (current behavior), Expected Change (post-implementation behavior), and a verification step.
3. Format suitable for copy-paste into PR1 description per AGENTS.md:18-21.
**Verification:**
- `test -s docs/gangsta/autonomous-pipeline-commands/pressure-test-plan.md`
- `grep -c '^### Scenario' docs/gangsta/autonomous-pipeline-commands/pressure-test-plan.md` returns 4
- Each scenario block contains Setup / Baseline / Change / Verification subsections.
**Budget:** 4,000 tokens
**Dependencies:** None

### PR2 — Territory C: Commands

#### WP-012: Command — `commands/heist.md`
**Territory:** C
**Contract Clauses:** FR-014, FR-015, FR-016, AC-006
**Files:**
- Create: `commands/heist.md`
**Acceptance Criteria:**
1. AC-006: valid YAML frontmatter declaring `name: heist`, required positional arg `feature`, flags `--retries` (1-10, default 3), `--rounds` (1-7, default 3), `--best-effort` (default true).
2. Body documents behavior: invokes `gangsta:autonomous-mode` to run Recon → Grilling → Sit-Down → Resource-Dev autonomously; on success writes `docs/gangsta/.last-heist`; emits inline summary; aborts on don-proxy or Consigliere REJECT (FR-016 universal-phase clause cited).
3. Body cites the Contract reference path for traceability.
4. No code blocks containing executable code (frontmatter YAML is allowed; describe behavior in prose).
**Verification:**
- `test -s commands/heist.md`
- Frontmatter parses as valid YAML and contains keys `name`, `args` with `feature` required
- Body mentions `--retries`, `--rounds`, `--best-effort`, `.last-heist`
- Body mentions universal-phase Constitutional Floor abort (FR-016)
**Budget:** 4,500 tokens
**Dependencies:** None (PR2 commands reference PR1 skills by name; PR2 can be authored before PR1 merges, just not invocable until both land)

#### WP-013: Command — `commands/go.md`
**Territory:** C
**Contract Clauses:** FR-017, FR-018, FR-024, AC-006, AC-011, AC-012, AC-013
**Files:**
- Create: `commands/go.md`
**Acceptance Criteria:**
1. AC-006: valid YAML frontmatter declaring `name: go`, optional positional arg `feature`, flags `--retries`, `--best-effort`.
2. Body documents resolution algorithm: with arg → exact dir match required, no fuzzy/Levenshtein, hard error on miss; without arg → read `docs/gangsta/.last-heist`, hard error if missing/stale.
3. Body documents signing event: flips Contract frontmatter from `signed-by: don-proxy, status: pending-don-confirmation` to `signed-by: don, confirmed: <ISO-8601>`; flips matching ledger entries (heist key match per FR-018).
4. Body documents post-signing behavior: invokes Hit → Laundering under autonomous-mode.
**Verification:**
- `test -s commands/go.md`
- Frontmatter valid YAML with `name: go`
- Body explicitly states "no fuzzy match" or "exact match only"
- Body cites `.last-heist` and `signed-by: don`
**Budget:** 5,000 tokens
**Dependencies:** None

#### WP-014: Command — `commands/abort.md`
**Territory:** C
**Contract Clauses:** FR-019, FR-020, AC-006, AC-014, AC-015
**Files:**
- Create: `commands/abort.md`
**Acceptance Criteria:**
1. AC-006: valid YAML frontmatter declaring `name: abort`, required positional arg `feature`.
2. Body documents move semantics: `docs/gangsta/<feature>/` → `docs/gangsta/.aborted/<feature>-<ISO-8601>/`.
3. Body documents `abort-marker.md` written at new location with frontmatter `signed-by: don, rejected: <ISO-8601>, original-path: docs/gangsta/<feature>`.
4. Body documents `.last-heist` clearing if pointed at this feature (FR-019).
5. Body cites that subsequent ledger reads exclude `.aborted/` (FR-020).
**Verification:**
- `test -s commands/abort.md`
- Frontmatter valid YAML with `name: abort`, `feature` required
- Body cites `.aborted/`, `abort-marker.md`, `.last-heist` clearing, ledger exclusion
**Budget:** 4,000 tokens
**Dependencies:** None

### PR2 — Territory D: Plugin + Validation

#### WP-015: Plugin Extension — `.opencode/plugins/gangsta.js`
**Territory:** D
**Contract Clauses:** FR-021, AC-007
**Files:**
- Modify: `.opencode/plugins/gangsta.js`
**Acceptance Criteria:**
1. AC-007: plugin attempts registration of `cfg.command.paths` pointing to `commands/`.
2. If registration fails or key not honored, falls back to directory-based discovery of `commands/` such that all three commands are discoverable.
3. One-line comment adjacent to registration site documents the fallback behavior (FR-021).
4. Existing `cfg.skills.paths` and `cfg.agents.paths` registrations preserved unchanged.
5. Zero new third-party dependencies added (NFR-001 / AGENTS.md:9).
**Verification:**
- `grep -q 'cfg.command' .opencode/plugins/gangsta.js`
- `grep -q 'commands' .opencode/plugins/gangsta.js`
- `grep -q 'cfg.skills' .opencode/plugins/gangsta.js && grep -q 'cfg.agents' .opencode/plugins/gangsta.js` (regression check)
- `git diff package.json` shows no new dependencies (or `package.json` not in diff)
**Budget:** 7,000 tokens
**Dependencies:** WP-012, WP-013, WP-014 (commands directory must exist)

#### WP-016: Manifest Update — `.claude-plugin/plugin.json`
**Territory:** D
**Contract Clauses:** FR-022, AC-008
**Files:**
- Modify: `.claude-plugin/plugin.json`
**Acceptance Criteria:**
1. AC-008: `commands` field added listing the three commands with their manifest file paths.
2. Existing manifest structure preserved (other fields untouched).
3. JSON remains valid (parses cleanly).
**Verification:**
- `python3 -c "import json; d=json.load(open('.claude-plugin/plugin.json')); assert 'commands' in d; assert len(d['commands']) >= 3"` or `node -e "const d=require('./.claude-plugin/plugin.json'); if(!d.commands||d.commands.length<3) process.exit(1)"`
- `grep -q 'heist' .claude-plugin/plugin.json && grep -q 'go' .claude-plugin/plugin.json && grep -q 'abort' .claude-plugin/plugin.json`
**Budget:** 2,500 tokens
**Dependencies:** WP-012, WP-013, WP-014

#### WP-017: Validate Extension — `scripts/validate.sh`
**Territory:** D
**Contract Clauses:** FR-023, AC-009
**Files:**
- Modify: `scripts/validate.sh`
**Acceptance Criteria:**
1. AC-009: validate returns non-zero if any command file missing valid YAML frontmatter, any of the three command files absent, or either new skill missing.
2. Existing skill-presence and CHANGELOG.md checks preserved (regression).
3. Zero new third-party deps; uses standard POSIX shell tools (NFR-001).
**Verification:**
- Run `bash scripts/validate.sh` against the merged tree → exit code 0 with all three commands present
- Run `bash scripts/validate.sh` against a tree with `commands/heist.md` removed → non-zero exit
- Run `bash scripts/validate.sh` against a tree with `skills/autonomous-mode/SKILL.md` removed → non-zero exit
- `grep -q 'commands/' scripts/validate.sh` and `grep -q 'autonomous-mode' scripts/validate.sh && grep -q 'don-proxy' scripts/validate.sh`
**Budget:** 5,500 tokens
**Dependencies:** WP-001, WP-002, WP-012, WP-013, WP-014 (target files must exist for validate to test against them)

### Cross-PR Integration

#### WP-018: Whole-System Integration Verification
**Territory:** Crew Lead orchestration (no single Worker; runs after all of WP-001..017)
**Contract Clauses:** AC-001..021 collectively
**Files:** None modified; verification only
**Acceptance Criteria:**
1. All 22 ACs in the Contract verifiable against the merged PR1+PR2 tree.
2. The four pressure-test scenarios from WP-011 each produce a baseline + change result documented in the PR1 description (NFR-004).
3. `bash scripts/validate.sh` returns exit code 0 against the merged tree.
4. `git diff master..heist/autonomous-pipeline-commands -- package.json package-lock.json bun.lockb yarn.lock` is empty (no dep changes; NFR-001).
5. No code blocks present in any modified or created skill SKILL.md (NFR-002).
**Verification:**
- Run a Sweep using `gangsta:sweep-verification` after all packages report green.
- Manually walk AC-010..AC-018 (the behavioral ACs) using a scratch heist name like `test-feature-pressure-1` against the merged tree.
- Audit-Review per `gangsta:audit-review` before declaring laundering-ready.
**Budget:** 5,000 tokens
**Dependencies:** All other WPs

## Execution Order

### Wave 1 (parallel, no dependencies)
- WP-001 Author autonomous-mode skill
- WP-002 Author don-proxy skill
- WP-010 Constitution init
- WP-011 Pressure-test plan
- WP-012 Command heist.md
- WP-013 Command go.md
- WP-014 Command abort.md

### Wave 2 (parallel, depends on WP-001)
- WP-003 reconnaissance carve-out
- WP-004 the-grilling carve-out
- WP-005 the-sit-down carve-out
- WP-006 resource-development carve-out
- WP-007 the-hit carve-out
- WP-008 laundering carve-out
- WP-009 using-gangsta amendment

### Wave 3 (depends on Wave 1 commands existing)
- WP-015 Plugin extension (depends on WP-012, WP-013, WP-014)
- WP-016 Plugin manifest update (depends on WP-012, WP-013, WP-014)

### Wave 4 (depends on skills + commands existing)
- WP-017 Validate extension (depends on WP-001, WP-002, WP-012, WP-013, WP-014)

### Wave 5 (final integration)
- WP-018 Whole-system integration verification (depends on everything)

## Baseline Verification

- **Tests:** No test suite exists; only `scripts/validate.sh` as the validation harness. `bash scripts/validate.sh` reports 20 passed, 0 failed at baseline (master, commit 6696ecd).
- **Dependencies:** OK. No new dependencies required.
- **Branch:** `heist/autonomous-pipeline-commands` to be created from `master` (commit 6696ecd) before The Hit begins.
- **Working tree:** Clean (only `docs/gangsta/autonomous-pipeline-commands/` untracked, expected).

## Isolation Strategy

- Single feature branch `heist/autonomous-pipeline-commands` off master.
- No worktrees needed: the four territories edit non-overlapping file sets (skill SKILL.md files, doc files, command manifests, plugin/validation files). Conflict surface within Territory B is a single skill (the-sit-down) that gets two carve-outs in WP-005 — handled by sequential edits within that work package.
- PR split: a single branch may produce a PR1 commit set followed by a PR2 commit set, but the commits are organized so that `git log --oneline heist/autonomous-pipeline-commands` cleanly separates PR1 commits from PR2 commits. Alternative: two branches `heist/autonomous-pipeline-commands-pr1` and `heist/autonomous-pipeline-commands-pr2` (preferred for clean PR boundaries). Decided at Hit-launch by Underboss.

## Open Risks Carried From Contract

- Risk-001 [MEDIUM] Token cost of mandatory Grilling — mitigated in WP-001 (Cost Profile section; `--rounds=1` floor).
- Risk-002 [MEDIUM] Single end-of-/heist review gate — mitigated in WP-001 (`autonomous-log.md` progressive write) + WP-014 (`/abort` reject path).
- Risk-003 [LOW] Constitutional Floor enforcement — mitigated by WP-002 (Constitutional Floor section) + WP-011 (pressure-test scenario #4).
- Risk-004 [LOW] `.aborted/` indefinite retention — accepted; no work package required.
