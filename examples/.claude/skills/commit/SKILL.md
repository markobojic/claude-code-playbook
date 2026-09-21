---
name: commit
description: Stages the current changes and commits them with a conventional-commit message.
disable-model-invocation: true
allowed-tools: Bash(git add *) Bash(git status *) Bash(git diff *) Bash(git commit *)
---

# Commit

<!--
  BLUEPRINT: guarding a skill that has a side effect.

  Frontmatter demonstrated:
    disable-model-invocation: true
        Claude can never run this on its own — only you, by typing /commit.
        Every skill that writes, deploys, publishes, or commits gets this.
    allowed-tools
        Pre-approves these calls for the invoking turn only; the grant clears
        on your next message. It ADDS permission and never restricts, so list
        the narrowest patterns that work. Note what is absent: no `git push`,
        no `git reset`, no bare `Bash(git *)`.

  To pin access for a whole session, use permission rules in settings.json
  instead — and you can gate the skill itself with a rule like Skill(commit).
-->

## Current state

!`git status --short`

!`git diff --stat HEAD`

## Instructions

1. If nothing is staged and nothing is modified, say so and stop.
2. Group the changes by intent. If they are clearly two unrelated changes, say
   so and propose two commits rather than one mixed one.
3. Stage what belongs in the commit. Never `git add -A` blindly — name paths.
4. Write a conventional-commit message: `type(scope): summary` under 72
   characters, where type is feat, fix, chore, docs, refactor, or test.
   Add a body only when the *why* is not obvious from the summary.
5. Show the message and wait for approval before committing.
6. Never push. Pushing is a separate, deliberate step.
