// ContextMenusPage.swift - contextMenu modifier demos

import SwiftUI

struct ContextMenusPage: View {
    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("context-menus")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Basic Context Menu") {
                    Text("Right-click me")
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(.fill.tertiary, in: RoundedRectangle(cornerRadius: 8))
                        .contextMenu {
                            Button("Copy", systemImage: "doc.on.doc") {}
                            Button("Paste", systemImage: "clipboard") {}
                            Divider()
                            Button("Delete", systemImage: "trash", role: .destructive) {}
                        }
                }

                GlassSection(title: "Context Menu with Preview") {
                    Label("Right-click for context menu with sections", systemImage: "cursorarrow.click.2")
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(.fill.tertiary, in: RoundedRectangle(cornerRadius: 8))
                        .contextMenu {
                            Section("Edit") {
                                Button("Cut", systemImage: "scissors") {}
                                Button("Copy", systemImage: "doc.on.doc") {}
                                Button("Paste", systemImage: "clipboard") {}
                            }
                            Section("Actions") {
                                Button("Share", systemImage: "square.and.arrow.up") {}
                                Button("Duplicate", systemImage: "plus.square.on.square") {}
                            }
                        }
                }
            }
        }
    }
}
