// VibrancyBackgroundView.swift - NSVisualEffectView wrapper for fine-grained blur

import AppKit
import SwiftUI

/// NSViewRepresentable wrapping NSVisualEffectView for precise vibrancy control.
public struct VibrancyBackgroundView: NSViewRepresentable {
    public var material: NSVisualEffectView.Material
    public var blendingMode: NSVisualEffectView.BlendingMode
    public var isActive: Bool

    public init(
        material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode = .behindWindow,
        isActive: Bool = true
    ) {
        self.material = material
        self.blendingMode = blendingMode
        self.isActive = isActive
    }

    public func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = isActive ? .active : .inactive
        view.isEmphasized = true
        view.wantsLayer = true
        return view
    }

    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
        nsView.state = isActive ? .active : .inactive
    }
}
