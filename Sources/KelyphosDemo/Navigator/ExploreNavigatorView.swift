// ExploreNavigatorView.swift - Hierarchical List with sections
// Dual mode: sections-only when content column visible, full hierarchy otherwise.

import SwiftUI
import KelyphosKit

struct ExploreNavigatorView: View {
    @Environment(\.showcaseState) private var showcaseState
    @Environment(\.kelyphosShellState) private var shellState
    @State private var localItemSelection: ShowcaseItem?
    @State private var localSectionSelection: ShowcaseSection?

    private var isThreeColumn: Bool {
        shellState?.contentColumnVisible == true
    }

    var body: some View {
        if isThreeColumn {
            sectionListView
        } else {
            fullHierarchyView
        }
    }

    // MARK: - Three-column mode: sections only

    private var sectionListView: some View {
        List(selection: $localSectionSelection) {
            ForEach(ShowcaseCatalog.currentPlatformSections, id: \.0) { section, _ in
                Label(section.title, systemImage: section.systemImage)
                    .tag(section)
            }
        }
        .listStyle(.sidebar)
        .onChange(of: localSectionSelection) { _, newValue in
            showcaseState?.selectedSection = newValue
        }
        .onChange(of: showcaseState?.selectedSection) { _, newValue in
            if localSectionSelection != newValue {
                localSectionSelection = newValue
            }
        }
        .onAppear {
            localSectionSelection = showcaseState?.selectedSection
        }
    }

    // MARK: - Two-column mode: full hierarchy

    private var fullHierarchyView: some View {
        List(selection: $localItemSelection) {
            ForEach(ShowcaseCatalog.currentPlatformSections, id: \.0) { section, items in
                Section(section.title) {
                    ForEach(items) { item in
                        NavigatorItemRow(item: item)
                            .tag(item)
                            .contextMenu {
                                if let state = showcaseState {
                                    Button {
                                        state.toggleBookmark(item)
                                    } label: {
                                        if state.isBookmarked(item) {
                                            Label("Remove Bookmark", systemImage: "bookmark.slash")
                                        } else {
                                            Label("Add Bookmark", systemImage: "bookmark")
                                        }
                                    }
                                }
                            }
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .onChange(of: localItemSelection) { _, newValue in
            showcaseState?.selectedItem = newValue
        }
        .onChange(of: showcaseState?.selectedItem) { _, newValue in
            if localItemSelection != newValue {
                localItemSelection = newValue
            }
        }
        .onAppear {
            localItemSelection = showcaseState?.selectedItem
        }
    }
}
