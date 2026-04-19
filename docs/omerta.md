# Omerta: The Five Laws

Omerta is not a phase. It is a cross-cutting governance framework enforced by every skill at every stage. These laws are non-negotiable.

## Law 1 — The Introduction Rule (Authorization Protocol)

No agent-to-agent interaction without hierarchy mediation. Workers cannot message each other directly. All communication flows: Worker → Crew Lead → Underboss → Don.

**Why:** Prevents shadow coordination where agents develop shared assumptions outside the spec.

**Violated when:** A Worker asks another Worker a question directly, or a Crew Lead bypasses the Underboss.

## Law 2 — The Rule of Availability (State Durability)

All Heist state must be checkpointed to files before each phase transition. If a session is interrupted, state is recoverable.

**Checkpoint location:** `docs/gangsta/<heist-name>/checkpoints/YYYY-MM-DD-checkpoint-<phase>.md`

**Checkpoint format:**
```yaml
---
heist: <heist-name>
phase: <current-phase>
status: in-progress | completed | blocked
timestamp: YYYY-MM-DDTHH:MM:SS
next-action: <what to do next>
artifacts:
  - <list of files produced>
---
## Resume Context
<What has been done, what remains, any blockers>
```

**Violated when:** A phase transition happens without writing a checkpoint first.

## Law 3 — The Rule of Truth (Anti-Hallucination)

Every claim must cite its source. Agents operate with a Fact-First posture.

| Claim Type | Required Citation |
|-----------|------------------|
| Code behavior | `file:line` reference |
| Spec requirement | Contract section name |
| Architectural decision | Constitution entry |
| Past pattern | Ledger insight/fail reference |

An uncited claim is invalid and must be flagged. The Consigliere has standing authority to invoke a Truth Check at any point. When flagged, the agent must either provide a citation or retract the claim.

**Violated when:** An agent says "this passes" without running the test, or "this is the pattern" without citing a file.

## Law 4 — The Rule of Budget (Resource Management)

Each Crew Lead operates within a token budget set by the Underboss. Workers report resource consumption in their Reports. If a territory exceeds its budget, work pauses until the Underboss approves more allocation. All results (merged code, passing tests) are reported up: Worker → Crew Lead → Underboss → Don.

**Violated when:** A Worker dispatches without a budget, or a Crew Lead proceeds after budget exhaustion.

## Law 5 — The Spec is Law

The Contract is the absolute source of truth. If code contradicts the spec, revise the spec first — never the reverse. No shadow hotfixes. Every code change must trace to a Contract clause.

**If a bug is found during implementation:**
1. Worker escalates to Crew Lead
2. Crew Lead escalates to Underboss
3. Underboss runs a mini-Grilling (single-round) to revise the Contract
4. Implementation resumes only after Contract revision

**Violated when:** A Worker "fixes" something that contradicts the spec without escalating.

---

## Omerta Compliance Checklist

Every skill verifies this before proceeding to the next phase or action:

- [ ] **Introduction Rule:** All agent interactions mediated by hierarchy
- [ ] **Rule of Availability:** Current state checkpointed to file
- [ ] **Rule of Truth:** All claims cite their source
- [ ] **Rule of Budget:** Resource consumption within allocated budget
- [ ] **Spec is Law:** All changes trace to a Contract clause

## Red Flags

| Thought | Violated Law |
|---------|-------------|
| "I'll just make this quick fix without updating the spec" | Law 5: Spec is Law |
| "I know this is true, I don't need to cite it" | Law 3: Rule of Truth |
| "Let me ask that other agent directly, it's faster" | Law 1: Introduction Rule |
| "I'll save the checkpoint after I finish this part" | Law 2: Rule of Availability |
| "We're close to done, the budget doesn't matter now" | Law 4: Rule of Budget |
