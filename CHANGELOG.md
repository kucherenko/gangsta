# Changelog

All notable changes to Gangsta are documented here.

This project adheres to [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-04-13 — Framework Maturity

### Added
- `using-gangsta` — new meta-bootstrap skill that serves as the single entry point for all intent routing through the Borgata hierarchy
- Platform tool mapping references for OpenCode, Copilot CLI, Codex, and Gemini CLI (`references/` directory)
- Proactive memory capture protocol — the orchestrator now automatically offers to save insights or fails to the Ledger after significant exchanges
- Formal framework design spec and implementation plan documents

### Changed
- `the-don` merged into `using-gangsta` — orchestration is now unified under a single bootstrap skill instead of two overlapping roles
- Heist document structure reorganized — all artifacts now live under `docs/gangsta/<heist>/` with `recon/`, `plans/`, and `checkpoints/` subdirectories for clarity
- Phase labels changed from numbers to names across all skills (e.g., "Phase 1" → "Reconnaissance") for readability
- The Grilling: Don now interacts one question at a time per round instead of receiving a bulk summary — tighter adversarial loop
- OpenCode plugin updated to server API

### Fixed
- Checkpoint path references updated across all skills to match the new `docs/gangsta/<heist>/checkpoints/` structure

## [0.3.0] - 2026-04-13 — Software Dev Skills

### Added
- `interrogation-debugging` skill — systematic root-cause interrogation protocol before any fix attempt; prevents premature patching
- `drill-tdd` skill — enforces Red-Green-Refactor with a hard rule: no production code without a failing test first
- `safehouse-worktrees` skill — sets up isolated git worktrees so feature work never contaminates the main workspace
- `audit-review` skill — dispatches `the-inspector` subagent for independent code review after implementation
- `receiving-orders` skill — processes code review feedback with technical rigor, distinguishing valid orders from stronzate
- `sweep-verification` skill — evidence-before-assertions gate that must pass before any "done" claim is made
- `exit-strategy` skill — guides clean branch integration, PR creation, and safehouse cleanup after a Heist
- `the-inspector` agent — independent code review subagent definition with standing audit authority
- Cross-references wired between all new skills and the core Heist pipeline (the-hit, laundering, the-consigliere)
- Software Development Skills section added to README

### Fixed
- Repository URLs corrected from placeholder to `kucherenko/gangsta`
- Installation instructions updated to fetch-and-follow pattern

## [0.2.0] - 2026-04-13 — Cross-Platform

### Added
- OpenCode plugin (`opencode/plugins/gangsta.js`) with session-start hooks for automatic framework bootstrapping
- Platform manifests for Claude Code (`.claude-plugin/`), Cursor (`.cursor-plugin/`), Codex (`.codex/`), and Gemini CLI (`gemini-extension.json`)
- `README.md` — framework philosophy, full Heist Pipeline overview, Borgata Hierarchy table, and installation instructions for all supported platforms
- `AGENTS.md` — contributor guidelines including zero-dependency mandate, skill change requirements, and Omerta law compliance rules

### Fixed
- Session-start hook rewritten to use `awk` for POSIX-compatible YAML frontmatter stripping (replaces non-portable bash workaround)

## [0.1.0] - 2026-04-13 — The Foundation

### Added
- `omerta` skill — the governance foundation; defines the Omerta Laws that govern all agent behavior (anti-hallucination, authorization, spec supremacy, etc.)
- `the-ledger` skill — institutional memory system for Insights, Fails, and the Project Constitution
- `the-consigliere` skill — impartial architectural advisor operating outside the chain of command with authority to invoke truth checks
- `the-underboss` skill — COO-level task decomposition, territory allocation, and resource management
- `the-capo` skill — domain territory commander template for orchestrating Soldier subagents
- `reconnaissance` skill — Phase 1 intel gathering protocol with structured Dossier format
- `the-grilling` skill — adversarial Multi-Agent Debate (Proposer vs Devils-Advocate) with bounded round limits and Don participation
- `the-sit-down` skill — Phase 3 formal contract drafting with strict code prohibition (spec before implementation)
- `resource-development` skill — Phase 4 task decomposition into Work Packages with territory allocation and token budgets
- `the-hit` skill — Phase 5 parallel Soldier execution with TDD enforcement and escalation protocols
- `laundering` skill — Phase 6 verification, integration, Consigliere review, and Ledger update
- Named agent definitions: `soldier`, `devils-advocate`, `proposer`, `synthesizer`, `associate`
- Full 6-phase Heist Pipeline: Reconnaissance → The Grilling → The Sit-Down → Resource Development → The Hit → Laundering
- Borgata hierarchy: Don → Consigliere → Underboss → Capo → Soldiers/Associates
- Project scaffold with `package.json` (MIT license, zero dependencies)

[Unreleased]: https://github.com/kucherenko/gangsta/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/kucherenko/gangsta/compare/v0.3.0...v1.0.0
[0.3.0]: https://github.com/kucherenko/gangsta/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/kucherenko/gangsta/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/kucherenko/gangsta/releases/tag/v0.1.0