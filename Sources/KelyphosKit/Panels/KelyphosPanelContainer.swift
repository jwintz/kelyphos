// KelyphosPanelContainer.swift - Tab-switching panel wrapper

import SwiftUI

/// A container that pairs a tab bar with the selected panel's content.
public struct KelyphosPanelContainer<Tab: KelyphosPanel>: View {
    @Binding var items: [Tab]
    @Binding var selection: Tab?
    var position: KelyphosTabBarPosition
    var selectionStyle: KelyphosTabBarSelectionStyle
    var showBorder: Bool
    var tabBarHorizontalPadding: CGFloat

    public init(
        items: Binding<[Tab]>,
        selection: Binding<Tab?>,
        position: KelyphosTabBarPosition = .top,
        selectionStyle: KelyphosTabBarSelectionStyle = .material,
        showBorder: Bool = false,
        tabBarHorizontalPadding: CGFloat = KelyphosDesign.Padding.compact
    ) {
        self._items = items
        self._selection = selection
        self.position = position
        self.selectionStyle = selectionStyle
        self.showBorder = showBorder
        self.tabBarHorizontalPadding = tabBarHorizontalPadding
    }

    public var body: some View {
        VStack(spacing: 0) {
            if position == .top {
                KelyphosPanelTabBar(items: $items, selection: $selection, position: .top, selectionStyle: selectionStyle, showBorder: showBorder, horizontalPadding: tabBarHorizontalPadding)
            }

            if let selected = selection {
                AnyView(selected)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            if position == .side {
                // Side tab bar is handled externally in an HStack
            }
        }
    }
}
