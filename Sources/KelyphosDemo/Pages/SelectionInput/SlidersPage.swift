// SlidersPage.swift - Slider variants

import SwiftUI

struct SlidersPage: View {
    @State private var value = 50.0
    @State private var rangeValue = 0.5
    @State private var steppedValue = 3.0

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("sliders")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Basic Slider") {
                    VStack(alignment: .leading, spacing: 8) {
                        Slider(value: $value, in: 0...100) {
                            Text("Value")
                        }
                        Text("Value: \(Int(value))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                GlassSection(title: "Slider with Labels") {
                    Slider(value: $rangeValue, in: 0...1) {
                        Text("Opacity")
                    } minimumValueLabel: {
                        Image(systemName: "sun.min")
                    } maximumValueLabel: {
                        Image(systemName: "sun.max")
                    }
                }

                GlassSection(title: "Stepped Slider") {
                    VStack(alignment: .leading, spacing: 8) {
                        Slider(value: $steppedValue, in: 1...5, step: 1) {
                            Text("Rating")
                        }
                        Text("Rating: \(Int(steppedValue)) / 5")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
