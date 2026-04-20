#!/usr/bin/env bash
# WORKSPACE-SYNCED from Syntropment devops scripts; refresh with `pixi run sync-scripts-all` in the workspace.
# Print a markdown changelog from git log since the last tag (or full history).
#
# Output is raw markdown on stdout — suitable for piping to a file or paste
# target. Styling helpers are not used here because the output format must
# stay clean for downstream consumers.
set -euo pipefail

TAG="$(git describe --tags --abbrev=0 2>/dev/null || true)"
if [ -z "$TAG" ]; then
    echo "# Changelog"
    echo
    git log --pretty=format:"- %s (%h)" --no-merges
else
    echo "# Changelog since $TAG"
    echo
    git log "${TAG}..HEAD" --pretty=format:"- %s (%h)" --no-merges
fi
