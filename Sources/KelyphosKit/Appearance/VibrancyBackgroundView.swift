// VibrancyBackgroundView.swift - NSVisualEffectView wrapper (macOS) / Material fallback (iOS)

import SwiftUI

#if os(macOS)
import AppKit

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
#else
/// iOS fallback: uses SwiftUI Material for a blur background.
public struct VibrancyBackgroundView: View {
    public var isActive: Bool

    public init(
        isActive: Bool = true
    ) {
        self.isActive = isActive
    }

    public var body: some View {
        if isActive {
            Rectangle().fill(.ultraThinMaterial)
        } else {
            Color.clear
        }
    }
}
#endif
