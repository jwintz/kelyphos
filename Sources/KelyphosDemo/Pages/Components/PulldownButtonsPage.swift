// PulldownButtonsPage.swift - Menu with primary action

import SwiftUI

struct PulldownButtonsPage: View {
    @State private var lastAction = "None"

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("pulldown-buttons")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Pull-Down Button") {
                    VStack(alignment: .leading, spacing: 12) {
                        Menu("Add") {
                            Button("Add File", systemImage: "doc.badge.plus") { lastAction = "Add File" }
                            Button("Add Folder", systemImage: "folder.badge.plus") { lastAction = "Add Folder" }
                            Button("Add Package", systemImage: "shippingbox") { lastAction = "Add Package" }
                        }

                        Text("Last action: \(lastAction)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                GlassSection(title: "With Primary Action") {
                    Menu("Create") {
                        Button("Document") { lastAction = "Document" }
                        Button("Spreadsheet") { lastAction = "Spreadsheet" }
                        Button("Presentation") { lastAction = "Presentation" }
                    } primaryAction: {
                        lastAction = "Primary: Create"
                    }
                }
            }
        }
    }
}
