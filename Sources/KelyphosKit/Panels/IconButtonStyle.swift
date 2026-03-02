// IconButtonStyle.swift - Tab button style for panel icon bars

import SwiftUI

/// Button style for panel tab icons with active/inactive states.
public struct IconButtonStyle: ButtonStyle {
    public var isActive: Bool
    public var size: CGSize?

    #if os(macOS)
    @Environment(\.controlActiveState) private var controlActiveState
    #endif
    @Environment(\.colorScheme) private var colorScheme

    public init(isActive: Bool, size: CGSize? = nil) {
        self.isActive = isActive
        self.size = size
    }

    private var inactiveColor: Color {
        #if os(macOS)
        Color(nsColor: .secondaryLabelColor)
        #else
        Color(uiColor: .secondaryLabel)
        #endif
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isActive ? Color.accentColor : inactiveColor)
            .frame(width: size?.width, height: size?.height, alignment: .center)
            .contentShape(Rectangle())
            .brightness(
                configuration.isPressed
                    ? colorScheme == .dark
                        ? 0.5
                        : isActive ? -0.25 : -0.75
                    : 0
            )
            #if os(macOS)
            .opacity(controlActiveState == .inactive ? 0.5 : 1)
            #endif
    }
}
