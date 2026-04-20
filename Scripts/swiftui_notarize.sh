#!/usr/bin/env bash
# WORKSPACE-SYNCED from Syntropment devops scripts; refresh with `pixi run sync-scripts-all` in the workspace.
# Submit $APP-<version>.dmg to Apple notarization, wait, and staple.
#
# Required env vars:
#   APP              .app bundle name without extension (DMG filename derived)
#   APPLE_ID         Apple ID email
#   APPLE_PASSWORD   App-specific password
#   APPLE_TEAM_ID    Team ID
#
# Optional env vars:
#   VERSION  version string (see swiftui_dmg.sh)
set -euo pipefail
# shellcheck source=_lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh"

: "${APP:?APP env var required}"
VERSION="${VERSION:-$(git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//' || echo "0.0.0")}"
DMG="${APP}-${VERSION}.dmg"

say_header "notarize $DMG"

if [ ! -f "$DMG" ]; then
    say_err "$DMG not found. Run dmg first."
    exit 1
fi

missing=()
[ -z "${APPLE_ID:-}" ] && missing+=("APPLE_ID")
[ -z "${APPLE_PASSWORD:-}" ] && missing+=("APPLE_PASSWORD")
[ -z "${APPLE_TEAM_ID:-}" ] && missing+=("APPLE_TEAM_ID")
if [ "${#missing[@]}" -gt 0 ]; then
    say_err "missing env var(s): ${missing[*]}"
    exit 1
fi

say_step "notarytool submit --wait"
xcrun notarytool submit "$DMG" \
    --apple-id "$APPLE_ID" \
    --password "$APPLE_PASSWORD" \
    --team-id "$APPLE_TEAM_ID" \
    --wait

say_step "stapler staple"
xcrun stapler staple "$DMG"
say_ok "notarized $DMG"
