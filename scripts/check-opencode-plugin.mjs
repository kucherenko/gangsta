#!/usr/bin/env node
// Verifies .opencode/plugins/gangsta.js against both OpenCode plugin contracts
// without OpenCode installed: V2 (`default.setup`) and V1 (`default.server`).
// Drives the V2 setup with a fake context and checks that every skill and agent
// directory in the repo is registered.
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const entry = path.join(ROOT, ".opencode/plugins/gangsta.js");
const fail = (message) => {
  console.error(`  FAIL: ${message}`);
  process.exit(1);
};

const module = await import(pathToFileURL(entry).href);
const plugin = module.default;

// Frontmatter parser: the YAML subset the plugin documents must round-trip.
const cases = [
  ["---\nname: x\ndescription: plain text # trailing comment\n---\n\n# Body\n", { name: "x", description: "plain text" }, "\n# Body\n"],
  ['---\nname: "quoted: value"\nmodel: \'it\'\'s\'\n---\nbody', { name: "quoted: value", model: "it's" }, "body"],
  ["---\ndescription: |\n  line one\n  line two\n\nmodel: inherit\n---\nbody", { description: "line one\nline two\n", model: "inherit" }, "body"],
  ["---\ndescription: |-\n  keep\n  clipped\n---\n", { description: "keep\nclipped" }, ""],
  ["---\ndescription: >\n  folded\n  text\n\n  new para\n---\n", { description: "folded text\nnew para\n" }, ""],
  ["---\ndescription: |+\n  keep\n\n---\n", { description: "keep\n\n" }, ""],
  ["---\ndescription: |2\n   indented\n---\n", { description: " indented\n" }, ""],
  ["---\ndescription: |\n\n---\n", { description: "" }, ""],
  ["---\r\nname: crlf\r\n---\r\nbody", { name: "crlf" }, "body"],
  ["---\n---\nbody", {}, "body"],
  ["no frontmatter", {}, "no frontmatter"],
];
for (const [source, data, content] of cases) {
  const parsed = module.parseFrontmatter(source);
  if (JSON.stringify(parsed.data) !== JSON.stringify(data) || parsed.content !== content)
    fail(`parseFrontmatter(${JSON.stringify(source)}) = ${JSON.stringify(parsed)}, expected ${JSON.stringify({ data, content })}`);
}

// V2 contract: default export is { id: string, setup: function } (extra keys are ignored).
if (!plugin || typeof plugin !== "object") fail("default export is not an object");
if (typeof plugin.id !== "string" || !plugin.id) fail("default.id must be a non-empty string");
if (typeof plugin.setup !== "function") fail("default.setup must be a function (OpenCode 2.x)");
// V1 contract: default export is { id, server: function }.
if (typeof plugin.server !== "function") fail("default.server must be a function (OpenCode 1.x)");

const expectedSkills = fs
  .readdirSync(path.join(ROOT, "skills"))
  .filter((dir) => fs.existsSync(path.join(ROOT, "skills", dir, "SKILL.md")))
  .sort();
const expectedAgents = fs
  .readdirSync(path.join(ROOT, "agents"))
  .filter((file) => file.endsWith(".md"))
  .map((file) => file.replace(/\.md$/, ""))
  .sort();

// Fake V2 context mirroring the editor surfaces the plugin uses.
const skills = new Map();
const agents = new Map();
const hooks = new Map();
const ctx = {
  skill: { transform: async (fn) => fn({ get: (id) => skills.get(id), add: (skill) => skills.set(skill.id, skill) }) },
  agent: {
    transform: async (fn) =>
      fn({
        get: (id) => agents.get(id),
        update: (id, update) => {
          const current = agents.get(id) ?? { id, name: id, mode: "primary", hidden: false, permissions: [] };
          agents.set(id, current);
          update(current);
        },
      }),
  },
  session: { hook: async (name, callback) => hooks.set(name, callback) },
};
await plugin.setup(ctx);

const registeredSkills = [...skills.keys()].sort();
if (JSON.stringify(registeredSkills) !== JSON.stringify(expectedSkills))
  fail(`skills registered ${JSON.stringify(registeredSkills)} != directories ${JSON.stringify(expectedSkills)}`);
for (const skill of skills.values()) {
  if (!skill.name || !skill.content || !path.isAbsolute(skill.path))
    fail(`skill ${skill.id} is missing name, content, or absolute path`);
  if (/^\s*---\n/.test(skill.content)) fail(`skill ${skill.id} content still contains frontmatter`);
}

const registeredAgents = [...agents.keys()].sort();
if (JSON.stringify(registeredAgents) !== JSON.stringify(expectedAgents))
  fail(`agents registered ${JSON.stringify(registeredAgents)} != files ${JSON.stringify(expectedAgents)}`);
for (const agent of agents.values()) {
  if (!["subagent", "primary", "all"].includes(agent.mode)) fail(`agent ${agent.id} has invalid mode ${agent.mode}`);
  if (!agent.system || !agent.description) fail(`agent ${agent.id} is missing system prompt or description`);
}

const context = hooks.get("context");
if (!context) fail("session 'context' hook not registered");
const event = { agent: "build", system: [], messages: [], options: {} };
await context(event);
await context(event);
const injected = event.system.filter((part) => part.type === "text" && part.text.includes("EXTREMELY_IMPORTANT"));
if (injected.length !== 1) fail(`bootstrap injected ${injected.length} times, expected 1`);
const auxiliary = { agent: "title", system: [], messages: [], options: {} };
await context(auxiliary);
if (auxiliary.system.length !== 0) fail("bootstrap injected into the title agent");

// V1 hooks object.
const legacy = await plugin.server({});
if (typeof legacy.config !== "function") fail("V1 hooks object has no config hook");
const cfg = {};
await legacy.config(cfg);
if (!cfg.skills?.paths?.includes(path.join(ROOT, "skills"))) fail("V1 config hook did not register skills path");
if (!cfg.agents?.paths?.includes(path.join(ROOT, "agents"))) fail("V1 config hook did not register agents path");

console.log(`  OK:   OpenCode plugin contract (V1 + V2), frontmatter parser, ${skills.size} skills, ${agents.size} agents, bootstrap hook`);
