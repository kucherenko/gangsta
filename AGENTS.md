# Contributing to Gangsta

## What This Is

Gangsta is an AI agentic skills framework for spec-driven development. Skills are behavior-shaping code, not documentation. They must be tested rigorously.

## What Will NOT Be Accepted

- Third-party dependencies (this is a zero-dependency package)
- Changes that weaken Omerta governance rules
- Skills without adversarial pressure testing
- Bulk PRs with unrelated changes bundled together
- "Improvements" that add complexity without clear value
- Narrative storytelling in skill content (skills are instructions, not blog posts)

## Skill Changes

Every skill change requires:
1. Baseline testing: Run a pressure scenario WITHOUT the change, document behavior
2. Change testing: Run the same scenario WITH the change, document improvement
3. Include both results in your PR

## The Laws Apply to Contributors Too

- Omerta Law 3 (Rule of Truth): Every claim in a PR must be verifiable
- Omerta Law 5 (Spec is Law): Changes must align with the framework design spec
