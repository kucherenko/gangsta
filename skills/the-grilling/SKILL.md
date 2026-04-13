---
name: the-grilling
description: Use when adversarial brainstorming is needed after reconnaissance — runs a multi-agent debate with proposer, devils-advocate, and synthesizer subagents, with the don participating each round, bounded by hard round limits to prevent infinite loops
---

# The Grilling: Adversarial Brainstorming (Phase 2)

## Overview

The Grilling is a structured Multi-Agent Debate (MAD) protocol. Before any plan is set in stone, agents engage in adversarial brainstorming to explore solutions, test feasibility, and enumerate options exhaustively. The Don participates every round.

## Trigger

Invoked after the Don approves the Reconnaissance Dossier (Phase 1 complete).

## Round Limits (HARD RULES)

| Limit | Value | Rule |
|-------|-------|------|
| Minimum rounds | 2 | No Premature Consensus — 1-round agreement is suspicious |
| Default maximum | 5 | Standard debate ceiling |
| Hard ceiling | 7 | Don can extend from 5 to 7 if debate is productive |
| Early exit | After round 2 | Don can declare consensus at any point after round 2 |

**These limits are non-negotiable.** If round 7 is reached without Nash Equilibrium, the debate ENDS and the Synthesizer produces a "Best Available Consensus."

## The Protocol

### Round 1

1. **Proposer** (subagent) — Reads the Reconnaissance Dossier and proposes an architectural solution. The proposal must include:
   - Architecture overview
   - Key technical decisions with rationale
   - File structure changes
   - Potential risks (Inverse Reasoning requirement)

2. **Devils-Advocate** (subagent) — Attacks the proposal:
   - Find architectural flaws
   - Identify security gaps
   - Check against Constitution Negative Constraints
   - Enumerate potential regressions
   - Assess scalability concerns

3. **Don** (user) — Asked for opinion, **one question at a time**:
   > Present the summary and concerns, then ask one question first: "Do you agree with the Devil's-Advocate's attack?" Wait for the answer. Then ask: "Any concerns they missed?" Wait. Then: "Do you want to override any part of the proposal?" Wait. Collect all answers before passing to the Synthesizer.

4. **Synthesizer** (subagent) — Incorporates:
   - Valid attacks from the Devils-Advocate
   - Don's feedback and concerns
   - Defends valid elements of the original proposal
   - Produces a revised solution

### Rounds 2..N

Same cycle: Devils-Advocate attacks → Don weighs in → Synthesizer revises.

### Termination Conditions

The Grilling ends when ANY of these is true:

1. **Nash Equilibrium** — The Devils-Advocate cannot raise a NEW valid objection AND the Don has no remaining concerns
2. **Don declares consensus** — After round 2, the Don can say "I'm satisfied, proceed"
3. **Round limit reached** — At round 5 (or 7 if extended), the Synthesizer produces Best Available Consensus

### At Round 5 (Default Maximum)

Ask the Don:
> "We've completed 5 rounds of The Grilling. [Summarize current state]. Do you want to:
> 1. Accept the current consensus and proceed
> 2. Extend the debate (up to 2 more rounds)
> 3. Kill this proposal and start over"

### Best Available Consensus (Forced Termination)

If the hard ceiling is reached:

```markdown
## Best Available Consensus

**Proposal:** <Final revised solution>

### Resolved Points
- <Points where all parties agree>

### Unresolved Objections
1. <Objection> — Risk: HIGH/MEDIUM/LOW — Mitigation: <if any>
2. ...

### Don's Decision Required
Accept this consensus (with documented risks), reject and restart, or table.
```

## Don Interrogation Protocol (HARD RULE)

Every interaction with the Don asks **one question at a time**. Wait for the Don's answer before asking the next question.

This rule overrides any template or subagent output that bundles multiple questions into a single message. The orchestrating agent (the one running The Grilling) must:

1. Identify all questions a subagent raises for the Don
2. Prioritize them by importance (most critical decision first)
3. Present the first question, wait for the Don's response
4. Present the next question, wait again
5. Repeat until all questions are answered
6. Collect all Don responses and pass them to the next subagent as a batch

This applies to:
- Round 1 and 2..N Step 3 (Don weighs in)
- The Round 5 extension decision (remains a single choice — one decision, not multiple questions)
- Any questions the Synthesizer or Proposer raise for the Don

**Why:** The Don gives better answers to one question than to three asked simultaneously. Bundled questions force mental juggling and produce lower-quality decisions.

## Repetition Detection

If the Devils-Advocate repeats a previously-addressed objection:
1. The Synthesizer flags it: "This objection was addressed in Round N"
2. It counts as a no-new-attack round
3. This accelerates toward Nash Equilibrium

## Stronzate Detection

If the Devils-Advocate's attacks are consistently weak or off-topic:
1. The Synthesizer flags it: "Attacks in this round lack specificity"
2. The Don is informed that the debate may have reached natural consensus
3. The Don can declare early exit

## Subagent Prompts

The Proposer, Devils-Advocate, and Synthesizer are dispatched as subagents using prompts in this directory:
- `proposer-prompt.md` — Prompt template for the Proposer
- `devils-advocate-prompt.md` — Prompt template for the Devils-Advocate
- `synthesizer-prompt.md` — Prompt template for the Synthesizer

## Output

The Grilling does NOT produce a standalone transcript file. Instead, the orchestrating agent produces a **Grilling Conclusions** summary at the end of the debate. This summary is passed directly to the next phase (The Sit-Down) for inclusion in the Contract.

The Grilling Conclusions must contain:
- **Key Decisions:** Each architectural/design decision reached, with rationale
- **Rejected Alternatives:** Each option that was considered and discarded, with the reason
- **Unresolved Objections:** Any risks acknowledged but accepted (from Best Available Consensus)
- **Termination Reason:** Nash Equilibrium / Don declared / Round limit

The orchestrating agent holds this summary in context — it is NOT saved as a separate file.

## Checkpoint

```yaml
---
heist: <heist-name>
phase: the-grilling
status: completed
timestamp: <ISO 8601>
next-action: Proceed to The Sit-Down (Phase 3)
artifacts: []
note: Grilling Conclusions passed in-context to The Sit-Down for inclusion in the Contract
---
```

## Omerta Compliance
- [ ] Introduction Rule: Proposer, Devils-Advocate, and Synthesizer do not communicate directly — all mediated through this skill
- [ ] Rule of Truth: All attacks and proposals must cite Recon Dossier, Constitution, or specific technical facts
- [ ] Rule of Availability: Transcript and checkpoint saved after completion
