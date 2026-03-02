// VibrancyMaterial.swift - Vibrancy material enum

import SwiftUI
#if os(macOS)
import AppKit
#endif

/// Maps to NSVisualEffectView.Material levels on macOS, SwiftUI Material on iOS.
public enum VibrancyMaterial: String, CaseIterable, Sendable {
    case none = "none"
    case ultraThick = "ultraThick"
    case thick = "thick"
    case regular = "regular"
    case thin = "thin"
    case ultraThin = "ultraThin"

    #if os(macOS)
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
    #endif

    /// The corresponding SwiftUI Material value.
    public var swiftUIMaterial: Material {
        switch self {
        case .none: .regular
        case .ultraThick: .ultraThickMaterial
        case .thick: .thickMaterial
        case .regular: .regularMaterial
        case .thin: .thinMaterial
        case .ultraThin: .ultraThinMaterial
        }
    }
}
