// DemoNavigatorTab.swift - Navigator panels with showcase views

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
            ExploreNavigatorView()
        case .search:
            SearchNavigatorView()
        case .bookmarks:
            BookmarksNavigatorView()
        }
    }
}
