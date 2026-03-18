// KelyphosShellState.swift - Central observable state for the Kelyphos shell
// All UI components bind to this single source of truth.

import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension Notification.Name {
    /// Posted by `KelyphosShellState.saveAppearance()`. Object is the persistencePrefix string.
    static let kelyphosAppearanceDidChange = Notification.Name("me.jwintz.kelyphos.appearanceDidChange")
}

@MainActor
@Observable
public final class KelyphosShellState {

    // MARK: - Persistence Prefix

    /// Prefix for UserDefaults keys, preventing collisions between client apps.
    public let persistencePrefix: String

    /// Prefix used specifically for panel-visibility keys.
    /// Defaults to `persistencePrefix`; override to isolate per-window panel state
    /// while keeping appearance keys shared with the rest of the app.
    public let panelPersistencePrefix: String

    // MARK: - Title

    public var title: String = ""
    public var subtitle: String = ""

    // MARK: - Appearance

    #if os(macOS)
    public var backgroundColor: NSColor = .windowBackgroundColor
    #else
    public var backgroundColor: UIColor = .systemBackground
    #endif
    public var backgroundAlpha: CGFloat = 0.5
    public var windowAppearance: String = "auto"
    public var vibrancyMaterial: VibrancyMaterial = .ultraThin
    public var decorationsVisible: Bool = true

    // MARK: - Color Theme

    public var colorTheme: any KelyphosColorThemeProtocol = KelyphosColorTheme()

    // MARK: - Panel Enabled (dynamic deactivation — P14)

    /// When false, the navigator sidebar and its toolbar button are removed entirely.
    public var navigatorEnabled: Bool = true
    /// When false, the inspector panel and its toolbar button are removed entirely.
    public var inspectorEnabled: Bool = true
    /// When false, the utility area and its toolbar button are removed entirely.
    public var utilityEnabled: Bool = true

    // MARK: - Panel Visibility

    public var navigatorVisible: Bool = false
    public var inspectorVisible: Bool = false
    public var utilityAreaVisible: Bool = false

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

    // MARK: - Command Palette

    public var showCommandPalette: Bool = false

    // MARK: - Minibuffer Overlay (client-driven, e.g. Emacs minibuffer bridge)

    public var showMinibufferOverlay: Bool = false

    // MARK: - Persistence Keys

    private var kAlpha: String { "\(persistencePrefix).appearance.alpha" }
    private var kMaterial: String { "\(persistencePrefix).appearance.material" }
    private var kAppearance: String { "\(persistencePrefix).appearance.mode" }
    private var kNavigatorVisible: String { "\(panelPersistencePrefix).panel.navigatorVisible" }
    private var kInspectorVisible: String { "\(panelPersistencePrefix).panel.inspectorVisible" }
    private var kUtilityVisible: String { "\(panelPersistencePrefix).panel.utilityVisible" }

    @ObservationIgnored nonisolated(unsafe) private var appearanceObserver: NSObjectProtocol?

    // MARK: - Init

    public init(persistencePrefix: String = "kelyphos", panelPrefix: String? = nil) {
        self.persistencePrefix = persistencePrefix
        self.panelPersistencePrefix = panelPrefix ?? persistencePrefix
        self.windowAppearance = Self.systemAppearanceMode()
        self.reloadAppearance()
        self.reloadPanelState()

        appearanceObserver = NotificationCenter.default.addObserver(
            forName: .kelyphosAppearanceDidChange,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self,
                  let prefix = notification.object as? String,
                  prefix == self.persistencePrefix else { return }
            MainActor.assumeIsolated {
                self.reloadAppearance()
            }
        }
    }

    deinit {
        if let token = appearanceObserver {
            NotificationCenter.default.removeObserver(token)
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
        defaults.set(windowAppearance, forKey: kAppearance)
        NotificationCenter.default.post(name: .kelyphosAppearanceDidChange, object: persistencePrefix)
    }

    private func reloadAppearance() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: kAlpha) != nil {
            self.backgroundAlpha = defaults.double(forKey: kAlpha)
        }
        if let mat = defaults.string(forKey: kMaterial),
           let material = VibrancyMaterial(rawValue: mat) {
            self.vibrancyMaterial = material
        }
        if let mode = defaults.string(forKey: kAppearance) {
            self.windowAppearance = mode
        }
    }

    /// Save navigator/inspector/utility panel visibility to UserDefaults.
    public func savePanelState() {
        let defaults = UserDefaults.standard
        #if DEBUG
        print("[Kelyphos] savePanelState inspector=\(inspectorVisible) navigator=\(navigatorVisible) utility=\(utilityAreaVisible) prefix=\(panelPersistencePrefix)")
        #endif
        defaults.set(navigatorVisible, forKey: kNavigatorVisible)
        defaults.set(inspectorVisible, forKey: kInspectorVisible)
        defaults.set(utilityAreaVisible, forKey: kUtilityVisible)
    }

    private func reloadPanelState() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: kNavigatorVisible) != nil {
            self.navigatorVisible = defaults.bool(forKey: kNavigatorVisible)
        }
        if defaults.object(forKey: kInspectorVisible) != nil {
            self.inspectorVisible = defaults.bool(forKey: kInspectorVisible)
        }
        if defaults.object(forKey: kUtilityVisible) != nil {
            self.utilityAreaVisible = defaults.bool(forKey: kUtilityVisible)
        }
        #if DEBUG
        print("[Kelyphos] reloadPanelState inspector=\(inspectorVisible) navigator=\(navigatorVisible) utility=\(utilityAreaVisible) prefix=\(panelPersistencePrefix)")
        #endif
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
