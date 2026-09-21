#!/usr/bin/env bash
# PreToolUse hook: deny recursive rm, stay silent otherwise. Requires jq.
# Wire it up in .claude/settings.json under hooks.PreToolUse (matcher "Bash").
set -euo pipefail
input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

if printf '%s' "$cmd" | grep -qiE '(^|[[:space:]])rm[[:space:]]+(-[a-z]*r|--recursive)'; then
  cat <<'JSON'
{ "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Recursive rm is blocked by a project hook. Delete specific files instead." } }
JSON
fi
# Exit 0 with no output lets the normal permission flow decide.
exit 0
