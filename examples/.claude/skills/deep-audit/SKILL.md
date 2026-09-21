---
name: deep-audit
description: Audits an area of Acme Web for dead code, duplicated logic, and drift from the conventions in CLAUDE.md.
argument-hint: "[path-or-area]"
disable-model-invocation: true
context: fork
agent: Explore
model: inherit
effort: high
background: false
---

# Deep audit

<!--
  BLUEPRINT: running a skill somewhere other than your own context.

  Frontmatter demonstrated:
    context: fork   runs in a separate subagent instead of this conversation.
                    The fork does NOT see your history, so the instructions
                    below must stand alone — that is the main authoring cost.
    agent: Explore  which subagent type. Explore is read-only and built for
                    wide searching; general-purpose can also write.
    model: inherit  keep the session's model. Name a model instead to force a
                    cheap one for mechanical work, or a stronger one for
                    judgement. Reverts on your next prompt.
    effort: high    reasoning effort while the skill runs. low…max.
                    Worth raising for analysis, not for mechanical edits.
    background:     false = wait and return the findings into THIS turn.
                    The default (true) reports back later via a notification,
                    which is right for long audits but looks like nothing
                    happened if you are expecting an answer inline.

    disable-model-invocation keeps an expensive job from firing on its own.

  Cost note: forking spends a second context. Reach for it when the work would
  flood yours with search output you do not need to keep — not by default.
-->

Audit $ARGUMENTS in the Acme Web monorepo. You are running in a fresh context
and cannot see the conversation that invoked you, so gather what you need.

1. Read the root `CLAUDE.md` and any nested `CLAUDE.md` under the target path,
   so you know the conventions before judging anything against them.
2. Map the area: entry points, exports, and what imports them.
3. Report, most severe first:
   - **Dead code** — exported but never imported, or behind a flag removed long ago.
   - **Duplicated logic** — the same rule implemented twice, which drifts.
   - **Convention drift** — code contradicting a stated rule. Quote the rule.
4. For each finding give `file:line`, what is wrong, and the smallest fix.

Report findings only. Do not edit files — this audit is read-only by design.
If the area is clean, say so plainly rather than padding the list.
