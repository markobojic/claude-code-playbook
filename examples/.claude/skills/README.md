# Skill blueprints

Five skills, each demonstrating a different part of the frontmatter surface.
Read them in this order — each adds one idea to the last. Full field reference
is in [docs/04-skills.md](../../../docs/04-skills.md).

| Skill | Demonstrates |
|---|---|
| [`summarize-changes`](summarize-changes/SKILL.md) | The minimum: `description` only, plus `` !`cmd` `` dynamic context |
| [`billing-rules`](billing-rules/SKILL.md) | `when_to_use`, `user-invocable: false` — domain knowledge, not a procedure |
| [`release-notes`](release-notes/SKILL.md) | Multi-file: `reference.md` + `scripts/` + `assets/`, `arguments`, pinned `allowed-tools` |
| [`deep-audit`](deep-audit/SKILL.md) | `context: fork`, `agent`, `model`, `effort`, `background` |
| [`commit`](commit/SKILL.md) | `disable-model-invocation` + narrow `allowed-tools` for a side effect |

Each `SKILL.md` carries a `BLUEPRINT:` comment explaining why its fields are set
the way they are. Those are block HTML comments, so they are stripped before the
file reaches Claude's context — they cost nothing and can be deleted freely.

## The three decisions that matter most

1. **The description is a routing decision.** It is the only part Claude sees
   before choosing to load the skill. Lead with the user's intent in the words
   they would use. When a skill "never triggers," this is almost always why.
2. **Keep `SKILL.md` small.** Once loaded it stays in context. Push detail into
   a reference file, and deterministic work into a script — a script is
   executed, never read, so its length is free.
3. **Guard side effects.** Anything that writes, commits, deploys or publishes
   gets `disable-model-invocation: true`, and `allowed-tools` pinned to exact
   commands rather than a wildcard.

## Before you copy one

`allowed-tools` in a *project* skill applies even in folders you have never
trusted, so read it before running Claude Code in a repo whose skills you did
not write. `release-notes` pins its grant to one bundled script
(`Bash(${CLAUDE_SKILL_DIR}/scripts/collect-changes.sh*)`) rather than
`Bash(git *)` for exactly this reason.

These are blueprints for the fictional **Acme Web** monorepo used throughout
`examples/` — see [`CLAUDE.project.example.md`](../../CLAUDE.project.example.md).
They live in a real `.claude/skills/` path, so Claude Code discovers them when
working in this repository.
