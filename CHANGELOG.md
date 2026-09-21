# Changelog

All notable changes to this guide are recorded here. Because the guide tracks
a fast-moving product, entries note the Claude Code behaviour they reflect.

This project follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-09-21

First public release.

### Added

**The guide** — ten topics, plus an appendix for administrators:

- Setup & Configuration, Scope & Precedence, Memory & CLAUDE.md
- Skills, Subagents, MCP
- Hooks, Plugins
- When & What (decision cheat sheet and comparison matrix), Prompting & Workflow
- Enterprise deployment (appendix)

**Examples** — copy-pasteable artifacts under `examples/`:

- `CLAUDE.md` files for project, user, and nested scope
- A path-scoped rule in `.claude/rules/`
- Five skill blueprints, each covering a different part of the frontmatter
  surface: the minimal shape, `when_to_use` and knowledge skills, multi-file
  (reference + script + asset), forked execution
  (`context`/`agent`/`model`/`effort`), and guarded side effects
- A subagent, a hook, `settings.example.json`, and `.mcp.example.json`
- `prompt-patterns.md` — a worked prompt for each technique in the ladder

Everything under `examples/` is public domain (CC0 1.0) — copy it with no
attribution and no conditions. The guide itself is CC BY 4.0.

_Reflects Claude Code as of September 2026._
