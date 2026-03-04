// KelyphosPanelTabBar.swift - Liquid glass segmented tab bar for panel switching

import SwiftUI

/// Position of the tab bar relative to panel content.
public enum KelyphosTabBarPosition: Sendable {
    case side
    case top
}

/// Selection indicator style for the tab bar.
public enum KelyphosTabBarSelectionStyle: Sendable {
    /// Frosted material — visible on vibrancy/material backgrounds (navigator, utility).
    case material
    /// Opaque fill — visible on solid/inspector backgrounds.
    case opaque
}

/// Liquid glass tab bar for switching between panel tabs.
public struct KelyphosPanelTabBar<Tab: KelyphosPanel>: View {
    @Binding var items: [Tab]
    @Binding var selection: Tab?
    var position: KelyphosTabBarPosition
    var selectionStyle: KelyphosTabBarSelectionStyle
    /// When true, draws a subtle stroke border around the tab bar capsule.
    /// Use when the parent panel has a glass background (glass-on-glass loses natural separation).
    var showBorder: Bool

    @Namespace private var glassNamespace

    public init(
        items: Binding<[Tab]>,
        selection: Binding<Tab?>,
        position: KelyphosTabBarPosition = .top,
        selectionStyle: KelyphosTabBarSelectionStyle = .material,
        showBorder: Bool = false
    ) {
        self._items = items
        self._selection = selection
        self.position = position
        self.selectionStyle = selectionStyle
        self.showBorder = showBorder
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
                                switch selectionStyle {
                                case .material:
                                    Capsule().fill(.regularMaterial)
                                case .opaque:
                                    Capsule().fill(.background)
                                        .shadow(color: .primary.opacity(0.15), radius: 1, y: 0.5)
                                }
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
                .overlay {
                    if showBorder {
                        Capsule().strokeBorder(.primary.opacity(0.12), lineWidth: 0.5)
                    }
                }
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
