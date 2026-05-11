# kelyphos audit — 2026-05-11

Source-of-truth for the SwiftUI stack. 98 Swift files under `Sources/`.

## Recent touch points (Phase 1-3 of the iPad-shortcuts fix)

- `Sources/KelyphosKit/Shell/KelyphosShellView.swift` — added `.focused($isFocused)` + `.onAppear { isFocused = true }` to make the publishing view explicitly focused so `.focusedSceneValue(\.kelyphosShellState, state)` reaches `Commands` on iPad. Confirmed working on iPad device by the user.
- Diagnostic logging from Phase 1 stripped; build is clean.

## Findings

### High — fix or revisit

- **CMD+1..9 / CMD+OPT+1..9 / CMD+OPT+SHIFT+1..9 tab shortcuts may register disabled on iPad.** `KelyphosCommands.swift:146,166,186` gates each `navTab(n)` / `inspTab(n)` / `utilTab(n)` with `.disabled(n > (state?.navigatorTabCount ?? 0))`. `navigatorTabCount` defaults to `0` in `KelyphosShellState.swift:83-85` and is set to the real count inside `ShellLifecycleModifier.onAppear` at `KelyphosShellView.swift:559-561`. `Commands` is evaluated against the scene context before that `.onAppear` fires, and `.disabled(true)` at registration prevents `.keyboardShortcut` from firing on iPad even after the value flips. Verified in simulator on 2026-05-11: CMD+0 / CMD+SHIFT+P / CMD+OPT+0 / CMD+SHIFT+/ all fire and log; CMD+1/2/3 produce no log entries.

  Two options:
  - (a) Pass tab counts into `KelyphosShellState` at construction in `KelyphosShellConfiguration` so they're correct at first eval.
  - (b) Remove `.disabled(...)` from the helpers and guard inside each Button action with `guard n <= state.navigatorTabCount else { return }`. Smallest diff.

### Medium — confirm / cleanup

- **Debounce save via `DispatchQueue.main.asyncAfter`** at `Sources/KelyphosKit/Core/KelyphosShellState.swift:180`. Used to coalesce `UserDefaults` writes after rapid state mutations. Pattern repeats in sema and kytos. Functionally fine, but a Combine `debounce` or `Task.sleep`-based debouncer in Swift 6 would be more uniform. Flag for a later kit-level helper.
- **Repeated `.commands { KelyphosCommands() }`** wiring in every sibling's app entry. Could be extracted into a `KelyphosScene` helper that bundles the commands + about/settings scenes. Not urgent.

### Low

- Magic numbers in demo views: font sizes (`size: 32`, `size: 48`, `size: 64`, `size: 11`) and spacings (`spacing: 16`, `spacing: 24`) without rationale comments. Demo target only — purely cosmetic.

## Recommendations

1. Decide CMD+digit fix path (a or b above) — small diff either way.
2. Treat `KelyphosShellState`'s debounce-save as the canonical pattern and document it; sibling apps should use the same prefix-scoped persistence.

## What I did not change

- Did not touch the CMD+digit `.disabled` bug — user did not request a fix in this pass. Flagged here.
- Did not refactor `asyncAfter` debounce — the pattern is intentional and stable.
