// DemoUtilityTab.swift - Sample utility panels

import SwiftUI
import KelyphosKit

enum DemoUtilityTab: String, KelyphosPanel, CaseIterable {
    case console
    case diagnostics

    nonisolated var id: String { rawValue }

    nonisolated var title: String {
        switch self {
        case .console: "Console"
        case .diagnostics: "Diagnostics"
        }
    }

    nonisolated var systemImage: String {
        switch self {
        case .console: "terminal"
        case .diagnostics: "exclamationmark.triangle"
        }
    }

    var body: some View {
        switch self {
        case .console:
            ScrollView {
                VStack(alignment: .leading) {
                    Text("$ swift build")
                        .font(.system(size: 11, design: .monospaced))
                    Text("Build complete! (0.42s)")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundStyle(.green)
                    Text("$")
                        .font(.system(size: 11, design: .monospaced))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
            }
            .background(Color(nsColor: .textBackgroundColor))
        case .diagnostics:
            List {
                Label("No issues", systemImage: "checkmark.circle")
                    .foregroundStyle(.green)
            }
        }
    }
}
