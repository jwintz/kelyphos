#!/usr/bin/env bash
# WORKSPACE-SYNCED from Syntropment devops scripts; refresh with `pixi run sync-scripts-all` in the workspace.
# Shared output helpers for Syntropment shell scripts.
#
# Sourced by every swiftui_*.sh, status.sh, and for_each_swiftui.sh. The
# default output is ASCII-first for readability across terminal themes.
# Set SYNTROPMENT_UI=gum to opt into gum styling when desired.
#
# Helper contract:
#   say_header "Title"     # section title
#   say_step   "Doing X"   # progress step
#   say_ok     "Done"      # success line
#   say_warn   "Note"      # warning (to stderr)
#   say_err    "Bad"       # error (to stderr)
#   say_kv     key value   # aligned key/value row
#   run_step "label" cmd...# run cmd under a gum spinner (or plain echo)
#
# Consumers should prefer these helpers over bare echo so output stays
# consistent across the stack.

_has_gum() { command -v gum >/dev/null 2>&1; }

# Enable styling only when explicitly requested with SYNTROPMENT_UI=gum.
_use_gum() {
    [ "${SYNTROPMENT_UI:-}" != "gum" ] && return 1
    [ -n "${NO_COLOR:-}" ] && return 1
    [ ! -t 1 ] && return 1
    _has_gum
}

say_header() {
    if _use_gum; then
        printf '\n'
        gum style --foreground 212 --bold -- "$*"
    else
        printf '\n== %s ==\n' "$*"
    fi
}

say_step() {
    if _use_gum; then
        gum style --foreground 45 -- "-> $*"
    else
        printf -- '-> %s\n' "$*"
    fi
}

say_ok() {
    if _use_gum; then
        gum style --foreground 82 -- "OK  $*"
    else
        printf 'OK  %s\n' "$*"
    fi
}

say_warn() {
    if _use_gum; then
        gum style --foreground 214 -- "WARN $*" >&2
    else
        printf 'WARN %s\n' "$*" >&2
    fi
}

say_err() {
    if _use_gum; then
        gum style --foreground 196 --bold -- "ERR  $*" >&2
    else
        printf 'ERR  %s\n' "$*" >&2
    fi
}

say_kv() {
    local k="$1"; shift
    local v="$*"
    if _use_gum; then
        printf '  %s %s\n' \
            "$(gum style --foreground 244 -- "$(printf '%-20s' "$k")")" \
            "$(gum style --foreground 252 -- "$v")"
    else
        printf '  %-20s %s\n' "$k" "$v"
    fi
}

# run_step "label" cmd args...
# Under gum: show a spinner while the command runs, print OK/ERR after.
# Plain:    print step + echo result.
run_step() {
    local label="$1"; shift
    if _use_gum; then
        if gum spin --spinner dot --title "$label" -- "$@"; then
            say_ok "$label"
        else
            local rc=$?
            say_err "$label (exit $rc)"
            return $rc
        fi
    else
        say_step "$label"
        "$@"
    fi
}
