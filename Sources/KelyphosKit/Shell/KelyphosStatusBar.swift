// KelyphosStatusBar.swift - Bottom status bar slot

import SwiftUI

/// A generic status bar container for the bottom of the shell.
public struct KelyphosStatusBar<Content: View>: View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        HStack(spacing: 0) {
            content
        }
        .frame(height: KelyphosDesign.Height.statusBar)
        .frame(maxWidth: .infinity)
        .overlay(alignment: .top) {
            Divider()
        }
    }
}
