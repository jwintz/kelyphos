// DemoInspectorTab.swift - Sample inspector panels

import SwiftUI
import KelyphosKit

enum DemoInspectorTab: String, KelyphosPanel, CaseIterable {
    case details
    case properties

    nonisolated var id: String { rawValue }

    nonisolated var title: String {
        switch self {
        case .details: "Details"
        case .properties: "Properties"
        }
    }

    nonisolated var systemImage: String {
        switch self {
        case .details: "info.circle"
        case .properties: "slider.horizontal.3"
        }
    }

    var body: some View {
        switch self {
        case .details:
            Form {
                Section("Selection") {
                    LabeledContent("Name", value: "Example.swift")
                    LabeledContent("Type", value: "Swift Source")
                    LabeledContent("Size", value: "2.4 KB")
                    LabeledContent("Modified", value: "Today")
                }
            }
            .formStyle(.grouped)
        case .properties:
            Form {
                Section("Display") {
                    Toggle("Show Line Numbers", isOn: .constant(true))
                    Toggle("Word Wrap", isOn: .constant(false))
                }
                Section("Behavior") {
                    Toggle("Auto-save", isOn: .constant(true))
                    Toggle("Trim Whitespace", isOn: .constant(true))
                }
            }
            .formStyle(.grouped)
        }
    }
}
