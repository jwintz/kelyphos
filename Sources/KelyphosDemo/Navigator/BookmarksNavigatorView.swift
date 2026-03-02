// BookmarksNavigatorView.swift - List of bookmarked items

import SwiftUI

struct BookmarksNavigatorView: View {
    @Environment(\.showcaseState) private var showcaseState
    @State private var localSelection: ShowcaseItem?

    var body: some View {
        if let state = showcaseState {
            if state.bookmarkedItems.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 32))
                        .foregroundStyle(.quaternary)
                    Text("No Bookmarks")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Right-click items in Explore to bookmark them.")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(selection: $localSelection) {
                    ForEach(state.bookmarkedItems) { item in
                        NavigatorItemRow(item: item)
                            .tag(item)
                            .contextMenu {
                                Button {
                                    state.toggleBookmark(item)
                                } label: {
                                    Label("Remove Bookmark", systemImage: "bookmark.slash")
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
            }
        }
    }
}
