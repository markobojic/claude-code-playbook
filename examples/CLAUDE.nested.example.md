<!--
  Example nested CLAUDE.md. Part of the Acme Web worked example — the same
  fictional pnpm monorepo as CLAUDE.project.example.md, which is that repo's
  root CLAUDE.md. Real path: packages/api/CLAUDE.md

      acme-web/
      ├── CLAUDE.md                  ← CLAUDE.project.example.md
      ├── .claude/rules/testing.md   ← applies across every package
      └── packages/api/
          └── CLAUDE.md              ← this file

  It loads on demand, when Claude reads a file in packages/api, and stacks on
  top of the root CLAUDE.md rather than replacing it. So add only what is true
  here and nowhere else — everything in the root file already applies.

  Why this is a nested CLAUDE.md and not a rule: it is about one directory.
  Guidance that spans packages (testing, security) belongs in .claude/rules/.
-->

# packages/api

- Run this package alone: `pnpm --filter @acme/api dev` (needs Postgres on :5432).
- Route handlers stay thin: validate, call a service in `src/services/`, return.
- `src/server.ts` is the only place that reads `process.env`.
