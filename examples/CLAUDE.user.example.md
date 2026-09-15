<!--
  Example user CLAUDE.md — copy to ~/.claude/CLAUDE.md.

  The one example here that is NOT part of the Acme Web repo: it lives on your
  machine and applies to every project, so keep it free of anything specific to
  one repo. The other three examples are files inside a single repo.
-->

# Personal instructions

## Style

- Be terse. No preamble, no "Great question!", no summary of what I just read.
- Show the diff or the command, not a paragraph describing it.
- When you are unsure, ask one question rather than guessing and building on it.

## Working habits

- For changes spanning more than two files, outline the approach before editing.
- Prefer editing existing code over rewriting it. Match the surrounding style.
- Ask before adding a dependency, and say what it replaces.
- Don't add comments that restate the code.

## Tooling

- Default package manager is pnpm unless the repo's lockfile says otherwise.
- Use `rg`, not `grep -r`.

<!--
  Not here: project commands, repo conventions, secrets, or absolute paths
  from this machine. Those go in the project CLAUDE.md, CLAUDE.local.md, or
  .claude/settings.local.json.
-->
