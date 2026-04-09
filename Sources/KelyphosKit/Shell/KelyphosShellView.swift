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

private struct PlatformInspectorPresentation: ViewModifier {
    func body(content: Content) -> some View {
        #if os(macOS)
        content
        #else
        content
            .dynamicTypeSize(.xSmall ... .medium)
            .presentationDetents([.medium, .large])
            .presentationBackgroundInteraction(.enabled)
        #endif
    }
}

// MARK: - Shell View

/// The main Kelyphos shell: NavigationSplitView with navigator sidebar,
/// detail area (with scrollable content + utility panel), and inspector.
public struct KelyphosShellView<
    NavTab: KelyphosPanel,
    InspTab: KelyphosPanel,
    UtilTab: KelyphosPanel,
    Content: View,
    Detail: View
>: View {
    @Bindable var state: KelyphosShellState
    let configuration: KelyphosShellConfiguration<NavTab, InspTab, UtilTab, Content, Detail>

    @State private var columnVisibility: NavigationSplitViewVisibility
    @State private var didAppear = false
    @State private var contentColumnWidth: CGFloat = 280
    @State private var showingSettings = false
    @State private var settingsDetent: PresentationDetent = .large

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var navigatorItems: [NavTab] = []
    @State private var navigatorSelection: NavTab?
    @State private var inspectorItems: [InspTab] = []
    @State private var inspectorSelection: InspTab?
    @State private var keybindingRegistry: KelyphosKeybindingRegistry
    @State private var commandPaletteRegistry: KelyphosCommandPaletteRegistry

    private let appearanceObserver = AppearanceObserver()

    private var inspectorVisibleBinding: Binding<Bool> {
        Binding(
            get: { state.inspectorVisible && state.inspectorEnabled },
            set: { newValue in
                if didAppear {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        state.inspectorVisible = newValue
                    }
                } else {
                    state.inspectorVisible = newValue
                }
            }
        )
    }

    public init(
        state: KelyphosShellState,
        configuration: KelyphosShellConfiguration<NavTab, InspTab, UtilTab, Content, Detail>,
        keybindingRegistry: KelyphosKeybindingRegistry? = nil,
        commandPaletteRegistry: KelyphosCommandPaletteRegistry? = nil
    ) {
        self.state = state
        self.configuration = configuration
        self._keybindingRegistry = State(initialValue: keybindingRegistry ?? KelyphosKeybindingRegistry())
        self._commandPaletteRegistry = State(initialValue: commandPaletteRegistry ?? KelyphosCommandPaletteRegistry())

        // Always 2-column NavigationSplitView: .all = sidebar+detail,
        // .detailOnly = detail only. Content column is inside the detail.
        let initialVisibility: NavigationSplitViewVisibility = state.navigatorVisible ? .all : .detailOnly
        self._columnVisibility = State(initialValue: initialVisibility)
    }

    public var body: some View {
        mainContent
            .navigationSplitViewStyle(.balanced)
            #if os(macOS)
            .navigationTitle(state.title)
            .navigationSubtitle(state.subtitle)
            .toolbarTitleDisplayMode(.inline)
            .toolbarTitleMenu {
                if let titleMenu = configuration.titleMenu {
                    titleMenu()
                }
            }
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
                appearanceObserver: appearanceObserver,
                horizontalSizeClass: horizontalSizeClass
            ))
            .overlay { keybindingsOverlay }
            .overlay { commandPaletteOverlay }
            .overlay { clientOverlays }
            .environment(\.kelyphosShellState, state)
            .environment(\.kelyphosKeybindingRegistry, keybindingRegistry)
            .environment(\.kelyphosCommandPaletteRegistry, commandPaletteRegistry)
            #if os(macOS)
            .focusedSceneValue(\.kelyphosShellState, state)
            #else
            .sheet(isPresented: $state.showWelcome) {
                if let welcomeBuilder = configuration.welcomeView {
                    welcomeBuilder()
                        .interactiveDismissDisabled()
                }
            }
            #endif
    }

    // MARK: - Main Content

    /// The content column (when provided and visible) is rendered inside the
    /// NavigationSplitView detail via an HStack. This keeps a single 2-column
    /// NavigationSplitView at all times, preserving toolbar geometry, inspector
    /// attachment, and column visibility state across toggles.
    @ViewBuilder
    private var mainContent: some View {
        if state.navigatorEnabled {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                sidebarContent
            } detail: {
                detailWithContentColumn
            }
        } else {
            detailWithContentColumn
        }
    }

    /// Wraps detailContentBase with an optional leading content column,
    /// then applies toolbar and inspector at the outermost level so they
    /// remain direct children of the NavigationSplitView detail slot.
    @ViewBuilder
    private var detailWithContentColumn: some View {
        Group {
            if configuration.content != nil {
                // Structural branch: always HStack when content closure is provided.
                // contentColumnVisible toggles children inside the HStack,
                // keeping the outer view identity stable for toolbar/inspector.
                HStack(spacing: 0) {
                    if state.contentColumnVisible {
                        configuration.content!()
                            .frame(width: contentColumnWidth)
                            .frame(maxHeight: .infinity)
                            .clipped()
                        KelyphosResizableDivider(width: $contentColumnWidth, minWidth: 200, maxWidth: 400)
                    }
                    detailContentBase
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                detailContentBase
            }
        }
        #if os(macOS)
        .toolbar { trailingToolbar }
        .inspector(isPresented: inspectorVisibleBinding) {
            inspectorContent
                .transaction { $0.animation = nil }
        }
        #else
        .navigationTitle(state.title)
        .toolbarTitleDisplayMode(.inline)
        .toolbar { iOSTrailingToolbar }
        .inspector(isPresented: inspectorVisibleBinding) {
            inspectorContent
                .transaction { $0.animation = nil }
        }
        .sheet(isPresented: $showingSettings) {
            if let settingsBuilder = configuration.settingsView {
                NavigationStack {
                    settingsBuilder()
                        .navigationTitle("Settings")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") { showingSettings = false }
                            }
                        }
                }
                .presentationDetents([.medium, .large], selection: $settingsDetent)
            }
        }
        #endif
    }

    private var sidebarContent: some View {
        KelyphosPanelContainer(
            items: $navigatorItems,
            selection: $navigatorSelection,
            position: .top
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #if !os(macOS)
        .dynamicTypeSize(.xSmall ... .medium)
        .toolbar {
            if configuration.settingsView != nil {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
        #endif
        .navigationSplitViewColumnWidth(ideal: KelyphosDesign.Width.sidebarIdeal)
        .background {
            GeometryReader { geo in
                Color.clear
                    .preference(key: NavigatorWidthKey.self, value: geo.size.width)
            }
        }
    }

    private var detailContentBase: some View {
        KelyphosContentArea(
            state: state,
            utilityTabs: configuration.utilityTabs,
            scrollable: configuration.scrollable,
            detail: configuration.detail
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var inspectorContent: some View {
        KelyphosPanelContainer(
            items: $inspectorItems,
            selection: $inspectorSelection,
            position: .top,
            selectionStyle: .opaque
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .modifier(PlatformInspectorPresentation())
        .inspectorColumnWidth(
            min: KelyphosDesign.Width.inspectorMin,
            ideal: KelyphosDesign.Width.inspectorIdeal,
            max: KelyphosDesign.Width.inspectorMax
        )
        .background {
            GeometryReader { geo in
                Color.clear
                    .preference(key: InspectorWidthKey.self, value: geo.size.width)
            }
        }
    }

    // MARK: - Toolbar (P14: conditional on enabled flags)

    #if os(macOS)
    @ToolbarContentBuilder
    private var trailingToolbar: some ToolbarContent {
        if let leading = configuration.leadingToolbar {
            ToolbarItem(placement: .navigation) { leading() }
        }
        if let principal = configuration.principalToolbar {
            ToolbarItem(placement: .principal) { principal() }
        }

        ToolbarSpacer(.flexible)

        // Emit each trailing toolbar item as its own ToolbarItem for independent spacing.
        // @ToolbarContentBuilder has a 10-item limit, so we split into two builder properties.
        trailingToolbarInjectedItems

        // Emit grouped trailing items inside a single ToolbarItemGroup (shared glass pill).
        trailingToolbarInjectedItemGroup

        if configuration.content != nil {
            ToolbarItem {
                contentColumnToggleButton
            }
        }

        if state.utilityEnabled && !configuration.utilityTabs.isEmpty {
            ToolbarItem {
                utilityToggleButton
            }
        }

        if state.inspectorEnabled && !configuration.inspectorTabs.isEmpty {
            ToolbarItem {
                inspectorToggleButton
            }
        }

        ToolbarSpacer(.fixed)
    }

    /// Separate builder property for injected trailing items to stay within the
    /// 10-expression limit of `@ToolbarContentBuilder`. Supports up to 6 items.
    @ToolbarContentBuilder
    private var trailingToolbarInjectedItems: some ToolbarContent {
        if configuration.trailingToolbarItems.count > 0 {
            ToolbarItem { configuration.trailingToolbarItems[0]() }
                .sharedBackgroundVisibility(.hidden)
        }
        if configuration.trailingToolbarItems.count > 1 {
            ToolbarItem { configuration.trailingToolbarItems[1]() }
                .sharedBackgroundVisibility(.hidden)
        }
        if configuration.trailingToolbarItems.count > 2 {
            ToolbarItem { configuration.trailingToolbarItems[2]() }
                .sharedBackgroundVisibility(.hidden)
        }
        if configuration.trailingToolbarItems.count > 3 {
            ToolbarItem { configuration.trailingToolbarItems[3]() }
                .sharedBackgroundVisibility(.hidden)
        }
        if configuration.trailingToolbarItems.count > 4 {
            ToolbarItem { configuration.trailingToolbarItems[4]() }
                .sharedBackgroundVisibility(.hidden)
        }
        if configuration.trailingToolbarItems.count > 5 {
            ToolbarItem { configuration.trailingToolbarItems[5]() }
                .sharedBackgroundVisibility(.hidden)
        }
    }

    /// Renders grouped trailing items inside a single `ToolbarItemGroup`.
    /// Items share a glass background pill with individual hover effects.
    @ToolbarContentBuilder
    private var trailingToolbarInjectedItemGroup: some ToolbarContent {
        if !configuration.trailingToolbarItemGroup.isEmpty {
            ToolbarItemGroup {
                ForEach(Array(configuration.trailingToolbarItemGroup.enumerated()), id: \.offset) { _, item in
                    item()
                }
            }
        }
    }
    #else
    @ToolbarContentBuilder
    private var iOSTrailingToolbar: some ToolbarContent {
        if let leading = configuration.leadingToolbar {
            ToolbarItemGroup(placement: .topBarLeading) { leading() }
        }
        ToolbarItemGroup(placement: .topBarTrailing) {
            ForEach(Array(configuration.trailingToolbarItems.enumerated()), id: \.offset) { _, item in
                item()
            }
            ForEach(Array(configuration.trailingToolbarItemGroup.enumerated()), id: \.offset) { _, item in
                item()
            }
            if configuration.content != nil {
                contentColumnToggleButton
            }
            if state.utilityEnabled && !configuration.utilityTabs.isEmpty {
                utilityToggleButton
            }
            if state.inspectorEnabled && !configuration.inspectorTabs.isEmpty {
                inspectorToggleButton
            }
        }
    }
    #endif

    private var contentColumnToggleButton: some View {
        Button {
            state.contentColumnVisible.toggle()
        } label: {
            Image(systemName: "rectangle.split.3x1")
        }
        .help(state.contentColumnVisible ? "Hide Content Column" : "Show Content Column")
        .accessibilityIdentifier("ContentColumnToolbarToggle")
        .accessibilityLabel("Toggle Content Column")
    }

    private var utilityToggleButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                state.utilityAreaVisible.toggle()
            }
        } label: {
            Image(systemName: "rectangle.bottomthird.inset.filled")
        }
        .help(state.utilityAreaVisible ? "Hide Utility Area" : "Show Utility Area")
        .accessibilityIdentifier("UtilityToolbarToggle")
        .accessibilityLabel("Toggle Utility Area")
    }

    private var inspectorToggleButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                state.inspectorVisible.toggle()
            }
        } label: {
            Image(systemName: "sidebar.right")
        }
        #if os(macOS)
        .buttonStyle(.bordered)
        .fixedSize()
        #endif
        .help(state.inspectorVisible ? "Hide Inspector" : "Show Inspector")
        .accessibilityIdentifier("InspectorToolbarToggle")
        .accessibilityLabel("Toggle Inspector")
    }

    // MARK: - Background

    // ZStack is required: VibrancyBackgroundView wraps a platform-native view
    // (NSVisualEffectView / UIVisualEffectView) via a representable, so the
    // tint color overlay must be a separate SwiftUI layer composited on top.
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

    // MARK: - Command Palette Overlay

    @ViewBuilder
    private var commandPaletteOverlay: some View {
        if state.showCommandPalette {
            KelyphosCommandPaletteView(isPresented: $state.showCommandPalette)
        }
    }

    // MARK: - Client Overlays

    @ViewBuilder
    private var clientOverlays: some View {
        ForEach(0..<configuration.overlays.count, id: \.self) { i in
            configuration.overlays[i]()
        }
    }
}

// MARK: - Lifecycle Modifier

private struct ShellLifecycleModifier<
    NavTab: KelyphosPanel,
    InspTab: KelyphosPanel,
    UtilTab: KelyphosPanel,
    ContentCol: View,
    Detail: View
>: ViewModifier {
    @Bindable var state: KelyphosShellState
    @Binding var columnVisibility: NavigationSplitViewVisibility
    @Binding var didAppear: Bool
    @Binding var navigatorItems: [NavTab]
    @Binding var navigatorSelection: NavTab?
    @Binding var inspectorItems: [InspTab]
    @Binding var inspectorSelection: InspTab?
    let configuration: KelyphosShellConfiguration<NavTab, InspTab, UtilTab, ContentCol, Detail>
    let appearanceObserver: AppearanceObserver
    var horizontalSizeClass: UserInterfaceSizeClass?

    @State private var columnVisibilityUpdateToken: Int = 0

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

                // On iPad with regular width, default to showing the sidebar
                #if !os(macOS)
                if horizontalSizeClass == .regular {
                    state.navigatorVisible = true
                }
                #endif

                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    columnVisibility = columnVisibilityTarget(navigatorVisible: state.navigatorVisible)
                    didAppear = true
                }
                appearanceObserver.start(updating: state.colorTheme)
                #if os(macOS)
                applyAppearance(state.windowAppearance)
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
                let target = columnVisibilityTarget(navigatorVisible: isVisible)
                guard columnVisibility != target else { return }
                columnVisibilityUpdateToken &+= 1
                let token = columnVisibilityUpdateToken
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
                DispatchQueue.main.async {
                    // Only clear if no newer update has started
                    if columnVisibilityUpdateToken == token {
                        columnVisibilityUpdateToken = 0
                    }
                }
            }
            .onChange(of: columnVisibility) { _, newValue in
                guard didAppear, columnVisibilityUpdateToken == 0 else { return }
                // Always 2-column: .all or .doubleColumn means navigator visible
                let isVisible = (newValue == .all || newValue == .doubleColumn)
                if state.navigatorVisible != isVisible {
                    state.navigatorVisible = isVisible
                }
            }
            .onChange(of: state.contentColumnVisible) { _, _ in
                // Reset column visibility to match the new layout mode
                let target = columnVisibilityTarget(navigatorVisible: state.navigatorVisible)
                columnVisibilityUpdateToken &+= 1
                let token = columnVisibilityUpdateToken
                if didAppear {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        columnVisibility = target
                    }
                }
                state.savePanelState()
                DispatchQueue.main.async {
                    if columnVisibilityUpdateToken == token {
                        columnVisibilityUpdateToken = 0
                    }
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

    /// Compute the correct NavigationSplitViewVisibility.
    /// Always 2-column: navigator visible → .all, hidden → .detailOnly.
    private func columnVisibilityTarget(navigatorVisible: Bool) -> NavigationSplitViewVisibility {
        navigatorVisible ? .all : .detailOnly
    }

    #if os(macOS)
    /// Install NSEvent local monitor to intercept shell-level key shortcuts.
    private func installKeyMonitor() {
        keyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [configuration] event in
            let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            let keyCode = event.keyCode

            if flags == .command {
                switch keyCode {
                case 42: // \ — Toggle Tab Bar
                    if let handler = configuration.onToggleTabBar {
                        handler()
                    } else {
                        NSApp.keyWindow?.toggleTabBar(nil)
                    }
                    return nil
                default:
                    break
                }
            }

            // keyCode 44 = "/" on US keyboard; CMD+SHIFT+/ → keybindings overlay
            // macOS reserves this for the Help menu — intercept before it gets there.
            let isSlashKey = keyCode == 44
            let isCmdShift = flags == [.command, .shift]
            if isSlashKey && isCmdShift {
                withAnimation(.easeInOut(duration: 0.15)) {
                    state.showKeybindingsOverlay.toggle()
                }
                return nil
            }

            // keyCode 35 = "P" on US keyboard; CMD+SHIFT+P → command palette
            if keyCode == 35 && isCmdShift {
                withAnimation(.easeInOut(duration: 0.15)) {
                    state.showCommandPalette.toggle()
                }
                return nil
            }

            return event
        }
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

// MARK: - Resizable Divider

/// A vertical divider that can be dragged to resize an adjacent column.
struct KelyphosResizableDivider: View {
    @Binding var width: CGFloat
    let minWidth: CGFloat
    let maxWidth: CGFloat

    @State private var isDragging = false

    var body: some View {
        Rectangle()
            .fill(Color(white: 0.5, opacity: 0.2))
            .frame(width: 1)
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle().inset(by: -3))
            #if os(macOS)
            .onHover { hovering in
                if hovering {
                    NSCursor.resizeLeftRight.push()
                } else {
                    NSCursor.pop()
                }
            }
            #endif
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        if !isDragging { isDragging = true }
                        let newWidth = width + value.translation.width
                        width = min(max(newWidth, minWidth), maxWidth)
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
    }
}
