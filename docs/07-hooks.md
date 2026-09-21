*Unofficial community guide — not affiliated with Anthropic. Reflects Claude Code as of Sep 2026 · last verified Sep 2026 · [official docs](https://code.claude.com/docs).*

# Hooks

Everything else shapes what Claude *tends* to do. Hooks make things *happen* —
deterministically, every time, whether or not the model remembers. Claude is
probabilistic; some parts of a workflow can't be left to chance. Files must be
formatted on every edit. Secrets must stay unread. A recursive delete must be
blocked before it reaches the shell. Hooks are how you guarantee those things.

Think of them as git hooks for your AI assistant: commands (or prompts, agents,
or HTTP calls) that fire at fixed points and can block, allow, or reshape what
happens next.

## When a hook is the right tool

If you keep asking Claude to "remember to run X" or "never touch Y," that belief
belongs in a hook, not a prompt. Guidance in `CLAUDE.md` or a skill is advisory;
a hook is enforced. Use hooks for the small set of things that must be true on
every turn.

## The configuration structure

Hooks live in the same settings files as everything else; commit them to project
settings and the whole team inherits the guardrails. The shape is three levels:
the event, a list of matchers, and each matcher's list of hooks.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command",
            "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/format.sh" }
        ]
      }
    ]
  }
}
```

Each hook has a `type`: `command` (a shell command or script) is most common;
`prompt`, `agent`, and `http` cover model-driven checks and remote endpoints.

## Matchers and the if filter

The `matcher` (used only by `PreToolUse` and `PostToolUse`) selects which tools
trigger the hook. It's case-sensitive: an exact string (`Write`), a regex
(`Edit|Write`), or `*` for all. A finer `if` field matches on the tool's
arguments so a hook spawns only for the calls it cares about.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command",
            "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/block-rm.sh",
            "if": "Bash(rm *)" }
        ]
      }
    ]
  }
}
```

## How a hook makes a decision

A hook receives the event as JSON on stdin and reports back through its exit
code, its JSON output, or both.

Input on stdin:

```json
{
  "hook_event_name": "PreToolUse",
  "tool_name": "Bash",
  "tool_input": { "command": "rm -rf dist/" },
  "cwd": "/your/project"
}
```

Exit codes:

- **Exit 0, no output** — no decision; the normal permission flow continues.
- **Exit 2** — a blocking error. On `PreToolUse` it blocks the call before it
  runs and feeds your stderr back to Claude. On `PostToolUse` the tool already
  ran, but stderr still reaches Claude.
- **Any other non-zero** — a non-blocking error, logged. (Stderr from an exit-0
  hook never reaches Claude.)

Structured JSON output gives finer control:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Recursive rm is blocked by a project hook."
  }
}
```

`permissionDecision` accepts `allow`, `deny`, or `ask`. One rule: exit 2 wins —
it blocks even if the JSON says `allow`.

## The events you'll use most

| Event | Fires when | Common use |
|---|---|---|
| `PreToolUse` | Before a tool runs | Block or gate risky calls (rm, .env, protected paths) |
| `PostToolUse` | After a tool succeeds | Auto-format, lint, run tests, log |
| `UserPromptSubmit` | When you send a prompt | Inject context or validate the request |
| `SessionStart` | At the start of a session | Load environment, print reminders |
| `Stop` | Before Claude ends its turn | Notify you or enforce a final check |
| `PreCompact` / `PostCompact` | Around context compaction | Re-inject key context |
| `SubagentStop` | When a subagent finishes | Track or gate delegated work |
| `Notification` | When Claude needs input | Send a desktop or Slack ping |

Claude Code exposes roughly thirty events in total; these cover most needs.

## A worked example: block recursive deletes

With the `PreToolUse` config above wiring `block-rm.sh` to Bash commands
matching `rm *`, the script reads the command off stdin and denies anything
recursive, staying silent otherwise (full file in
[`examples/.claude/hooks/block-rm.sh`](../examples/.claude/hooks/block-rm.sh)):

```bash
#!/usr/bin/env bash
input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
if printf '%s' "$cmd" | grep -qiE '(^|[[:space:]])rm[[:space:]]+(-[a-z]*r|--recursive)'; then
  cat <<'JSON'
{ "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Recursive rm is blocked by a project hook." } }
JSON
fi
exit 0
```

The same pattern — read stdin, inspect `tool_input`, emit a deny — covers
blocking `.env` reads or guarding protected paths. For formatting, a
`PostToolUse` hook matched to `Edit|Write` runs your formatter and exits 0.

> **◆ Architect's take** — For real protection, pair the hook with a permission
> **deny rule**: the rule covers the file tools at the permission layer, the
> hook covers dynamic logic and Bash the rule can't anticipate. And because a
> hook runs arbitrary code with your privileges, **review every hook you pull
> from a shared repo** before trusting the workspace.
