*Unofficial community guide — not affiliated with Anthropic. Reflects Claude Code as of Sep 2026 · last verified Sep 2026 · [official docs](https://code.claude.com/docs).*

# Plugins

A plugin turns a good individual setup into shared, reusable infrastructure.

## What a plugin bundles

A plugin packages skills, subagents, hooks, MCP servers, and commands into one
installable unit, distributed through a **marketplace** (a git repo, a URL, or a
local path). It is the packaging layer for everything in the building-block and
guardrail topics.

```bash
/plugin marketplace add your-org/claude-plugins
/plugin install team-standards@your-org
```

## When to package one

- **Leave it in the repo** while a setup is still specific to one project, or
  still changing shape. A committed `.claude/` is already shared with the team.
- **Package a plugin** once the same setup is worth carrying across repos, or
  once you want teammates to install a versioned baseline rather than copy
  directories between projects.

> **◆ Architect's take** — This is how the guide becomes real. Once a setup
> proves itself in one repo, **package it as a plugin** and host an internal
> marketplace, so every new project starts from a standardized baseline instead
> of copy-paste and tribal knowledge. Treat your Claude Code configuration as
> infrastructure to be versioned and shared.
