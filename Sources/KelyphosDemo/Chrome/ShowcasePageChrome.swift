// ShowcasePageChrome.swift - Wrapper with title, platform row, and content slot

import SwiftUI

struct ShowcasePageChrome<Content: View>: View {
    let item: ShowcaseItem
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header: title left, platforms right, same line
                HStack(alignment: .firstTextBaseline) {
                    Label(item.title, systemImage: item.systemImage)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("—")
                        .foregroundStyle(.tertiary)

                    Text(item.section.title)
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    Spacer()

                    PlatformCartridgeRow(supported: item.platforms)
                }

                Divider()

                // Page content — full width
                content
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
