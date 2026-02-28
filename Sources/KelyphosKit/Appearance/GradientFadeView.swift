// GradientFadeView.swift - Edge gradient fader

import SwiftUI

/// A gradient overlay that fades content at an edge.
public struct GradientFadeView: View {
    public let edge: Edge
    public let length: CGFloat

    public init(edge: Edge = .bottom, length: CGFloat = 20) {
        self.edge = edge
        self.length = length
    }

    public var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [.clear, .black]),
            startPoint: startPoint,
            endPoint: endPoint
        )
        .frame(width: isHorizontal ? length : nil, height: isVertical ? length : nil)
        .allowsHitTesting(false)
    }

    private var isHorizontal: Bool { edge == .leading || edge == .trailing }
    private var isVertical: Bool { edge == .top || edge == .bottom }

    private var startPoint: UnitPoint {
        switch edge {
        case .top: .bottom
        case .bottom: .top
        case .leading: .trailing
        case .trailing: .leading
        }
    }

    private var endPoint: UnitPoint {
        switch edge {
        case .top: .top
        case .bottom: .bottom
        case .leading: .leading
        case .trailing: .trailing
        }
    }
}
