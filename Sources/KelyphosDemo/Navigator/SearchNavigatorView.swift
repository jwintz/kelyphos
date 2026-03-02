// SearchNavigatorView.swift - TextField + filtered List

import SwiftUI

struct SearchNavigatorView: View {
    @Environment(\.showcaseState) private var showcaseState
    @State private var searchText = ""
    @State private var localSelection: ShowcaseItem?

    private var filteredItems: [ShowcaseItem] {
        guard !searchText.isEmpty else { return [] }
        return ShowcaseCatalog.allItems.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.section.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.tertiary)
                TextField("Search components…", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .glassEffect(in: .capsule)
            .padding(8)

            if searchText.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 32))
                        .foregroundStyle(.quaternary)
                    Text("Type to search")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            } else if filteredItems.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 32))
                        .foregroundStyle(.quaternary)
                    Text("No results for \"\(searchText)\"")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            } else {
                List(selection: $localSelection) {
                    ForEach(filteredItems) { item in
                        NavigatorItemRow(item: item)
                            .tag(item)
                    }
                }
                .listStyle(.sidebar)
            }
        }
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
