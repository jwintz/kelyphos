// DeferredPage.swift - Placeholder for deferred items

import SwiftUI

struct DeferredPage: View {
    let item: ShowcaseItem

    var body: some View {
        ShowcasePageChrome(item: item) {
            VStack(spacing: 16) {
                Image(systemName: "clock.badge.questionmark")
                    .font(.system(size: 48))
                    .foregroundStyle(.tertiary)

                Text("Coming Soon")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Text("This component demo is planned but not yet implemented.")
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
        }
    }
}
