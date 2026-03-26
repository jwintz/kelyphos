// KelyphosShellConfiguration.swift - Generic config struct for panel types

import SwiftUI

/// Configuration for KelyphosShellView, specifying panel tabs, the detail view,
/// optional content column (for 3-column layouts like Mail/Notes),
/// optional custom toolbar content, and scroll behaviour.
public struct KelyphosShellConfiguration<
    NavTab: KelyphosPanel,
    InspTab: KelyphosPanel,
    UtilTab: KelyphosPanel,
    Content: View,
    Detail: View
> {
    public var navigatorTabs: [NavTab]
    public var inspectorTabs: [InspTab]
    public var utilityTabs: [UtilTab]

    // MARK: - Content Column (3-column layout)

    /// When non-nil, enables a 3-column NavigationSplitView layout:
    /// Navigator (sidebar) | Content (list) | Detail.
    /// Use for Mail-like or Notes-like master-detail patterns.
    public var content: (() -> Content)?

    // MARK: - Custom Toolbar

    /// Injected into `.navigation` placement (macOS) / `.topBarLeading` (iOS).
    /// Use for app-specific leading toolbar items such as a branch picker.
    public var leadingToolbar: (() -> AnyView)?

    /// Injected into `.principal` placement on both platforms.
    /// Use for a centered toolbar element such as an environment pill.
    public var principalToolbar: (() -> AnyView)?

    /// Injected trailing, before the panel-toggle buttons.
    /// Each element gets its own `ToolbarItem` for independent spacing.
    /// Use for app-specific trailing items such as pills or status indicators.
    public var trailingToolbarItems: [() -> AnyView]

    /// Injected trailing as a single `ToolbarItemGroup`, sharing a glass pill.
    /// Items appear grouped with individual hover effects.
    /// Use for related controls such as playback buttons.
    public var trailingToolbarItemGroup: [() -> AnyView]

    // MARK: - Window Tab Actions (macOS)

    /// Called when the user triggers "Toggle Tab Bar" (Cmd+\).
    /// Defaults to `NSApp.keyWindow?.toggleTabBar(nil)` when nil.
    public var onToggleTabBar: (() -> Void)?

    // MARK: - Title Menu

    /// When non-nil, adds a menu to the toolbar title area (clicking the title/subtitle).
    /// Use for vault-switching, document context menus, etc.
    public var titleMenu: (() -> AnyView)?

    // MARK: - Detail Scroll

    /// When `true` (default), the detail content is wrapped in a `ScrollView`.
    /// Set to `false` when the detail fills its own space (e.g. an editor view).
    public var scrollable: Bool

    // MARK: - Settings (iOS sheet)

    /// On iOS/iPadOS, a gear button is added to the toolbar that presents this
    /// view in a sheet. On macOS, settings use the native `Settings` scene.
    public var settingsView: (() -> AnyView)?

    // MARK: - Client Overlays

    /// Client-injected overlay views rendered on top of the shell content.
    /// Each closure returns an `AnyView` that is conditionally shown.
    /// Use for app-specific overlays like a minibuffer bridge.
    public var overlays: [() -> AnyView]

    // MARK: - Detail

    public var detail: () -> Detail

    // MARK: - Initializers

    /// Three-column initializer: Navigator | Content | Detail.
    public init(
        navigatorTabs: [NavTab],
        inspectorTabs: [InspTab],
        utilityTabs: [UtilTab] = [],
        scrollable: Bool = true,
        leadingToolbar: (() -> AnyView)? = nil,
        principalToolbar: (() -> AnyView)? = nil,
        trailingToolbarItems: [() -> AnyView] = [],
        trailingToolbarItemGroup: [() -> AnyView] = [],
        overlays: [() -> AnyView] = [],
        onToggleTabBar: (() -> Void)? = nil,
        titleMenu: (() -> AnyView)? = nil,
        settingsView: (() -> AnyView)? = nil,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder detail: @escaping () -> Detail
    ) {
        self.navigatorTabs = navigatorTabs
        self.inspectorTabs = inspectorTabs
        self.utilityTabs = utilityTabs
        self.scrollable = scrollable
        self.leadingToolbar = leadingToolbar
        self.principalToolbar = principalToolbar
        self.trailingToolbarItems = trailingToolbarItems
        self.trailingToolbarItemGroup = trailingToolbarItemGroup
        self.overlays = overlays
        self.onToggleTabBar = onToggleTabBar
        self.titleMenu = titleMenu
        self.settingsView = settingsView
        self.content = content
        self.detail = detail
    }
}

// MARK: - Two-Column Initializer (backward compatible)

extension KelyphosShellConfiguration where Content == EmptyView {

    /// Two-column initializer: Navigator | Detail (existing behavior).
    public init(
        navigatorTabs: [NavTab],
        inspectorTabs: [InspTab],
        utilityTabs: [UtilTab] = [],
        scrollable: Bool = true,
        leadingToolbar: (() -> AnyView)? = nil,
        principalToolbar: (() -> AnyView)? = nil,
        trailingToolbarItems: [() -> AnyView] = [],
        trailingToolbarItemGroup: [() -> AnyView] = [],
        overlays: [() -> AnyView] = [],
        onToggleTabBar: (() -> Void)? = nil,
        titleMenu: (() -> AnyView)? = nil,
        settingsView: (() -> AnyView)? = nil,
        @ViewBuilder detail: @escaping () -> Detail
    ) {
        self.navigatorTabs = navigatorTabs
        self.inspectorTabs = inspectorTabs
        self.utilityTabs = utilityTabs
        self.scrollable = scrollable
        self.leadingToolbar = leadingToolbar
        self.principalToolbar = principalToolbar
        self.trailingToolbarItems = trailingToolbarItems
        self.trailingToolbarItemGroup = trailingToolbarItemGroup
        self.overlays = overlays
        self.onToggleTabBar = onToggleTabBar
        self.titleMenu = titleMenu
        self.settingsView = settingsView
        self.content = nil
        self.detail = detail
    }
}
