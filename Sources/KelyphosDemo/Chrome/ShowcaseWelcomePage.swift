// ShowcaseWelcomePage.swift - Default landing page when no item is selected

import SwiftUI

struct ShowcaseWelcomePage: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "cube.transparent")
                .font(.system(size: 64))
                .foregroundStyle(.tertiary)

            Text("HIG Component Showcase")
                .font(.largeTitle)
                .fontWeight(.light)

            Text("Select a component from the navigator to explore")
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                Text("Shortcuts")
                    .font(.headline)
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
            .padding(16)
            .glassEffect(in: RoundedRectangle(cornerRadius: 16))
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
