// ActionSheetsPage.swift - .confirmationDialog

import SwiftUI

struct ActionSheetsPage: View {
    @State private var showDialog = false
    @State private var result = "None"

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("action-sheets")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Confirmation Dialog") {
                    VStack(alignment: .leading, spacing: 12) {
                        Button("Show Confirmation Dialog") {
                            showDialog = true
                        }
                        .confirmationDialog("Choose an action", isPresented: $showDialog) {
                            Button("Save") { result = "Save" }
                            Button("Discard Changes", role: .destructive) { result = "Discard" }
                            Button("Cancel", role: .cancel) { result = "Cancel" }
                        } message: {
                            Text("You have unsaved changes.")
                        }

                        Text("Last result: \(result)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                GlassSection(title: "About Action Sheets") {
                    Text("On iOS, `.confirmationDialog` presents an action sheet. On macOS, it presents a sheet-style dialog. Use it for confirming destructive actions or choosing between options.")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
