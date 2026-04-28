---
heist: autonomous-pipeline-commands
date: 2026-04-28
status: pending-review
---

# Reconnaissance Dossier: Autonomous Pipeline Commands

## Objective

Add two slash commands to the Gangsta framework:

1. **`/gangsta:heist <feature>`** — Run the full Plan stage autonomously, end-to-end, without Don interaction. Produces all spec artifacts: Reconnaissance Dossier → Grilling Conclusions → Contract → Execution Plan.
2. **`/gangsta:go <feature>`** — Run the Implementation stage autonomously: The Hit + Laundering. Reads pre-existing specs from `docs/gangsta/<feature>/` and delivers code.

Failure handling: configurable; default = auto-retry up to 3 times, then best-effort continue. Spec lookup by feature name with fuzzy match for typos.

## Codebase Overview

**Framework structure** (`package.json:1-24`):
- Zero-dependency package, name `gangsta`, v1.7.4
- `main: ".opencode/plugins/gangsta.js"` — only OpenCode has executable plugin code
- Single npm script: `validate` (structural lint via `scripts/validate.sh`)

**Skill format** (`skills/*/SKILL.md`):
- Markdown with YAML frontmatter (`name`, `description`)
- Validated by `scripts/validate.sh:13-21` and `.github/workflows/ci.yml:30-49`
- 19 skills currently in `skills/` directory

**Existing auto-advance precedents** (relevant to our autonomous design):
- `skills/the-sit-down/SKILL.md:164` — "Immediately invoke `gangsta:resource-development` — do NOT ask the Don what to do next, do NOT pause, do NOT prompt for confirmation. Auto-advance is mandatory."
- `skills/the-hit/SKILL.md:110` — Same auto-advance into Laundering.

**Direct contradiction to resolve:**
- `skills/using-gangsta/SKILL.md:144` — "Every phase gate requires Don approval. Never skip a phase. Never auto-advance." This contradicts the two auto-advances above and must be reconciled when introducing autonomous mode.

**Don override mechanism already exists:**
- `skills/using-gangsta/SKILL.md:23-30` — Instruction Priority hierarchy: "Don's explicit instructions" outrank skills. This is the sanctioned lever for the new commands.

**Mandatory gate language to override:**
- `skills/reconnaissance/SKILL.md:90-114` — "MANDATORY GATE — THE SIT-DOWN IS NON-NEGOTIABLE", "Wait for the Don's explicit choice before taking any action", proceed-menu format is fixed.
- `skills/the-grilling/SKILL.md:90-102` — "Don Interrogation Protocol (HARD RULE)" — one question at a time, sequential, mandatory wait.
- `skills/the-sit-down/SKILL.md:79-85` — "Wait for the Don's explicit selection before writing anything."
- `skills/the-sit-down/SKILL.md:158-172` — Contract signing gate.
- `skills/laundering/SKILL.md:96-113` — Ledger prompt + final declaration gate.

**Cross-cutting non-negotiable** (must preserve in autonomous mode):
- `skills/omerta/SKILL.md:30` — "Every phase transition writes a checkpoint BEFORE starting the next phase." Omerta Law 2 (Rule of Availability).

## Slash Command Infrastructure: Per-Platform Status

**Headline: zero slash commands exist in the repo today.** Verified by grep across entire tree. The `gangsta:<skill-name>` token is a Skill tool identifier, NOT a slash command.

| Platform | Manifest | Has commands? | Where new commands go |
|---|---|---|---|
| Claude Code | `.claude-plugin/plugin.json` (19 lines, no `commands` field) | No | `commands/heist.md` + `commands/go.md` (markdown with frontmatter); plugin auto-discovers `commands/` directory |
| OpenCode | `.opencode/plugins/gangsta.js` (registers `cfg.skills.paths`, `cfg.agents.paths` only at lines 39-53) | No | Either `command/heist.md` directory OR register via `cfg.command` in plugin |
| Cursor | `.cursor-plugin/plugin.json` (7 lines, no `commands` field) | No | Likely `commands` field — format undocumented in repo |
| Gemini CLI | `gemini-extension.json` (5 lines, no `commands`) | No | `commands/heist.toml` per Gemini extension convention |
| Codex | `.codex/INSTALL.md` only — manual symlink | No | No known command surface; symlink-only install |
| Copilot CLI | Reuses Claude marketplace via `.claude-plugin/marketplace.json` | No | Likely follows Claude Code convention |

**Implication:** The Hit phase will need to add command files for at minimum Claude Code, OpenCode, Cursor, Gemini CLI. Codex/Copilot may inherit via existing distribution.

## Existing Test Coverage

**Effectively none.**

- `package.json` has no `test` script — only `validate` (line 22).
- `scripts/validate.sh:1-41` checks two things: every `skills/*/` has `SKILL.md`; `CHANGELOG.md` is non-empty.
- `.github/workflows/ci.yml:1-63` runs three jobs: `commitlint` (PR title), `skill-check` (SKILL.md presence), `changelog-check` (CHANGELOG non-empty).
- No `tests/`, `__tests__/`, `*.test.*`, `*.spec.*` files anywhere.
- `AGENTS.md:18-21` requires "adversarial pressure testing" for skill changes — process requirement, manual, documented in PRs.

**Test command:** `npm run validate`.

**Implication for TDD:** drill-tdd's Red-Green-Refactor doesn't have a runtime to fail against. For markdown skills + manifest changes, "tests" must be:
1. Structural: validate.sh extension to check command files exist and have correct frontmatter
2. Behavioral: pressure-test scenarios (per AGENTS.md baseline-vs-change discipline)
3. Integration: invoke the autonomous flow end-to-end on a sample feature, verify all artifacts produced

## Dependencies

**Zero runtime dependencies.** AGENTS.md mandates: "Third-party dependencies (this is a zero-dependency package)" — listed explicitly under "What Will NOT Be Accepted."

**Implication:** Any retry logic, fuzzy matching, etc. must be implemented in the skill's prose instructions — no external libraries. Retry counters are tracked by the AI agent in-context per the skill's checklist.

## Documentation

- `README.md` — public-facing install instructions per platform
- `AGENTS.md` — contributor rules (zero-deps, no Omerta weakening, adversarial testing)
- `docs/gangsta/specs/2026-04-13-gangsta-framework-design.md` — original framework spec (line 214: "gate requiring Don approval before proceeding")
- `docs/gangsta/specs/2026-04-13-gangsta-implementation-plan.md:341` — "Every phase gate requires Don approval. Never skip a phase. Never auto-advance."

**The original framework spec is firmly anti-autonomous.** Adding autonomous-mode commands is a directional shift requiring spec amendment, not just an additive feature.

## Relevant Ledger Entries

### Applicable Insights
**None.** `docs/gangsta/insights/` exists but is empty. No prior insights recorded.

### Applicable Negative Constraints
**None.** `docs/gangsta/fails/` exists but is empty. `docs/gangsta/constitution.md` does not exist.

The Ledger is uninitialized. This Heist will produce the first entries — particularly an Insight on the autonomous-mode design pattern and likely a Commandment about preserving Omerta Law 2 (checkpoints) in any bypass mode.

## Existing Heist Artifacts (for reference patterns)

One real heist exists at `docs/gangsta/changelog-cicd/`:
- `recon/2026-04-14-recon-dossier.md` — 92-line example
- `checkpoints/phase-1-reconnaissance.yaml` (note: `.yaml`, not `.md` as skill spec prescribes — minor format inconsistency to note but not fix in this heist)
- `checkpoints/phase-implementation.yaml`

## Risks and Unknowns

**R1 — Philosophical violation of core framework principle.**
The whole design of the Heist is gate-by-gate Don approval. Adding `/heist` and `/go` legitimizes a parallel "trust mode" that could erode the spec-driven discipline if abused. Mitigation: position as opt-in shortcut for low-risk/well-scoped work; default Heist remains gated.

**R2 — `/gangsta:heist` produces a Contract without Don signing it.**
Currently the Sit-Down's most important moment is the Don literally signing off on the Contract (`the-sit-down:158-172`). Autonomous mode produces an unsigned Contract. **Resolution:** The Don still reviews the artifact post-hoc — the autonomous run delivers a complete bundle; the Don can reject and re-run. But this means the safety net moves from "before code is written" to "before code is written by `/go`." The two-command split is what makes this safe.

**R3 — Grilling without a human.**
The Grilling's value comes from adversarial pressure with the Don participating each round (`the-grilling:90-102`). Autonomous Grilling either skips it or runs proposer/devil's-advocate/synthesizer subagents in a self-contained loop with deterministic termination. The latter preserves more value. Risk: subagent debate without human grounding may converge on stronzate. Mitigation: bounded rounds (default 3, hard ceiling 5); record full transcript so Don can audit.

**R4 — Fuzzy feature-name matching.**
"Detect right feature if it has mistake" requires a matching algorithm. Options: substring, Levenshtein-distance, prefix, last-modified tiebreaker. Must be specified in Contract — no external dependencies allowed. Resolution: simple case-insensitive substring + Levenshtein in skill instructions; if multiple matches, the agent asks the Don to disambiguate (only acceptable interactive moment in `/go`).

**R5 — Retry semantics.**
"Auto-retry 3 times then best-effort continue" needs precise definition. What counts as a phase failure? What does "best-effort" mean for a failed Grilling vs a failed Hit? The Hit failures already have an escalation chain (`the-hit:98-104`); we'd be replacing escalation-to-Don with retry-then-warn. Resolution: Contract must define per-phase failure criteria and what "best-effort continue" looks like (e.g., for Grilling: accept current consensus and annotate; for Hit: continue with remaining work packages and mark failed ones in the Laundering report).

**R6 — Configuration mechanism.**
"Add ability to configure" retry counts. Where does configuration live? Options: command-line args (`/gangsta:heist <feature> --retries=5`), config file (`.gangsta.json`), env vars. Must be specified in Contract.

**R7 — Cross-platform command parity.**
Five platforms, each with its own command format. Must we ship to all of them simultaneously? Or pick one (OpenCode, since that's the only platform the user is currently on per the skill output) and add others incrementally? Recommendation: Tier 1 = OpenCode + Claude Code (most-used); Tier 2 = others.

**R8 — `using-gangsta` contradiction must be edited.**
Line 144 says "Never auto-advance." This is in direct conflict with the two existing auto-advances AND with the new commands. Must be amended in this Heist with a carve-out clause for sanctioned auto-advance directives.

**R9 — `/go`'s relationship to existing auto-advance.**
The Hit already auto-advances to Laundering. So `/go` is essentially "invoke The Hit, let it auto-advance." Question: does `/go` add anything new, or is it just a thin wrapper? It DOES add: spec-locating, fuzzy matching, configurable retry, and skipping the implicit "Resource Dev → Hit" gate (`resource-development:121-124`).

## Recommended Scope

**In scope:**
1. Two new slash commands at minimum on OpenCode + Claude Code platforms.
2. New skill: `gangsta:autonomous-mode` (or similar) — the autonomous orchestration logic, callable by both commands.
3. Amend `using-gangsta/SKILL.md:144` to permit sanctioned auto-advance.
4. Amend `reconnaissance/SKILL.md` MANDATORY GATE language to acknowledge autonomous-mode override.
5. Amend `the-grilling/SKILL.md` to support a "headless Grilling" mode (subagent-only, no human Q&A).
6. Amend `the-sit-down/SKILL.md` to support unsigned-Contract finalization in autonomous mode.
7. Amend `resource-development/SKILL.md` to remove the implicit gate when running under `/heist`.
8. Amend `laundering/SKILL.md` to skip Ledger-prompt and final-declaration gates in autonomous mode.
9. Amend `the-hit/SKILL.md` to substitute autonomous escalation handling for "escalate to Don."
10. Per-phase retry counter logic specified in Contract; default 3, configurable per-command.
11. Fuzzy-match feature lookup for `/go` (case-insensitive substring + Levenshtein, in-prose algorithm).
12. Extend `scripts/validate.sh` to validate command files have required frontmatter.
13. README + AGENTS.md updates explaining autonomous mode and when to use it (NOT default).
14. First Ledger entries: insight (autonomous-mode design pattern) + likely commandment (preserve checkpoints in any mode).

**Out of scope:**
- Cursor / Gemini CLI / Codex / Copilot command files (Tier 2; can be added later or in a follow-up Heist).
- Auto-merge to main (per Don's answer: `/go` ends at Laundering, not exit-strategy).
- Configuration file mechanism (`.gangsta.json`) — start with command-line args only; config file is follow-up.
- Changes to checkpoint format (preserve current format).
- Changes to the actual spec/contract format (preserve current format).

**Boundary on autonomous Grilling:**
Two viable options. The Sit-Down phase will need to choose between them:
- **Option A:** Skip Grilling entirely in autonomous mode (matches reconnaissance choice 2 today).
- **Option B:** Run Grilling with proposer/devil's-advocate/synthesizer subagents in a self-contained debate, no Don participation, bounded rounds.

Option B preserves more design discipline; Option A is simpler. The Grilling phase of THIS Heist will surface this for adversarial debate.

---

How do you want to proceed?

  1. Approve the dossier + run The Grilling → Multi-agent debate on architecture, then The Sit-Down
  2. Approve the dossier + skip The Grilling → Proceed directly to The Sit-Down (spec drafting)
  3. Adjust scope — Add/remove anything from the phases before we commit
  4. Request more intel — Deploy Associates to dig deeper into a specific area
