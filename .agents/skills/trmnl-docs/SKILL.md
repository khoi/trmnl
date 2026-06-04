---
name: trmnl-docs
description: Look up TRMNL developer documentation, including API reference, webhooks, screen templating, private/public/partners APIs, BYOD/BYOS, and the plugin marketplace. Use when building or debugging TRMNL plugins/devices, or when you need to know how a TRMNL endpoint, merge variable, or template feature works. Triggers include "TRMNL docs", "how do I send a TRMNL webhook", "TRMNL display API", "what merge variables does TRMNL support", and "TRMNL BYOS".
---

# TRMNL docs lookup

This repo holds custom plugins for [trmnl.com](https://trmnl.com). Official docs live at `https://docs.trmnl.com` and expose `llms.txt`, raw markdown pages, and scoped `?ask=` Q&A endpoints.

The driver lives at `.agents/skills/trmnl-docs/driver.sh`.

## Prerequisites

`curl` and network access to `docs.trmnl.com`.

## Run

```bash
.agents/skills/trmnl-docs/driver.sh index
.agents/skills/trmnl-docs/driver.sh page private-api/screens
.agents/skills/trmnl-docs/driver.sh ask private-plugins/webhooks "what is the payload rate limit?"
.agents/skills/trmnl-docs/driver.sh search "how do I bring my own server?"
```

`ask` and `search` return a direct answer plus `# Sources:` links. Follow those with `page` for exact text. `index` is the fastest way to find slugs such as `private-api/account`, `public-api/recipes-api`, `diy/byos`, and `plugin-marketplace/plugin-creation`.

## How it works (if you skip the driver)

```bash
curl -fsSL "https://docs.trmnl.com/llms.txt"
curl -fsSL "https://docs.trmnl.com/go/private-api/screens.md"
curl -fsSG "https://docs.trmnl.com/go/private-plugins/webhooks.md" \
  --data-urlencode "ask=what is the payload rate limit?"
```

## Gotchas

- `docs.usetrmnl.com` redirects to `docs.trmnl.com`.
- Every page is fetchable as raw markdown by appending `.md` to its `/go/` URL.
- Use `--data-urlencode "ask=..."`; questions often contain spaces, `?`, and `&`.
- `ask` answers can lag raw pages. Confirm exact headers, status codes, and JSON fields with `page <slug>`.

## Troubleshooting

- `# Page Not Found` with a normal exit code means the slug is wrong. Run `index` and copy the path between `/go/` and `.md`.
- Empty or HTML-looking output usually means the URL missed `/go/<slug>.md`.
