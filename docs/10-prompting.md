*Unofficial community guide — not affiliated with Anthropic. Reflects Claude Code as of Sep 2026 · last verified Sep 2026 · [official docs](https://code.claude.com/docs).*

# Prompting & Workflow Technique

Prompt engineering is mostly clear communication with one habit added: iterate
against real examples. The techniques below are ordered from the most broadly
effective to the more specialized — reach for them roughly in this order.

## The technique ladder

1. **Be clear and direct.** Say exactly what you want, for whom, and in what
   form. Replace "analyze this data" with "list the top three products by
   revenue, the quarter-over-quarter trend, and any anomalies, as a table."
2. **Use examples (multishot).** Show two to five input→output examples. They
   communicate format and edge cases faster than description. Wrap them in
   `<examples>` and cover the tricky cases.
3. **Let Claude think (chain of thought).** For multi-step reasoning, ask Claude
   to work through it in `<thinking>` and give the result in `<answer>`. Skip it
   for simple lookups.
4. **Use XML tags.** When a prompt has multiple parts, tag them so Claude can't
   confuse one for another (see below).
5. **Prefill the response.** Begin the answer for it — an opening `{` to force
   JSON, or an opening tag — to control format. In Claude Code, state the exact
   output shape you want.
6. **Chain complex prompts.** Break a big task into a sequence of verified steps.
7. **Long-context tips.** Above roughly 20k tokens of input, put the documents
   first and your question last — worth up to 30% on complex multi-document
   prompts. Have Claude quote the relevant passages *first*, then answer from
   those quotes.

Each one is worked through, with copy-pasteable prompts, in
[`examples/prompt-patterns.md`](../examples/prompt-patterns.md).

## Structure and XML tags

XML tags give Claude unambiguous boundaries between the instruction, the
material to act on, and the format to produce.

```
<instructions>
You are reviewing a code change. List only correctness bugs — not style.
Return your findings inside <review> tags as a short bullet list.
If you find no bugs, write "No correctness issues found."
</instructions>

<diff>
{{THE DIFF}}
</diff>

<review>
```

That last open `<review>` tag doubles as a prefill. Three habits make tags work:

- **Be consistent.** Use the same tag names throughout, and refer to them by name.
- **Nest for hierarchy.** `<examples>` containing several `<example>` blocks.
- **Combine** with multishot (`<example>`) and chain of thought
  (`<thinking>` / `<answer>`).

## Examples and reasoning, in practice

If you can show it, don't describe it. A couple of worked examples pin down
formatting decisions prose leaves ambiguous — and they're the fastest cure for
output that's "almost right but inconsistent." Make examples diverse and include
at least one edge case.

For reasoning, the simplest reliable pattern is `<thinking>` for the working and
`<answer>` for the conclusion, so you (or a script) can read or discard the
reasoning cleanly. Reserve it for tasks where the reasoning actually matters.

## Prompting Claude Code specifically

The ladder is general craft. Working inside Claude Code adds habits that matter
more than wording:

- **Explore → plan → code.** Have Claude read and understand first, produce a
  plan (plan mode is built for this), then implement. Jumping to code is where
  agentic work goes sideways.
- **Give it a way to verify.** Point Claude at tests, a build, or a linter. A
  closed verification loop is the single biggest lever on output quality.
- **Bring specific context.** Name the files, paste the exact error, reference
  files directly with `@path/to/file`.
- **Course-correct early.** Interrupt and steer rather than letting it run far
  down the wrong path.
- **Manage context deliberately.** Clear between unrelated tasks, delegate noisy
  investigation to subagents, and ask for deeper reasoning with `ultrathink`.

> **◆ Architect's take** — If your team adopts two habits, make them **structure
> the prompt with XML tags** for anything non-trivial, and **always give Claude
> a way to verify its work**. The first removes ambiguity; the second lets
> Claude catch its own mistakes before you see them.

## Anti-patterns to avoid

- **Vague instructions.** "Make it better" gives Claude nothing to aim at.
- **One giant prompt** for a multi-part task. Chain it into verified steps.
- **Unstructured mixing** of instructions, data, and examples. Tag them apart.
- **Reasoning where none is needed** — it just burns latency.
- **Describing what an example would show.** If you can demonstrate it, do.
