---
heist: pi-dev-extension
date: 2026-05-01
total-work-packages: 5
territories: 2
estimated-total-budget: 6000
---

# Execution Plan: pi.dev Extension

## Territories

### Territory A: pi Extension Core
**Crew Lead Domain:** TypeScript extension factory, package manifest
**Files:** `.pi/extensions/gangsta/index.ts`, `.pi/extensions/gangsta/package.json`
**Work Packages:** WP-001, WP-002
**Workers:** 1 (WP-001 before WP-002 for clarity; both are small)
**Budget:** 2500 tokens

### Territory B: Supporting Artifacts
**Crew Lead Domain:** Reference documentation, installation guide, validation script
**Files:** `skills/using-gangsta/references/pi-tools.md`, `.pi/INSTALL.md`, `scripts/validate.sh`
**Work Packages:** WP-003, WP-004, WP-005
**Workers:** 3 (fully parallel — no dependencies between them)
**Budget:** 3500 tokens

---

## Work Packages

### WP-001: Extension Package Manifest
**Territory:** A — pi Extension Core
**Contract Clause:** FR-006, NFR-001, NFR-002
**Files:**
- Create: `.pi/extensions/gangsta/package.json`
**Acceptance Criteria:**
1. File exists at `.pi/extensions/gangsta/package.json`
2. Contains `"pi": { "extensions": ["index.ts"] }`
3. Contains `"dependencies": {}`
4. `grep -r "FR-\|NFR-\|WP-" .pi/extensions/gangsta/package.json` returns no matches
**Verification:** `cat .pi/extensions/gangsta/package.json | python3 -c "import sys,json; d=json.load(sys.stdin); assert d['pi']['extensions']==['index.ts']; assert d['dependencies']=={};  print('OK')"`
**Budget:** 300 tokens
**Dependencies:** None

---

### WP-002: Extension Entry Point (index.ts)
**Territory:** A — pi Extension Core
**Contract Clause:** FR-001, FR-002, FR-003, FR-004, FR-005, NFR-002, NFR-003, NFR-005
**Files:**
- Create: `.pi/extensions/gangsta/index.ts`
**Acceptance Criteria:**
1. File exists at `.pi/extensions/gangsta/index.ts`
2. Exports a default factory function accepting a `pi` parameter (ExtensionAPI)
3. Calls `pi.on("before_agent_start", ...)` to inject the condensed bootstrap prompt
4. Condensed prompt contains: hierarchy summary, 1% rule, skill table with all 21 skill names and relative paths (`skills/<name>/SKILL.md`), intent routing table
5. Registers `gangsta:heist`, `gangsta:go`, `gangsta:abort` via `pi.registerCommand`
6. Each command reads from `commands/heist.md`, `commands/go.md`, `commands/abort.md` using `node:path` and `node:fs` (no other imports)
7. Path resolution uses `path.resolve(__dirname, '../../../commands/')` with `process.cwd()` fallback
8. File is ≤ 150 lines
9. `grep -r "FR-\|NFR-\|WP-" .pi/extensions/gangsta/index.ts` returns no matches
**Verification:** `wc -l .pi/extensions/gangsta/index.ts` (must be ≤ 150); `grep -c "registerCommand" .pi/extensions/gangsta/index.ts` (must be 3); `grep -c "before_agent_start" .pi/extensions/gangsta/index.ts` (must be 1)
**Budget:** 2000 tokens
**Dependencies:** WP-001 (package.json defines the module context)

---

### WP-003: Platform Tool Mapping Reference
**Territory:** B — Supporting Artifacts
**Contract Clause:** FR-008, NFR-002
**Files:**
- Create: `skills/using-gangsta/references/pi-tools.md`
**Acceptance Criteria:**
1. File exists at `skills/using-gangsta/references/pi-tools.md`
2. Contains a tool mapping table mapping pi.dev platform tool names to canonical Claude Code tool names
3. Follows the structure of `skills/using-gangsta/references/opencode-tools.md` (heading, table format, notes)
4. Covers at minimum: file read/write/edit, bash execution, search (grep/glob), and subagent dispatch equivalents for pi.dev
5. `grep -r "FR-\|NFR-\|WP-" skills/using-gangsta/references/pi-tools.md` returns no matches
**Verification:** `ls skills/using-gangsta/references/pi-tools.md && echo OK`
**Budget:** 800 tokens
**Dependencies:** None

---

### WP-004: Installation Guide
**Territory:** B — Supporting Artifacts
**Contract Clause:** FR-007, NFR-002
**Files:**
- Create: `.pi/INSTALL.md`
**Acceptance Criteria:**
1. File exists at `.pi/INSTALL.md`
2. Documents the steps to enable the extension in a pi.dev project (at minimum: where to place `.pi/` directory relative to project root, how pi.dev discovers extensions)
3. Lists all three accepted risks with their severity: `__dirname` under jiti (MEDIUM), `ctx.ui.notify()` channel (LOW), bootstrap prompt drift (MEDIUM)
4. States that zero runtime dependencies are required (`dependencies: {}` in package.json)
5. `grep -r "FR-\|NFR-\|WP-" .pi/INSTALL.md` returns no matches
**Verification:** `ls .pi/INSTALL.md && grep -c "MEDIUM\|LOW" .pi/INSTALL.md` (must be ≥ 3)
**Budget:** 600 tokens
**Dependencies:** None

---

### WP-005: validate.sh Scan Exception
**Territory:** B — Supporting Artifacts
**Contract Clause:** FR-009
**Files:**
- Modify: `scripts/validate.sh`
**Acceptance Criteria:**
1. `scripts/validate.sh` contains a new check that verifies `.pi/extensions/gangsta/index.ts` exists and is non-empty
2. `scripts/validate.sh` contains a new check that verifies `.pi/extensions/gangsta/package.json` exists and is non-empty
3. `npm run validate` passes with 32 or more tests (30 baseline + 2 new)
4. No existing checks are removed or weakened
**Verification:** `npm run validate` exits 0
**Budget:** 500 tokens
**Dependencies:** WP-001, WP-002 must exist before validate.sh check can pass

---

## Execution Order

**Group 1 — Parallel (no dependencies):** WP-001, WP-003, WP-004
**Group 2 — After Group 1:** WP-002 (requires WP-001 context), WP-005 (requires WP-001 and WP-002 to exist for verification)

Optimal execution:
1. WP-001 + WP-003 + WP-004 in parallel
2. WP-002 + WP-005 after WP-001 completes

---

## Baseline Verification

- **Validation:** PASS — 30 tests, 0 failures (verified on master branch)
- **Dependencies:** OK — zero runtime deps at root
- **Branch:** master (switched from `heist/spec-id-leakage`; Don confirmed master direct)
- **Untracked files:** `docs/gangsta/pi-dev-extension/` (heist artifacts — not part of deliverables)
- **Merge conflicts:** None — master is up to date with origin/master
