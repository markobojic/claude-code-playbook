*Unofficial community guide — not affiliated with Anthropic. Reflects Claude Code as of Sep 2026 · last verified Sep 2026 · [official docs](https://code.claude.com/docs).*

# Skills

A **skill** packages a procedure, a convention, or a body of domain knowledge
into a folder that Claude loads only when the task calls for it. Two properties
make skills worth mastering. First, they are **model-invoked**: Claude reads
your request, matches it against each skill's description, and loads the
relevant one on its own. Second, they use **progressive disclosure**: only the
short description sits in context at all times; the full body loads when the
skill is actually used. So you can keep a large library available and pay its
full cost only when a skill earns its place.

Custom slash commands have been **merged into skills** — a file at
`.claude/commands/deploy.md` and a skill at `.claude/skills/deploy/SKILL.md`
both create `/deploy` and work the same way. Prefer skills for new work: they
add supporting files, invocation control, and automatic loading. Existing
`.claude/commands/` files keep working, so an inherited repo full of them needs
no migration.

## What a skill does, and when Claude should use it

Both answers live in the **description** — the single most important line in the
file, because it is the only part Claude sees before deciding whether to load
the skill. Write it to answer *what the skill does* and *when to use it*, in the
words a developer would naturally say.

```yaml
---
description: Explains code with visual diagrams and analogies. Use when
  explaining how code works, teaching about a codebase, or when the user
  asks "how does this work?"
---
```

Two fields refine triggering: `when_to_use` appends extra trigger phrases, and
`paths` restricts automatic loading to matching files (e.g. `src/api/**`). The
combined description text is truncated at 1,536 characters in the listing, so
put the key use case first.

> **◆ Architect's take** — When a skill "never triggers," the description is
> almost always the cause. Lead with the trigger — what the user is trying to
> do, in their words — not with the mechanism. Treat the description as a
> product decision, not an afterthought.

## Anatomy of a SKILL.md

Every skill is a directory containing a `SKILL.md` with two parts: YAML
frontmatter between `---` markers (when to use it) and markdown content (the
instructions Claude follows once it runs). The opening `---` must be the file's
first line.

```yaml
---
name: api-conventions
description: API design patterns for this codebase. Use when writing or
  reviewing HTTP endpoints.
allowed-tools: Read Grep
---

When writing API endpoints:
- Use RESTful naming conventions
- Return a consistent error envelope { error: { code, message } }
- Validate the request body before touching the database
```

Keep the body concise — once loaded it stays in context across turns, so every
line is a recurring token cost.

## How to create one

```bash
mkdir -p ~/.claude/skills/summarize-changes
```

Write the `SKILL.md`:

```yaml
---
description: Summarizes uncommitted changes and flags anything risky. Use
  when the user asks what changed, wants a commit message, or asks to
  review their diff.
---

## Current changes

!`git diff HEAD`

## Instructions

Summarize the changes above in two or three bullets, then list any risks
you notice. If the diff is empty, say there are no uncommitted changes.
```

The `` !`git diff HEAD` `` line is dynamic context injection: Claude Code runs
the command and inlines its output *before* Claude reads the skill. Test it by
asking "What did I change?" or invoking `/summarize-changes`. Skill directories
are watched live, so edits take effect without restarting.

## Multi-file skills: references, scripts, assets

Bundle supporting files beside `SKILL.md` to keep the always-loaded file small
while heavy material loads only when needed.

```
my-skill/
  SKILL.md         # required — overview + navigation, kept short
  reference.md     # detailed docs — loaded only when needed
  scripts/
    helper.py      # executed, never loaded into context
  assets/
    template.html  # files the script reads or emits
```

- **References** (markdown) are read on demand. Link them from `SKILL.md` so
  Claude knows what each holds.
- **Scripts** are *executed, not read into context*. A 300-line script costs no
  tokens. Use scripts for deterministic work.
- **Assets** are templates or fixtures the scripts consume or produce.

Reference bundled files with `${CLAUDE_SKILL_DIR}` so paths resolve at any
install level.

> **◆ Architect's take** — Keep `SKILL.md` under ~500 lines and push everything
> situational into references and scripts. If a paragraph isn't needed on
> *every* run, it belongs in a reference file. Prefer a script over prose
> whenever the work is deterministic — it's free context and can't be forgotten
> mid-task.

## Allowed tools

`allowed-tools` pre-approves specific tools for the turn that invokes the skill.
The grant is **per-turn** and it **adds** permission — it does not restrict;
every other tool is still available under your normal settings.

```yaml
---
name: commit
description: Stage and commit the current changes.
disable-model-invocation: true
allowed-tools: Bash(git add *) Bash(git commit *) Bash(git status *)
---
```

`disallowed-tools` removes tools while the skill is active. To pin access for
the whole session, use permission rules instead; you can also gate the skill
itself with rules like `Skill(commit)`.

> **◆ Architect's take** — A project skill's `allowed-tools` applies even in
> folders you've never trusted, so **review the allowed-tools of any skill you
> pull from a shared repo** before running Claude Code there. Pair
> `allowed-tools` with `${CLAUDE_SKILL_DIR}` scoped to the exact bundled script.

## Model, effort, and running in a subagent

`model` overrides the model for the skill's turn (`inherit` or a model name);
`effort` sets reasoning effort (`low` … `max`). Both revert on your next prompt.
For isolation, `context: fork` runs the skill in a separate subagent, with
`agent` choosing the type (`Explore`, `Plan`, `general-purpose`) and
`background` controlling whether you wait. A forked skill doesn't see your
conversation history, so its instructions must stand alone.

```yaml
---
name: deep-research
description: Research a topic thoroughly across the codebase.
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly, then summarize findings with file references.
```

## Invocation, arguments, and dynamic context

- `disable-model-invocation: true` — only you can run it (`/name`). Use for
  side effects: `/deploy`, `/commit`.
- `user-invocable: false` — only Claude can run it. Use for background knowledge.
- **Arguments** via `$ARGUMENTS`, `$0`/`$1`, or named args in frontmatter.
- **Dynamic context**: `` !`command` `` runs a shell command and injects its
  output before Claude sees the content. Append `|| true` to commands that may
  exit non-zero.

## How to test a skill

Seeing a skill trigger tells you Claude found it — not that it did what you
intended. Measure both.

**Baseline comparison** (no tooling): run a handful of realistic prompts in a
*fresh* session with the skill on, and again with it off, and compare. A fresh
session matters — leftover authoring context hides gaps.

**Automate with skill-creator:**

```bash
/plugin install skill-creator@claude-plugins-official
# then, in conversation:
evaluate my summarize-changes skill with skill-creator
```

It stores cases in `evals/evals.json`, runs each in an isolated subagent,
grades assertions, and benchmarks with-skill vs. without-skill. For plugin
skills, `claude plugin eval` can gate CI; `/skill-doctor` reports each skill's
context cost and how often it fires.

**When a skill won't trigger:** check the description uses the words a user
would say; confirm it loads ("What skills are available?"); if it triggers too
often, make the description more specific or set `disable-model-invocation`.

## Best practices, distilled

- **Description first.** Write it for triggering; lead with the user's intent.
- **Keep the body lean.** Under ~500 lines; state what to do, not why.
- **Push weight outward.** References for knowledge, scripts for deterministic work.
- **Scope tools narrowly.** Grant only what's needed, pinned to a script.
- **Match model to job.** Cheap for mechanical skills; fork for research.
- **Guard side effects.** Anything that deploys or commits gets `disable-model-invocation: true`.
- **Measure, don't assume.** Baseline-compare in fresh sessions; retire unused skills.

## Frontmatter quick reference

| Field | What it does | Example |
|---|---|---|
| `description` | What the skill does and when to use it. The field Claude matches on. | free text |
| `when_to_use` | Extra trigger phrases, appended to description. | free text |
| `allowed-tools` | Tools pre-approved (no prompt) for the invoking turn. | `Read Grep` |
| `disallowed-tools` | Tools removed while the skill is active. | `AskUserQuestion` |
| `model` | Model to use while the skill runs. | `inherit` |
| `effort` | Reasoning effort while active. | `low` … `max` |
| `disable-model-invocation` | Only you can invoke it. | `true` / `false` |
| `user-invocable` | Only Claude can invoke it. | `true` / `false` |
| `context` | Run the skill in a forked subagent. | `fork` |
| `agent` | Subagent type when `context: fork`. | `Explore` |
| `paths` | Auto-load only for matching files. | `src/api/**` |
