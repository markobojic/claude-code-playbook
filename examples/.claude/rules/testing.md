---
paths:
  - "packages/*/src/**/*.test.ts"
---

# Testing conventions

<!--
  Part of the Acme Web worked example. Real path: .claude/rules/testing.md

  Why this is a rule and not a nested CLAUDE.md: tests live in every package,
  so no single directory owns this guidance. A nested CLAUDE.md can only cover
  the folder it sits in.

  How it fires: nothing registers this file — being in .claude/rules/ is
  enough. It then loads when Claude READS a file matching the glob above, not
  when you ask about testing. Write a new test without reading an existing one
  and it may not fire at all.

  It is discovered by Claude Code in this repo, but the glob matches no file
  here (there is no TypeScript), so it never loads — which is the point: a
  path-scoped rule costs nothing until it is relevant.
-->

- Tests sit beside the code as `<name>.test.ts`, not in a separate `test/` tree.
- Run one file with `pnpm vitest run packages/api/src/foo.test.ts`.
- Unit tests make no network or database calls. Stub at the service boundary.
- Assert on one behaviour per test. Name it for the behaviour, not the function:
  `rejects an expired token`, not `test validateToken`.
- Fixtures belong in `packages/shared/test-fixtures/` when more than one
  package uses them.
