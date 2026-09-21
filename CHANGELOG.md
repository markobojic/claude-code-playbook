# Changelog

All notable changes to this guide are recorded here. Because the guide tracks
a fast-moving product, entries note the Claude Code behaviour they reflect.

This project follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] — 2026-09-21

An accuracy pass over the reference tables, verified against the official docs.

### Fixed

- **Subagents** — `memory` documented as taking `true`. It takes a *scope*
  string: `user`, `project`, or `local`. A config copied from the old table
  did not do what it looked like it did.
- **Hooks** — hook `type` listed four values; there are five. Added `mcp_tool`.
- **Skills** — `argument-hint` and `arguments` were used by the `release-notes`
  blueprint but had no rows in the frontmatter reference. Added, along with
  `background` and `shell`.
- **Skills** — documented the fenced `` ```! `` form for multi-line dynamic
  context, which `release-notes` uses; only the inline form was described.
- **Setup** — the permission mode called "Normal" is labelled **Manual** and
  identified as `default`. Modes are now a table pairing each label with the
  identifier `defaultMode` actually takes, and `dontAsk` is described as
  auto-denying rather than stopping.

### Added

- **Hooks** — `InstructionsLoaded` and `SessionEnd` rows; `InstructionsLoaded`
  reports *why* an instruction file loaded, which the memory topic leaves you
  wanting.
- Reference tables now state that they are curated rather than exhaustive, and
  link to the official reference for the full surface.

_Reflects Claude Code as of September 2026._

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
