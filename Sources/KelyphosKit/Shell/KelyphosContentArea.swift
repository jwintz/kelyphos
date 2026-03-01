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

    /// Utility area opacity boost over base (matching Hyalo's pattern)
    private static var utilityOpacityBoost: CGFloat { 0.15 }

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
                // P21: Hyalo-style denser tint — base alpha + 0.15 boost
                .background {
                    Color(nsColor: state.backgroundColor)
                        .opacity(min(1.0, Double(state.backgroundAlpha) + Self.utilityOpacityBoost))
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
