// PopupButtonsPage.swift - Picker with .menu style

import SwiftUI

struct PopupButtonsPage: View {
    @State private var selectedOption = "Option A"
    @State private var selectedColor = "Blue"

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("popup-buttons")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Pop-Up Button (Picker .menu)") {
                    VStack(alignment: .leading, spacing: 12) {
                        Picker("Choose Option", selection: $selectedOption) {
                            Text("Option A").tag("Option A")
                            Text("Option B").tag("Option B")
                            Text("Option C").tag("Option C")
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: 200)

                        Text("Selected: \(selectedOption)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                GlassSection(title: "Labeled Pop-Up") {
                    LabeledContent("Color") {
                        Picker("Color", selection: $selectedColor) {
                            Text("Red").tag("Red")
                            Text("Green").tag("Green")
                            Text("Blue").tag("Blue")
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                        .frame(maxWidth: 150)
                    }
                }
            }
        }
    }
}
