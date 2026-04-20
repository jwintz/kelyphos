#!/usr/bin/env bash
# WORKSPACE-SYNCED from Syntropment devops scripts; refresh with `pixi run sync-scripts-all` in the workspace.
# Shared output helpers for Syntropment shell scripts.
#
# Sourced by every swiftui_*.sh, status.sh, and for_each_swiftui.sh. Gum is
# enabled by default when available and a TTY is attached, using the terminal's
# base ANSI palette so it follows the active theme. Set SYNTROPMENT_UI=plain to
# force plain ASCII output.
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

_gum_color() {
    case "$1" in
        header) printf '6' ;;
        step)   printf '4' ;;
        ok)     printf '2' ;;
        warn)   printf '3' ;;
        err)    printf '1' ;;
        key)    printf '6' ;;
        value)  printf '7' ;;
        *)      return 1 ;;
    esac
}

# Enable gum by default when available. Allow opting out with
# SYNTROPMENT_UI=plain / ascii / none / off.
_use_gum() {
    case "${SYNTROPMENT_UI:-auto}" in
        plain|ascii|none|off|0|false)
            return 1
            ;;
    esac
    [ -n "${NO_COLOR:-}" ] && return 1
    [ ! -t 1 ] && return 1
    _has_gum
}

say_header() {
    if _use_gum; then
        printf '\n'
        gum style --foreground "$(_gum_color header)" --bold -- "== $* =="
    else
        printf '\n== %s ==\n' "$*"
    fi
}

say_step() {
    if _use_gum; then
        gum style --foreground "$(_gum_color step)" -- "-> $*"
    else
        printf -- '-> %s\n' "$*"
    fi
}

say_ok() {
    if _use_gum; then
        gum style --foreground "$(_gum_color ok)" --bold -- "OK  $*"
    else
        printf 'OK  %s\n' "$*"
    fi
}

say_warn() {
    if _use_gum; then
        gum style --foreground "$(_gum_color warn)" --bold -- "WARN $*" >&2
    else
        printf 'WARN %s\n' "$*" >&2
    fi
}

say_err() {
    if _use_gum; then
        gum style --foreground "$(_gum_color err)" --bold -- "ERR  $*" >&2
    else
        printf 'ERR  %s\n' "$*" >&2
    fi
}

say_kv() {
    local k="$1"; shift
    local v="$*"
    if _use_gum; then
        printf '  %s %s\n' \
            "$(gum style --foreground "$(_gum_color key)" --bold -- "$(printf '%-20s' "$k")")" \
            "$(gum style --foreground "$(_gum_color value)" -- "$v")"
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
