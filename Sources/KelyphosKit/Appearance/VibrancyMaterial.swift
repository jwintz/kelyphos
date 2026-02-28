// VibrancyMaterial.swift - Vibrancy material enum

import AppKit

/// Maps to NSVisualEffectView.Material levels.
public enum VibrancyMaterial: String, CaseIterable, Sendable {
    case none = "none"
    case ultraThick = "ultraThick"
    case thick = "thick"
    case regular = "regular"
    case thin = "thin"
    case ultraThin = "ultraThin"

    /// The corresponding NSVisualEffectView.Material value.
    public var nsMaterial: NSVisualEffectView.Material {
        switch self {
        case .none: .windowBackground
        case .ultraThick: .headerView
        case .thick: .titlebar
        case .regular: .menu
        case .thin: .popover
        case .ultraThin: .hudWindow
        }
    }
}
