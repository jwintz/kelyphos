#!/usr/bin/env bash
# WORKSPACE-SYNCED from Syntropment devops scripts; refresh with `pixi run sync-scripts-all` in the workspace.
# Shared xcodegen+xcodebuild Debug build for SwiftUI stack projects.
#
# Required env vars:
#   PROJECT  Xcode project name without extension (e.g. Kytos -> Kytos.xcodeproj)
#   SCHEME   xcodebuild scheme (e.g. Kytos-macOS)
#
# Optional env vars:
#   CONFIG              Debug (default) | Release
#   VERSIONED           1 to inject CURRENT_PROJECT_VERSION=$(date +%s), 0 to skip (default 1)
#   RELEASE_ARCHS       space-separated archs forwarded as ARCHS=... (Release only, default arm64)
#   EXTRA_BUILD_ARGS    extra flags appended verbatim
#   SDKROOT             defaults to Xcode.app MacOSX.sdk
set -euo pipefail
# shellcheck source=_lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh"

: "${PROJECT:?PROJECT env var required (e.g. Kytos)}"
: "${SCHEME:?SCHEME env var required (e.g. Kytos-macOS)}"
CONFIG="${CONFIG:-Debug}"
VERSIONED="${VERSIONED:-1}"
EXTRA_BUILD_ARGS="${EXTRA_BUILD_ARGS:-}"
export SDKROOT="${SDKROOT:-/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk}"

say_header "$PROJECT / $SCHEME ($CONFIG)"
say_kv "project" "${PROJECT}.xcodeproj"
say_kv "scheme"  "$SCHEME"
say_kv "config"  "$CONFIG"

args=(-project "${PROJECT}.xcodeproj" -scheme "$SCHEME" -configuration "$CONFIG" build -allowProvisioningUpdates)

if [ "$CONFIG" = "Release" ]; then
    ARCHS="${RELEASE_ARCHS:-arm64}"
    args+=(ARCHS="$ARCHS" CODE_SIGN_INJECT_BASE_ENTITLEMENTS=NO)
    say_kv "archs" "$ARCHS"
fi

if [ "$VERSIONED" = "1" ]; then
    args+=(CURRENT_PROJECT_VERSION="$(date +%s)")
fi

say_step "xcodebuild ${CONFIG}"
# shellcheck disable=SC2086
xcodebuild "${args[@]}" $EXTRA_BUILD_ARGS
say_ok "built $PROJECT ($CONFIG)"
