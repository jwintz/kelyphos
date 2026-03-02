// SteppersPage.swift - Stepper variants

import SwiftUI

struct SteppersPage: View {
    @State private var quantity = 1
    @State private var fontSize = 14.0

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("steppers")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Basic Stepper") {
                    Stepper("Quantity: \(quantity)", value: $quantity, in: 0...99)
                }

                GlassSection(title: "Stepper with Format") {
                    Stepper(value: $fontSize, in: 8...72, step: 0.5) {
                        Text("Font Size: \(fontSize, specifier: "%.1f") pt")
                    }
                }

                GlassSection(title: "Custom Stepper") {
                    Stepper {
                        HStack {
                            Text("Items")
                            Spacer()
                            Text("\(quantity)")
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                    } onIncrement: {
                        quantity += 1
                    } onDecrement: {
                        if quantity > 0 { quantity -= 1 }
                    }
                }
            }
        }
    }
}
