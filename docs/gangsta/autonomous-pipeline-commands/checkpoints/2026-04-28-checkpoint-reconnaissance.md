---
heist: autonomous-pipeline-commands
phase: reconnaissance
status: completed
timestamp: 2026-04-28T00:00:00Z
next-action: Proceed to The Grilling
artifacts:
  - docs/gangsta/autonomous-pipeline-commands/recon/2026-04-28-recon-dossier.md
---

## Resume Context

Don approved dossier with choice 1 (Grilling + Sit-Down). Heist objective: add `/gangsta:heist <feature>` (autonomous Plan stage) and `/gangsta:go <feature>` (autonomous Hit + Laundering) commands. Default retry 3 then best-effort, fuzzy feature-name match for `/go`. Tier 1 platforms: OpenCode + Claude Code.

Key tensions to grill:
- Headless Grilling: Option A skip vs Option B subagent-debate
- Reconciling `using-gangsta:144` ("Never auto-advance") with new commands
- Unsigned-Contract safety in autonomous mode
- Per-phase retry/best-effort semantics
- Fuzzy match algorithm (zero-dependency constraint)
