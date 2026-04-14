---
heist: changelog-cicd
date: 2026-04-14
status: pending-review
---

# Reconnaissance Dossier: Changelog, Versioning & GitHub CI/CD

## Objective

Build a readable CHANGELOG.md with retroactive versioning across existing commit history,
create matching git tags and GitHub Releases, and integrate GitHub CI/CD pipelines for
automated future versioning and release management.

## Codebase Overview

- **Repo:** `git@github.com:kucherenko/gangsta.git`
- **Package:** `gangsta@1.0.0` (package.json — version never bumped, no npm publish)
- **Total commits:** 54, all dated 2026-04-13 (single-day project build)
- **No git tags exist** — all history is unversioned
- **No `.github/` directory** — zero CI/CD infrastructure currently

### Key files
| File | Notes |
|------|-------|
| `package.json` | Version 1.0.0, no scripts defined |
| `README.md` | Good documentation, install + hierarchy docs |
| `AGENTS.md` | Contributor guidelines — explicitly zero-dependency requirement |
| `skills/` | 17 SKILL.md files across the Borgata role and dev discipline skills |
| `agents/` | 6 agent definition markdown files |
| `.opencode/plugins/gangsta.js` | Plugin entry point |
| `.claude-plugin/`, `.cursor-plugin/` | Platform manifests |

### Proposed Retroactive Version Groups

| Version | Name | Boundary Commit SHA | Key Changes |
|---------|------|---------------------|-------------|
| `v0.1.0` | The Foundation | `c3d3fd23` | Core Borgata roles + full 6-phase Heist pipeline (omerta → laundering) + named agents |
| `v0.2.0` | Cross-Platform | `bbb06fc1` | OpenCode plugin, Claude/Cursor/Codex/Gemini manifests, README, awk fix |
| `v0.3.0` | Software Dev Skills | `64bb26bb` | 7 dev discipline skills: interrogation-debugging, drill-tdd, safehouse-worktrees, audit-review, receiving-orders, sweep-verification, exit-strategy + the-inspector agent |
| `v1.0.0` | Framework Maturity | `7bb54562` (HEAD) | using-gangsta bootstrap meta-skill, heist document reorganization, proactive memory capture, phase name refactor |

## Existing Test Coverage

None. No test files, no test runner, no test scripts in package.json.
AGENTS.md mandates "adversarial pressure testing" for skill changes but no automated test infrastructure.

## Dependencies

- **Runtime:** Zero dependencies (explicitly mandated by AGENTS.md)
- **Dev dependencies:** None currently
- **CI/CD dependencies to add:** GitHub Actions only (no npm packages needed)

## Proposed CI/CD Architecture

### `.github/workflows/ci.yml` — PR Validation
- Trigger: `pull_request` to main
- Jobs:
  - **commitlint:** Enforce conventional commits on PR title/commits
  - **skill-check:** Validate every `skills/*/` directory has a `SKILL.md`
  - **changelog-check:** Warn if CHANGELOG.md not updated on feature PRs

### `.github/workflows/release-please.yml` — Automated Release Management
- Tool: Google `release-please-action` (handles conventional commit parsing, CHANGELOG sections, version bumping, GitHub Releases)
- Trigger: push to `main`
- Outputs: Release PR → when merged, creates GitHub Release + git tag automatically

### Retroactive tagging
- Create annotated tags at the boundary commits for v0.1.0, v0.2.0, v0.3.0, v1.0.0
- Create matching GitHub Releases with curated release notes

## Relevant Ledger Entries

None found (docs/gangsta/insights/ and docs/gangsta/fails/ are empty).

## Risks and Unknowns

| Risk | Mitigation |
|------|-----------|
| `release-please` requires conventional commits going forward | Add commitlint CI check; existing history is manually handled |
| No `GITHUB_TOKEN` permissions configured | Standard `release-please` setup handles this via default Actions token |
| Retroactive tags on already-pushed commits require `--force` if previously pushed | No remote tags exist — clean push |
| `release-please` needs a bootstrap manifest for existing version | Create `.release-please-manifest.json` seeded at `1.0.0` |

## Recommended Scope

1. Write `CHANGELOG.md` covering all 4 version groups with curated human-readable entries
2. Create retroactive annotated git tags at boundary commits
3. Create `.github/workflows/release-please.yml` for future automation
4. Create `.github/workflows/ci.yml` for PR validation
5. Add `release-please-config.json` and `.release-please-manifest.json`
6. Update `package.json` to add a `scripts` section (optional lint script)
