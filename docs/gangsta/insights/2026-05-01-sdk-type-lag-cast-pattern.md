---
date: 2026-05-01
heist: pi-dev-extension
phase: laundering
tags: [typescript, sdk-integration, pi-dev, type-safety]
---

# Cast to `any` as the correct workaround when SDK types lag behind runtime API

## Discovery

During the pi-dev-extension Heist, `pi.registerCommand` was not present on the typed
`ExtensionAPI` interface from `@mariozechner/pi-coding-agent`, even though the runtime
supports it. A direct call would fail TypeScript compilation. The Consigliere flagged
this during the final review.

## Solution

Use `(pi as any).registerCommand(...)` — a targeted `as any` cast scoped only to the
call site. This:
- Preserves TypeScript compilation (no `ts-ignore` suppression of the whole file)
- Keeps all other API calls fully typed
- Is self-documenting: the cast signals "SDK types do not yet cover this method"

The pattern generalizes: when an SDK's types lag its runtime, cast to `any` at the
specific call site rather than widening the type of the entire object or suppressing
TypeScript globally.

## Project Commandment

C-PI-001: When an SDK's TypeScript types lag behind its runtime API, use a targeted
`(obj as any).method()` cast at the call site. Document the gap in INSTALL.md under
"Accepted Risks" so future maintainers know why the cast exists.
