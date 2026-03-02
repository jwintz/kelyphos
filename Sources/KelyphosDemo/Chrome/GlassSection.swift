// GlassSection.swift - Liquid Glass section container for showcase pages

import SwiftUI

/// A section container that uses Liquid Glass as its background material.
/// Replaces GroupBox for the HIG showcase to leverage the macOS 26 glass design.
struct GlassSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(in: RoundedRectangle(cornerRadius: 16))
    }
}
