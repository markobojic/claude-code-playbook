#!/usr/bin/env bash
# Lists customer-relevant commits between two refs, newest first.
#
# Invoked from SKILL.md as:  collect-changes.sh "$since" "$until"
# Local git only — no network, no writes. Safe to run anywhere; if the refs
# don't exist it says so and exits 0 rather than failing the skill.
set -euo pipefail

since="${1:-}"
until_ref="${2:-HEAD}"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Not a git repository — nothing to collect."
  exit 0
fi

# Default to the most recent tag when no start ref was given.
if [ -z "$since" ]; then
  since=$(git describe --tags --abbrev=0 2>/dev/null || true)
fi

if [ -z "$since" ]; then
  echo "No tags found and no start ref given. Pass one: /release-notes v1.2.0 HEAD"
  exit 0
fi

for ref in "$since" "$until_ref"; do
  if ! git rev-parse --verify --quiet "$ref^{commit}" >/dev/null; then
    echo "Ref '$ref' does not exist in this repository."
    exit 0
  fi
done

echo "Commits in ${since}..${until_ref}"
echo

# %s = subject only. Bodies and hashes are noise for release notes.
count=$(git log --no-merges --pretty=format:'- %s' "${since}..${until_ref}" | tee /dev/stderr | wc -l | tr -d ' ')

if [ "$count" = "0" ]; then
  echo "(no commits in range)"
fi
