# Claude Code Playbook

*Unofficial community guide — not affiliated with Anthropic. Reflects Claude Code as of Sep 2026 · last verified Sep 2026 · [official docs](https://code.claude.com/docs).*

## How to read this guide

This is a playbook, not a manual. It says what each part of Claude Code is,
where it lives, and — the part that matters — when to reach for it and what we
recommend. It is deliberately focused: enough to make good decisions on a real
project without reproducing the official docs.

**The one distinction to get straight first.** *Claude Code* is the main agent —
the session you talk to. *Subagents* are helpers it spawns to do isolated work
and report back. When this guide says "the agent," it means your Claude Code
session; "subagent" always means a delegated helper.

**Conventions.** Blockquotes marked *Architect's take* contain the
recommendation — if you skim nothing else, read those. The **enterprise
appendix** is for admins configuring Claude Code org-wide; most developers can
skip it.

## How the pieces fit

Read the foundations first, because they tell you where everything lives:

- **[Setup & Configuration](01-setup-and-config.md)** — the `.claude/`
  directory, settings files, permission modes.
- **[Scope & Precedence](02-scope-and-precedence.md)** — enterprise / project /
  user tiers, and the one rule that trips everyone up.
- **[Memory & CLAUDE.md](03-memory-claude-md.md)** — standing instructions,
  rules, auto memory.

Then the building blocks:

- **[Skills](04-skills.md)** — reusable, model-invoked capabilities.
- **[Subagents](05-subagents.md)** — delegated work in an isolated context.
- **[MCP](06-mcp.md)** — connecting external tools and data.

Then guardrails and packaging:

- **[Hooks](07-hooks.md)** — deterministic, event-driven guardrails.
- **[Plugins](08-plugins.md)** — packaging a setup for reuse across projects.

Then judgment:

- **[When & What](09-when-and-what.md)** — the decision framework and a
  comparison matrix.
- **[Prompting & Workflow](10-prompting.md)** — techniques and Claude-Code-specific habits.
