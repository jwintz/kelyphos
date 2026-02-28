// DemoInspectorTab.swift - Sample inspector panels

import SwiftUI
import KelyphosKit

enum DemoInspectorTab: String, KelyphosPanel, CaseIterable {
    case attributes
    case help
    case appearance

    nonisolated var id: String { rawValue }

    nonisolated var title: String {
        switch self {
        case .attributes: "Attributes"
        case .help: "Quick Help"
        case .appearance: "Appearance"
        }
    }

    nonisolated var systemImage: String {
        switch self {
        case .attributes: "slider.horizontal.3"
        case .help: "questionmark.circle"
        case .appearance: "paintbrush"
        }
    }

    var body: some View {
        switch self {
        case .attributes:
            Form {
                Section("File Info") {
                    LabeledContent("Name", value: "Example.swift")
                    LabeledContent("Size", value: "2.4 KB")
                    LabeledContent("Modified", value: "Today")
                }
                Section("Properties") {
                    Toggle("Read Only", isOn: .constant(false))
                    Toggle("Hidden", isOn: .constant(false))
                }
            }
            .formStyle(.grouped)
        case .help:
            VStack(alignment: .leading, spacing: 12) {
                Text("Quick Help")
                    .font(.headline)
                    .padding(.horizontal)
                Text("Select a symbol to see documentation.")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                Spacer()
            }
            .padding(.top)
        case .appearance:
            Text("Appearance settings are in ⌘, Preferences")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
