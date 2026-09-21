# Claude Code Playbook

A practical, opinionated engineering guide to setting up, extending, and
automating projects with **Claude Code** — written as one Markdown file per
topic.

> **Unofficial community guide.** Not affiliated with, endorsed by, or
> sponsored by Anthropic. Claude Code changes quickly; each topic carries a
> "last verified" date and links to the official docs. Always check
> <https://code.claude.com/docs> for the current source of truth.

## What's inside

| # | Topic | File |
|---|-------|------|
| — | Overview / how to read | [`docs/index.md`](docs/index.md) |
| 01 | Setup & Configuration | [`docs/01-setup-and-config.md`](docs/01-setup-and-config.md) |
| 02 | Scope & Precedence | [`docs/02-scope-and-precedence.md`](docs/02-scope-and-precedence.md) |
| 03 | Memory & CLAUDE.md | [`docs/03-memory-claude-md.md`](docs/03-memory-claude-md.md) |
| 04 | Skills | [`docs/04-skills.md`](docs/04-skills.md) |
| 05 | Subagents | [`docs/05-subagents.md`](docs/05-subagents.md) |
| 06 | MCP | [`docs/06-mcp.md`](docs/06-mcp.md) |
| 07 | Hooks | [`docs/07-hooks.md`](docs/07-hooks.md) |
| 08 | Plugins | [`docs/08-plugins.md`](docs/08-plugins.md) |
| 09 | When & What | [`docs/09-when-and-what.md`](docs/09-when-and-what.md) |
| 10 | Prompting & Workflow | [`docs/10-prompting.md`](docs/10-prompting.md) |
| — | Enterprise deployment (appendix) | [`docs/appendix-enterprise.md`](docs/appendix-enterprise.md) |

Working, copy-pasteable artifacts live in [`examples/`](examples/): sample
`CLAUDE.md` files for project, user, and nested scope, a path-scoped rule,
five [skill blueprints](examples/.claude/skills/README.md) covering the
frontmatter surface, [worked prompt patterns](examples/prompt-patterns.md), a
subagent, a hook, `settings.example.json`, and `.mcp.example.json`.

## Licensing

- **The guide** — `docs/` and the root markdown files: CC BY 4.0.
- **Everything in `examples/`**: CC0 1.0 — public domain. Paste it into your
  own projects with no attribution and no conditions.

Both are declared in [`LICENSE`](LICENSE).

## Contributing

Corrections and additions welcome — especially version-drift fixes. See
[`CONTRIBUTING.md`](CONTRIBUTING.md).

Release notes are in [`CHANGELOG.md`](CHANGELOG.md).
