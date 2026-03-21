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
    @State private var isDraggingResize = false

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

    private var utilityVisible: Bool {
        state.utilityAreaVisible && state.utilityEnabled && !utilityTabs.isEmpty
    }

    public var body: some View {
        GeometryReader { geometry in
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

                // Resize handle between detail and utility
                if utilityVisible {
                    resizeHandle(containerHeight: geometry.size.height)

                    KelyphosPanelContainer(
                        items: $utilityItems,
                        selection: $utilitySelection,
                        position: .top,
                        selectionStyle: .opaque,
                        showBorder: true,
                        tabBarHorizontalPadding: 4
                    )
                    .frame(height: state.utilityAreaHeight)
                    #if !os(macOS)
                    .dynamicTypeSize(.xSmall ... .medium)
                    #endif
                    .scrollContentBackground(.hidden)
                    #if os(macOS)
                    .clipShape(UnevenRoundedRectangle(
                        topLeadingRadius: KelyphosDesign.CornerRadius.glass,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: KelyphosDesign.CornerRadius.glass
                    ))
                    .glassEffect(in: UnevenRoundedRectangle(
                        topLeadingRadius: KelyphosDesign.CornerRadius.glass,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: KelyphosDesign.CornerRadius.glass
                    ))
                    #else
                    .clipShape(.rect(cornerRadius: KelyphosDesign.CornerRadius.glass))
                    .glassEffect(in: .rect(cornerRadius: KelyphosDesign.CornerRadius.glass))
                    #endif
                    .padding(.horizontal, KelyphosDesign.Padding.compact)
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

    // MARK: - Resize Handle

    private func resizeHandle(containerHeight: CGFloat) -> some View {
        let maxHeight = min(KelyphosDesign.Height.utilityAreaMax, containerHeight * 0.6)
        return Rectangle()
            .fill(Color.clear)
            .frame(height: KelyphosDesign.Height.resizeHandle)
            .contentShape(Rectangle())
            #if os(macOS)
            .onHover { hovering in
                if hovering {
                    NSCursor.resizeUpDown.push()
                } else {
                    NSCursor.pop()
                }
            }
            #endif
            .gesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { value in
                        isDraggingResize = true
                        let newHeight = state.utilityAreaHeight - value.translation.height
                        state.utilityAreaHeight = min(max(newHeight, KelyphosDesign.Height.utilityAreaMin), maxHeight)
                    }
                    .onEnded { _ in
                        isDraggingResize = false
                    }
            )
            .overlay {
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(.tertiary)
                    .frame(width: 36, height: 3)
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
