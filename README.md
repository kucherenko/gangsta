# Gangsta

An AI agentic skills framework for spec-driven development, built on the organizational model of La Cosa Nostra.

## Philosophy

Gangsta replaces open-ended Agile iteration with a directive, vertical hierarchy. A small team of highly specialized agents — each operating with autonomy within their Position — outperforms a large pool of general-purpose agents.

**The Spec is Law.** Code is an implementation detail validated against the specification. No shadow hotfixes.

**The Informed Minority.** Clear roles, clear hierarchy, clear accountability.

## How It Works

When you start a session, the framework bootstraps The Don — an orchestrator that analyzes your intent and routes to the appropriate skill. When you want to build something, it initiates a **Heist**: a 6-phase operational cycle.

### The Heist Pipeline

1. **Reconnaissance** — Intel gathering on codebase and requirements
2. **The Grilling** — Adversarial brainstorming via Multi-Agent Debate (Proposer vs Devils-Advocate, with you weighing in each round)
3. **The Sit-Down** — Formal spec drafting. No code allowed.
4. **Resource Development** — Task decomposition into Work Packages
5. **The Hit** — Parallel execution by Soldier subagents with TDD enforcement
6. **Laundering** — Verification, integration, and Ledger update

Every phase gate requires your approval. You are the Don.

### The Borgata Hierarchy

| Role | Function |
|------|----------|
| **Don** (You) | Supreme authority. Approves all phase gates. |
| **Consigliere** | Impartial advisor. Security and architecture auditor. |
| **Underboss** | COO. Task decomposition, resource allocation. |
| **Capo** | Domain crew lead. Manages Soldiers per territory. |
| **Soldier** | Stateless code executor. TDD enforced. |
| **Associate** | External tool/API proxy. |

### The Family Ledger

The Borgata maintains institutional memory:
- **Insights** — Successful reasoning pathways and creative solutions
- **Fails** — Documented failures with cognitive diagnoses and negative constraints
- **Constitution** — Accumulated commandments and prohibitions

### Omerta: Governance

Five non-negotiable laws govern all operations:
1. **Introduction Rule** — No agent-to-agent communication without hierarchy mediation
2. **Rule of Availability** — All state checkpointed to files
3. **Rule of Truth** — Every claim cites its source. No stronzate.
4. **Rule of Tribute** — Resource budgets tracked and enforced
5. **Spec is Law** — Code contradicts spec → spec is revised first

## Installation

### OpenCode

Add to your `opencode.json`:
```json
{
  "plugin": ["gangsta@git+https://github.com/user/gangsta.git"]
}
```

### Claude Code

```
/plugin marketplace add user/gangsta-marketplace
/plugin install gangsta@gangsta-marketplace
```

### Cursor

```
/add-plugin gangsta
```

### Codex

```bash
git clone https://github.com/user/gangsta.git ~/.gangsta
ln -sf ~/.gangsta/skills ~/.agents/skills/gangsta
```

### Gemini CLI

```bash
gemini extensions install https://github.com/user/gangsta
```

## Verify Installation

Start a new session and say:
> "I want to build a new feature"

The agent should invoke Gangsta skills automatically, starting with Reconnaissance.

## License

MIT
