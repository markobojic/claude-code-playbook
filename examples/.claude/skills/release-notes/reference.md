# Release-note style guide

<!--
  Loaded on demand — only when SKILL.md tells Claude to read it. Keeping this
  out of SKILL.md is the whole point of a multi-file skill: detail that matters
  on some runs shouldn't cost tokens on every run.
-->

## Voice

- Write for a customer, not a committer. "Invoices now show the tax breakdown",
  not "refactor InvoiceSerializer to expose tax_lines".
- Present tense, active voice. No "we have added".
- One line per entry. If an entry needs two sentences, the second belongs in
  the linked issue.

## Grouping

| Section | Holds |
|---|---|
| **Added** | Capabilities that did not exist before |
| **Fixed** | Behaviour that was wrong and now is not |
| **Changed** | Behaviour that was right, and is now different |

A breaking change goes under **Changed**, prefixed `BREAKING:`, with the
migration step on the same line.

## What never appears

- Internal refactors, test-only changes, CI and lint config.
- Dependency bumps, unless the bump changes what a customer sees.
- Commit hashes and branch names. Link the issue number instead.

## Worked example

Raw commits:

```
fix(api): guard against null tax_rate in InvoiceSerializer (#412)
chore: bump vitest to 3.1.0
feat(web): add tax breakdown to invoice PDF (#408)
```

Becomes:

```markdown
### Added
- Invoice PDFs now show a per-line tax breakdown. (#408)

### Fixed
- Invoices for tax-exempt customers no longer fail to render. (#412)
```

Note the vitest bump is absent, and #412 is described by its customer-visible
symptom rather than its cause.
