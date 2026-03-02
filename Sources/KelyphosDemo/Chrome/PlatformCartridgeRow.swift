// PlatformCartridgeRow.swift - HStack of platform badges

import SwiftUI

struct PlatformCartridgeRow: View {
    let supported: [ShowcasePlatform]

    var body: some View {
        HStack(spacing: 6) {
            ForEach(ShowcasePlatform.allCases) { platform in
                Image(systemName: platform.systemImage)
                    .font(.system(size: 11))
                    .foregroundStyle(supported.contains(platform) ? .primary : .quaternary)
                    .help(platform.rawValue)
            }
        }
    }
}

struct MiniPlatformBadges: View {
    let platforms: [ShowcasePlatform]

    var body: some View {
        HStack(spacing: 2) {
            ForEach(platforms) { platform in
                Image(systemName: platform.systemImage)
                    .font(.system(size: 8))
                    .foregroundStyle(.secondary)
            }
        }
    }
}
