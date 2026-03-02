// SearchFieldsPage.swift - .searchable demos

import SwiftUI

struct SearchFieldsPage: View {
    @State private var searchText = ""
    private let sampleItems = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape"]

    var filteredItems: [String] {
        if searchText.isEmpty { return sampleItems }
        return sampleItems.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("search-fields")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "TextField-Based Search") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            TextField("Search fruits…", text: $searchText)
                                .textFieldStyle(.roundedBorder)
                        }

                        ForEach(filteredItems, id: \.self) { item in
                            Text(item)
                                .padding(.vertical, 2)
                        }
                    }
                }

                GlassSection(title: "About .searchable") {
                    Text("The `.searchable` modifier adds a search field to the navigation bar or toolbar. It works with NavigationSplitView and NavigationStack to provide platform-appropriate search UI.")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
