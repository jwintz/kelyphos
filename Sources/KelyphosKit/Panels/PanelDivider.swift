// PanelDivider.swift - Styled divider for panel sections

import SwiftUI

/// A divider with a separator color overlay.
public struct PanelDivider: View {
    public init() {}

    public var body: some View {
        Divider()
            .overlay(Color(nsColor: .separatorColor))
    }
}
