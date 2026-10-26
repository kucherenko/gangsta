// OpenCode 2.x entry for directory installs (`plugins: [{ "package": "/path/to/gangsta" }]`
// or a checkout placed under `.opencode/plugins/`). OpenCode probes `<dir>/server` and
// `<dir>/index`, not package.json, so this shim forwards to the real plugin module.
export { default } from "./.opencode/plugins/gangsta.js";
