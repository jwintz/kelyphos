// KelyphosFontStack.swift - Font family definitions

import SwiftUI

/// A font family definition with display name, PostScript name, and available weights.
public struct KelyphosFontFamily: Identifiable, Hashable, Sendable {
    public let id: String
    public let displayName: String
    public let postScriptName: String
    public let category: KelyphosFontCategory
    public let availableWeights: [Font.Weight]

    public init(
        displayName: String,
        postScriptName: String,
        category: KelyphosFontCategory,
        availableWeights: [Font.Weight] = [.regular, .medium, .semibold, .bold]
    ) {
        self.id = postScriptName
        self.displayName = displayName
        self.postScriptName = postScriptName
        self.category = category
        self.availableWeights = availableWeights
    }

    /// Create a SwiftUI Font at the given size and weight.
    public func font(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        if postScriptName == "SF Pro" || postScriptName == "SF Mono" {
            return .system(size: size, weight: weight, design: postScriptName == "SF Mono" ? .monospaced : .default)
        }
        return .custom(postScriptName, size: size)
    }
}

/// Font category for grouping in the chooser.
public enum KelyphosFontCategory: String, CaseIterable, Sendable {
    case system = "System"
    case monospaced = "Monospaced"
    case proportional = "Proportional"
}

/// Built-in font stacks.
public enum KelyphosFontStack {
    public static let sfPro = KelyphosFontFamily(
        displayName: "SF Pro",
        postScriptName: "SF Pro",
        category: .system,
        availableWeights: [.ultraLight, .thin, .light, .regular, .medium, .semibold, .bold, .heavy, .black]
    )

    public static let sfMono = KelyphosFontFamily(
        displayName: "SF Mono",
        postScriptName: "SF Mono",
        category: .system,
        availableWeights: [.light, .regular, .medium, .semibold, .bold, .heavy]
    )

    public static let lilex = KelyphosFontFamily(
        displayName: "Lilex",
        postScriptName: "Lilex-Regular",
        category: .monospaced,
        availableWeights: [.thin, .light, .regular, .medium, .semibold, .bold]
    )

    public static let geistMono = KelyphosFontFamily(
        displayName: "Geist Mono",
        postScriptName: "GeistMono-Regular",
        category: .monospaced,
        availableWeights: [.thin, .light, .regular, .medium, .semibold, .bold, .heavy, .black]
    )

    public static let recursive = KelyphosFontFamily(
        displayName: "Recursive",
        postScriptName: "Recursive-Regular",
        category: .proportional,
        availableWeights: [.light, .regular, .medium, .semibold, .bold, .heavy, .black]
    )

    /// All built-in font families.
    public static let all: [KelyphosFontFamily] = [sfPro, sfMono, lilex, geistMono, recursive]
}
