// ExploreNavigatorView.swift - Hierarchical List with sections

import SwiftUI

struct ExploreNavigatorView: View {
    @Environment(\.showcaseState) private var showcaseState
    @State private var localSelection: ShowcaseItem?

    var body: some View {
        List(selection: $localSelection) {
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
        .onChange(of: localSelection) { _, newValue in
            showcaseState?.selectedItem = newValue
        }
        .onChange(of: showcaseState?.selectedItem) { _, newValue in
            if localSelection != newValue {
                localSelection = newValue
            }
        }
        .onAppear {
            localSelection = showcaseState?.selectedItem
        }
    }
}
