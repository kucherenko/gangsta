import { readFileSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, "../..");
const SKILLS_DIR = join(ROOT, "skills");

function readBootstrap() {
  const raw = readFileSync(join(SKILLS_DIR, "using-gangsta/SKILL.md"), "utf-8");
  const body = raw.replace(/^---[\s\S]*?---\n/, "");
  return [
    "<EXTREMELY_IMPORTANT>",
    body,
    "",
    "Use OpenCode's native `skill` tool to list and load skills.",
    "</EXTREMELY_IMPORTANT>",
  ].join("\n");
}

export default {
  id: "gangsta",

  server: async (_input, _options) => {
    return {
      config: async (cfg) => {
        cfg.skills = cfg.skills || {};
        cfg.skills.paths = cfg.skills.paths || [];
        cfg.skills.paths.push(SKILLS_DIR);
      },

      "experimental.chat.messages.transform": async (_input, output) => {
        if (!output.messages.length) return;
        const bootstrap = readBootstrap();
        output.messages[0].parts.unshift({ type: "text", text: bootstrap });
      },
    };
  },
};
