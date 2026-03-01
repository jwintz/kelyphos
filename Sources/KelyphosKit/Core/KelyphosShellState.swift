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

    // MARK: - Panel Enabled (dynamic deactivation — P14)

    /// When false, the navigator sidebar and its toolbar button are removed entirely.
    public var navigatorEnabled: Bool = true
    /// When false, the inspector panel and its toolbar button are removed entirely.
    public var inspectorEnabled: Bool = true
    /// When false, the utility area and its toolbar button are removed entirely.
    public var utilityEnabled: Bool = true

    // MARK: - Panel Visibility

    public var navigatorVisible: Bool = true
    public var inspectorVisible: Bool = false
    public var utilityAreaVisible: Bool = true

    // MARK: - Panel Dimensions

    public var navigatorWidth: CGFloat = 280
    public var inspectorWidth: CGFloat = 300
    public var utilityAreaHeight: CGFloat = 260

    // MARK: - Tab Selection (by index, for keyboard shortcuts)

    /// Selected navigator tab index (0-based). Nil means no selection.
    public var selectedNavigatorIndex: Int? = 0
    /// Selected inspector tab index (0-based). Nil means no selection.
    public var selectedInspectorIndex: Int? = 0
    /// Selected utility tab index (0-based). Nil means no selection.
    public var selectedUtilityIndex: Int? = 0

    /// Number of tabs in each panel area (set by the shell view).
    public var navigatorTabCount: Int = 0
    public var inspectorTabCount: Int = 0
    public var utilityTabCount: Int = 0

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
