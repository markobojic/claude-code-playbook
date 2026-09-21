*Unofficial community guide — not affiliated with Anthropic. Reflects Claude Code as of Sep 2026 · last verified Sep 2026 · [official docs](https://code.claude.com/docs).*

# When & What — Choosing the Right Tool

Several features overlap, and the wrong choice usually still "works" — just more
expensively or less reliably. Two questions cut through most decisions:

- **Always or sometimes?** Does this always apply (→ CLAUDE.md / rules) or only
  sometimes (→ skill)?
- **Judgment or guarantee?** Do you want Claude to decide (→ instructions,
  skills, subagents) or must it happen every time (→ hook)?

The matrix to keep open when you set up a project:

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
