// KelyphosColorTheme.swift - Observable color theme with light/dark variants

import AppKit
import SwiftUI

/// Observable color theme with light and dark variants.
/// The active variant is selected based on system appearance.
@MainActor
@Observable
public final class KelyphosColorTheme {

    // MARK: - Variants

    public var light: KelyphosColorVariant = .defaultLight
    public var dark: KelyphosColorVariant = .defaultDark

    // MARK: - Appearance Tracking

    /// Stored property so SwiftUI's @Observable graph registers a dependency.
    public var isDark: Bool = false

    public init() {
        self.isDark = KelyphosColorTheme.systemIsDarkMode()
    }

    /// Call this when the system appearance changes.
    public func refreshAppearance() {
        isDark = Self.systemIsDarkMode()
    }

    // MARK: - Active Variant

    public var active: KelyphosColorVariant {
        isDark ? dark : light
    }

    // MARK: - SwiftUI Color Accessors

    public var accent: Color { Color(hex: active.accent) ?? .accentColor }
    public var accentSecondary: Color { Color(hex: active.accentSecondary) ?? .secondary }
    public var background: Color { Color(hex: active.background) ?? Color(nsColor: .windowBackgroundColor) }
    public var backgroundDim: Color { Color(hex: active.backgroundDim) ?? Color(nsColor: .controlBackgroundColor) }
    public var foreground: Color { Color(hex: active.foreground) ?? .primary }
    public var foregroundDim: Color { Color(hex: active.foregroundDim) ?? .secondary }
    public var error: Color { Color(hex: active.error) ?? .red }
    public var warning: Color { Color(hex: active.warning) ?? .orange }
    public var success: Color { Color(hex: active.success) ?? .green }
    public var link: Color { Color(hex: active.link) ?? .blue }
    public var border: Color { Color(hex: active.border) ?? Color(nsColor: .separatorColor) }
    public var selection: Color { Color(hex: active.selection) ?? Color(nsColor: .selectedContentBackgroundColor) }

    // MARK: - Update from Dictionary

    public func update(variant: String, from dict: [String: String]) {
        let v = KelyphosColorVariant(
            background: dict["background"] ?? (variant == "dark" ? "#1e1e1e" : "#ffffff"),
            backgroundDim: dict["backgroundDim"] ?? (variant == "dark" ? "#27272a" : "#fafafa"),
            foreground: dict["foreground"] ?? (variant == "dark" ? "#f4f4f5" : "#18181b"),
            foregroundDim: dict["foregroundDim"] ?? (variant == "dark" ? "#71717a" : "#a1a1aa"),
            accent: dict["accent"] ?? "#A58AF9",
            accentSecondary: dict["accentSecondary"] ?? (variant == "dark" ? "#dcd3f8" : "#321685"),
            error: dict["error"] ?? (variant == "dark" ? "#f38ba8" : "#D32F2F"),
            warning: dict["warning"] ?? (variant == "dark" ? "#f9e2af" : "#F57F17"),
            success: dict["success"] ?? (variant == "dark" ? "#a6e3a1" : "#2E7D32"),
            link: dict["link"] ?? (variant == "dark" ? "#89b4fa" : "#7c3aed"),
            border: dict["border"] ?? (variant == "dark" ? "#3f3f46" : "#d4d4d8"),
            selection: dict["selection"] ?? (variant == "dark" ? "#655594" : "#c5beda")
        )
        if variant == "dark" {
            dark = v
        } else {
            light = v
        }
    }

    // MARK: - System Detection

    private static func systemIsDarkMode() -> Bool {
        guard let app = NSApp else { return false }
        let appearance = app.effectiveAppearance
        return appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }
}
