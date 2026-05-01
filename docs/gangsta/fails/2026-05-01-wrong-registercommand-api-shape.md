---
date: 2026-05-01
heist: pi-dev-extension
phase: laundering
tags: [pi-dev, sdk-integration, api-shape, registerCommand]
severity: medium
---

# `registerCommand` implemented with wrong API shape — bare handler instead of options object

## What Happened

The initial implementation of the three slash commands passed a bare async function as
the second argument to `registerCommand`:

```typescript
// WRONG
(pi as any).registerCommand("gangsta:heist", async (ctx: any) => { ... });
```

The correct pi.dev API shape takes an options object with `description` and `handler`:

```typescript
// CORRECT
(pi as any).registerCommand("gangsta:heist", {
  description: "...",
  handler: async (_args: any, ctx: any) => { ... },
});
```

Additionally, the command file paths were passed with the full command name including
the namespace prefix (`resolveCommandPath("gangsta:heist")` → `commands/gangsta:heist.md`),
but the actual files are `commands/heist.md`, `commands/go.md`, `commands/abort.md`.
Both bugs were caught together during the Laundering audit review.

## Cognitive Diagnosis

The SDK's imperative API shape was inferred from incomplete reconnaissance on the
pi.dev extension API. The Worker implemented the shape by analogy with Node.js
event-emitter patterns (`emitter.on("event", handler)`) rather than verifying the
actual `registerCommand` signature from documentation or type definitions. The command
name confusion happened because the command names use a `gangsta:` namespace prefix at
registration but the backing files do not include that prefix.

## Negative Constraint

NC-PI-001: NEVER infer an SDK's method signature by analogy with similar patterns.
Always verify the exact argument shape from documentation or type definitions before
implementation. When types are unavailable, add an explicit comment citing the source
of truth for the expected shape.
