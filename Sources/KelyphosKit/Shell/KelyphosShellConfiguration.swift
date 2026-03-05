// KelyphosShellConfiguration.swift - Generic config struct for panel types

import SwiftUI

/// Configuration for KelyphosShellView, specifying panel tabs, the detail view,
/// optional custom toolbar content, and scroll behaviour.
public struct KelyphosShellConfiguration<
    NavTab: KelyphosPanel,
    InspTab: KelyphosPanel,
    UtilTab: KelyphosPanel,
    Detail: View
> {
    public var navigatorTabs: [NavTab]
    public var inspectorTabs: [InspTab]
    public var utilityTabs: [UtilTab]

    // MARK: - Custom Toolbar

    /// Injected into `.navigation` placement (macOS) / `.topBarLeading` (iOS).
    /// Use for app-specific leading toolbar items such as a branch picker.
    public var leadingToolbar: (() -> AnyView)?

    /// Injected into `.principal` placement on both platforms.
    /// Use for a centered toolbar element such as an environment pill.
    public var principalToolbar: (() -> AnyView)?

    /// Injected trailing, before the panel-toggle buttons.
    /// Use for app-specific trailing items such as a keycast pill or package manager.
    public var trailingToolbarPrefix: (() -> AnyView)?

    // MARK: - Window Tab Actions (macOS)

    /// Called when the user triggers "Toggle Tab Bar" (Cmd+\).
    /// Defaults to `NSApp.keyWindow?.toggleTabBar(nil)` when nil.
    public var onToggleTabBar: (() -> Void)?

    // MARK: - Detail Scroll

    /// When `true` (default), the detail content is wrapped in a `ScrollView`.
    /// Set to `false` when the detail fills its own space (e.g. an editor view).
    public var scrollable: Bool

    // MARK: - Settings (iOS sheet)

    /// On iOS/iPadOS, a gear button is added to the toolbar that presents this
    /// view in a sheet. On macOS, settings use the native `Settings` scene.
    public var settingsView: (() -> AnyView)?

    // MARK: - Detail

    public var detail: () -> Detail

    public init(
        navigatorTabs: [NavTab],
        inspectorTabs: [InspTab],
        utilityTabs: [UtilTab] = [],
        scrollable: Bool = true,
        leadingToolbar: (() -> AnyView)? = nil,
        principalToolbar: (() -> AnyView)? = nil,
        trailingToolbarPrefix: (() -> AnyView)? = nil,
        onToggleTabBar: (() -> Void)? = nil,
        settingsView: (() -> AnyView)? = nil,
        @ViewBuilder detail: @escaping () -> Detail
    ) {
        self.navigatorTabs = navigatorTabs
        self.inspectorTabs = inspectorTabs
        self.utilityTabs = utilityTabs
        self.scrollable = scrollable
        self.leadingToolbar = leadingToolbar
        self.principalToolbar = principalToolbar
        self.trailingToolbarPrefix = trailingToolbarPrefix
        self.onToggleTabBar = onToggleTabBar
        self.settingsView = settingsView
        self.detail = detail
    }
}
