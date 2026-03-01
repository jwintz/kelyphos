// KelyphosCommands.swift - Menu commands with keyboard shortcuts
// Convention:
//   ⌘+DIGIT      → navigator (0 toggles, 1-9 selects tab or collapses if current)
//   ⌘⌥+DIGIT     → inspector (0 toggles, 1-9 selects tab or collapses if current)
//   ⌘⌥⇧+DIGIT    → utility   (0 toggles, 1-9 selects tab or collapses if current)
//   ⇧⌘/          → keybindings overlay

import SwiftUI

/// Menu commands for the Kelyphos shell.
/// Add to your scene with `.commands { KelyphosCommands(state:) }`.
public struct KelyphosCommands: Commands {
    @Bindable var state: KelyphosShellState

    public init(state: KelyphosShellState) {
        self.state = state
    }

    public var body: some Commands {
        CommandGroup(after: .toolbar) {
            // Navigator
            Section {
                Button(state.navigatorVisible ? "Hide Navigator" : "Show Navigator") {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        state.navigatorVisible.toggle()
                    }
                }
                .keyboardShortcut("0", modifiers: .command)

                navTab(1); navTab(2); navTab(3)
                navTab(4); navTab(5); navTab(6)
                navTab(7); navTab(8); navTab(9)
            }

            Divider()

            // Inspector
            Section {
                Button(state.inspectorVisible ? "Hide Inspector" : "Show Inspector") {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        state.inspectorVisible.toggle()
                    }
                }
                .keyboardShortcut("0", modifiers: [.command, .option])

                inspTab(1); inspTab(2); inspTab(3)
                inspTab(4); inspTab(5); inspTab(6)
                inspTab(7); inspTab(8); inspTab(9)
            }

            Divider()

            // Utility
            Section {
                Button(state.utilityAreaVisible ? "Hide Utility Area" : "Show Utility Area") {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        state.utilityAreaVisible.toggle()
                    }
                }
                .keyboardShortcut("0", modifiers: [.command, .option, .shift])

                utilTab(1); utilTab(2); utilTab(3)
                utilTab(4); utilTab(5); utilTab(6)
                utilTab(7); utilTab(8); utilTab(9)
            }

        }

        // P27: Remove Help menu entirely so CMD+SHIFT+/ doesn't get intercepted.
        // The actual keybindings overlay shortcut is handled via NSEvent monitor
        // in KelyphosShellView (ShellLifecycleModifier).
        CommandGroup(replacing: .help) { }
    }

    // MARK: - Tab Button Helpers (P16: toggle-if-current)

    private func navTab(_ n: Int) -> some View {
        Button("Navigator Tab \(n)") {
            let idx = n - 1
            // P16: If already on this tab and visible, collapse
            if state.navigatorVisible && state.selectedNavigatorIndex == idx {
                withAnimation(.easeInOut(duration: 0.15)) {
                    state.navigatorVisible = false
                }
            } else {
                withAnimation(.easeInOut(duration: 0.15)) {
                    state.navigatorVisible = true
                }
                state.selectedNavigatorIndex = idx
            }
        }
        .keyboardShortcut(KeyEquivalent(Character("\(n)")), modifiers: .command)
        .disabled(n > state.navigatorTabCount)
    }

    private func inspTab(_ n: Int) -> some View {
        Button("Inspector Tab \(n)") {
            let idx = n - 1
            if state.inspectorVisible && state.selectedInspectorIndex == idx {
                withAnimation(.easeInOut(duration: 0.15)) {
                    state.inspectorVisible = false
                }
            } else {
                withAnimation(.easeInOut(duration: 0.15)) {
                    state.inspectorVisible = true
                }
                state.selectedInspectorIndex = idx
            }
        }
        .keyboardShortcut(KeyEquivalent(Character("\(n)")), modifiers: [.command, .option])
        .disabled(n > state.inspectorTabCount)
    }

    private func utilTab(_ n: Int) -> some View {
        Button("Utility Tab \(n)") {
            let idx = n - 1
            if state.utilityAreaVisible && state.selectedUtilityIndex == idx {
                withAnimation(.easeInOut(duration: 0.15)) {
                    state.utilityAreaVisible = false
                }
            } else {
                withAnimation(.easeInOut(duration: 0.15)) {
                    state.utilityAreaVisible = true
                }
                state.selectedUtilityIndex = idx
            }
        }
        .keyboardShortcut(KeyEquivalent(Character("\(n)")), modifiers: [.command, .option, .shift])
        .disabled(n > state.utilityTabCount)
    }
}
