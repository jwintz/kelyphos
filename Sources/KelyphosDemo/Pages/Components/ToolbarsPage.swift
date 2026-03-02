// ToolbarsPage.swift - .toolbar modifier demos

import SwiftUI

struct ToolbarsPage: View {
    @State private var showInfo = false

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("toolbars")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "About Toolbars") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Toolbars provide convenient access to frequently used commands. In SwiftUI, you add toolbar items using the `.toolbar` modifier.")
                            .foregroundStyle(.secondary)

                        Divider()

                        Text("Toolbar Placements:")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 4) {
                            Label(".automatic — System default", systemImage: "sparkle")
                            Label(".primaryAction — Primary action area", systemImage: "star")
                            Label(".secondaryAction — Overflow menu", systemImage: "ellipsis.circle")
                            Label(".navigation — Navigation area", systemImage: "chevron.left")
                            Label(".confirmationAction — Confirmation", systemImage: "checkmark")
                            Label(".cancellationAction — Cancel", systemImage: "xmark")
                            Label(".destructiveAction — Destructive", systemImage: "trash")
                        }
                        .font(.system(size: 12))
                        .padding(.leading, 4)
                    }
                }

                GlassSection(title: "Interactive Example") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("The toolbar items for this page are added to the window toolbar above.")
                            .foregroundStyle(.secondary)

                        if showInfo {
                            Text("Info panel is showing!")
                                .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
            }
        }
    }
}
