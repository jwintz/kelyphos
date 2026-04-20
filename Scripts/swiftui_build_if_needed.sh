#!/usr/bin/env bash
# WORKSPACE-SYNCED from Syntropment devops scripts; refresh with `pixi run sync-scripts-all` in the workspace.
# Build only when any watched path is newer than the built binary.
#
# Required env vars:
#   PROJECT  Xcode project name
#   SCHEME   xcodebuild scheme
#   APP      .app bundle name without extension (e.g. Kytos -> Kytos.app)
#   BINARY   executable name inside Contents/MacOS (e.g. Kytos)
#
# Optional env vars:
#   CONFIG         Debug (default) | Release
#   WATCH_PATHS    space-separated list fed to `find -newer` (default: "Sources project.yml")
#                  (project.pbxproj is always watched)
#
# Delegates to swiftui_build.sh when rebuild is needed.
set -euo pipefail
# shellcheck source=_lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh"

: "${PROJECT:?PROJECT env var required}"
: "${SCHEME:?SCHEME env var required}"
: "${APP:?APP env var required}"
: "${BINARY:?BINARY env var required}"
CONFIG="${CONFIG:-Debug}"
WATCH_PATHS="${WATCH_PATHS:-Sources project.yml}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BUILT_DIR="$(xcodebuild -project "${PROJECT}.xcodeproj" -scheme "$SCHEME" -configuration "$CONFIG" -showBuildSettings 2>/dev/null \
    | awk -F'= ' '/ BUILT_PRODUCTS_DIR = /{print $2; exit}')"
BIN="$BUILT_DIR/${APP}.app/Contents/MacOS/${BINARY}"

PBXPROJ="${PROJECT}.xcodeproj/project.pbxproj"
# shellcheck disable=SC2086
NEWER="$(find $WATCH_PATHS "$PBXPROJ" -newer "$BIN" -print -quit 2>/dev/null || true)"

if [ -f "$BIN" ] && [ -z "$NEWER" ]; then
    say_ok "$APP ($CONFIG) up to date"
    exit 0
fi

say_step "$APP ($CONFIG) rebuild needed"
exec bash "$SCRIPT_DIR/swiftui_build.sh"
