// DemoNavigatorTab.swift - Sample navigator panels

import SwiftUI
import KelyphosKit

enum DemoNavigatorTab: String, KelyphosPanel, CaseIterable {
    case files
    case search
    case git

    nonisolated var id: String { rawValue }

    nonisolated var title: String {
        switch self {
        case .files: "Files"
        case .search: "Search"
        case .git: "Source Control"
        }
    }

    nonisolated var systemImage: String {
        switch self {
        case .files: "doc.on.doc"
        case .search: "magnifyingglass"
        case .git: "point.3.filled.connected.trianglepath.dotted"
        }
    }

    var body: some View {
        switch self {
        case .files:
            List {
                Label("Package.swift", systemImage: "swift")
                Label("Sources/", systemImage: "folder")
                Label("Tests/", systemImage: "folder")
                Label("README.md", systemImage: "doc.text")
            }
            .listStyle(.sidebar)
        case .search:
            VStack {
                TextField("Search…", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Spacer()
                Text("Enter a search term")
                    .foregroundStyle(.secondary)
                Spacer()
            }
        case .git:
            List {
                Section("Changes") {
                    Label("Modified: AppDelegate.swift", systemImage: "pencil.circle")
                    Label("Added: NewFile.swift", systemImage: "plus.circle")
                }
            }
            .listStyle(.sidebar)
        }
    }
}
