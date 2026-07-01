#!/usr/bin/env bash
#
# release.sh — cut a new Morning Brief release.
#
# Bumps the version in BOTH manifests (plugin.json and marketplace.json,
# including the nested plugins[] entry), commits, tags, and pushes.
# The version bump is what signals an update to installed copies, so keeping
# the two files in lockstep is the whole point of this script.
#
# Releases must come from an up to date main, because that is what testers
# pick up. The script enforces that before it changes anything.
#
# Usage:
#   scripts/release.sh <new-version> ["commit message"]
#
# Example:
#   scripts/release.sh 0.2.1 "Tighten inbox categorization"
#
# After it runs, testers pick up the update with:
#   /plugin marketplace update morning-brief-plugin
#
set -euo pipefail

NEW_VERSION="${1:?Usage: scripts/release.sh <new-version> [commit message]}"
MSG="${2:-Release v${NEW_VERSION}}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_JSON="${ROOT}/plugins/morning-brief/.claude-plugin/plugin.json"
MARKET_JSON="${ROOT}/.claude-plugin/marketplace.json"

# Releases ship from main. Tagging a feature branch would put the tag on a
# commit testers never receive, so refuse anything else.
BRANCH="$(git -C "${ROOT}" rev-parse --abbrev-ref HEAD)"
if [[ "${BRANCH}" != "main" ]]; then
  echo "Releases must be cut from 'main' (you are on '${BRANCH}')." >&2
  echo "Switch and sync first:  git checkout main && git pull --ff-only" >&2
  exit 1
fi

# Refuse to run on a dirty tree so the release commit is clean and reviewable.
if [[ -n "$(git -C "${ROOT}" status --porcelain)" ]]; then
  echo "Working tree not clean. Commit or stash your changes first." >&2
  exit 1
fi

# main must match origin/main, or the tag lands on a commit that is not shipping.
git -C "${ROOT}" fetch --quiet origin main
LOCAL="$(git -C "${ROOT}" rev-parse @)"
REMOTE="$(git -C "${ROOT}" rev-parse origin/main)"
if [[ "${LOCAL}" != "${REMOTE}" ]]; then
  echo "Local main is not in sync with origin/main." >&2
  echo "Reconcile first:  git pull --ff-only" >&2
  exit 1
fi

if git -C "${ROOT}" rev-parse "v${NEW_VERSION}" >/dev/null 2>&1; then
  echo "Tag v${NEW_VERSION} already exists. Pick a new version." >&2
  exit 1
fi

# Safe JSON edits: bump top-level version and any nested plugins[].version.
node -e '
  const fs = require("fs");
  const v = process.argv[1];
  for (const f of process.argv.slice(2)) {
    const j = JSON.parse(fs.readFileSync(f, "utf8"));
    if (j.version !== undefined) j.version = v;
    if (Array.isArray(j.plugins)) j.plugins.forEach(p => { if (p.version !== undefined) p.version = v; });
    fs.writeFileSync(f, JSON.stringify(j, null, 2) + "\n");
  }
' "${NEW_VERSION}" "${PLUGIN_JSON}" "${MARKET_JSON}"

git -C "${ROOT}" add "${PLUGIN_JSON}" "${MARKET_JSON}"
git -C "${ROOT}" commit -m "${MSG}"
git -C "${ROOT}" tag "v${NEW_VERSION}"
git -C "${ROOT}" push origin main
git -C "${ROOT}" push origin "v${NEW_VERSION}"

echo ""
echo "Released v${NEW_VERSION}."
echo "Testers update with:  /plugin marketplace update morning-brief-plugin"
echo "Roll back:            see docs/dev-workflow.md (roll forward from the prior tag)"
