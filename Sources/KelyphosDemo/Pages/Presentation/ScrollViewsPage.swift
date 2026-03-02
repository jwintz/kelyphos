// ScrollViewsPage.swift - ScrollView demos

import SwiftUI

struct ScrollViewsPage: View {
    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("scroll-views")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Vertical ScrollView") {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(0..<20) { i in
                                Text("Row \(i)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(.fill.tertiary, in: RoundedRectangle(cornerRadius: 6))
                            }
                        }
                    }
                    .frame(height: 200)
                }

                GlassSection(title: "Horizontal ScrollView") {
                    ScrollView(.horizontal) {
                        HStack(spacing: 8) {
                            ForEach(0..<15) { i in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hue: Double(i) / 15.0, saturation: 0.6, brightness: 0.8))
                                    .frame(width: 80, height: 80)
                                    .overlay {
                                        Text("\(i)")
                                            .foregroundStyle(.white)
                                            .fontWeight(.bold)
                                    }
                            }
                        }
                    }
                }

                GlassSection(title: "ScrollView Indicators") {
                    Text("ScrollView supports `.scrollIndicators(.hidden)`, `.scrollIndicators(.visible)`, and `.scrollIndicators(.automatic)` for controlling scroll indicator visibility.")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
