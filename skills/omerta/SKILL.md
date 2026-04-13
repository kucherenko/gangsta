---
name: omerta
description: Use when enforcing governance guardrails during any gangsta operation — referenced as cross-cutting concern by all skills for anti-hallucination, authorization, state durability, resource management, and spec supremacy rules
---

# Omerta: The Laws of the Borgata

## Overview

Omerta is the governance framework for the Gangsta Borgata. It is not a phase — it is a cross-cutting concern enforced by every skill at every stage. These laws are non-negotiable.

## The Five Laws

### Law 1: The Introduction Rule (Authorization Protocol)

No agent-to-agent interaction occurs without mediation by the Underboss or Don.

- Soldiers CANNOT communicate directly with each other
- All messages pass through the chain: Soldier → Capo → Underboss
- This prevents "shadow coordination" where agents develop shared assumptions outside the spec
- Violation: Any attempt at direct agent-to-agent messaging is blocked and logged

### Law 2: The Rule of Availability (State Durability)

All Heist state MUST be checkpointed to files. If a session is interrupted, state must be recoverable.

- Checkpoint location: `docs/gangsta/<heist-name>/checkpoints/YYYY-MM-DD-checkpoint-<phase>.md`
- Checkpoint format: YAML frontmatter with phase, status, timestamp, resume instructions
- Every phase transition writes a checkpoint BEFORE starting the next phase
- On session resume, the Don reads the latest checkpoint and continues from that point

Checkpoint template:
```yaml
---
heist: <heist-name>
phase: <current-phase>
status: in-progress | completed | blocked
timestamp: YYYY-MM-DDTHH:MM:SS
next-action: <what to do next>
artifacts:
  - <list of files produced so far>
---

## Resume Context
<Summary of what has been done and what remains>
```

### Law 3: The Rule of Truth (Anti-Hallucination)

Every claim MUST cite its source. Agents adopt a "Fact-First" posture.

| Claim Type | Required Citation |
|-----------|------------------|
| Code behavior | `file:line` reference |
| Spec requirement | Contract section name |
| Architectural decision | Constitution entry |
| Past pattern | Ledger insight/fail reference |

- Any uncited claim is **stronzate** (bullshit) and must be flagged immediately
- The Consigliere has standing authority to invoke a Truth check at any point
- When flagged, the agent must either provide a citation or retract the claim

### Law 4: The Rule of Tribute (Resource Management)

- Each Capo operates within an allocated token budget set by the Underboss
- Soldiers report resource consumption in their Tributes
- If a territory exceeds its budget, work pauses until the Underboss approves additional allocation
- All "profits" (merged code, passing tests) are reported up: Soldier → Capo → Underboss → Don

### Law 5: The Spec is Law

The specification is the absolute source of truth.

- If code contradicts the spec, the SPEC is revised first — never the reverse
- No "shadow code" hotfixes — every code change must trace to a Contract clause
- If a bug is found during The Hit:
  1. Soldier escalates to Capo
  2. Capo escalates to Underboss
  3. Underboss may invoke a mini-Grilling (single-round) to revise the Contract
  4. Only after Contract revision does implementation proceed

## Omerta Compliance Checklist

Every skill MUST verify this checklist before proceeding to the next phase or action:

- [ ] **Introduction Rule:** All agent interactions mediated by hierarchy (no direct Soldier-to-Soldier)
- [ ] **Rule of Availability:** Current state checkpointed to file
- [ ] **Rule of Truth:** All claims cite their source (no stronzate)
- [ ] **Rule of Tribute:** Resource consumption within allocated budget
- [ ] **Spec is Law:** All changes trace to a Contract clause

## Red Flags

If you catch yourself thinking any of these, STOP — you are about to violate Omerta:

| Thought | Violated Law |
|---------|-------------|
| "I'll just make this quick fix without updating the spec" | Law 5: Spec is Law |
| "I know this is true, I don't need to cite it" | Law 3: Rule of Truth |
| "Let me ask that other agent directly, it's faster" | Law 1: Introduction Rule |
| "I'll save the checkpoint after I finish this part" | Law 2: Rule of Availability |
| "We're close to done, the budget doesn't matter now" | Law 4: Rule of Tribute |
