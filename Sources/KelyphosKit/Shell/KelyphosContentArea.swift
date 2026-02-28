// KelyphosContentArea.swift - Center area with optional utility panel

import SwiftUI

/// The center content area with optional collapsible utility panel at the bottom.
public struct KelyphosContentArea<
    UtilTab: KelyphosPanel,
    Detail: View,
    StatusBar: View
>: View {
    @Bindable var state: KelyphosShellState
    var utilityTabs: [UtilTab]
    var detail: () -> Detail
    var statusBar: (() -> StatusBar)?

    @State private var utilityItems: [UtilTab] = []
    @State private var utilitySelection: UtilTab?

    public init(
        state: KelyphosShellState,
        utilityTabs: [UtilTab],
        @ViewBuilder detail: @escaping () -> Detail,
        statusBar: (() -> StatusBar)? = nil
    ) {
        self.state = state
        self.utilityTabs = utilityTabs
        self.detail = detail
        self.statusBar = statusBar
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Main detail content
            detail()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Utility area (collapsible)
            if state.utilityAreaVisible && !utilityTabs.isEmpty {
                PanelDivider()

                KelyphosPanelContainer(
                    items: $utilityItems,
                    selection: $utilitySelection,
                    position: .top
                )
                .frame(height: state.utilityAreaHeight)
            }

            // Status bar
            if let statusBar {
                PanelDivider()
                statusBar()
                    .frame(height: KelyphosDesign.Height.statusBar)
            }
        }
        .onAppear {
            utilityItems = utilityTabs
            if utilitySelection == nil {
                utilitySelection = utilityTabs.first
            }
        }
    }
}
