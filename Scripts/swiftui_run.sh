#!/usr/bin/env bash
# WORKSPACE-SYNCED from Syntropment devops scripts; refresh with `pixi run sync-scripts-all` in the workspace.
# Register app + optional widget/extension via Launch Services, then open it.
#
# Required env vars:
#   PROJECT  Xcode project name
#   SCHEME   scheme whose BUILT_PRODUCTS_DIR holds $APP.app
#   APP      .app bundle name without extension
#
# Optional env vars:
#   CONFIG           Debug (default) | Release
#   WIDGET_APPEX     appex bundle name (e.g. KytosWidget.appex) to pluginkit-register
#   OPEN_WAIT        1 to use `open -W` (blocking), 0 to return immediately (default 1)
set -euo pipefail
# shellcheck source=_lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh"

: "${PROJECT:?PROJECT env var required}"
: "${SCHEME:?SCHEME env var required}"
: "${APP:?APP env var required}"
CONFIG="${CONFIG:-Debug}"
WIDGET_APPEX="${WIDGET_APPEX:-}"
OPEN_WAIT="${OPEN_WAIT:-1}"

BUILT_DIR="$(xcodebuild -project "${PROJECT}.xcodeproj" -scheme "$SCHEME" -configuration "$CONFIG" -showBuildSettings 2>/dev/null \
    | awk -F'= ' '/ BUILT_PRODUCTS_DIR = /{print $2; exit}')"
APP_PATH="$BUILT_DIR/${APP}.app"

say_header "run $APP ($CONFIG)"

if [ ! -d "$APP_PATH" ]; then
    say_err "$APP_PATH not found."
    exit 1
fi

LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
say_step "lsregister $APP.app"
"$LSREGISTER" -f "$APP_PATH" 2>/dev/null || true

if [ -n "$WIDGET_APPEX" ]; then
    WIDGET="$APP_PATH/Contents/PlugIns/$WIDGET_APPEX"
    if [ -d "$WIDGET" ]; then
        say_step "pluginkit register $WIDGET_APPEX"
        pluginkit -r "$WIDGET" 2>/dev/null || true
        pluginkit -a "$WIDGET" 2>/dev/null || true
    fi
fi

if [ "$OPEN_WAIT" = "1" ]; then
    say_step "open -W $APP_PATH"
    open -W "$APP_PATH"
else
    say_step "open $APP_PATH"
    open "$APP_PATH"
fi
