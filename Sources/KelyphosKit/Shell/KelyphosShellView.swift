// KelyphosShellView.swift - NavigationSplitView layout
// Main entry point for the Kelyphos shell chrome.

import SwiftUI
#if os(macOS)
import AppKit
#endif

// MARK: - Preference Keys

private struct NavigatorWidthKey: PreferenceKey {
    static let defaultValue: CGFloat = 280
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct InspectorWidthKey: PreferenceKey {
    static let defaultValue: CGFloat = 300
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Shell View

/// The main Kelyphos shell: NavigationSplitView with navigator sidebar,
/// detail area (with scrollable content + utility panel), and inspector.
public struct KelyphosShellView<
    NavTab: KelyphosPanel,
    InspTab: KelyphosPanel,
    UtilTab: KelyphosPanel,
    Detail: View
>: View {
    @Bindable var state: KelyphosShellState
    let configuration: KelyphosShellConfiguration<NavTab, InspTab, UtilTab, Detail>

    @State private var columnVisibility: NavigationSplitViewVisibility = .detailOnly
    @State private var didAppear = false

    @State private var navigatorItems: [NavTab] = []
    @State private var navigatorSelection: NavTab?
    @State private var inspectorItems: [InspTab] = []
    @State private var inspectorSelection: InspTab?

    private let appearanceObserver = AppearanceObserver()

    private var inspectorVisibleBinding: Binding<Bool> {
        Binding(
            get: { state.inspectorVisible && state.inspectorEnabled },
            set: { newValue in
                withAnimation(.easeInOut(duration: 0.15)) {
                    state.inspectorVisible = newValue
                }
            }
        )
    }

    public init(
        state: KelyphosShellState,
        configuration: KelyphosShellConfiguration<NavTab, InspTab, UtilTab, Detail>
    ) {
        self.state = state
        self.configuration = configuration
    }

    public var body: some View {
        mainContent
            #if os(macOS)
            .navigationSplitViewStyle(.balanced)
            #else
            .navigationSplitViewStyle(.automatic)
            #endif
            #if os(macOS)
            .navigationTitle(state.title)
            .navigationSubtitle(state.subtitle)
            .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
            .toolbarTitleDisplayMode(.inline)
            .toolbar { trailingToolbar }
            #endif
            .background { vibrancyBackground }
            .onPreferenceChange(NavigatorWidthKey.self) { state.navigatorWidth = $0 }
            .onPreferenceChange(InspectorWidthKey.self) { state.inspectorWidth = $0 }
            .modifier(ShellLifecycleModifier(
                state: state,
                columnVisibility: $columnVisibility,
                didAppear: $didAppear,
                navigatorItems: $navigatorItems,
                navigatorSelection: $navigatorSelection,
                inspectorItems: $inspectorItems,
                inspectorSelection: $inspectorSelection,
                configuration: configuration,
                appearanceObserver: appearanceObserver
            ))
            .overlay { keybindingsOverlay }
            .environment(\.kelyphosShellState, state)
            .environment(\.kelyphosKeybindingRegistry, KelyphosKeybindingRegistry())
    }

    // MARK: - Main Content

    private var mainContent: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebarContent
        } detail: {
            detailContent
        }
    }

    private var sidebarContent: some View {
        KelyphosPanelContainer(
            items: $navigatorItems,
            selection: $navigatorSelection,
            position: .top
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationSplitViewColumnWidth(ideal: KelyphosDesign.Width.sidebarIdeal)
        .background {
            GeometryReader { geo in
                Color.clear
                    .preference(key: NavigatorWidthKey.self, value: geo.size.width)
            }
        }
    }

    // Detail content: scrollable main view + utility panel, wrapped with inspector
    private var detailContent: some View {
        KelyphosContentArea(
            state: state,
            utilityTabs: configuration.utilityTabs,
            detail: configuration.detail
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #if !os(macOS)
        .navigationTitle(state.title)
        .toolbarTitleDisplayMode(.inline)
        .toolbar { trailingToolbar }
        #endif
        .inspector(isPresented: inspectorVisibleBinding) {
            inspectorContent
        }
    }

    private var inspectorContent: some View {
        KelyphosPanelContainer(
            items: $inspectorItems,
            selection: $inspectorSelection,
            position: .top,
            selectionStyle: .opaque
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .inspectorColumnWidth(ideal: KelyphosDesign.Width.inspectorIdeal)
        .background {
            GeometryReader { geo in
                Color.clear
                    .preference(key: InspectorWidthKey.self, value: geo.size.width)
            }
        }
    }

    // MARK: - Toolbar (P14: conditional on enabled flags)

    @ToolbarContentBuilder
    private var trailingToolbar: some ToolbarContent {
        ToolbarSpacer(.flexible)

        // Utility area toggle — only shown when utility is enabled
        if state.utilityEnabled && !configuration.utilityTabs.isEmpty {
            ToolbarItem {
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        state.utilityAreaVisible.toggle()
                    }
                } label: {
                    Image(systemName: "rectangle.bottomthird.inset.filled")
                }
                .help(state.utilityAreaVisible ? "Hide Utility Area" : "Show Utility Area")
            }
        }

        // Inspector toggle — only shown when inspector is enabled
        if state.inspectorEnabled && !configuration.inspectorTabs.isEmpty {
            ToolbarItem {
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        state.inspectorVisible.toggle()
                    }
                } label: {
                    Image(systemName: "sidebar.right")
                }
                .buttonStyle(.bordered)
                .fixedSize()
                .help(state.inspectorVisible ? "Hide Inspector" : "Show Inspector")
            }
        }

        ToolbarSpacer(.fixed)
    }

    // MARK: - Background

    private var vibrancyBackground: some View {
        ZStack {
            #if os(macOS)
            VibrancyBackgroundView(
                material: state.vibrancyMaterial.nsMaterial,
                blendingMode: .behindWindow,
                isActive: state.vibrancyMaterial != .none
            )
            Color(nsColor: state.backgroundColor)
                .opacity(Double(state.backgroundAlpha))
            #else
            VibrancyBackgroundView(
                isActive: state.vibrancyMaterial != .none
            )
            Color(uiColor: state.backgroundColor)
                .opacity(Double(state.backgroundAlpha))
            #endif
        }
        .ignoresSafeArea()
    }

    // MARK: - Keybindings Overlay

    @ViewBuilder
    private var keybindingsOverlay: some View {
        if state.showKeybindingsOverlay {
            KelyphosKeybindingsOverlay(isPresented: $state.showKeybindingsOverlay)
        }
    }
}

// MARK: - Lifecycle Modifier

private struct ShellLifecycleModifier<
    NavTab: KelyphosPanel,
    InspTab: KelyphosPanel,
    UtilTab: KelyphosPanel,
    Detail: View
>: ViewModifier {
    @Bindable var state: KelyphosShellState
    @Binding var columnVisibility: NavigationSplitViewVisibility
    @Binding var didAppear: Bool
    @Binding var navigatorItems: [NavTab]
    @Binding var navigatorSelection: NavTab?
    @Binding var inspectorItems: [InspTab]
    @Binding var inspectorSelection: InspTab?
    let configuration: KelyphosShellConfiguration<NavTab, InspTab, UtilTab, Detail>
    let appearanceObserver: AppearanceObserver

    #if os(macOS)
    /// NSEvent monitor for CMD+SHIFT+/ (keybindings overlay).
    /// macOS reserves this for the Help menu — we intercept it before the system.
    @State private var keyMonitor: Any?
    #endif

    func body(content: Content) -> some View {
        content
            .onAppear {
                navigatorItems = configuration.navigatorTabs
                inspectorItems = configuration.inspectorTabs
                if navigatorSelection == nil { navigatorSelection = navigatorItems.first }
                if inspectorSelection == nil { inspectorSelection = inspectorItems.first }

                state.navigatorTabCount = navigatorItems.count
                state.inspectorTabCount = inspectorItems.count
                state.utilityTabCount = configuration.utilityTabs.count

                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    columnVisibility = state.navigatorVisible ? .all : .detailOnly
                }
                DispatchQueue.main.async { didAppear = true }
                appearanceObserver.start(updating: state.colorTheme)
                #if os(macOS)
                installKeyMonitor()
                #endif
            }
            .onDisappear {
                #if os(macOS)
                if let monitor = keyMonitor {
                    NSEvent.removeMonitor(monitor)
                }
                #endif
            }
            // Sync index-based tab selection from keyboard shortcuts
            .onChange(of: state.selectedNavigatorIndex) { _, newIndex in
                guard let idx = newIndex, idx >= 0, idx < navigatorItems.count else { return }
                navigatorSelection = navigatorItems[idx]
            }
            .onChange(of: state.selectedInspectorIndex) { _, newIndex in
                guard let idx = newIndex, idx >= 0, idx < inspectorItems.count else { return }
                inspectorSelection = inspectorItems[idx]
            }
            // Sync selection back to state index (for toggle-if-current)
            .onChange(of: navigatorSelection) { _, newSel in
                if let sel = newSel, let idx = navigatorItems.firstIndex(of: sel) {
                    state.selectedNavigatorIndex = idx
                }
            }
            .onChange(of: inspectorSelection) { _, newSel in
                if let sel = newSel, let idx = inspectorItems.firstIndex(of: sel) {
                    state.selectedInspectorIndex = idx
                }
            }
            // P14: When a panel is disabled, force it closed
            .onChange(of: state.navigatorEnabled) { _, enabled in
                if !enabled { state.navigatorVisible = false }
            }
            .onChange(of: state.inspectorEnabled) { _, enabled in
                if !enabled { state.inspectorVisible = false }
            }
            .onChange(of: state.utilityEnabled) { _, enabled in
                if !enabled { state.utilityAreaVisible = false }
            }
            .onChange(of: state.navigatorVisible) { _, isVisible in
                let target: NavigationSplitViewVisibility = isVisible ? .all : .detailOnly
                guard columnVisibility != target else { return }
                if didAppear {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        columnVisibility = target
                    }
                } else {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        columnVisibility = target
                    }
                }
            }
            .onChange(of: columnVisibility) { _, newValue in
                guard didAppear else { return }
                let isVisible = (newValue == .all || newValue == .doubleColumn)
                if state.navigatorVisible != isVisible {
                    state.navigatorVisible = isVisible
                }
            }
            .onChange(of: state.windowAppearance) { _, newValue in
                applyAppearance(newValue)
            }
            .onChange(of: state.backgroundAlpha) { _, _ in
                state.saveAppearance()
            }
            .onChange(of: state.vibrancyMaterial) { _, _ in
                state.saveAppearance()
            }
    }

    #if os(macOS)
    /// Install NSEvent local monitor to intercept CMD+SHIFT+/ before macOS Help menu.
    private func installKeyMonitor() {
        print("[Kelyphos] Installing key monitor for CMD+SHIFT+/")
        keyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            let chars = event.charactersIgnoringModifiers ?? "<nil>"
            let keyCode = event.keyCode

            // Log all CMD+SHIFT combos for debugging
            if flags.contains(.command) && flags.contains(.shift) {
                print("[Kelyphos] CMD+SHIFT key event: chars='\(chars)' keyCode=\(keyCode) flags=\(flags.rawValue)")
            }

            // keyCode 44 = "/" on US keyboard (the physical key)
            // charactersIgnoringModifiers may report "?" when shift is held
            let isSlashKey = keyCode == 44
            let isCmdShift = flags == [.command, .shift]

            if isSlashKey && isCmdShift {
                print("[Kelyphos] CMD+SHIFT+/ intercepted — toggling keybindings overlay (current: \(state.showKeybindingsOverlay))")
                withAnimation(.easeInOut(duration: 0.15)) {
                    state.showKeybindingsOverlay.toggle()
                }
                return nil // consume the event
            }
            return event
        }
        print("[Kelyphos] Key monitor installed: \(keyMonitor != nil)")
    }
    #endif

    private func applyAppearance(_ mode: String) {
        #if os(macOS)
        let nsAppearance: NSAppearance?
        switch mode {
        case "light": nsAppearance = NSAppearance(named: .aqua)
        case "dark": nsAppearance = NSAppearance(named: .darkAqua)
        default: nsAppearance = nil
        }
        NSApp.appearance = nsAppearance
        #endif
        state.colorTheme.refreshAppearance()
        state.saveAppearance()
    }
}
