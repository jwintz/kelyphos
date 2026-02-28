// DemoContentView.swift - Placeholder detail view

import SwiftUI
import KelyphosKit

struct DemoContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cube.transparent")
                .font(.system(size: 64))
                .foregroundStyle(.tertiary)

            Text("Kelyphos Demo")
                .font(.largeTitle)
                .fontWeight(.light)

            Text("A reusable macOS Liquid Glass shell framework")
                .foregroundStyle(.secondary)

            GroupBox {
                VStack(alignment: .leading, spacing: 8) {
                    shortcutRow("⌘1", "Toggle Navigator")
                    shortcutRow("⌘⌥0", "Toggle Inspector")
                    shortcutRow("⌘?", "Show Keybindings")
                    shortcutRow("⌘,", "Settings")
                }
                .font(.system(size: 12))
                .padding(4)
            }
            .frame(width: 280)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func shortcutRow(_ shortcut: String, _ label: String) -> some View {
        HStack {
            Text(shortcut)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(width: 60, alignment: .trailing)
            Text(label)
        }
    }
}
