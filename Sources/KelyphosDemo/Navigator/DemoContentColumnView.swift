// DemoContentColumnView.swift - Content column showing items for selected section

import SwiftUI
import KelyphosKit

struct DemoContentColumnView: View {
    @Environment(\.showcaseState) private var showcaseState
    @State private var localSelection: ShowcaseItem?

    var body: some View {
        Group {
            if let section = showcaseState?.selectedSection,
               let items = itemsForSection(section), !items.isEmpty {
                List(selection: $localSelection) {
                    ForEach(items) { item in
                        NavigatorItemRow(item: item)
                            .tag(item)
                    }
                }
                .listStyle(.sidebar)
                .scrollContentBackground(.hidden)
            } else {
                ContentUnavailableView(
                    "No Section Selected",
                    systemImage: "square.split.2x1",
                    description: Text("Select a section in the navigator.")
                )
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
        .onChange(of: showcaseState?.selectedSection) { _, newSection in
            // When section changes, auto-select the first item if current
            // selection is nil or belongs to a different section.
            guard let state = showcaseState, let section = newSection else { return }
            if state.selectedItem == nil || state.selectedItem?.section != section {
                if let firstItem = itemsForSection(section)?.first {
                    state.selectedItem = firstItem
                    localSelection = firstItem
                }
            } else {
                localSelection = state.selectedItem
            }
        }
        .onAppear {
            localSelection = showcaseState?.selectedItem
        }
    }

    private func itemsForSection(_ section: ShowcaseSection) -> [ShowcaseItem]? {
        ShowcaseCatalog.currentPlatformSections
            .first { $0.0 == section }
            .map(\.1)
    }
}
