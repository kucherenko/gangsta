---
name: the-grilling
description: Use when adversarial brainstorming is needed after reconnaissance — the Proposer, Devils-Advocate, and Synthesizer each run ONE pass (no rounds); the Don is grilled on the IDEA first, one question at a time, then the proposal is attacked
---

# The Grilling: Adversarial Brainstorming

## Overview

The Grilling is a single-pass Multi-Agent Debate. The Proposer proposes, the Devils-Advocate attacks (idea first, then proposal), the Synthesizer revises. There are NO rounds — each agent runs exactly once. The Don is interrogated **one question at a time**, never a list. The IDEA is grilled before the proposal.

## Trigger

Invoked after the Don approves the Reconnaissance Dossier (Reconnaissance complete).

## HARD RULES (non-negotiable)

1. **No rounds.** Each agent — Proposer, Devils-Advocate, Synthesizer — runs exactly ONCE. Do not loop back. There is no Round 2.
2. **Idea first.** The Devils-Advocate attacks the Don's objective (the IDEA) before attacking the proposal. The Don is grilled on the idea — framing, assumptions, scope, analogues from the Recon Dossier — before any architecture is proposed.
3. **One question at a time.** Every interaction with the Don asks exactly ONE question. Wait for the answer before asking the next. This overrides any subagent output that bundles questions. See Don Interrogation Protocol below.
4. **No lists of questions.** A message to the Don that contains 2+ distinct questions is a violation, even if they are numbered. Ask the most critical question first; only after it is answered, decide whether the next question is still needed.

## The Protocol (single pass)

### Phase A — Grill the IDEA

Before any proposal is built, the orchestrating agent grills the Don on the objective itself, drawing on the Recon Dossier (especially analogues, prior art, and the Constraint & Risk Survey in greenfield mode).

1. The orchestrating agent reads the Recon Dossier and extracts every unresolved assumption, scope ambiguity, and analogue-comparison decision that the Don must make.
2. Prioritize these questions: most critical to the idea's validity first (problem framing → hidden assumptions → scope → analogue choices).
3. Ask the Don **one question at a time**. After each answer, decide whether the next planned question is still relevant — the Don's answer may resolve it, may obsolete it, or may surface a new, more urgent question.
4. Continue until no critical idea-level question remains. The Don may also say "the idea is settled, move to architecture."

**Idea Verdict (orchestrating agent):**
- **REJECT** — the objective as stated is flawed; the Don must redefine it. Halt and ask the Don to restate the objective or abort.
- **CHALLENGE** — the objective needs the refinements captured above. Incorporate them and proceed to Phase B.
- **SOUND** — the objective is valid. Proceed to Phase B.

If REJECT: stop. Surface the verdict and the reasons to the Don. Do not dispatch the Proposer. The Don may revise the objective (return to Reconnaissance) or abort.

### Phase B — Proposer (single pass)

Dispatch the Proposer subagent ONCE. It reads the Recon Dossier and the refined objective (with the Don's idea-level answers integrated) and produces one proposal. See `proposer-prompt.md`.

### Phase C — Devils-Advocate (single pass)

Dispatch the Devils-Advocate subagent ONCE. It attacks the proposal — architectural flaws, security, constitution violations, regressions, scalability. Idea-level concerns raised in Phase A are already on record; the Devils-Advocate revisits them only if the proposal materially changes the objective's scope. See `devils-advocate-prompt.md`.

### Phase D — Don weighs in (one question at a time)

Present the Devils-Advocate's attack summary to the Don. Then ask:

1. **First question:** "Do you agree with the Devil's-Advocate's attack?" — wait for the answer.
2. Decide the next question from the Don's answer. Only if needed, ask: "Any concerns they missed?" — wait.
3. Only if needed, ask: "Do you want to override any part of the proposal?" — wait.

Each question is asked only if the prior answer did not already settle it. Collect all Don answers.

### Phase E — Synthesizer (single pass)

Dispatch the Synthesizer subagent ONCE. It incorporates the valid attacks and the Don's feedback, defends the valid elements of the proposal, and produces the final revised solution. See `synthesizer-prompt.md`.

The Synthesizer's output IS the final consensus. There is no second attack pass.

### Termination

The Grilling ends after Phase E. There is no Nash-Equilibrium check, no round limit, no early-exit at round 2 — because there are no rounds. The single pass is the whole debate.

**Exception — Best Available Consensus:** If the Synthesizer finds that the Devils-Advocate raised a CRITICAL objection that the Don and the proposal cannot resolve in a single synthesis pass, the Synthesizer produces a Best Available Consensus with documented unresolved objections instead:

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
4. After the answer, re-evaluate: is the next planned question still needed? Skip it if the answer already settled it.
5. Present the next still-needed question, wait again
6. Repeat until no remaining question is needed
7. Collect all Don responses and pass them to the next subagent as a batch

**Anti-pattern — the bundled list:** Never present a numbered list of questions to the Don in a single message. Even if a subagent outputs a "Questions for the Don" list, the orchestrating agent asks them sequentially, one per message, and skips any that became irrelevant.

### Question Tool Schema (HARD RULE)

When using the `question` tool to ask the Don, every option MUST have both fields as non-null strings:

```
label: string       — concise display text, 1-5 words
description: string — explanation of what choosing this option means
```

**`description` is NEVER null, undefined, or omitted.** Even for obvious choices like "Yes" or "No", provide a description:

```
Bad:  { label: "Yes" }
Bad:  { label: "Yes", description: null }
Good: { label: "Yes", description: "I agree with the Devil's-Advocate's attack" }
Good: { label: "No",  description: "I reject the attack — the proposal stands" }
```

Violating this schema causes the tool call to fail with a validation error.

This applies to:
- Phase A idea grilling (each idea-level question)
- Phase D Don weighs in
- Best Available Consensus decision
- Any questions the Synthesizer or Proposer raise for the Don

**Why:** The Don gives better answers to one question than to three asked simultaneously. Bundled questions force mental juggling and produce lower-quality decisions.

## Repetition Detection (single-pass note)

In single-pass mode, repetition between the Phase A idea grilling and the Phase C Devils-Advocate attack is expected and acceptable — both are interrogating the idea from different angles. The Synthesizer flags genuine duplication so the final consensus doesn't double-count the same concern.

## Subagent Prompts

The Proposer, Devils-Advocate, and Synthesizer are dispatched as subagents using prompts in this directory:
- `proposer-prompt.md` — Prompt template for the Proposer
- `devils-advocate-prompt.md` — Prompt template for the Devils-Advocate
- `synthesizer-prompt.md` — Prompt template for the Synthesizer

### Dispatch Instructions

When calling the Task tool to dispatch each subagent:

1. Read the prompt file for that agent from the skill's directory
2. Fill in template placeholders (dossier content, Don's idea-grilling answers, Devils-Advocate output, Don feedback, etc.)
3. Set `subagent_type` to the named Gangsta agent — `"proposer"`, `"devils-advocate"`, or `"synthesizer"` as appropriate. Do NOT use `"general"` or `"general-purpose"` — these are not valid in a Gangsta installation.
4. Include the full filled prompt as the `prompt` parameter

**CRITICAL — Platform agent types:** Valid `subagent_type` values in a Gangsta installation are the named custom agents: `"associate"`, `"soldier"`, `"the-inspector"`, `"proposer"`, `"devils-advocate"`, `"synthesizer"`. The built-in `"general"` and `"explore"` agents are disabled. **Never use `"general-purpose"`, `"Task"`, `"oracle"`, `"fixer"`, `"explorer"`, or `"council"` — these are never valid.** See `using-gangsta/references/opencode-tools.md` for the complete platform mapping.

## Output

The Grilling does NOT produce a standalone transcript file. Instead, the orchestrating agent produces a **Grilling Conclusions** summary at the end of the debate. This summary is passed directly to the next phase (The Sit-Down) for inclusion in the Contract.

The Grilling Conclusions must contain:
- **Idea Verdict:** REJECT / CHALLENGE / SOUND, with the Don's idea-level answers captured in Phase A
- **Key Decisions:** Each architectural/design decision reached, with rationale
- **Rejected Alternatives:** Each option that was considered and discarded, with the reason (including analogues from the Recon Dossier that were NOT followed)
- **Unresolved Objections:** Any risks acknowledged but accepted (from Best Available Consensus, if fired)
- **Termination Reason:** Single-pass complete / Best Available Consensus

The orchestrating agent holds this summary in context — it is NOT saved as a separate file.

## Checkpoint

```yaml
---
heist: <heist-name>
phase: the-grilling
status: completed
timestamp: <ISO 8601>
next-action: Proceed to The Sit-Down
artifacts: []
note: Grilling Conclusions passed in-context to The Sit-Down for inclusion in the Contract
---
```

## Omerta Compliance
- [ ] Introduction Rule: Proposer, Devils-Advocate, and Synthesizer do not communicate directly — all mediated through this skill
- [ ] Rule of Truth: All attacks and proposals must cite Recon Dossier, Constitution, or specific technical facts
- [ ] Rule of Availability: Transcript and checkpoint saved after completion
- [ ] No-Rounds Rule: Each agent runs exactly once — no cyclic re-attack loop
- [ ] Idea-First Rule: Phase A grills the idea before Phase B proposes architecture
- [ ] One-Question-At-A-Time Rule: No bundled question lists reach the Don