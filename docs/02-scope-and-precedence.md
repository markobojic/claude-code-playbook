*Unofficial community guide — not affiliated with Anthropic. Reflects Claude Code as of Sep 2026 · last verified Sep 2026 · [official docs](https://code.claude.com/docs).*

# Scope & Precedence

This is the spine of the guide. The same three-tier idea repeats across every
feature, so learn it once and each later topic only needs a one-line note.

## The tiers

- **Enterprise / managed** — deployed by IT, cannot be overridden. The lock.
- **Project** — committed to the repo, shared with the team. The shared truth.
- **User** — your global personal configuration across all projects.

Two more sit in the settings chain: local project settings (personal, per-repo,
git-ignored) and one-off command-line overrides for a single session.

## The one rule that matters

The trap is assuming everything layers the same way. It does not — two
mechanisms resolve two different ways:

| What resolves this way | Behaviour |
|---|---|
| **Settings & permissions** | Resolve by **precedence** — the highest tier wins per key (managed > CLI > local > project > user). List-type values such as permission rules and allowlists *merge* across the non-managed tiers instead of replacing. |
| **CLAUDE.md & rules** | **Accumulate** — every tier loads and stacks into context together (org + project + nested + user). Nothing "wins"; all instructions apply at once. |

So a stricter **permission** set by your org overrides everything below it,
while an org **CLAUDE.md** is added to — not replaced by — your project and
personal instructions. Getting this backwards is the single most common
configuration mistake.

> **◆ Architect's take** — Put anything a teammate's session would be wrong
> without into **project** scope. Keep personal ergonomics in **user** scope.
> Reserve **local** for secrets and machine-specific paths. Treat **managed** as
> enforcement, not convenience — if a rule doesn't truly need to be unbreakable,
> it belongs in project scope where the team can see and evolve it.
