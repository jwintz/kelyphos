// WidgetsPage.swift - Widget size preview cards

import SwiftUI

struct WidgetsPage: View {
    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("widgets")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Widget Sizes") {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Widgets come in multiple sizes. Here are the standard widget families:")
                            .foregroundStyle(.secondary)

                        HStack(alignment: .top, spacing: 16) {
                            widgetPreview("Small", width: 80, height: 80)
                            widgetPreview("Medium", width: 170, height: 80)
                        }
                        HStack(alignment: .top, spacing: 16) {
                            widgetPreview("Large", width: 170, height: 170)
                            widgetPreview("Extra Large", width: 250, height: 170)
                        }
                    }
                }

                GlassSection(title: "About Widgets") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Widgets display glanceable, relevant content from your app. They are built using WidgetKit and SwiftUI.")
                            .foregroundStyle(.secondary)

                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            Label("WidgetKit — Framework for building widgets", systemImage: "square.grid.2x2")
                            Label("TimelineProvider — Supplies widget data", systemImage: "clock")
                            Label("IntentConfiguration — User-configurable", systemImage: "gearshape")
                            Label("App Intents — Modern configuration", systemImage: "sparkle")
                        }
                        .font(.system(size: 12))
                    }
                }
            }
        }
    }

    private func widgetPreview(_ label: String, width: CGFloat, height: CGFloat) -> some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.fill.tertiary)
                .frame(width: width, height: height)
                .overlay {
                    VStack {
                        Image(systemName: "square.grid.2x2")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        Text(label)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
