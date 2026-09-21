*Unofficial community guide — not affiliated with Anthropic. Reflects Claude Code as of Sep 2026 · last verified Sep 2026 · [official docs](https://code.claude.com/docs).*

# MCP

The Model Context Protocol (MCP) is an open standard that connects Claude Code
to systems beyond the repository — GitHub, databases, internal APIs, SaaS tools
— by exposing their capabilities as tools Claude can call. If skills and
subagents are about *how Claude works*, MCP is about *what Claude can reach*.

Its tools show up namespaced as `mcp__<server>__<tool>`, so a GitHub server's
"create issue" appears as `mcp__github__create_issue`.

## The two transports you'll actually use

- **Remote (HTTP)** — the common case for hosted services. Point Claude Code at
  a URL and usually pass a credential. (The protocol calls this
  `streamable-http`; an older `sse` variant exists for legacy servers.)
- **Local (stdio)** — a program Claude Code launches on your machine and talks
  to over standard input/output. Right for local tools and servers you run.

## Adding a server

One command registers a server. The rule that trips people up: **every option
comes before the name**, and for a stdio server a `--` separates Claude's flags
from the command it should run.

Remote HTTP server:

```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp \
  --header "Authorization: Bearer <YOUR_TOKEN>"
```

Local stdio server:

```bash
claude mcp add my-db \
  -- npx -y @modelcontextprotocol/server-postgres postgresql://localhost/mydb
```

From a ready-made JSON snippet:

```bash
claude mcp add-json linear '{"type":"http","url":"https://mcp.linear.app/mcp"}'
```

Editing files directly works too: local and user servers live in
`~/.claude.json`; project servers live in `.mcp.json`. A JSON entry with a `url`
but no `type` is an error — always set `"type": "http"` (or `sse` / `ws`).

## Scopes: who sees the server

| Scope | Flag | Where it lives / who sees it |
|---|---|---|
| **Local** | (default) | Only you, only this project. Stored in `~/.claude.json`. Highest precedence. |
| **Project** | `--scope project` | `.mcp.json` at the repo root; commit to share. Teammates approve on first use. |
| **User** | `--scope user` | All your projects on this machine. Lowest precedence. |

Precedence runs **local > project > user**, and it bites: a broken local-scoped
entry silently shadows a working user-scoped one with the same name.

> **◆ Architect's take** — Share team-standard servers through a committed
> `.mcp.json` (`--scope project`) so everyone connects the same way. Keep
> anything personal at user or local scope. Most "it works on my machine" MCP
> confusion is a server sitting in the wrong tier.

## Authentication and management

Remote servers commonly authenticate via **OAuth** (run `/mcp` in a session and
Claude Code handles the browser login) or an API key via `--header` (HTTP) or
`--env` (stdio). Put credentials in headers, env vars, or your local file —
never in a committed `.mcp.json`.

```bash
claude mcp list            # all servers and their health
claude mcp get <name>      # inspect one server
claude mcp remove <name>   # remove (add -s project / -s user to target a scope)
/mcp                       # in-session: status, OAuth login, reconnect
```

## Beyond tools: prompts and resources

Servers can expose **prompts** (surfaced as slash commands) and **resources**
(referenced into context by name). You can also run Claude Code itself *as* an
MCP server, and import servers from Claude Desktop or connectors set up on
claude.ai.

## Security: the part not to skip

- **Prompt injection.** Content a server returns can contain instructions aimed
  at Claude. Prefer servers you trust; review what a server can do.
- **Project-server approval.** A `.mcp.json` server from a repo isn't active
  until you approve it. Don't approve a server you haven't looked at.
- **Least privilege.** Enable write access only when needed; scope which
  subagents reach a server via their `mcpServers` field.
- **Managed control.** Admins can allowlist or deny servers org-wide.

> **◆ Architect's take** — Be **judicious**. Every server adds tools, and tools
> cost context and widen the attack surface. Before adding a server, ask what
> specific thing Claude can't already do without it — if there's no clear
> answer, don't add it.
