// KelyphosShellState.swift - Central observable state for the Kelyphos shell
// All UI components bind to this single source of truth.

import AppKit
import SwiftUI

@MainActor
@Observable
public final class KelyphosShellState {

    // MARK: - Persistence Prefix

    /// Prefix for UserDefaults keys, preventing collisions between client apps.
    public let persistencePrefix: String

    // MARK: - Appearance

    public var backgroundColor: NSColor = .windowBackgroundColor
    public var backgroundAlpha: CGFloat = 0.5
    public var windowAppearance: String = "auto"
    public var vibrancyMaterial: VibrancyMaterial = .ultraThin
    public var decorationsVisible: Bool = true

    // MARK: - Color Theme

    public var colorTheme = KelyphosColorTheme()

    // MARK: - Panel Visibility

    public var navigatorVisible: Bool = false
    public var inspectorVisible: Bool = false
    public var utilityAreaVisible: Bool = false

    // MARK: - Panel Dimensions

    public var navigatorWidth: CGFloat = 280
    public var inspectorWidth: CGFloat = 300
    public var utilityAreaHeight: CGFloat = 260

    // MARK: - Keybindings Overlay

    public var showKeybindingsOverlay: Bool = false

    // MARK: - Persistence Keys

    private var kAlpha: String { "\(persistencePrefix).appearance.alpha" }
    private var kMaterial: String { "\(persistencePrefix).appearance.material" }
    private var kAppearance: String { "\(persistencePrefix).appearance.mode" }

    // MARK: - Init

    public init(persistencePrefix: String = "kelyphos") {
        self.persistencePrefix = persistencePrefix
        self.windowAppearance = Self.systemAppearanceMode()

        let defaults = UserDefaults.standard
        if defaults.object(forKey: kAlpha) != nil {
            self.backgroundAlpha = defaults.double(forKey: kAlpha)
        }
        if let mat = defaults.string(forKey: kMaterial),
           let material = VibrancyMaterial(rawValue: mat) {
            self.vibrancyMaterial = material
        }
    }

    // MARK: - Appearance Detection

    private static func systemAppearanceMode() -> String {
        let defaults = UserDefaults.standard
        let autoSwitches = defaults.bool(forKey: "AppleInterfaceStyleSwitchesAutomatically")
        if autoSwitches { return "auto" }
        let style = defaults.string(forKey: "AppleInterfaceStyle")
        if style?.caseInsensitiveCompare("dark") == .orderedSame { return "dark" }
        return "light"
    }

    // MARK: - Persistence

    public func saveAppearance() {
        let defaults = UserDefaults.standard
        defaults.set(backgroundAlpha, forKey: kAlpha)
        defaults.set(vibrancyMaterial.rawValue, forKey: kMaterial)
    }

    // MARK: - Computed

    public var isDarkMode: Bool {
        switch windowAppearance {
        case "dark": return true
        case "light": return false
        default: return colorTheme.isDark
        }
    }
}
