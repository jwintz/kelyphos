// AlertsPage.swift - .alert variants

import SwiftUI

struct AlertsPage: View {
    @State private var showBasicAlert = false
    @State private var showActionAlert = false
    @State private var showTextFieldAlert = false
    @State private var alertInput = ""

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("alerts")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Basic Alert") {
                    Button("Show Alert") { showBasicAlert = true }
                        .alert("Information", isPresented: $showBasicAlert) {
                            Button("OK") {}
                        } message: {
                            Text("This is a basic informational alert.")
                        }
                }

                GlassSection(title: "Alert with Actions") {
                    Button("Show Destructive Alert") { showActionAlert = true }
                        .alert("Delete Item?", isPresented: $showActionAlert) {
                            Button("Delete", role: .destructive) {}
                            Button("Cancel", role: .cancel) {}
                        } message: {
                            Text("This action cannot be undone.")
                        }
                }

                GlassSection(title: "Alert with Text Field") {
                    VStack(alignment: .leading, spacing: 8) {
                        Button("Show Input Alert") { showTextFieldAlert = true }
                            .alert("Enter Name", isPresented: $showTextFieldAlert) {
                                TextField("Name", text: $alertInput)
                                Button("OK") {}
                                Button("Cancel", role: .cancel) {}
                            } message: {
                                Text("Please enter a name for the item.")
                            }

                        if !alertInput.isEmpty {
                            Text("Entered: \(alertInput)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }
}
