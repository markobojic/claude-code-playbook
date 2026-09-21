*Unofficial community guide — not affiliated with Anthropic. Reflects Claude Code as of Sep 2026 · last verified Sep 2026 · [official docs](https://code.claude.com/docs).*

# Setup & Configuration

Everything Claude Code knows about a project lives in a small set of files.
Learn the layout once and the rest of this guide has a place to hang.

## The .claude/ directory

Per project, Claude Code reads from a `.claude/` folder at the repo root, plus
a couple of root-level files:

```
your-project/
  .claude/
    settings.json         # team settings (commit this)
    settings.local.json   # personal overrides (git-ignored)
    agents/               # subagent definitions
    skills/               # project skills
    commands/             # slash commands (legacy; prefer skills/)
    rules/                # path-specific instruction files
    hooks/                # scripts that settings.json points at
  .mcp.json               # shared MCP servers (commit this)
  CLAUDE.md               # always-on project instructions
```

Your personal, cross-project versions of these live under `~/.claude/` (for
example `~/.claude/settings.json` and `~/.claude/CLAUDE.md`).

**Discovered vs. referenced.** Settings, agents, skills, commands and rules are
*discovered*: they work only in those exact directories, and a skill moved out
of `.claude/skills/` simply isn't found. Hook scripts are *referenced* — the
path in `settings.json` is the only thing that matters, so `.claude/hooks/` is a
useful convention rather than a requirement. `.mcp.json` is the exception in the
other direction: it's a cross-tool standard file and belongs at the project root.
`CLAUDE.md` is the one file with two valid homes — `./CLAUDE.md` or
`./.claude/CLAUDE.md` load identically; root is conventional because it's
visible to anyone browsing the repo.

## Settings files

- **User** — `~/.claude/settings.json`. Your personal defaults across every project.
- **Project** — `.claude/settings.json`. Checked into source control, shared with the team.
- **Local** — `.claude/settings.local.json`. Personal, machine-specific overrides; git-ignored automatically.

Settings cover permissions, environment variables, hooks, and model choice.
[Scope & Precedence](02-scope-and-precedence.md) explains exactly how they combine.

## Permission modes

Permission mode decides how much Claude Code does before asking you. You switch
modes per session, or set a default with `defaultMode` in settings — which takes
the identifier in the second column, not the label you see in the UI.

| Mode | Identifier | Behaviour |
|---|---|---|
| **Manual** | `default` | Prompts on first use of each tool. The safe default. (`manual` is accepted as an alias.) |
| **Plan** | `plan` | Reads and explores but makes no changes until you approve a plan. |
| **Accept edits** | `acceptEdits` | Auto-approves file edits and common filesystem commands; still gates riskier actions. |
| **Auto** | `auto` | A classifier reviews each action, approving what aligns with your request and escalating the rest. |
| **Don't ask** | `dontAsk` | Auto-**denies** anything that would otherwise prompt. Pre-approved tools and no-approval actions still run. |
| **Bypass** | `bypassPermissions` | Skips the prompts entirely. Powerful and dangerous; sandboxed use only. |

`auto` and `bypassPermissions` can each be taken off the table entirely with
`permissions.disableAutoMode` and `permissions.disableBypassPermissionsMode` —
usually set in managed settings, but they work from any scope, so you can lock
yourself out of bypass mode on your own machine.

> **◆ Architect's take** — Start new work in **plan mode** to let Claude map the
> ground, then move to **acceptEdits** once you trust its plan. Commit a project
> `settings.json` with sensible permissions so the whole team inherits the same
> baseline. Never ship `bypassPermissions` as a default.
