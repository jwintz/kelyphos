// KelyphosPanelTabBar.swift - Liquid glass segmented tab bar for panel switching

import SwiftUI

/// Position of the tab bar relative to panel content.
public enum KelyphosTabBarPosition: Sendable {
    case side
    case top
}

/// Liquid glass tab bar for switching between panel tabs.
public struct KelyphosPanelTabBar<Tab: KelyphosPanel>: View {
    @Binding var items: [Tab]
    @Binding var selection: Tab?
    var position: KelyphosTabBarPosition

    @Namespace private var glassNamespace

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

    // MARK: - Top: Liquid Glass Segmented Control

    @ViewBuilder
    private var topBody: some View {
        if !items.isEmpty {
            let effective = selection ?? items.first!
            GlassEffectContainer {
                HStack(spacing: 2) {
                    ForEach(items) { tab in
                        Button {
                            withAnimation(.bouncy) {
                                selection = tab
                            }
                        } label: {
                            Text(tab.title)
                                .font(.system(size: KelyphosDesign.FontSize.body))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 5)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(tab == effective ? .primary : .secondary)
                        .background {
                            if tab == effective {
                                Capsule()
                                    .fill(.thinMaterial)
                            }
                        }
                        .glassEffectID("\(tab.title)", in: glassNamespace)
                        .focusable(false)
                        .accessibilityIdentifier("PanelTab-\(tab.title)")
                        .accessibilityLabel(tab.title)
                    }
                }
                .padding(3)
                .frame(maxWidth: .infinity)
                .glassEffect(in: .capsule)
            }
            .padding(.horizontal, KelyphosDesign.Padding.compact)
            .padding(.vertical, KelyphosDesign.Spacing.tight)
        }
    }

    // MARK: - Side: Icon Buttons

    private var sideBody: some View {
        VStack(spacing: 0) {
            ForEach(items) { tab in
                makeIcon(tab: tab)
            }
            Spacer()
        }
        .padding(.vertical, 5)
        .frame(idealWidth: 40, maxHeight: .infinity)
        .fixedSize(horizontal: true, vertical: false)
        .glassEffect(in: .capsule)
    }

    private func makeIcon(tab: Tab) -> some View {
        Button {
            selection = tab
        } label: {
            Image(systemName: tab.systemImage)
                .font(.system(size: 12.5))
                .symbolVariant(tab == selection ? .fill : .none)
                .frame(width: 40, height: 28)
                .contentShape(Rectangle())
                .help(tab.title)
        }
        .buttonStyle(
            IconButtonStyle(
                isActive: tab == selection,
                size: CGSize(width: 40, height: 28)
            )
        )
        .focusable(false)
        .accessibilityIdentifier("PanelTab-\(tab.title)")
        .accessibilityLabel(tab.title)
    }
}
