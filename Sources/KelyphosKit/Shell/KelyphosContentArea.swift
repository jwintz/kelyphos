// KelyphosContentArea.swift - Center detail area with optional utility panel

import AppKit
import SwiftUI

/// The detail content area: scrollable main view + optional utility panel at the bottom.
/// Lives inside the NavigationSplitView detail column.
public struct KelyphosContentArea<
    UtilTab: KelyphosPanel,
    Detail: View
>: View {
    @Bindable var state: KelyphosShellState
    var utilityTabs: [UtilTab]
    var detail: () -> Detail

    @State private var utilityItems: [UtilTab] = []
    @State private var utilitySelection: UtilTab?

    /// Thin tint opacity layered on top of withinWindow vibrancy
    private static var utilityTintOpacity: CGFloat { 0.08 }

    public init(
        state: KelyphosShellState,
        utilityTabs: [UtilTab],
        @ViewBuilder detail: @escaping () -> Detail
    ) {
        self.state = state
        self.utilityTabs = utilityTabs
        self.detail = detail
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Scrollable main content — avoids imposing size constraints
            ScrollView {
                detail()
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Utility area (collapsible) — fixed height at the bottom
            if state.utilityAreaVisible && state.utilityEnabled && !utilityTabs.isEmpty {
                PanelDivider()

                KelyphosPanelContainer(
                    items: $utilityItems,
                    selection: $utilitySelection,
                    position: .top
                )
                .frame(height: state.utilityAreaHeight)
                // P21b: withinWindow vibrancy matching the shell + thin tint for differentiation
                .background {
                    ZStack {
                        VibrancyBackgroundView(
                            material: state.vibrancyMaterial.nsMaterial,
                            blendingMode: .withinWindow,
                            isActive: state.vibrancyMaterial != .none
                        )
                        Color(nsColor: state.backgroundColor)
                            .opacity(Self.utilityTintOpacity)
                    }
                }
            }
        }
        .onAppear {
            utilityItems = utilityTabs
            if utilitySelection == nil {
                utilitySelection = utilityTabs.first
            }
        }
        .onChange(of: state.selectedUtilityIndex) { _, newIndex in
            guard let idx = newIndex, idx >= 0, idx < utilityItems.count else { return }
            utilitySelection = utilityItems[idx]
        }
    }
}
