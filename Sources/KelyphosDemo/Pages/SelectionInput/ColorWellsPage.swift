// ColorWellsPage.swift - ColorPicker

import SwiftUI

struct ColorWellsPage: View {
    @State private var selectedColor = Color.blue
    @State private var bgColor = Color.white

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("color-wells")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Color Picker") {
                    VStack(alignment: .leading, spacing: 12) {
                        ColorPicker("Foreground Color", selection: $selectedColor)
                        ColorPicker("Background Color", selection: $bgColor, supportsOpacity: true)

                        RoundedRectangle(cornerRadius: 8)
                            .fill(bgColor)
                            .frame(height: 60)
                            .overlay {
                                Text("Preview")
                                    .foregroundStyle(selectedColor)
                                    .fontWeight(.bold)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.secondary.opacity(0.3))
                            )
                    }
                }

                GlassSection(title: "Minimal Style") {
                    HStack {
                        Text("Accent Color:")
                        ColorPicker("", selection: $selectedColor)
                            .labelsHidden()
                    }
                }
            }
        }
    }
}
