// KelyphosContentArea.swift - Center detail area with optional utility panel

import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// The detail content area: scrollable main view + optional utility panel at the bottom.
/// Lives inside the NavigationSplitView detail column.
public struct KelyphosContentArea<
    UtilTab: KelyphosPanel,
    Detail: View
>: View {
    @Bindable var state: KelyphosShellState
    var utilityTabs: [UtilTab]
    var scrollable: Bool
    var detail: () -> Detail

    @State private var utilityItems: [UtilTab] = []
    @State private var utilitySelection: UtilTab?

    public init(
        state: KelyphosShellState,
        utilityTabs: [UtilTab],
        scrollable: Bool = true,
        @ViewBuilder detail: @escaping () -> Detail
    ) {
        self.state = state
        self.utilityTabs = utilityTabs
        self.scrollable = scrollable
        self.detail = detail
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Main content — scrollable or fixed depending on configuration
            if scrollable {
                ScrollView {
                    detail()
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                detail()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            // Utility area (collapsible) — fixed height at the bottom
            // P21b: 8pt margins outside, no padding inside, rounded top corners
            if state.utilityAreaVisible && state.utilityEnabled && !utilityTabs.isEmpty {
                KelyphosPanelContainer(
                    items: $utilityItems,
                    selection: $utilitySelection,
                    position: .top,
                    selectionStyle: .opaque,
                    showBorder: true
                )
                .frame(height: state.utilityAreaHeight)
                #if !os(macOS)
                .dynamicTypeSize(.xSmall ... .medium)
                #endif
                .scrollContentBackground(.hidden)
                .glassEffect(in: UnevenRoundedRectangle(
                    topLeadingRadius: KelyphosDesign.CornerRadius.content,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: KelyphosDesign.CornerRadius.content
                ))
                .padding(.horizontal, KelyphosDesign.Padding.compact)
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

    @ViewBuilder
    private var backgroundView: some View {
        #if os(macOS)
        ZStack {
            VibrancyBackgroundView(
                material: .menu,
                blendingMode: .behindWindow,
                isActive: true
            )
            backgroundTint
                .opacity(Double(state.backgroundAlpha))
        }
        #else
        ZStack {
            Rectangle().fill(.ultraThinMaterial)
            backgroundTint
                .opacity(Double(state.backgroundAlpha))
        }
        #endif
    }

    private var backgroundTint: Color {
        #if os(macOS)
        Color(nsColor: state.backgroundColor)
        #else
        Color(uiColor: state.backgroundColor)
        #endif
    }
}
