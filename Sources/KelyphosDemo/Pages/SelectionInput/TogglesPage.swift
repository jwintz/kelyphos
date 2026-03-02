// TogglesPage.swift - Toggle styles

import SwiftUI

struct TogglesPage: View {
    @State private var isOn1 = true
    @State private var isOn2 = false
    @State private var isOn3 = true

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("toggles")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Switch Style (Default)") {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Wi-Fi", isOn: $isOn1)
                        Toggle("Bluetooth", isOn: $isOn2)
                        Toggle("Airplane Mode", isOn: $isOn3)
                    }
                }

                #if os(macOS)
                GlassSection(title: "Checkbox Style") {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Show hidden files", isOn: $isOn1)
                            .toggleStyle(.checkbox)
                        Toggle("Auto-save", isOn: $isOn2)
                            .toggleStyle(.checkbox)
                        Toggle("Show line numbers", isOn: $isOn3)
                            .toggleStyle(.checkbox)
                    }
                }
                #endif

                GlassSection(title: "Button Style") {
                    HStack(spacing: 12) {
                        Toggle("Bold", isOn: $isOn1)
                            .toggleStyle(.button)
                        Toggle("Italic", isOn: $isOn2)
                            .toggleStyle(.button)
                        Toggle("Underline", isOn: $isOn3)
                            .toggleStyle(.button)
                    }
                }

                GlassSection(title: "Disabled") {
                    Toggle("Cannot change", isOn: .constant(true))
                        .disabled(true)
                }
            }
        }
    }
}
