// DemoUtilityTab.swift - Sample utility panels

import AppKit
import SwiftUI
import KelyphosKit

enum DemoUtilityTab: String, KelyphosPanel, CaseIterable {
    case output
    case log

    nonisolated var id: String { rawValue }

    nonisolated var title: String {
        switch self {
        case .output: "Output"
        case .log: "Log"
        }
    }

    nonisolated var systemImage: String {
        switch self {
        case .output: "terminal"
        case .log: "list.bullet.rectangle"
        }
    }

    var body: some View {
        switch self {
        case .output:
            ScrollView {
                Text("$ swift build\nBuild complete! (0.42s)\n$ ")
                    .font(.system(size: 11, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
            }
            .background(Color(nsColor: .textBackgroundColor))
        case .log:
            List {
                Label("Framework loaded", systemImage: "checkmark.circle")
                    .foregroundStyle(.green)
                Label("Window created", systemImage: "checkmark.circle")
                    .foregroundStyle(.green)
                Label("3 navigator tabs registered", systemImage: "info.circle")
                    .foregroundStyle(.blue)
                Label("2 inspector tabs registered", systemImage: "info.circle")
                    .foregroundStyle(.blue)
            }
        }
    }
}
