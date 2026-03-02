// PageControlsPage.swift - TabView with .page style info

import SwiftUI

struct PageControlsPage: View {
    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("page-controls")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Page Controls") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Page controls indicate the current page in a flat list of pages. On iOS, `TabView` with `.tabViewStyle(.page)` provides native page swiping with dot indicators.")
                            .foregroundStyle(.secondary)

                        Text("On macOS, page controls are less common. Horizontal scrolling or segmented controls are preferred alternatives.")
                            .foregroundStyle(.secondary)

                        Divider()

                        HStack(spacing: 8) {
                            ForEach(0..<5) { i in
                                Circle()
                                    .fill(i == 2 ? Color.primary : Color.secondary.opacity(0.3))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                }
            }
        }
    }
}
