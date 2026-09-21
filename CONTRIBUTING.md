# Contributing

Thanks for helping keep this guide accurate and useful.

## Ground rules

- **One topic per file.** Keep each file focused on its subject.
- **Cite the official docs** when you add or change a technical claim, and
  update the "last verified" date at the top of the file.
- **Keep the voice.** Opinionated but fair; recommendations go in an
  "Architect's take" blockquote:

  ```markdown
  > **◆ Architect's take** — the recommendation, and its trade-off.
  ```

- **Note anything user-facing** in `CHANGELOG.md` under the next version.
  Typo and wording fixes don't need an entry.

## Style

- **Title Case** for a chapter's `#` title, sentence case for `##` sections.
- Inline code for file names, fields, and commands.
- Prefer a short worked example over a long description.
- Tables for reference material (frontmatter fields, comparisons).

## Working in `examples/`

That directory is live configuration, not inert samples — Claude Code reads it
when running in this repo. Three rules follow:

- **Never name a file exactly `CLAUDE.md`.** Any file with that name is loaded
  as memory for sessions in its directory, which would inject the example into
  real work. Hence `CLAUDE.project.example.md` and friends.
- **Keep every rule in `examples/.claude/rules/` path-scoped** with `paths:`
  frontmatter. A rule without it loads unconditionally, in every session here.
- **Use the `.example.` suffix** for files a reader copies to a fixed name —
  `settings.example.json`, `.mcp.example.json`.

## Reporting version drift

Claude Code moves fast. If a fact is stale, open an issue titled
`drift: <topic> — <what changed>` with a link to the current official docs,
or send a PR that fixes the text and bumps the "last verified" date.

## Licensing your contribution

By opening a pull request you agree to release your contribution under the same
terms as the rest of the repository — see [`LICENSE`](LICENSE):

- **Anything in `docs/` or a root markdown file** — CC BY 4.0.
- **Anything in `examples/`** — CC0 1.0, a **public domain dedication**. You
  give up your rights to it so readers can paste it into their own projects
  with no attribution and no conditions. Only contribute examples you are
  willing to release on those terms.
