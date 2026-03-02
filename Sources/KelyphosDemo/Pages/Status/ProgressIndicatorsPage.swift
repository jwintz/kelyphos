// ProgressIndicatorsPage.swift - ProgressView variants

import SwiftUI

struct ProgressIndicatorsPage: View {
    @State private var progress = 0.6

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("progress-indicators")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Indeterminate") {
                    VStack(alignment: .leading, spacing: 12) {
                        ProgressView()
                            .progressViewStyle(.circular)
                        ProgressView("Loading…")
                            .progressViewStyle(.circular)
                    }
                }

                GlassSection(title: "Determinate (Linear)") {
                    VStack(alignment: .leading, spacing: 12) {
                        ProgressView(value: progress) {
                            Text("Downloading…")
                        }
                        ProgressView(value: progress) {
                            Text("Upload Progress")
                        } currentValueLabel: {
                            Text("\(Int(progress * 100))%")
                        }

                        Slider(value: $progress, in: 0...1)
                    }
                }

                GlassSection(title: "Determinate (Circular)") {
                    HStack(spacing: 24) {
                        ProgressView(value: 0.3)
                            .progressViewStyle(.circular)
                        ProgressView(value: 0.6)
                            .progressViewStyle(.circular)
                        ProgressView(value: 0.9)
                            .progressViewStyle(.circular)
                    }
                }
            }
        }
    }
}
