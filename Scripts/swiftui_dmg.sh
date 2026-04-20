#!/usr/bin/env bash
# WORKSPACE-SYNCED from Syntropment devops scripts; refresh with `pixi run sync-scripts-all` in the workspace.
# Build $APP-<version>.dmg with $APP.app and an /Applications symlink.
#
# Required env vars:
#   APP  .app bundle name without extension
#
# Optional env vars:
#   VERSION  version string (default: `git describe --tags --abbrev=0` stripped of leading v, else 0.0.0)
set -euo pipefail
# shellcheck source=_lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh"

: "${APP:?APP env var required}"
VERSION="${VERSION:-$(git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//' || echo "0.0.0")}"
BUNDLE="${APP}.app"
DMG="${APP}-${VERSION}.dmg"

say_header "dmg $DMG"
say_kv "bundle"  "$BUNDLE"
say_kv "version" "$VERSION"

if [ ! -d "$BUNDLE" ]; then
    say_err "$BUNDLE not found. Run package + sign first."
    exit 1
fi

rm -f "$DMG"
TEMP="$(mktemp -d)"
trap 'rm -rf "$TEMP"' EXIT
cp -R "$BUNDLE" "$TEMP/"
ln -s /Applications "$TEMP/Applications"
say_step "hdiutil create (UDZO)"
hdiutil create -volname "$APP" -srcfolder "$TEMP" -ov -format UDZO "$DMG" >/dev/null
say_ok "created $DMG"
