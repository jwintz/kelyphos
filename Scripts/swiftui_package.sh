#!/usr/bin/env bash
# WORKSPACE-SYNCED from Syntropment devops scripts; refresh with `pixi run sync-scripts-all` in the workspace.
# Locate the Release build of $APP.app and copy it to the project root.
#
# xcodebuild already produces a full .app (with embedded widgets/extensions
# configured via project.yml), so we just find it and copy it.
#
# Required env vars:
#   PROJECT  Xcode project name
#   SCHEME   Release scheme
#   APP      .app bundle name without extension
set -euo pipefail
# shellcheck source=_lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh"

: "${PROJECT:?PROJECT env var required}"
: "${SCHEME:?SCHEME env var required}"
: "${APP:?APP env var required}"

say_header "package $APP"

BUILT_DIR="$(xcodebuild -project "${PROJECT}.xcodeproj" -scheme "$SCHEME" -configuration Release -showBuildSettings 2>/dev/null \
    | awk -F'= ' '/ BUILT_PRODUCTS_DIR = /{print $2; exit}')"
SRC="$BUILT_DIR/${APP}.app"
DEST="${APP}.app"

if [ ! -d "$SRC" ]; then
    say_err "Release build not found at $SRC"
    exit 1
fi

say_step "copy $SRC -> $DEST"
rm -rf "$DEST"
cp -R "$SRC" "$DEST"
say_ok "packaged $DEST"
