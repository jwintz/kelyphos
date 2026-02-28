// KelyphosCommands.swift - Menu commands with keyboard shortcuts

import SwiftUI

/// Menu commands for the Kelyphos shell. Add to your scene with `.commands { KelyphosCommands(state:) }`.
public struct KelyphosCommands: Commands {
    @Bindable var state: KelyphosShellState

    public init(state: KelyphosShellState) {
        self.state = state
    }

    public var body: some Commands {
        // View menu
        CommandGroup(after: .toolbar) {
            Button(state.navigatorVisible ? "Hide Navigator" : "Show Navigator") {
                withAnimation(.easeInOut(duration: 0.15)) {
                    state.navigatorVisible.toggle()
                }
            }
            .keyboardShortcut("1", modifiers: .command)

            Button(state.inspectorVisible ? "Hide Inspector" : "Show Inspector") {
                withAnimation(.easeInOut(duration: 0.15)) {
                    state.inspectorVisible.toggle()
                }
            }
            .keyboardShortcut("0", modifiers: [.command, .option])

            Button(state.utilityAreaVisible ? "Hide Utility Area" : "Show Utility Area") {
                withAnimation(.easeInOut(duration: 0.15)) {
                    state.utilityAreaVisible.toggle()
                }
            }
            .keyboardShortcut("y", modifiers: [.command, .shift])

            Divider()

            Button("Keyboard Shortcuts") {
                state.showKeybindingsOverlay.toggle()
            }
            .keyboardShortcut("/", modifiers: [.command, .shift])
        }
    }
}
