// PickersPage.swift - Picker styles

import SwiftUI

struct PickersPage: View {
    @State private var selection1 = "Apple"
    @State private var selection2 = "Banana"
    @State private var selection3 = "Cherry"
    private let fruits = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("pickers")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Menu Style (Default)") {
                    Picker("Fruit", selection: $selection1) {
                        ForEach(fruits, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.menu)
                }

                #if os(macOS)
                GlassSection(title: "Radio Group Style") {
                    Picker("Fruit", selection: $selection2) {
                        ForEach(fruits, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.radioGroup)
                }
                #endif

                GlassSection(title: "Inline Style") {
                    Picker("Fruit", selection: $selection3) {
                        ForEach(fruits, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.inline)
                    .frame(height: 120)
                }
            }
        }
    }
}
