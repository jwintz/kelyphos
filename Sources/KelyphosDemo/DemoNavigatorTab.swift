// DemoNavigatorTab.swift - Sample navigator panels

import SwiftUI
import KelyphosKit

enum DemoNavigatorTab: String, KelyphosPanel, CaseIterable {
    case explore
    case search
    case bookmarks

    nonisolated var id: String { rawValue }

    nonisolated var title: String {
        switch self {
        case .explore: "Explore"
        case .search: "Search"
        case .bookmarks: "Bookmarks"
        }
    }

    nonisolated var systemImage: String {
        switch self {
        case .explore: "folder"
        case .search: "magnifyingglass"
        case .bookmarks: "bookmark"
        }
    }

    var body: some View {
        switch self {
        case .explore:
            List {
                Section("Project") {
                    Label("Sources", systemImage: "folder.fill")
                    Label("Resources", systemImage: "folder.fill")
                    Label("Tests", systemImage: "folder.fill")
                }
                Section("Files") {
                    Label("Package.swift", systemImage: "doc.text")
                    Label("README.md", systemImage: "doc.text")
                    Label("LICENSE", systemImage: "doc.text")
                }
            }
            .listStyle(.sidebar)
        case .search:
            VStack(spacing: 12) {
                TextField("Search…", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .padding(.top)
                Spacer()
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 32))
                    .foregroundStyle(.quaternary)
                Text("Type to search")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        case .bookmarks:
            List {
                Label("Getting Started", systemImage: "star")
                Label("API Reference", systemImage: "star")
                Label("Architecture", systemImage: "star")
            }
            .listStyle(.sidebar)
        }
    }
}
