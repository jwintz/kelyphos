// SegmentedControlsPage.swift - Picker .segmented

import SwiftUI

struct SegmentedControlsPage: View {
    @State private var viewMode = "List"
    @State private var alignment = "Left"

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("segmented-controls")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Segmented Control") {
                    VStack(alignment: .leading, spacing: 12) {
                        Picker("View Mode", selection: $viewMode) {
                            Text("List").tag("List")
                            Text("Grid").tag("Grid")
                            Text("Gallery").tag("Gallery")
                        }
                        .pickerStyle(.segmented)

                        Text("Selected: \(viewMode)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                GlassSection(title: "With Icons") {
                    Picker("Alignment", selection: $alignment) {
                        Image(systemName: "text.alignleft").tag("Left")
                        Image(systemName: "text.aligncenter").tag("Center")
                        Image(systemName: "text.alignright").tag("Right")
                        Image(systemName: "text.justify").tag("Justify")
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
    }
}
