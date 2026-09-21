# Prompt patterns — worked examples

One example per technique in the [prompting ladder](../docs/10-prompting.md),
in the same order. Copy a block, swap in your own material.

Where the contrast teaches something, a **Weak** version comes first. Where it
doesn't, there's only the good one.

---

## 1. Be clear and direct

Say what you want, for whom, and in what form.

**Weak** — nothing to aim at, so Claude picks its own scope and format:

```
Review this endpoint.
```

**Better:**

```
Review packages/api/src/routes/invoices.ts for correctness bugs only —
skip style and naming, a formatter handles those.

For each bug: the line number, what input triggers it, and the smallest fix.
Order by severity. If you find none, say "No correctness issues found."
```

The three additions that matter: what to look for, what to ignore, and the
exact shape of the answer.

---

## 2. Use examples (multishot)

Two to five input→output pairs pin down format faster than any description.
Include at least one edge case — that's where formats break.

```
Write a commit message for the diff below. Follow these examples exactly.

<examples>
  <example>
    <input>Added a retry with backoff to the Stripe webhook handler</input>
    <output>fix(billing): retry Stripe webhooks with exponential backoff</output>
  </example>
  <example>
    <input>Pulled the date helpers out of utils.ts into their own module</input>
    <output>refactor(shared): extract date helpers into date/ module</output>
  </example>
  <example>
    <input>Renamed the `user_id` field to `customer_id` across the API, which
    breaks existing clients</input>
    <output>feat(api)!: rename user_id to customer_id

BREAKING CHANGE: clients must send customer_id. Update before upgrading.</output>
  </example>
</examples>

<diff>
{{THE DIFF}}
</diff>
```

The third example is the one earning its place: it shows how a breaking change
is marked, which prose would have taken a paragraph to explain.

---

## 3. Let Claude think (chain of thought)

Separate the working from the conclusion, so you can read one and discard the
other. Use it where the reasoning is the hard part — not for lookups.

```
This test fails roughly one run in twenty, always in CI, never locally.

<test>
{{THE TEST}}
</test>

<ci-log>
{{FAILING RUN OUTPUT}}
</ci-log>

Work through the likely causes in <thinking> tags: shared state between tests,
timing assumptions, ordering, external calls, resource limits. Weigh each
against the evidence above rather than listing them generically.

Then in <answer> tags give the single most likely cause and the change that
would confirm it.
```

Naming the candidate causes keeps the reasoning grounded in this test rather
than producing a general essay on flakiness.

---

## 4. Use XML tags

Tags stop Claude confusing the instruction with the material or the rules.
Once a prompt has three or more parts, tag every one of them.

```
<instructions>
Port the handler in <code> to the conventions in <constraints>.
Return only the rewritten file, inside <result> tags. No commentary.
</instructions>

<code>
{{CURRENT HANDLER}}
</code>

<constraints>
- Validate the body with a Zod schema before any database call.
- Errors return { error: { code, message } } — never a bare string.
- 422 for validation, 404 for missing, 409 for conflict.
- No raw SQL; go through packages/shared/src/db/.
</constraints>

<result>
```

Note the trailing open `<result>` tag — that's technique 5 riding along.

---

## 5. Prefill the response

Start the answer and Claude continues in that shape. The cheapest way to
force a format.

```
Extract every TODO comment in <code> as JSON: an array of objects with
file, line, author, and text.

<code>
{{THE FILES}}
</code>

Respond with JSON only, starting from the opening brace.

{
```

That trailing `{` leaves no room for "Here's the JSON you asked for:".

**In Claude Code**, where you're in a conversation rather than an API call,
the equivalent is stating the shape exactly:

```
List the failing tests as a markdown table with columns: test, file, error.
No preamble, no summary after the table.
```

---

## 6. Chain complex prompts

Break a large task into steps you can check. Each step's output is the next
step's input, so a wrong turn surfaces immediately instead of at the end.

Rather than *"migrate packages/api from Express to Fastify"*:

```
Step 1 — Inventory. List every Express-specific API used under
packages/api/src: middleware signatures, res/req helpers, error handling,
router mounting. One table, file:line and what it does. Stop there.
```

Check the table, then:

```
Step 2 — Map. For each row, give the Fastify equivalent, or mark it
"no direct equivalent" with a one-line note on what changes. Stop there.
```

Check the mapping, then:

```
Step 3 — Migrate one route. Port packages/api/src/routes/health.ts using
that mapping. Run `pnpm --filter @acme/api test` and show the result.
```

Once one route passes, the rest is repetition — and you've verified the
mapping before it's applied fifty times. The checkpoint after each step is the
technique; skip it and this is just one big prompt in three messages.

---

## 7. Long-context prompts

Above roughly 20k tokens of input, order matters: documents first, question
last. Ask for quotes *before* the answer so Claude narrows the material before
reasoning over it.

```
<documents>
  <document index="1">
    <source>rfc-014-billing-migration.md</source>
    <document_content>{{RFC}}</document_content>
  </document>
  <document index="2">
    <source>incident-2026-08-11-double-charge.md</source>
    <document_content>{{POSTMORTEM}}</document_content>
  </document>
  <document index="3">
    <source>packages/api/src/billing/charge.ts</source>
    <document_content>{{SOURCE}}</document_content>
  </document>
</documents>

First, pull the passages relevant to idempotency of charge retries into
<quotes> tags, each tagged with its source.

Then, using only those quotes, answer in <answer> tags: does the current
implementation satisfy what the RFC requires, and which incident conditions
would still reproduce?
```

Three things are doing work here: documents above the question, each one
labelled with its source so citations are traceable, and quotes extracted as a
separate first step.
