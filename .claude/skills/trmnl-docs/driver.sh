#!/usr/bin/env bash
# TRMNL documentation driver — queries https://docs.trmnl.com (GitBook llms.txt).
# No auth, no app to launch: the docs site IS the thing we drive, via curl.
set -euo pipefail

BASE="https://docs.trmnl.com"

usage() {
  cat <<'EOF'
TRMNL docs driver. Usage:
  driver.sh index                      List every doc page (llms.txt index)
  driver.sh page  <path>               Print raw markdown of one page
  driver.sh ask   <path> <question..>  Natural-language Q&A scoped to one page
  driver.sh search <question..>        Q&A entered from the Overview page

<path> is a slug from `index`, e.g.  private-api/screens
                                      private-plugins/webhooks
The leading `go/` and trailing `.md` are optional — both are normalized.

Examples:
  driver.sh index
  driver.sh page private-api/screens
  driver.sh ask private-plugins/webhooks "what is the rate limit?"
  driver.sh search "how do I bring my own server?"
EOF
}

# Normalize a page reference into the canonical "<slug>.md" form.
norm() { local p="${1#/}"; p="${p#go/}"; p="${p%.md}"; printf '%s.md' "$p"; }

cmd="${1:-}"; [ $# -gt 0 ] && shift || true
case "$cmd" in
  index|list)
    curl -fsSL "$BASE/llms.txt" ;;
  page)
    [ $# -ge 1 ] || { usage; exit 1; }
    curl -fsSL "$BASE/go/$(norm "$1")" ;;
  ask)
    [ $# -ge 2 ] || { usage; exit 1; }
    path="$(norm "$1")"; shift
    curl -fsSG "$BASE/go/$path" --data-urlencode "ask=$*" ;;
  search)
    [ $# -ge 1 ] || { usage; exit 1; }
    curl -fsSG "$BASE/go/readme.md" --data-urlencode "ask=$*" ;;
  ""|-h|--help|help)
    usage ;;
  *)
    usage; exit 1 ;;
esac
