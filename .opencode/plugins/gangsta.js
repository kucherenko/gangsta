import { readFileSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, "../..");
const SKILLS_DIR = join(ROOT, "skills");

function readBootstrap() {
  const raw = readFileSync(join(SKILLS_DIR, "the-don/SKILL.md"), "utf-8");
  const body = raw.replace(/^---[\s\S]*?---\n/, "");
  return [
    "<EXTREMELY_IMPORTANT>",
    body,
    "",
    "**Tool Mapping for OpenCode:**",
    "When skills reference tools you don't have, substitute OpenCode equivalents:",
    "- `TodoWrite` → `todowrite`",
    "- `Task` tool with subagents → Use OpenCode's subagent system",
    "- `Skill` tool → OpenCode's native `skill` tool",
    "- `Read`, `Write`, `Edit`, `Bash` → Your native tools",
    "",
    "Use OpenCode's native `skill` tool to list and load skills.",
    "</EXTREMELY_IMPORTANT>",
  ].join("\n");
}

export default {
  name: "gangsta",
  version: "1.0.0",

  config(cfg) {
    cfg.skills = cfg.skills || {};
    cfg.skills.paths = cfg.skills.paths || [];
    cfg.skills.paths.push(SKILLS_DIR);
    return cfg;
  },

  "experimental.chat.messages.transform"(messages) {
    if (!messages.length) return messages;
    const bootstrap = readBootstrap();
    const first = messages[0];
    if (Array.isArray(first.content)) {
      first.content.unshift({ type: "text", text: bootstrap });
    }
    return messages;
  },
};
