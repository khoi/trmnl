---
name: trmnl-docs
description: Look up TRMNL developer documentation — API reference, webhooks, screen templating, private/public/partners APIs, BYOD/BYOS, and the plugin marketplace. Use when building or debugging TRMNL plugins/devices, or when you need to know how a TRMNL endpoint, merge variable, or template feature works. Triggers — "TRMNL docs", "how do I send a TRMNL webhook", "TRMNL display API", "what merge variables does TRMNL support", "TRMNL BYOS".
---

# TRMNL docs lookup

This repo holds custom plugins for [trmnl.com](https://trmnl.com). The official
docs at `https://docs.trmnl.com` publish an `llms.txt` index plus a GitBook
`?ask=` Q&A endpoint. The driver wraps both with `curl` — there is no app to
launch; the docs site is what you drive.

Paths below are relative to the repo root (`<unit>/`). The driver lives at
`.claude/skills/trmnl-docs/driver.sh`.

## Prerequisites

`curl` only (preinstalled on macOS/Linux). Network access to `docs.trmnl.com`.

## Run (agent path)

```bash
# List every doc page with its slug + one-line summary:
.claude/skills/trmnl-docs/driver.sh index

# Print the raw markdown of one page (slug from `index`; go/ and .md optional):
.claude/skills/trmnl-docs/driver.sh page private-api/screens

# Ask a natural-language question scoped to one page:
.claude/skills/trmnl-docs/driver.sh ask private-plugins/webhooks "what is the payload rate limit?"

# Ask a question without knowing the page — enters from the Overview:
.claude/skills/trmnl-docs/driver.sh search "how do I bring my own server?"
```

`ask`/`search` return a direct answer plus a `# Sources:` list of page links —
follow those with `page` for the full text. `index` is the fastest way to learn
the available slugs (e.g. `private-api/account`, `public-api/recipes-api`,
`diy/byos`, `plugin-marketplace/plugin-creation`).

## How it works (if you skip the driver)

```bash
curl -fsSL "https://docs.trmnl.com/llms.txt"                      # the index
curl -fsSL "https://docs.trmnl.com/go/private-api/screens.md"     # raw page
curl -fsSG "https://docs.trmnl.com/go/private-plugins/webhooks.md" \
  --data-urlencode "ask=what is the payload rate limit?"          # Q&A
```

## Gotchas

- **`docs.usetrmnl.com` 301-redirects to `docs.trmnl.com`.** The driver and the
  curl lines above already use the final host; use `curl -L` if you ever hit the
  old one.
- **Every page is fetchable as raw markdown** by appending `.md` to its `/go/`
  URL — that's what `page` does. Add `?ask=` to *any* page to turn it into a
  scoped Q&A endpoint; `ask` does exactly that.
- **Use `--data-urlencode "ask=..."` (i.e. `curl -G`), not a raw `?ask=...`.**
  Questions contain spaces, `?`, and `&`; the driver encodes them for you.
- **`ask` answers can lag the raw page.** When precision matters (exact header
  names, status codes, JSON field names), confirm against `page <slug>` rather
  than trusting the prose summary alone.

## Troubleshooting

- **`# Page Not Found` in the output (with a normal exit code)** → wrong slug.
  A bad page returns a 200 with that body, *not* a curl error, so check the
  first line of output, not just the exit code. Run `index` and copy the exact
  path between `/go/` and `.md`.
- Empty / HTML-looking output → you hit the marketing site, not `/go/<slug>.md`.
  Re-check the host is `docs.trmnl.com` and the path starts with `go/`.
