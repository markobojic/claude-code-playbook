*Unofficial community guide — not affiliated with Anthropic. Reflects Claude Code as of Sep 2026 · last verified Sep 2026 · [official docs](https://code.claude.com/docs).*

# Enterprise Deployment (admins)

This appendix is for administrators rolling Claude Code out across the
organization. Most developers can stop at the [prompting](10-prompting.md) topic.

## Managed settings

Organization-wide policy is delivered through managed settings, which sit at the
top of the precedence chain and **cannot be overridden** by project, local, or
user settings. They are deployed as a system-level file:

```
macOS:        /Library/Application Support/ClaudeCode/managed-settings.json
Linux / WSL:  /etc/claude-code/managed-settings.json
```

They can also be delivered by MDM policy or pushed from the Claude console;
server-managed settings sync automatically.

## What to lock

- **Permission rules** — pin an allow/deny baseline developers cannot loosen.
- **MCP servers** — allowlist approved servers and deny the rest.
- **Plugins** — restrict customization to approved plugins / marketplaces, if required.
- **An org-wide CLAUDE.md** — remember this *accumulates* with project and user
  files rather than replacing them.

> **◆ Architect's take** — Managed settings are **enforcement**, and they always
> win — so use them sparingly and deliberately. Lock what genuinely must be
> unbreakable (security-relevant permissions, MCP allowlists) and leave
> everything else in project scope, where teams can see, discuss, and evolve it.
> Over-locking pushes developers toward workarounds; a small, well-justified
> managed policy earns trust and holds.
