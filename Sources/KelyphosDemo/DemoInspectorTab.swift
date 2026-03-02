// DemoInspectorTab.swift - Inspector panels with showcase details

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
            SelectedItemDetailsView()
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
