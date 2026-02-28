// KelyphosShellView.swift - NavigationSplitView layout
// Main entry point for the Kelyphos shell chrome.

import AppKit
import SwiftUI

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
/// detail area (with optional utility panel), and inspector.
public struct KelyphosShellView<
    NavTab: KelyphosPanel,
    InspTab: KelyphosPanel,
    UtilTab: KelyphosPanel,
    Detail: View,
    StatusBar: View
>: View {
    @Bindable var state: KelyphosShellState
    let configuration: KelyphosShellConfiguration<NavTab, InspTab, UtilTab, Detail, StatusBar>

    @State private var columnVisibility: NavigationSplitViewVisibility = .detailOnly
    @State private var didAppear = false

    @State private var navigatorItems: [NavTab] = []
    @State private var navigatorSelection: NavTab?
    @State private var inspectorItems: [InspTab] = []
    @State private var inspectorSelection: InspTab?

    private let appearanceObserver = AppearanceObserver()

    private var inspectorVisibleBinding: Binding<Bool> {
        Binding(
            get: { state.inspectorVisible },
            set: { newValue in
                withAnimation(.easeInOut(duration: 0.15)) {
                    state.inspectorVisible = newValue
                }
            }
        )
    }

    public init(
        state: KelyphosShellState,
        configuration: KelyphosShellConfiguration<NavTab, InspTab, UtilTab, Detail, StatusBar>
    ) {
        self.state = state
        self.configuration = configuration
    }

    public var body: some View {
        mainContent
            .navigationSplitViewStyle(.balanced)
            // P6: Always hide toolbar background — let vibrancy show through
            .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
            .toolbarTitleDisplayMode(.inline)
            // P2: No custom navigator toggle — NavigationSplitView provides its own
            .toolbar { trailingToolbar }
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
    }

    // MARK: - Main Content

    private var mainContent: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebarContent
        } detail: {
            detailContent
        }
    }

    // P1: sidebar content fills available height
    private var sidebarContent: some View {
        KelyphosPanelContainer(
            items: $navigatorItems,
            selection: $navigatorSelection,
            position: .top
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationSplitViewColumnWidth(
            min: KelyphosDesign.Width.sidebarMin,
            ideal: KelyphosDesign.Width.sidebarIdeal,
            max: KelyphosDesign.Width.sidebarMax
        )
        .background {
            GeometryReader { geo in
                Color.clear
                    .preference(key: NavigatorWidthKey.self, value: geo.size.width)
            }
        }
    }

    private var detailContent: some View {
        KelyphosContentArea(
            state: state,
            utilityTabs: configuration.utilityTabs,
            detail: configuration.detail,
            statusBar: configuration.statusBar
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .inspector(isPresented: inspectorVisibleBinding) {
            inspectorContent
        }
    }

    private var inspectorContent: some View {
        KelyphosPanelContainer(
            items: $inspectorItems,
            selection: $inspectorSelection,
            position: .top
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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

    // MARK: - Toolbar (trailing items only — P2: no navigator toggle)

    @ToolbarContentBuilder
    private var trailingToolbar: some ToolbarContent {
        ToolbarSpacer(.flexible)

        // Utility area toggle
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

        // Inspector toggle
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

        ToolbarSpacer(.fixed)
    }

    // MARK: - Background

    private var vibrancyBackground: some View {
        ZStack {
            VibrancyBackgroundView(
                material: state.vibrancyMaterial.nsMaterial,
                blendingMode: .behindWindow,
                isActive: state.vibrancyMaterial != .none
            )
            Color(nsColor: state.backgroundColor)
                .opacity(Double(state.backgroundAlpha))
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

/// Extracted lifecycle modifiers to reduce type-checker complexity.
private struct ShellLifecycleModifier<
    NavTab: KelyphosPanel,
    InspTab: KelyphosPanel,
    UtilTab: KelyphosPanel,
    Detail: View,
    StatusBar: View
>: ViewModifier {
    @Bindable var state: KelyphosShellState
    @Binding var columnVisibility: NavigationSplitViewVisibility
    @Binding var didAppear: Bool
    @Binding var navigatorItems: [NavTab]
    @Binding var navigatorSelection: NavTab?
    @Binding var inspectorItems: [InspTab]
    @Binding var inspectorSelection: InspTab?
    let configuration: KelyphosShellConfiguration<NavTab, InspTab, UtilTab, Detail, StatusBar>
    let appearanceObserver: AppearanceObserver

    func body(content: Content) -> some View {
        content
            .onAppear {
                navigatorItems = configuration.navigatorTabs
                inspectorItems = configuration.inspectorTabs
                if navigatorSelection == nil { navigatorSelection = navigatorItems.first }
                if inspectorSelection == nil { inspectorSelection = inspectorItems.first }

                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    columnVisibility = state.navigatorVisible ? .all : .detailOnly
                }
                DispatchQueue.main.async { didAppear = true }
                appearanceObserver.start(updating: state.colorTheme)
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
            // P5: Use NSApp.appearance for whole-app appearance change
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

    private func applyAppearance(_ mode: String) {
        let nsAppearance: NSAppearance?
        switch mode {
        case "light": nsAppearance = NSAppearance(named: .aqua)
        case "dark": nsAppearance = NSAppearance(named: .darkAqua)
        default: nsAppearance = nil
        }
        // P5: Set on NSApp, not mainWindow — works for swift run apps
        NSApp.appearance = nsAppearance
        state.colorTheme.refreshAppearance()
        state.saveAppearance()
    }
}
