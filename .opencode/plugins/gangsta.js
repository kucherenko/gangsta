/**
 * Gangsta plugin for OpenCode.ai
 *
 * - Auto-registers skills and agents directories via config hook (no symlinks needed)
 * - Injects Gangsta bootstrap + tool mapping into the first user message of each session
 */

import path from "path";
import fs from "fs";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "../..");
const SKILLS_DIR = path.join(ROOT, "skills");
const AGENTS_DIR = path.join(ROOT, "agents");

const extractBody = (content) => content.replace(/^---[\s\S]*?---\n/, "");

const getBootstrap = () => {
  const skillPath = path.join(SKILLS_DIR, "using-gangsta/SKILL.md");
  if (!fs.existsSync(skillPath)) return null;

  const body = extractBody(fs.readFileSync(skillPath, "utf8"));

  const toolMapping = `**Tool Mapping for OpenCode:**
When skills reference Claude Code tools, use OpenCode equivalents:
- \`TodoWrite\` → \`todowrite\`
- \`Task\` tool with subagents → \`@mention\` syntax (e.g. \`@associate\`, \`@soldier\`)
- \`Skill\` tool → OpenCode's native \`skill\` tool
- \`Read\`, \`Write\`, \`Edit\`, \`Bash\`, \`Grep\`, \`Glob\` → your native tools

Use OpenCode's native \`skill\` tool to list and load skills.`;

  return `<EXTREMELY_IMPORTANT>\n${body}\n\n${toolMapping}\n</EXTREMELY_IMPORTANT>`;
};

export default {
  id: "gangsta",

  server: async (_input, _options) => {
    return {
      config: async (cfg) => {
        // Register skills path (with dedup)
        cfg.skills = cfg.skills || {};
        cfg.skills.paths = cfg.skills.paths || [];
        if (!cfg.skills.paths.includes(SKILLS_DIR)) {
          cfg.skills.paths.push(SKILLS_DIR);
        }

        // Register agents path (with dedup)
        cfg.agents = cfg.agents || {};
        cfg.agents.paths = cfg.agents.paths || [];
        if (!cfg.agents.paths.includes(AGENTS_DIR)) {
          cfg.agents.paths.push(AGENTS_DIR);
        }
      },

      // Inject bootstrap into the first user message of each session.
      // Using a user message instead of a system message avoids:
      //   1. Token bloat from system messages repeated every turn
      //   2. Multiple system messages breaking certain models
      "experimental.chat.messages.transform": async (_input, output) => {
        const bootstrap = getBootstrap();
        if (!bootstrap || !output.messages.length) return;

        const firstUser = output.messages.find((m) => m.info.role === "user");
        if (!firstUser || !firstUser.parts.length) return;

        // Only inject once per session
        if (firstUser.parts.some((p) => p.type === "text" && p.text.includes("EXTREMELY_IMPORTANT"))) return;

        const ref = firstUser.parts[0];
        firstUser.parts.unshift({ ...ref, type: "text", text: bootstrap });
      },
    };
  },
};
