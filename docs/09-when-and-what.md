*Unofficial community guide — not affiliated with Anthropic. Reflects Claude Code as of Sep 2026 · last verified Sep 2026 · [official docs](https://code.claude.com/docs).*

# When & What — Choosing the Right Tool

Several features overlap, and the wrong choice usually still "works" — just more
expensively or less reliably.

## Cheat sheet: ask these in order

Stop at the first **yes**. The questions are ordered by how decisive they are,
so an earlier yes beats a later one.

1. **Must this happen every time, whatever Claude decides?**
   → a [hook](07-hooks.md). It is the only mechanism that is code rather than
   guidance; everything else is advisory.
2. **Does Claude need to reach outside the repo?**
   → [MCP](06-mcp.md). Nothing else adds new reach.
3. **Does it apply to (almost) every task in this project?**
   → `CLAUDE.md`. Short, imperative, always in context.
4. **Only to certain files or folders — and short enough to state as a few
   conventions?**
   → a path-scoped rule in `.claude/rules/`, or a nested `CLAUDE.md` when the
   guidance belongs to one directory. See [Memory](03-memory-claude-md.md).
   If it's more than a handful of lines, keep reading.
5. **Only when a particular job comes up, or is it a whole body of knowledge?**
   → a [skill](04-skills.md) — a procedure, a repeated prompt, or domain rules
   Claude can't infer from the code.
6. **Would doing it flood my context with output I won't need afterwards?**
   → a [subagent](05-subagents.md), which reports back a result instead of the
   search it waded through.
7. **Is the work deterministic?**
   → a script. Bundled in a skill it costs no context at all; wired to a hook it
   also becomes guaranteed.
8. **Should other repos get this too?**
   → package it as a [plugin](08-plugins.md).

The first two settle most arguments, because they're the only questions with a
hard answer — enforcement and reach. Everything below them is a cost trade-off,
so when two options both fit, take the cheaper one.

## The matrix

Keep this open when you set up a project:

| Mechanism | What it's for | Loaded | Deterministic? | Reach for it when |
|---|---|---|---|---|
| **CLAUDE.md / rules** | Always-on project norms | Every session | No — guidance | A rule applies to (almost) every task |
| **Skill** | A reusable procedure, prompt, or body of knowledge | On demand | No — guidance | You repeat a procedure only sometimes, or keep typing the same instruction |
| **Subagent** | Isolated / parallel work | When delegated | No — judgment | A task would flood context, or you want parallelism |
| **Hook** | A rule enforced automatically | On an event | Yes — code | The behaviour must happen every time |
| **MCP** | Reach external tools and data | Server connected | N/A — tools | Claude needs live data or to act outside the repo |

> **◆ Architect's take** — Default order of reach: **CLAUDE.md** for always-on
> norms, a **skill** for sometimes-on procedures and prompts you repeat, a
> **subagent** for context isolation or parallelism, a **hook** for
> anything that must be guaranteed, and **MCP** when Claude must reach outside
> the repo. When two options both fit, choose the one that costs less context
> and leaves less to chance.
