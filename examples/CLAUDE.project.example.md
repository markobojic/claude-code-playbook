<!--
  Example project CLAUDE.md — copy to your repo root as CLAUDE.md and commit it.

  Root of the Acme Web worked example. Three files in these examples describe
  this one fictional repo:

      acme-web/
      ├── CLAUDE.md                  ← this file
      ├── .claude/rules/testing.md   ← spans every package
      └── packages/api/
          └── CLAUDE.md              ← CLAUDE.nested.example.md

  (CLAUDE.user.example.md is the fourth, and belongs on your machine at
  ~/.claude/CLAUDE.md rather than in any repo.)

  Block-level HTML comments like this one are stripped before the file enters
  Claude's context, so maintainer notes cost no tokens.
-->

# Acme Web — project instructions

TypeScript monorepo, pnpm workspaces. `packages/api` (Fastify),
`packages/web` (Next.js), `packages/shared` (types and utilities).

## Commands

- Install: `pnpm install` — never `npm` or `yarn`; the lockfile is pnpm's.
- Test: `pnpm test`. Run it before proposing a commit.
- Single package: `pnpm --filter @acme/api test`.
- Typecheck: `pnpm typecheck`. Lint: `pnpm lint --fix`.

## Conventions

- Import shared types from `@acme/shared`, never by relative path across packages.
- All database access goes through `packages/shared/src/db/`. No raw SQL in handlers.
- Errors returned to clients use the envelope `{ error: { code, message } }`.
- Dates are UTC ISO-8601 strings at every boundary. Convert only for display.

## Do not edit

- `packages/shared/src/generated/**` — regenerate with `pnpm codegen`.
- `pnpm-lock.yaml` — change it by running pnpm, not by hand.

## Git

- Conventional commits (`feat:`, `fix:`, `chore:`).
- Never commit to `main`; branch as `<type>/<short-description>`.
- Do not commit unless asked.

<!--
  Guidance that spans packages lives in .claude/rules/ so it loads only when
  Claude touches matching files — see examples/.claude/rules/testing.md.
  Guidance about one directory goes in a nested CLAUDE.md there instead —
  see examples/CLAUDE.nested.example.md.
-->
