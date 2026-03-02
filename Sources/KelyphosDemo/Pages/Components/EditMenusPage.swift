// EditMenusPage.swift - TextEditor with edit menu

import SwiftUI

struct EditMenusPage: View {
    @State private var text = "Select this text and use the Edit menu or right-click for editing options."

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("edit-menus")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Text Editor with Edit Menu") {
                    TextEditor(text: $text)
                        .frame(height: 120)
                        .scrollContentBackground(.hidden)
                }

                GlassSection(title: "About Edit Menus") {
                    Text("Edit menus provide standard text editing commands like Cut, Copy, Paste, Select All, and Find. SwiftUI provides these automatically for TextEditor and TextField.")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
