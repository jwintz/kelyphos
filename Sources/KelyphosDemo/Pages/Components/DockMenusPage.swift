// DockMenusPage.swift - NSApplication dock menu

import SwiftUI

struct DockMenusPage: View {
    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("dock-menus")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Dock Menu") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Dock menus appear when the user right-clicks or Control-clicks the app icon in the Dock.")
                            .foregroundStyle(.secondary)

                        Text("In SwiftUI, dock menus are not directly supported via a modifier. You typically implement them via the NSApplicationDelegate's `applicationDockMenu(_:)` method.")
                            .foregroundStyle(.secondary)

                        Divider()

                        Text("Example items a dock menu might contain:")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 4) {
                            Label("New Window", systemImage: "plus.rectangle")
                            Label("New Tab", systemImage: "plus.square")
                            Label("Show All Windows", systemImage: "rectangle.stack")
                        }
                        .padding(.leading, 4)
                    }
                }
            }
        }
    }
}
