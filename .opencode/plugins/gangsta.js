/**
 * Gangsta plugin for OpenCode.ai
 *
 * One module serves both OpenCode plugin generations:
 *
 * - OpenCode V2 (`@opencode/cli` 2.x) loads `default.setup(ctx)` and registers
 *   skills, agents, and the Gangsta bootstrap through domain transforms.
 * - OpenCode V1 (`opencode-ai` 1.x) loads `default.server(input)` and receives
 *   the legacy hooks object (config + message transform).
 *
 * V2 validates `default` as `{ id, setup }` and ignores the extra `server` key;
 * V1 (1.4.0 and newer) detects `{ id, server }` and ignores `setup`. OpenCode
 * 1.0–1.3 called every export as a function and cannot load this module; pin
 * `#gangsta-v1.11.6` there. Nothing is imported from `@opencode/plugin` or
 * `@opencode-ai/plugin`, so the package stays dependency-free.
 */

import path from "node:path";
import fs from "node:fs";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "../..");
const SKILLS_DIR = path.join(ROOT, "skills");
const AGENTS_DIR = path.join(ROOT, "agents");

const BOOTSTRAP_MARKER = "EXTREMELY_IMPORTANT";

// Auxiliary agents that never need the Gangsta bootstrap in their system prompt.
const AUXILIARY_AGENTS = new Set(["title", "summary", "compaction"]);

// ---------------------------------------------------------------------------
// Markdown frontmatter
//
// Supported YAML subset (enough for SKILL.md and agents/*.md, checked by
// scripts/check-opencode-plugin.mjs):
//   - `key: value` plain scalars, with a trailing ` # comment` stripped
//   - `key: "value"` / `key: 'value'` quoted scalars
//   - `key: |` / `key: >` block scalars, with chomping (`-`, `+`) and indentation
//     indicators; `>` folds single newlines into spaces
// Anything else (nested maps, lists, anchors) is left as its raw text.
// ---------------------------------------------------------------------------

const BLOCK_INDICATOR = /^([|>])([+-]?\d*|\d*[+-]?)$/;

const parseScalar = (raw) => {
  const value = raw.trim();
  if (/^"(?:[^"\\]|\\.)*"$/.test(value)) return value.slice(1, -1).replace(/\\(.)/g, "$1");
  if (/^'(?:[^']|'')*'$/.test(value)) return value.slice(1, -1).replace(/''/g, "'");
  return value.replace(/\s+#.*$/, "").trim();
};

const parseBlock = (lines, start, indicator) => {
  const block = [];
  let i = start;
  while (i < lines.length && (lines[i].trim() === "" || /^\s/.test(lines[i]))) block.push(lines[i++]);
  const trailing = [];
  while (block.length && block[block.length - 1].trim() === "") trailing.unshift(block.pop());
  const [, style, flags] = indicator.match(BLOCK_INDICATOR);
  const explicit = Number(flags.replace(/[+-]/g, "")) || 0;
  const indents = block.filter((line) => line.trim()).map((line) => line.match(/^\s*/)[0].length);
  const indent = explicit || (indents.length ? Math.min(...indents) : 0);
  const body = block.map((line) => line.slice(indent));
  // `>` folds a single newline into a space; a run of n blank lines becomes n newlines.
  let text =
    style === ">"
      ? body.join("\n").replace(/([^\n])\n(?=[^\n])/g, "$1 ").replace(/\n(\n+)/g, "$1")
      : body.join("\n");
  if (flags.includes("+")) text += "\n".repeat(trailing.length + 1);
  else if (!flags.includes("-") && block.length) text += "\n";
  return { text, next: i };
};

const parseFrontmatter = (source) => {
  const match = source.match(/^---\r?\n(?:([\s\S]*?)\r?\n)?---[ \t]*(?:\r?\n|$)/);
  if (!match) return { data: {}, content: source };
  const data = {};
  const lines = (match[1] ?? "").split(/\r?\n/);
  for (let i = 0; i < lines.length; i++) {
    const entry = lines[i].match(/^([A-Za-z0-9_-]+):\s*(.*)$/);
    if (!entry) continue;
    const [, key, raw] = entry;
    const value = raw.trim();
    if (BLOCK_INDICATOR.test(value)) {
      const block = parseBlock(lines, i + 1, value);
      data[key] = block.text;
      i = block.next - 1;
      continue;
    }
    data[key] = parseScalar(value);
  }
  return { data, content: source.slice(match[0].length) };
};

// ---------------------------------------------------------------------------
// Content loaders (run once at setup; transforms must stay synchronous)
// ---------------------------------------------------------------------------

const loadSkills = () => {
  if (!fs.existsSync(SKILLS_DIR)) return [];
  return fs
    .readdirSync(SKILLS_DIR)
    .sort()
    .map((id) => {
      const file = path.join(SKILLS_DIR, id, "SKILL.md");
      if (!fs.existsSync(file)) return null;
      const { data, content } = parseFrontmatter(fs.readFileSync(file, "utf8"));
      return {
        id,
        name: data.name || id,
        ...(data.description ? { description: data.description.trim() } : {}),
        path: file,
        content,
      };
    })
    .filter(Boolean);
};

const parseModel = (value) => {
  if (typeof value !== "string" || !value.includes("/")) return undefined;
  const [providerID, rest] = value.split(/\/(.*)/s);
  const [id, variant] = rest.split("#");
  return { id, providerID, ...(variant ? { variant } : {}) };
};

const AGENT_MODES = new Set(["subagent", "primary", "all"]);

const parseBoolean = (value) => (value === "true" ? true : value === "false" ? false : undefined);

// Agent frontmatter: `name`, `description`, `model` (provider/model[#variant];
// `inherit` leaves the session model), plus the OpenCode 2.x agent fields
// `mode`, `color`, `hidden` and `steps` when present. Gangsta agents default
// to `mode: subagent` so skills can dispatch them by name.
const loadAgents = () => {
  if (!fs.existsSync(AGENTS_DIR)) return [];
  return fs
    .readdirSync(AGENTS_DIR)
    .filter((file) => file.endsWith(".md"))
    .sort()
    .map((file) => {
      const { data, content } = parseFrontmatter(fs.readFileSync(path.join(AGENTS_DIR, file), "utf8"));
      const id = file.replace(/\.md$/, "");
      const steps = Number.parseInt(data.steps, 10);
      return {
        id,
        name: data.name || id,
        description: (data.description || "").trim(),
        system: content.trim(),
        mode: AGENT_MODES.has(data.mode) ? data.mode : "subagent",
        model: parseModel(data.model),
        color: data.color || undefined,
        hidden: parseBoolean(data.hidden),
        steps: Number.isInteger(steps) ? steps : undefined,
      };
    });
};

const getBootstrap = (toolMapping) => {
  const skillPath = path.join(SKILLS_DIR, "using-gangsta/SKILL.md");
  if (!fs.existsSync(skillPath)) return null;
  const { content } = parseFrontmatter(fs.readFileSync(skillPath, "utf8"));
  return `<${BOOTSTRAP_MARKER}>\n${content.trim()}\n\n${toolMapping}\n</${BOOTSTRAP_MARKER}>`;
};

const V2_TOOL_MAPPING = `**Tool Mapping for OpenCode:**
When skills reference Claude Code tools, use OpenCode equivalents:
- \`TodoWrite\` → \`todowrite\`
- \`Task\` tool with subagents → \`subagent\` tool, \`agent\` parameter set to the Gangsta agent name (e.g. \`associate\`, \`soldier\`)
- \`Skill\` tool → OpenCode's native \`skill\` tool
- \`Bash\` → \`shell\`
- \`AskUserQuestion\` → \`question\`
- \`Read\`, \`Write\`, \`Edit\`, \`Grep\`, \`Glob\`, \`WebFetch\`, \`WebSearch\` → the same names in lowercase

Use OpenCode's native \`skill\` tool to list and load skills.`;

const V1_TOOL_MAPPING = `**Tool Mapping for OpenCode:**
When skills reference Claude Code tools, use OpenCode equivalents:
- \`TodoWrite\` → \`todowrite\`
- \`Task\` tool with subagents → \`@mention\` syntax (e.g. \`@associate\`, \`@soldier\`)
- \`Skill\` tool → OpenCode's native \`skill\` tool
- \`Read\`, \`Write\`, \`Edit\`, \`Bash\`, \`Grep\`, \`Glob\` → your native tools

Use OpenCode's native \`skill\` tool to list and load skills.`;

// ---------------------------------------------------------------------------
// OpenCode V2 (`@opencode/cli` 2.x)
// ---------------------------------------------------------------------------

const setup = async (ctx) => {
  const skills = loadSkills();
  const agents = loadAgents();
  const bootstrap = getBootstrap(V2_TOOL_MAPPING);

  // Skills: register each SKILL.md unless a skill with the same ID already exists
  // (user-configured skill directories take precedence). Transforms are replayed,
  // so hand the editor a copy and keep the loaded originals untouched.
  await ctx.skill.transform((editor) => {
    for (const skill of skills) {
      if (!editor.get(skill.id)) editor.add({ ...skill });
    }
  });

  // Agents: `update` on an unknown ID creates it with default permissions. Skip
  // IDs the user already defined in their config so their settings win.
  await ctx.agent.transform((editor) => {
    for (const agent of agents) {
      if (editor.get(agent.id)) continue;
      editor.update(agent.id, (item) => {
        item.name = agent.name;
        item.description = agent.description;
        item.mode = agent.mode;
        item.system = agent.system;
        if (agent.model) item.model = agent.model;
        if (agent.color) item.color = agent.color;
        if (agent.hidden !== undefined) item.hidden = agent.hidden;
        if (agent.steps !== undefined) item.steps = agent.steps;
      });
    }
  });

  // Bootstrap: append the using-gangsta skill to the system prompt of every
  // agent request. V2 rebuilds `system` per request, so this never persists in
  // session history and stays cache-friendly.
  if (bootstrap) {
    await ctx.session.hook("context", (event) => {
      if (AUXILIARY_AGENTS.has(event.agent)) return;
      if (event.system.some((part) => part.type === "text" && part.text.includes(BOOTSTRAP_MARKER))) return;
      event.system.push({ type: "text", text: bootstrap });
    });
  }
};

// ---------------------------------------------------------------------------
// OpenCode V1 (`opencode-ai` 1.x) — legacy hooks object
// ---------------------------------------------------------------------------

const server = async () => {
  const bootstrap = getBootstrap(V1_TOOL_MAPPING);
  return {
    config: async (cfg) => {
      cfg.skills = cfg.skills || {};
      cfg.skills.paths = cfg.skills.paths || [];
      if (!cfg.skills.paths.includes(SKILLS_DIR)) cfg.skills.paths.push(SKILLS_DIR);

      cfg.agents = cfg.agents || {};
      cfg.agents.paths = cfg.agents.paths || [];
      if (!cfg.agents.paths.includes(AGENTS_DIR)) cfg.agents.paths.push(AGENTS_DIR);
    },

    // Inject the bootstrap into the first user message of each session. A user
    // message avoids token bloat from repeated system messages and models that
    // reject multiple system messages.
    "experimental.chat.messages.transform": async (_input, output) => {
      if (!bootstrap || !output.messages.length) return;

      const firstUser = output.messages.find((m) => m.info.role === "user");
      if (!firstUser || !firstUser.parts.length) return;
      if (firstUser.parts.some((p) => p.type === "text" && p.text.includes(BOOTSTRAP_MARKER))) return;

      const ref = firstUser.parts[0];
      firstUser.parts.unshift({ ...ref, type: "text", text: bootstrap });
    },
  };
};

// Named export for scripts/check-opencode-plugin.mjs only. OpenCode 1.x reads the
// default object and OpenCode 2.x reads `default` alone, so neither loads it.
export { parseFrontmatter };

export default {
  id: "gangsta",
  setup,
  server,
};
