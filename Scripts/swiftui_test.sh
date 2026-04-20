#!/usr/bin/env bash
# WORKSPACE-SYNCED from Syntropment devops scripts; refresh with `pixi run sync-scripts-all` in the workspace.
# Shared xcodebuild test wrapper.
#
# Required env vars:
#   PROJECT      Xcode project name
#   TEST_SCHEME  scheme to test (defaults to $SCHEME)
#
# Optional env vars:
#   CONFIG       Debug (default)
#   DESTINATION  xcodebuild destination (default 'platform=macOS')
#   EXTRA_TEST_ARGS
set -euo pipefail
# shellcheck source=_lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh"

: "${PROJECT:?PROJECT env var required}"
TEST_SCHEME="${TEST_SCHEME:-${SCHEME:?SCHEME or TEST_SCHEME env var required}}"
CONFIG="${CONFIG:-Debug}"
DESTINATION="${DESTINATION:-platform=macOS}"
EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS:-}"
export SDKROOT="${SDKROOT:-/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk}"

say_header "test $PROJECT / $TEST_SCHEME"
say_kv "destination" "$DESTINATION"
say_kv "config"      "$CONFIG"

say_step "xcodebuild test"
# shellcheck disable=SC2086
xcodebuild -project "${PROJECT}.xcodeproj" -scheme "$TEST_SCHEME" -configuration "$CONFIG" test \
    -allowProvisioningUpdates -destination "$DESTINATION" $EXTRA_TEST_ARGS
say_ok "tests passed"
