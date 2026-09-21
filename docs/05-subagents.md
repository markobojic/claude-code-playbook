_Unofficial community guide — not affiliated with Anthropic. Reflects Claude Code as of Sep 2026 · last verified Sep 2026 · [official docs](https://code.claude.com/docs)._

# Subagents

A subagent is a specialized Claude instance the main agent spawns to handle a
focused task in its **own context window**, with its own system prompt and tool
list. The parent delegates and gets back only a summary — so the main thread
stays clean. That one idea, **context isolation**, is the whole reason
subagents exist.

The problem they solve is concrete. A long session fills its context with file
reads, tool output, and dead ends; past roughly two-thirds full, quality drops
because the signal-to-noise ratio collapsed. A subagent does the noisy work off
to the side and returns just the conclusion.

## The built-in subagents

- **Explore** — read-only, runs on a fast, cheap model. Searches and understands
  a codebase without changing it.
- **Plan** — gathers context before Claude presents a strategy in plan mode.
- **general-purpose** — handles tasks needing both exploration and modification.

These show you what a good custom subagent looks like: narrow scope, tools
matched to the job, model matched to the difficulty.

## How to create one

The recommended path is the interactive `/agents` command, which walks you
through name, description, tools, model, and colour, and can draft the system
prompt. Under the hood every subagent is a markdown file with YAML frontmatter —
the frontmatter configures it, the body becomes its system prompt.

```yaml
---
name: code-reviewer
description: Reviews code for quality and security. Use PROACTIVELY after
    writing or modifying code.
tools: Read, Grep, Glob
model: sonnet
---
You are a code reviewer. For each issue, explain the problem, show the
current code, and provide an improved version. Focus on correctness, security,
and clarity — not style nits.
```

Save it under `.claude/agents/` (project, committed) or `~/.claude/agents/`
(user). Both directories are watched; edits are picked up within seconds.

## Where they live and which one wins

When names collide, Claude Code resolves in a strict priority order:

- **Session** (defined for the current session) — highest.
- **Project** — `.claude/agents/`, committed. The team's shared specialists.
- **User** — `~/.claude/agents/`. Your personal toolkit.
- **Plugin** — provided by an installed plugin. Lowest.

Directories are scanned recursively, so you can organise into subfolders; the
subfolder doesn't change identity, which comes only from the `name` field. Keep
names unique.

## How delegation works

**Automatic delegation:** Claude matches your request against each subagent's
`description` and routes on its own. **Explicit invocation:** you name it — "Use
the code-reviewer subagent on the auth module."

Automatic delegation lives or dies on the description. Write it as a routing
rule: name the exact situations and phrases that should trigger it, and add "use
PROACTIVELY" when you want Claude to reach for it unprompted.

> **◆ Architect's take** — The description is a **routing decision**, not
> documentation. A precise, trigger-oriented description is the difference
> between a subagent that quietly does its job and one that never fires.

## Controlling tools, model, and permissions

- **Tools.** List them in `tools` and the subagent can use only those; omit the
  field and it inherits everything, including MCP tools. Scope tightly — a
  research agent needs `Read, Grep, Glob` and nothing that can write.
- **Model.** Set `model` per subagent. Routing a 40-file `Explore` sweep to a
  small model is real money on metered billing. Use `inherit` to follow the
  session, or set `CLAUDE_CODE_SUBAGENT_MODEL` to force a ceiling.

Beyond those: `permissionMode`, `disallowedTools`, `mcpServers` (which servers
it can reach), `skills` (preloaded), `maxTurns`, and `memory` (a _scope_ —
`user`, `project` or `local`, not `true`).

## Foreground, background, and parallel work

A subagent runs in the foreground (you wait) or background (its summary arrives
when done). Two patterns:

- **Parallel fan-out.** Spawn several independent subagents at once — one per
  file, module, or hypothesis — and collect their summaries.
- **Chaining.** Feed one subagent's output into the next: design → review →
  implement → test, each in its own clean context.

## Subagent, skill, or agent team?

| Primitive      | How it runs                                     | Reach for it when                                                  |
| -------------- | ----------------------------------------------- | ------------------------------------------------------------------ |
| **Skill**      | In the main conversation; loads on demand       | You want a reusable procedure or knowledge applied inline          |
| **Subagent**   | In an isolated child context; returns a summary | You need to isolate noisy work or run investigations in parallel   |
| **Agent team** | Several coordinated agents working together     | A task genuinely splits into parallel streams that must coordinate |

Agent teams are the heavyweight option — reach for them only when a task truly
decomposes. For most work, one or two well-scoped subagents are plenty.

## Best practices and frontmatter reference

- **Start with one.** A code-reviewer is the safest first subagent.
- **Scope tools tightly.** Never leave a research agent able to write.
- **Match model to difficulty.** Small for search; frontier for hard reasoning.
- **Write descriptions as routing rules.** Trigger phrases and "use proactively."
- **Summarise aggressively.** Tell them to return conclusions, not transcripts.
- **Commit shared specialists** to `.claude/agents/`.

| Field             | What it does                                    | Example                      |
| ----------------- | ----------------------------------------------- | ---------------------------- |
| `name`            | Unique id, lowercase and hyphens. Required.     | `code-reviewer`              |
| `description`     | When Claude should delegate. Required.          | free text                    |
| `tools`           | Tools it may use; omit to inherit all.          | `Read, Grep, Glob`           |
| `model`           | Model for this subagent.                        | `sonnet` · `inherit`         |
| `permissionMode`  | Permission mode it runs under.                  | `default` · `plan`           |
| `disallowedTools` | Tools removed from its pool.                    | `Bash`                       |
| `mcpServers`      | Which MCP servers it can reach.                 | `github`                     |
| `skills`          | Skills preloaded into it.                       | `test-runner`                |
| `maxTurns`        | Cap on its turns.                               | `20`                         |
| `memory`          | Persistent memory **scope** across invocations. | `project` · `user` · `local` |
