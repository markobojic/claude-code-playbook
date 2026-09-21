---
name: release-notes
description: Drafts release notes for Acme Web from the commits between two tags.
argument-hint: "[since-tag] [until-tag]"
arguments: since until
disable-model-invocation: true
allowed-tools: Bash(${CLAUDE_SKILL_DIR}/scripts/collect-changes.sh*)
---

# Release notes

<!--
  BLUEPRINT: the multi-file shape — SKILL.md + reference + script + asset.

    SKILL.md      navigation, kept short. This is the only file always loaded.
    reference.md  the style guide. Read ONLY when drafting, not every run.
    scripts/      executed, never read into context. A long script costs 0 tokens.
    assets/       templates the script or Claude fills in.

  Frontmatter demonstrated:
    argument-hint            shown during / autocomplete
    arguments                names positions, so $since / $until work below
    disable-model-invocation only you can run it — it has a side effect
    allowed-tools            pinned to the ONE bundled script, not Bash(git *).
                             A project skill's grant applies in folders you have
                             never trusted, so keep it exact.

  Reference bundled files with ${CLAUDE_SKILL_DIR} so paths resolve wherever
  the skill is installed.
-->

## Collect the changes

```!
${CLAUDE_SKILL_DIR}/scripts/collect-changes.sh "$since" "$until"
```

## Draft the notes

1. Read `${CLAUDE_SKILL_DIR}/reference.md` for the wording rules before you
   write anything. Do not guess the house style.
2. Fill in `${CLAUDE_SKILL_DIR}/assets/template.md` with the collected changes.
3. Group entries under Added / Fixed / Changed. Drop anything user-invisible —
   refactors, CI tweaks, dependency bumps — unless it changes behaviour.
4. If the script found no commits, say so and stop. Do not invent entries.
