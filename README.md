<div align="center">
  <img src="logo.svg" alt="Gangsta" width="200" />
</div>

# Gangsta Agents

An AI agentic skills framework for spec-driven development, built on the organizational model of mafia.

## Philosophy

Gangsta Agents replaces open-ended Agile iteration with a directive, vertical hierarchy. A small team of highly specialized agents — each operating with autonomy within their Position — outperforms a large pool of general-purpose agents.

**The Spec is Law.** Code is an implementation detail validated against the specification. No shadow hotfixes.

**The Informed Minority.** Clear roles, clear hierarchy, clear accountability.

## How It Works

When you start a session, the framework bootstraps The Don — an orchestrator that analyzes your intent and routes to the appropriate skill. When you want to build something, it initiates a **Heist**: a 6-phase operational cycle.

### The Heist Pipeline

| Phase | What Happens |
|-------|-------------|
| 1. **Reconnaissance** | Intel gathering on codebase and requirements |
| 2. **The Grilling** | Adversarial brainstorming via Multi-Agent Debate (Proposer vs Devils-Advocate, with you weighing in each round) |
| 3. **The Sit-Down** | Formal spec drafting. No code allowed. |
| 4. **Resource Development** | Task decomposition into Work Packages |
| 5. **The Hit** | Parallel execution by Worker subagents with TDD enforcement |
| 6. **Laundering** | Verification, integration, and Ledger update |

Every phase gate requires your approval. You are the Don.

→ [Full Heist Pipeline documentation](docs/heist-pipeline.md)

### The Gangsta Agents Family Hierarchy

| Role | Function |
|------|----------|
| **Don** (You) | Supreme authority. Approves all phase gates. |
| **Consigliere** | Impartial advisor. Security and architecture auditor. |
| **Underboss** | COO. Task decomposition, resource allocation. |
| **Crew Lead** | Domain crew lead. Manages Workers per territory. |
| **Worker** | Stateless code executor. TDD enforced. |
| **Associate** | External tool/API proxy. |

→ [Full Hierarchy documentation](docs/hierarchy.md)

### The Family Ledger

The Gangsta Agents Family maintains institutional memory across all Heists:
- **Insights** — Successful reasoning pathways and creative solutions
- **Fails** — Documented failures with cognitive diagnoses and negative constraints
- **Constitution** — Accumulated commandments and prohibitions

→ [Full Ledger documentation](docs/ledger.md)

### Software Development Skills

| Skill | Purpose |
|-------|---------|
| **Interrogation** | Systematic debugging — find the rat before applying fixes |
| **The Drill** | TDD enforcement — no code without a failing test |
| **Safehouse** | Git worktrees — isolated operational bases |
| **The Audit** | Code review — the-inspector checks the work |
| **Receiving Orders** | Process feedback with rigor, not blind agreement |
| **The Sweep** | Verification — evidence before completion claims |
| **Exit Strategy** | Branch integration and cleanup |

→ [Full Dev Skills documentation](docs/dev-skills.md)

### Omerta: Governance

Five non-negotiable laws govern all operations:

1. **Introduction Rule** — No agent-to-agent communication without hierarchy mediation
2. **Rule of Availability** — All state checkpointed to files
3. **Rule of Truth** — Every claim cites its source. No invalid claims.
4. **Rule of Budget** — Resource budgets tracked and enforced
5. **Spec is Law** — Code contradicts spec → spec is revised first

→ [Full Omerta documentation](docs/omerta.md)

## Installation

### Claude Code

```bash
/plugin marketplace add kucherenko/gangsta
/plugin install gangsta@gangsta
```

### GitHub Copilot

```bash
copilot plugin marketplace add kucherenko/gangsta
copilot plugin install gangsta@gangsta-marketplace
```

### OpenCode

Tell OpenCode:

```
Fetch and follow instructions from https://raw.githubusercontent.com/kucherenko/gangsta/refs/heads/master/.opencode/INSTALL.md
```

### Codex

Tell Codex:

```
Fetch and follow instructions from https://raw.githubusercontent.com/kucherenko/gangsta/refs/heads/master/.codex/INSTALL.md
```

### Gemini CLI

```bash
gemini extensions install https://github.com/kucherenko/gangsta
```

## Verify Installation

Start a new session and say:

> "I want to build a new feature"

The agent should invoke Gangsta Agents skills automatically, starting with Reconnaissance.

## License

MIT
