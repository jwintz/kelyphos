// DemoContentView.swift - Central detail view

import SwiftUI
import KelyphosKit

struct DemoContentView: View {
    @Environment(\.kelyphosShellState) private var shellState

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "cube.transparent")
                .font(.system(size: 64))
                .foregroundStyle(.tertiary)

            Text("Kelyphos")
                .font(.largeTitle)
                .fontWeight(.light)

            Text("macOS Liquid Glass Shell Framework")
                .foregroundStyle(.secondary)

            // Panel deactivation toggles (inspector + utility only)
            GroupBox("Panels") {
                VStack(alignment: .leading, spacing: 8) {
                    if let state = shellState {
                        Toggle("Inspector", isOn: Binding(
                            get: { state.inspectorEnabled },
                            set: { state.inspectorEnabled = $0 }
                        ))
                        Toggle("Utility Area", isOn: Binding(
                            get: { state.utilityEnabled },
                            set: { state.utilityEnabled = $0 }
                        ))
                    }
                }
                .padding(4)
            }
            .frame(width: 300)

            GroupBox("Shortcuts") {
                VStack(alignment: .leading, spacing: 8) {
                    shortcutRow("⌘0", "Toggle Navigator")
                    shortcutRow("⌘1–9", "Select Navigator Tab")
                    shortcutRow("⌘⌥0", "Toggle Inspector")
                    shortcutRow("⌘⌥1–9", "Select Inspector Tab")
                    shortcutRow("⌘⌥⇧0", "Toggle Utility Area")
                    shortcutRow("⌘⌥⇧1–9", "Select Utility Tab")
                    shortcutRow("⌘?", "Keyboard Shortcuts")
                    shortcutRow("⌘,", "Settings")
                }
                .font(.system(size: 12))
                .padding(4)
            }
            .frame(width: 300)
        }
        .padding(.vertical, 40)
    }

    private func shortcutRow(_ shortcut: String, _ label: String) -> some View {
        HStack {
            Text(shortcut)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .trailing)
            Text(label)
        }
    }
}
