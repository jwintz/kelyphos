// KelyphosPanelContainer.swift - Tab-switching panel wrapper

import SwiftUI

/// A container that pairs a tab bar with the selected panel's content.
public struct KelyphosPanelContainer<Tab: KelyphosPanel>: View {
    @Binding var items: [Tab]
    @Binding var selection: Tab?
    var position: KelyphosTabBarPosition

    public init(
        items: Binding<[Tab]>,
        selection: Binding<Tab?>,
        position: KelyphosTabBarPosition = .top
    ) {
        self._items = items
        self._selection = selection
        self.position = position
    }

    public var body: some View {
        VStack(spacing: 0) {
            if position == .top {
                KelyphosPanelTabBar(items: $items, selection: $selection, position: .top)
                PanelDivider()
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
