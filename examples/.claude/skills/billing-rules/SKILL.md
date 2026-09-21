---
description: How Acme Web bills customers — proration, trials, refunds, and dunning. Use when working on billing, subscriptions, invoices, or payment failures.
when_to_use: >
  When the user asks how billing works, changes subscription or invoice code,
  mentions proration, trials, refunds, chargebacks, or dunning, or asks
  "why was this customer charged X?"
user-invocable: false
---

# Acme Web billing rules

<!--
  BLUEPRINT: the basic shape. A knowledge skill — no scripts, no references,
  just domain facts Claude cannot infer from the code.

  Frontmatter demonstrated:
    description       what it does + when to use it. The field Claude matches on.
    when_to_use       extra trigger phrases, appended to description in the
                      skill listing. Both share one 1,536-char cap, so lead
                      with the key use case.
    user-invocable    false = Claude may load it, but it stays out of the /menu.
                      Right for background knowledge nobody "runs".

  Part of the Acme Web worked example (see examples/CLAUDE.project.example.md).
-->

## Plans and periods

- Plans are monthly or annual. Annual is billed upfront at a 20% discount.
- A billing period always starts on the subscription's anchor day. If the
  anchor day doesn't exist in a month (the 31st in February), bill on the last
  day of that month and keep the original anchor for later periods.

## Proration

- Upgrades prorate immediately: charge the difference for the remaining days of
  the period, rounded to the cent, half-up.
- Downgrades never prorate. They take effect at the next period start.
- Proration is computed in whole days, not seconds. A change at 23:59 counts
  for that whole day.

## Trials

- 14 days, no card required. A trial that ends without a card lapses to
  read-only rather than cancelling — the customer's data is retained 90 days.
- Converting mid-trial starts a fresh billing period from the conversion date.

## Refunds and dunning

- Refunds are full-period only. Partial refunds go through support, not code.
- A failed payment retries on days 1, 3, and 7. After the third failure the
  account goes read-only and `subscription.dunning_exhausted` fires.
- Never delete billing records. Supersede them with a correcting entry so the
  audit trail stays intact.
