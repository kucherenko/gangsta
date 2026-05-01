import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import * as fs from "node:fs";
import * as path from "node:path";

const GANGSTA_BOOTSTRAP_PROMPT = `You are operating under the Gangsta Agents framework for Spec-Driven Development. The user IS the Don — the supreme authority.

If there is even a 1% chance a Gangsta skill applies to what you are doing, you MUST invoke it. This is non-negotiable.

## The Borgata Hierarchy

  Don (User) — Supreme authority
    Consigliere — Strategic advisor (gangsta:the-consigliere)
    Underboss — COO (gangsta:the-underboss)
      Crew Leads — Domain orchestration (gangsta:the-capo)
        Workers — Stateless code execution
    The Ledger — Institutional memory (gangsta:the-ledger)

## Intent Routing

| Intent | Action |
|--------|--------|
| Building something new | Invoke gangsta:reconnaissance |
| Fixing a bug or issue | Invoke gangsta:the-consigliere |
| Debugging a problem | Invoke gangsta:interrogation-debugging |
| Continuing existing work | Check docs/gangsta/ for checkpoint files |
| Reviewing or auditing | Invoke gangsta:the-consigliere |

## Available Skills (21)

| Skill | Path |
|-------|------|
| gangsta:using-gangsta | skills/using-gangsta/SKILL.md |
| gangsta:reconnaissance | skills/reconnaissance/SKILL.md |
| gangsta:the-grilling | skills/the-grilling/SKILL.md |
| gangsta:the-sit-down | skills/the-sit-down/SKILL.md |
| gangsta:resource-development | skills/resource-development/SKILL.md |
| gangsta:the-hit | skills/the-hit/SKILL.md |
| gangsta:laundering | skills/laundering/SKILL.md |
| gangsta:the-consigliere | skills/the-consigliere/SKILL.md |
| gangsta:the-underboss | skills/the-underboss/SKILL.md |
| gangsta:the-capo | skills/the-capo/SKILL.md |
| gangsta:the-ledger | skills/the-ledger/SKILL.md |
| gangsta:omerta | skills/omerta/SKILL.md |
| gangsta:drill-tdd | skills/drill-tdd/SKILL.md |
| gangsta:interrogation-debugging | skills/interrogation-debugging/SKILL.md |
| gangsta:audit-review | skills/audit-review/SKILL.md |
| gangsta:sweep-verification | skills/sweep-verification/SKILL.md |
| gangsta:exit-strategy | skills/exit-strategy/SKILL.md |
| gangsta:safehouse-worktrees | skills/safehouse-worktrees/SKILL.md |
| gangsta:receiving-orders | skills/receiving-orders/SKILL.md |
| gangsta:autonomous-mode | skills/autonomous-mode/SKILL.md |
| gangsta:don-proxy | skills/don-proxy/SKILL.md |

Use the \`skill\` tool (or platform equivalent) to load any skill before acting on it.`;

function resolveCommandPath(name: string): string {
  let dir: string | undefined;
  try {
    if (__dirname && fs.existsSync(__dirname)) {
      dir = __dirname;
    }
  } catch {
    // __dirname unavailable
  }
  if (dir) {
    return path.resolve(dir, "../../../commands/" + name + ".md");
  }
  console.warn("[gangsta] __dirname unavailable, falling back to cwd for command: " + name);
  return path.resolve(process.cwd(), "commands/" + name + ".md");
}

export default function (pi: ExtensionAPI) {
  pi.on("before_agent_start", async (event: any, _ctx: any) => {
    if (typeof event.systemPrompt === "string") {
      event.systemPrompt = event.systemPrompt + "\n\n" + GANGSTA_BOOTSTRAP_PROMPT;
    } else if (event.systemPrompt !== undefined) {
      (event as any).systemPrompt = GANGSTA_BOOTSTRAP_PROMPT;
    }
  });

  (pi as any).registerCommand("gangsta:heist", {
    description: "Begin a new Heist — spec-driven development pipeline (reconnaissance through laundering)",
    handler: async (_args: any, ctx: any) => {
      const filePath = resolveCommandPath("heist");
      const content = fs.readFileSync(filePath, "utf8");
      ctx.ui.notify(content);
    },
  });

  (pi as any).registerCommand("gangsta:go", {
    description: "Resume a paused Heist phase",
    handler: async (_args: any, ctx: any) => {
      const filePath = resolveCommandPath("go");
      const content = fs.readFileSync(filePath, "utf8");
      ctx.ui.notify(content);
    },
  });

  (pi as any).registerCommand("gangsta:abort", {
    description: "Abort the current Heist operation",
    handler: async (_args: any, ctx: any) => {
      const filePath = resolveCommandPath("abort");
      const content = fs.readFileSync(filePath, "utf8");
      ctx.ui.notify(content);
    },
  });
}
