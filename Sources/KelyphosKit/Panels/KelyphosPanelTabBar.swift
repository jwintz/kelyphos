// KelyphosPanelTabBar.swift - Icon tab bar for panel switching with drag reorder

import SwiftUI

/// Position of the tab bar relative to panel content.
public enum KelyphosTabBarPosition: Sendable {
    case side
    case top
}

/// Icon tab bar for switching between panel tabs, with drag-to-reorder.
public struct KelyphosPanelTabBar<Tab: KelyphosPanel>: View {
    @Binding var items: [Tab]
    @Binding var selection: Tab?
    var position: KelyphosTabBarPosition

    @State private var draggingTab: Tab?
    @State private var tabOffsets: [Tab: CGFloat] = [:]
    @State private var draggingStartLocation: CGFloat?
    @State private var draggingLastLocation: CGFloat?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(items: Binding<[Tab]>, selection: Binding<Tab?>, position: KelyphosTabBarPosition = .top) {
        self._items = items
        self._selection = selection
        self.position = position
    }

    public var body: some View {
        if position == .top {
            topBody
        } else {
            sideBody
        }
    }

    private var topBody: some View {
        GeometryReader { proxy in
            iconsView(size: proxy.size)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(reduceMotion ? nil : .default, value: items)
        }
        .clipped()
        .frame(maxWidth: .infinity, idealHeight: KelyphosDesign.Height.tabBar)
        .fixedSize(horizontal: false, vertical: true)
        .glassEffect(.regular, in: .rect)
    }

    private var sideBody: some View {
        GeometryReader { proxy in
            iconsView(size: proxy.size)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.default, value: items)
        }
        .clipped()
        .frame(idealWidth: 40, maxHeight: .infinity)
        .fixedSize(horizontal: true, vertical: false)
    }

    @ViewBuilder
    private func iconsView(size: CGSize) -> some View {
        let layout = position == .top
            ? AnyLayout(HStackLayout(spacing: 0))
            : AnyLayout(VStackLayout(spacing: 0))
        layout {
            ForEach(items) { tab in
                makeIcon(tab: tab, size: size)
                    .offset(offsetFor(tab))
                    .simultaneousGesture(dragGesture(for: tab))
            }
            if position == .side {
                Spacer()
            }
        }
    }

    // MARK: - Icon Button

    private func makeIcon(tab: Tab, size: CGSize) -> some View {
        Button {
            selection = tab
        } label: {
            Image(systemName: tab.systemImage)
                .font(.system(size: 12.5))
                .symbolVariant(tab == selection ? .fill : .none)
                .frame(
                    width: position == .side ? 40 : 24,
                    height: position == .side ? 28 : size.height
                )
                .contentShape(Rectangle())
                .help(tab.title)
        }
        .buttonStyle(
            IconButtonStyle(
                isActive: tab == selection,
                size: CGSize(
                    width: position == .side ? 40 : 24,
                    height: position == .side ? 28 : size.height
                )
            )
        )
        .focusable(false)
        .accessibilityIdentifier("PanelTab-\(tab.title)")
        .accessibilityLabel(tab.title)
    }

    // MARK: - Offset

    private func offsetFor(_ tab: Tab) -> CGSize {
        let offset = tabOffsets[tab] ?? 0
        return position == .top
            ? CGSize(width: offset, height: 0)
            : CGSize(width: 0, height: offset)
    }

    // MARK: - Drag Gesture

    private func dragGesture(for tab: Tab) -> some Gesture {
        DragGesture(minimumDistance: 2, coordinateSpace: .global)
            .onChanged { value in
                if draggingTab != tab {
                    draggingTab = tab
                    draggingStartLocation = position == .top
                        ? value.startLocation.x
                        : value.startLocation.y
                    draggingLastLocation = draggingStartLocation
                }

                guard let start = draggingStartLocation,
                      let last = draggingLastLocation,
                      let currentIndex = items.firstIndex(of: tab)
                else { return }

                let currentLocation = position == .top
                    ? value.location.x
                    : value.location.y
                let dragDifference = currentLocation - last
                tabOffsets[tab] = currentLocation - start

                checkSwap(tab: tab, currentIndex: currentIndex, dragDifference: dragDifference)

                let locationOnAxis = position == .top
                    ? value.location.x
                    : value.location.y
                if abs(locationOnAxis - last) >= 10 {
                    draggingLastLocation = locationOnAxis
                }
            }
            .onEnded { _ in
                draggingTab = nil
                draggingStartLocation = nil
                draggingLastLocation = nil
                if reduceMotion {
                    tabOffsets = [:]
                } else {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        tabOffsets = [:]
                    }
                }
            }
    }

    // MARK: - Swap Logic

    private func checkSwap(tab: Tab, currentIndex: Int, dragDifference: CGFloat) {
        if currentIndex > 0 && dragDifference < 0 {
            let prevTab = items[currentIndex - 1]
            let prevWidth = estimatedTabWidth(for: prevTab)
            if abs(tabOffsets[tab] ?? 0) > prevWidth * 0.5 {
                swapTabs(at: currentIndex, with: currentIndex - 1)
            }
        }

        if currentIndex < items.count - 1 && dragDifference > 0 {
            let nextTab = items[currentIndex + 1]
            let nextWidth = estimatedTabWidth(for: nextTab)
            if (tabOffsets[tab] ?? 0) > nextWidth * 0.5 {
                swapTabs(at: currentIndex, with: currentIndex + 1)
            }
        }
    }

    private func swapTabs(at index1: Int, with index2: Int) {
        items.swapAt(index1, index2)

        let width1 = estimatedTabWidth(for: items[index2])
        let width2 = estimatedTabWidth(for: items[index1])
        let adjustment = (width1 - width2) * (index1 < index2 ? -1 : 1)

        if let currentOffset = tabOffsets[items[index2]] {
            tabOffsets[items[index2]] = currentOffset + adjustment
        }

        draggingStartLocation? += adjustment
    }

    private func estimatedTabWidth(for _: Tab) -> CGFloat {
        position == .top ? 40 : 28
    }
}
