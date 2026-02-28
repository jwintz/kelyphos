// KelyphosColorVariant.swift - A single color variant (light or dark)

import SwiftUI

/// A single-variant color set (either light or dark).
public struct KelyphosColorVariant: Equatable, Sendable {
    // Core surfaces
    public var background: String
    public var backgroundDim: String
    public var foreground: String
    public var foregroundDim: String

    // Accent
    public var accent: String
    public var accentSecondary: String

    // Semantic
    public var error: String
    public var warning: String
    public var success: String
    public var link: String

    // Chrome
    public var border: String
    public var selection: String

    public init(
        background: String,
        backgroundDim: String,
        foreground: String,
        foregroundDim: String,
        accent: String,
        accentSecondary: String,
        error: String,
        warning: String,
        success: String,
        link: String,
        border: String,
        selection: String
    ) {
        self.background = background
        self.backgroundDim = backgroundDim
        self.foreground = foreground
        self.foregroundDim = foregroundDim
        self.accent = accent
        self.accentSecondary = accentSecondary
        self.error = error
        self.warning = warning
        self.success = success
        self.link = link
        self.border = border
        self.selection = selection
    }
}

// MARK: - Defaults

extension KelyphosColorVariant {
    /// Default dark variant — Zinc + Violet dichromatic
    public static let defaultDark = KelyphosColorVariant(
        background: "#1e1e1e",
        backgroundDim: "#27272a",
        foreground: "#f4f4f5",
        foregroundDim: "#71717a",
        accent: "#A58AF9",
        accentSecondary: "#dcd3f8",
        error: "#f38ba8",
        warning: "#f9e2af",
        success: "#a6e3a1",
        link: "#89b4fa",
        border: "#3f3f46",
        selection: "#655594"
    )

    /// Default light variant — Zinc + Violet dichromatic
    public static let defaultLight = KelyphosColorVariant(
        background: "#ffffff",
        backgroundDim: "#fafafa",
        foreground: "#18181b",
        foregroundDim: "#a1a1aa",
        accent: "#A58AF9",
        accentSecondary: "#321685",
        error: "#D32F2F",
        warning: "#F57F17",
        success: "#2E7D32",
        link: "#7c3aed",
        border: "#d4d4d8",
        selection: "#c5beda"
    )
}
