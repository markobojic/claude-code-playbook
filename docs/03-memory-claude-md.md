*Unofficial community guide — not affiliated with Anthropic. Reflects Claude Code as of Sep 2026 · last verified Sep 2026 · [official docs](https://code.claude.com/docs).*

# Memory & CLAUDE.md

`CLAUDE.md` is the project's standing brief — the context Claude Code carries
into every session. It is the most-read and most-abused file in the setup.

## CLAUDE.md

It loads automatically and **accumulates** across tiers, broadest first: an
org-wide file, your personal `~/.claude/CLAUDE.md`, the project-root file, then
any nested per-directory `CLAUDE.md` for the folder Claude is working in. The
most specific instruction is the last thing Claude reads. Write it
like standing orders: short, imperative, specific. "Run the test suite with
`pnpm test` before proposing a commit" earns its place; three paragraphs of
architectural history do not.

Aim for **under 200 lines**; adherence drops as the file grows. You can pull in
other files with `@path/to/file` imports, but note what that does and doesn't
buy you: imported files are expanded into context **at launch**, so imports
organise your instructions without reducing their cost. Only path-scoped rules
and nested files actually defer loading.

Two conveniences worth knowing: `/memory` opens the active memory files for
editing, and `/context` shows which ones actually loaded this session — the
first thing to check when an instruction seems to be ignored. Block-level HTML
comments are stripped before the file enters context, so you can leave notes
for human maintainers for free.

## The three scopes, side by side

The same project/user split from [Scope & Precedence](02-scope-and-precedence.md)
decides what goes where: project scope holds anything a teammate's session would
be wrong without, user scope holds your personal ergonomics.

The examples below are one worked scenario — a fictional pnpm monorepo — so you
can see how the files sit relative to each other:

```
acme-web/                          ← one repo, three of the four examples
├── CLAUDE.md                      ← CLAUDE.project.example.md
├── .claude/rules/testing.md       ← spans every package
└── packages/api/
    └── CLAUDE.md                  ← CLAUDE.nested.example.md

~/.claude/CLAUDE.md                ← CLAUDE.user.example.md (your machine,
                                     every project, not part of the repo)
```

| Scope | Location | Holds | Example |
|---|---|---|---|
| **Project** | `./CLAUDE.md` (committed) | Commands, conventions, invariants | [`CLAUDE.project.example.md`](../examples/CLAUDE.project.example.md) |
| **User** | `~/.claude/CLAUDE.md` | Style and habits, every repo | [`CLAUDE.user.example.md`](../examples/CLAUDE.user.example.md) |
| **Nested** | `packages/api/CLAUDE.md` | What's true of one folder only | [`CLAUDE.nested.example.md`](../examples/CLAUDE.nested.example.md) |

They **accumulate** — a nested file stacks on top of the root file rather than
replacing it, so it should contain only what the root file doesn't already say.
For personal, per-repo notes that shouldn't be committed, `CLAUDE.local.md` sits
beside `CLAUDE.md` and is git-ignored.

## Rules

When instructions get long, or only apply to part of the tree, split them into
`.claude/rules/` files — one topic per file.

**A rule is registered by existing.** Drop a `.md` file in `.claude/rules/` and
Claude Code finds it; the search is recursive, so `rules/frontend/forms.md`
works too. Nothing points at it, and nothing needs to — there is no wiring step.

> **Don't import a rule from `CLAUDE.md`.** The only way to reference one is
> `@path`, which is an *import*, and imports load at launch. Pulling in a
> path-scoped rule that way silently turns it into an always-loaded one — the
> exact cost you wrote it as a rule to avoid.

What makes a rule conditional is a **`paths:`** field in its frontmatter:

```yaml
---
paths:
  - "packages/*/src/**/*.test.ts"
---
```

| Rule file | Loads |
|---|---|
| No `paths:` | At launch, every session — same priority as the project `CLAUDE.md` |
| With `paths:` | When Claude **reads** a file matching one of the globs |

The trigger is a *file read*, not the subject of your prompt. Asking "add a test
for the login handler" does not by itself load a rule scoped to `*.test.ts` — it
fires once Claude reads a matching file. Write a brand-new test without reading
an existing one and it may never fire; `/compact` drops path-scoped rules the
same way, and they return only when a matching file is read again.

So a path-scoped rule is **reactive**. If the guidance must apply every time
regardless of what gets read, drop the `paths:` field or put it in `CLAUDE.md`.

To check what loaded, run `/context`; the `InstructionsLoaded`
[hook](07-hooks.md) logs which instruction files loaded and why.

`~/.claude/rules/` is the user-scope equivalent, applying to every project on
your machine.

## Rules folder vs. nested CLAUDE.md

Both keep the always-loaded file lean by deferring until relevant. They differ
in what they key off:

| | `.claude/rules/*.md` | Nested `CLAUDE.md` |
|---|---|---|
| Scoped by | Glob patterns in `paths:` | Its own directory |
| Loads when | Claude reads a matching file | Claude reads a file in that folder |
| Spans folders | Yes — `**/*.test.ts` covers the tree | No |
| Lives | Centrally, in `.claude/rules/` | Beside the code it governs |
| Best for | One topic: testing, security, API design | A package's own quirks |

Reach for a **rule** when the guidance follows a *file type or concern* across
the repo, and for a **nested `CLAUDE.md`** when it follows a *directory* and its
owning team. The worked example makes the split concrete: testing conventions
apply to `*.test.ts` in every package, so no single folder owns them — that's
[`testing.md`](../examples/.claude/rules/testing.md). How to run and lay out
`packages/api` is true of that folder and nowhere else — that's
[`CLAUDE.nested.example.md`](../examples/CLAUDE.nested.example.md).

If you find yourself writing a rule whose glob is just one directory, you
wanted a nested `CLAUDE.md`.

## What not to put in it

Most bloated `CLAUDE.md` files are full of things that belong somewhere else:

| Don't put this in `CLAUDE.md` | Put it here instead |
|---|---|
| Architectural history, "why we chose X" | Your docs — Claude reads them on request |
| Long situational procedures (deploy, release) | A [skill](04-skills.md) |
| Guidance for one folder or file type | `.claude/rules/` or a nested `CLAUDE.md` |
| Rules that must be *enforced*, not suggested | A [hook](07-hooks.md) — memory is advisory |
| Machine-specific paths, personal per-repo notes | `CLAUDE.local.md` (git-ignored) |
| Secrets and tokens | Not in any memory file — use your environment or secret store |
| Directory listings, dependency lists | Nothing — Claude can read the tree itself |
| "Write clean code", "you are an expert developer" | Nowhere; it costs tokens and changes nothing |
| Commands that no longer work | Fix or delete them — a stale command is worse than none |

## Auto memory

Claude Code can also maintain its own memory of things it learns across a
session. Treat it as a convenience for continuity, not as the place for
authoritative project rules — those you write and review by hand.

> **◆ Architect's take** — Keep `CLAUDE.md` **lean**: it is in context on every
> turn, so every line costs tokens and attention. If a block of guidance is
> long, or only relevant sometimes, it belongs in a [skill](04-skills.md), not
> here. In monorepos, prefer several small nested files over one giant root file.
> And treat every line as a promise: a command that no longer works or a
> convention the team abandoned doesn't just waste context, it actively
> misleads. Re-read the file whenever the build changes.
