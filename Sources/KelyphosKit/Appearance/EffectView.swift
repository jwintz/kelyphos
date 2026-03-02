// EffectView.swift - Simple NSVisualEffectView wrapper (macOS) / Material fallback (iOS)

import SwiftUI

#if os(macOS)
import AppKit

/// Lightweight NSVisualEffectView wrapper for quick vibrancy backgrounds.
public struct EffectView: NSViewRepresentable {
    public let material: NSVisualEffectView.Material
    public let blendingMode: NSVisualEffectView.BlendingMode

    public init(
        _ material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode = .behindWindow
    ) {
        self.material = material
        self.blendingMode = blendingMode
    }

    public func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
#else
/// iOS fallback: a simple SwiftUI Material rectangle.
public struct EffectView: View {
    public init(
        _ material: Material = .ultraThinMaterial
    ) {
        self.material = material
    }

    private let material: Material

    public var body: some View {
        Rectangle().fill(material)
    }
}
#endif
