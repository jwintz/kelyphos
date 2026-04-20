#!/usr/bin/env bash
# WORKSPACE-SYNCED from Syntropment devops scripts; refresh with `pixi run sync-scripts-all` in the workspace.
# Codesign $APP.app. Ad-hoc if no distribution identity is configured, else
# full hardened-runtime distribution signing.
#
# Required env vars:
#   APP  .app bundle name without extension
#
# Optional env vars:
#   APPLE_TEAM_ID  team id used to resolve the matching "Developer ID Application" identity
#   SIGN_IDENTITY  explicit codesigning identity override ("Developer ID Application: ...") or "-" for ad-hoc
#   DEEP_SIGN      1 to pass --deep when signing (default 1)
set -euo pipefail
# shellcheck source=_lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh"

: "${APP:?APP env var required}"
IDENTITY="${SIGN_IDENTITY:-}"
DEEP_SIGN="${DEEP_SIGN:-1}"
BUNDLE="${APP}.app"

say_header "sign $BUNDLE"

if [ ! -d "$BUNDLE" ]; then
    say_err "$BUNDLE not found. Run the package task first."
    exit 1
fi

if [ -z "$IDENTITY" ] && [ -n "${APPLE_TEAM_ID:-}" ]; then
    IDENTITY="$(security find-identity -v -p codesigning 2>/dev/null \
        | sed -n "s/.*\"\\(Developer ID Application: .* (${APPLE_TEAM_ID})\\)\"/\\1/p" \
        | head -n 1)"
    if [ -z "$IDENTITY" ]; then
        say_err "no Developer ID Application identity found for APPLE_TEAM_ID=$APPLE_TEAM_ID"
        exit 1
    fi
fi

IDENTITY="${IDENTITY:--}"

if [ "$IDENTITY" = "-" ]; then
    say_step "ad-hoc sign"
    if [ "$DEEP_SIGN" = "1" ]; then
        codesign --force --deep --sign - "$BUNDLE"
    else
        codesign --force --sign - "$BUNDLE"
    fi
    say_ok "ad-hoc signed $BUNDLE"
else
    say_kv "identity" "$IDENTITY"
    say_step "sign Mach-O binaries (hardened runtime, timestamp)"
    # Sign all Mach-O files inside first, then the bundle itself.
    while IFS= read -r BIN; do
        codesign --force --options runtime --timestamp --sign "$IDENTITY" "$BIN"
    done < <(find "$BUNDLE" -type f -perm +111 -exec file {} + | awk -F: '/Mach-O/{print $1}')

    say_step "sign bundle"
    if [ "$DEEP_SIGN" = "1" ]; then
        codesign --force --deep --options runtime --timestamp --sign "$IDENTITY" "$BUNDLE"
    else
        codesign --force --options runtime --timestamp --sign "$IDENTITY" "$BUNDLE"
    fi
    say_ok "signed $BUNDLE"
fi
