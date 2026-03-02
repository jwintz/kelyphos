// MenusPage.swift - Menu/CommandMenu demos

import SwiftUI

struct MenusPage: View {
    @State private var selectedSort = "Name"

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("menus")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Basic Menu") {
                    Menu("Actions") {
                        Button("New File", systemImage: "doc.badge.plus") {}
                        Button("New Folder", systemImage: "folder.badge.plus") {}
                        Divider()
                        Button("Import…", systemImage: "square.and.arrow.down") {}
                    }
                }

                GlassSection(title: "Menu with Submenus") {
                    Menu("Sort By") {
                        Button("Name") { selectedSort = "Name" }
                        Button("Date Modified") { selectedSort = "Date Modified" }
                        Button("Size") { selectedSort = "Size" }
                        Divider()
                        Menu("Group By") {
                            Button("Kind") {}
                            Button("Date") {}
                            Button("None") {}
                        }
                    }

                    Text("Current sort: \(selectedSort)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                }

                GlassSection(title: "Menu with Primary Action") {
                    Menu("Add Item") {
                        Button("Add File") {}
                        Button("Add Folder") {}
                        Button("Add Package") {}
                    } primaryAction: {
                        // Primary action
                    }
                }
            }
        }
    }
}
