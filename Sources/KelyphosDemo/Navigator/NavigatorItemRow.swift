// NavigatorItemRow.swift - Shared row with icon, title, and mini platform badges

import SwiftUI

struct NavigatorItemRow: View {
    let item: ShowcaseItem

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: item.systemImage)
                .frame(width: 16)
                .foregroundStyle(.secondary)
            Text(item.title)
            Spacer()
            MiniPlatformBadges(platforms: item.platforms)
        }
    }
}
