// KelyphosWelcomeView.swift - Vibrancy-aware welcome view for Kelyphos apps

import SwiftUI
#if os(macOS)
import AppKit
#endif

/// A reusable welcome view with left panel (icon, title, actions) and right panel (recents list).
///
/// Background vibrancy is driven by a `KelyphosShellState`, so the welcome view
/// respects the user's configured material, background color, and alpha.
///
/// Layout: 740×460pt (432pt on macOS 26), split horizontally:
/// left panel 460pt (branding + actions), right panel 280pt (recents).
/// An optional footer spans the full width at the bottom.
public struct KelyphosWelcomeView<FooterContent: View, RecentsContent: View>: View {
    private let title: String
    private let subtitle: String?
    private let icon: Image?
    private let actions: [KelyphosWelcomeAction]
    private let footer: () -> FooterContent
    private let recents: () -> RecentsContent

    @Bindable private var state: KelyphosShellState
    @Environment(\.colorScheme) private var colorScheme

    public init(
        title: String,
        subtitle: String? = nil,
        icon: Image? = nil,
        state: KelyphosShellState,
        actions: [KelyphosWelcomeAction],
        @ViewBuilder footer: @escaping () -> FooterContent,
        @ViewBuilder recents: @escaping () -> RecentsContent
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.state = state
        self.actions = actions
        self.footer = footer
        self.recents = recents
    }

    private var windowHeight: CGFloat {
        if #available(macOS 26.0, *) { return 432 }
        return 460
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                leftPanel
                Divider()
                rightPanel
            }

            let footerContent = footer()
            if !(footerContent is EmptyView) {
                Divider()
                footerContent
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
            }
        }
        #if os(macOS)
        .frame(width: 740)
        #else
        .frame(maxWidth: .infinity)
        #endif
        .frame(minHeight: windowHeight)
        .ignoresSafeArea()
        .background { backgroundLayer.ignoresSafeArea() }
    }

    // MARK: - Background

    @ViewBuilder
    private var backgroundLayer: some View {
        #if os(macOS)
        if state.vibrancyMaterial != .none {
            ZStack {
                if colorScheme == .dark {
                    Color(nsColor: .black).opacity(0.275)
                } else {
                    Color(nsColor: .white)
                }
                VibrancyBackgroundView(
                    material: colorScheme == .dark
                        ? NSVisualEffectView.Material.headerView
                        : NSVisualEffectView.Material.menu,
                    blendingMode: .behindWindow,
                    isActive: true
                )
            }
        } else {
            Color(nsColor: state.backgroundColor)
                .opacity(state.backgroundAlpha)
        }
        #else
        VibrancyBackgroundView(isActive: true)
        #endif
    }

    // MARK: - Left Panel

    private var leftPanel: some View {
        leftContent
            #if os(macOS)
            .frame(width: 460)
            #else
            .frame(maxWidth: .infinity)
            #endif
    }

    private var leftContent: some View {
        VStack(spacing: 0) {
            Spacer()

            appIcon
                .padding(.bottom, 10)

            Text(title)
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)

            Text("Version \(Self.appVersion)")
                .font(.system(size: 13.5))
                .foregroundStyle(.secondary)
                .padding(.top, 2)

            if let subtitle {
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
                    .padding(.top, 2)
            }

            Spacer()
                .frame(height: 40)

            actionButtons

            Spacer()
        }
        .padding(.horizontal, 56)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private var appIcon: some View {
        if let icon {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 128)
        } else {
            #if os(macOS)
            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 128)
            #else
            Image(systemName: "app.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 128)
                .foregroundStyle(.secondary)
            #endif
        }
    }

    private var actionButtons: some View {
        VStack(spacing: actionSpacing) {
            ForEach(actions) { action in
                WelcomeActionButton(action: action)
            }
        }
    }

    private var actionSpacing: CGFloat {
        if #available(macOS 26.0, *) { return 6 }
        return 8
    }

    // MARK: - Right Panel

    private var rightPanel: some View {
        ZStack(alignment: .topLeading) {
            rightBackground
            recents()
                .padding(.vertical, 8)
                .padding(.horizontal, 6)
        }
        .frame(width: 280)
    }

    @ViewBuilder
    private var rightBackground: some View {
        #if os(macOS)
        if state.vibrancyMaterial != .none {
            ZStack {
                if colorScheme == .dark {
                    Color(nsColor: .black).opacity(0.075)
                    VibrancyBackgroundView(
                        material: NSVisualEffectView.Material.titlebar,
                        blendingMode: .behindWindow,
                        isActive: true
                    )
                } else {
                    Color(nsColor: .white).opacity(0.6)
                    VibrancyBackgroundView(
                        material: NSVisualEffectView.Material.menu,
                        blendingMode: .behindWindow,
                        isActive: true
                    )
                }
            }
        } else {
            Color(nsColor: state.backgroundColor)
                .opacity(state.backgroundAlpha * 0.5)
        }
        #else
        VibrancyBackgroundView(isActive: true)
        #endif
    }

    // MARK: - Helpers

    private static var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
}

// MARK: - Convenience inits

extension KelyphosWelcomeView where RecentsContent == EmptyView {
    public init(
        title: String,
        subtitle: String? = nil,
        icon: Image? = nil,
        state: KelyphosShellState,
        actions: [KelyphosWelcomeAction],
        @ViewBuilder footer: @escaping () -> FooterContent
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            icon: icon,
            state: state,
            actions: actions,
            footer: footer,
            recents: { EmptyView() }
        )
    }
}

extension KelyphosWelcomeView where FooterContent == EmptyView, RecentsContent == EmptyView {
    public init(
        title: String,
        subtitle: String? = nil,
        icon: Image? = nil,
        state: KelyphosShellState,
        actions: [KelyphosWelcomeAction]
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            icon: icon,
            state: state,
            actions: actions,
            footer: { EmptyView() },
            recents: { EmptyView() }
        )
    }
}

extension KelyphosWelcomeView where FooterContent == EmptyView {
    public init(
        title: String,
        subtitle: String? = nil,
        icon: Image? = nil,
        state: KelyphosShellState,
        actions: [KelyphosWelcomeAction],
        @ViewBuilder recents: @escaping () -> RecentsContent
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            icon: icon,
            state: state,
            actions: actions,
            footer: { EmptyView() },
            recents: recents
        )
    }
}

// MARK: - Action Button

private struct WelcomeActionButton: View {
    let action: KelyphosWelcomeAction

    var body: some View {
        Button {
            action.action()
        } label: {
            HStack(spacing: 7) {
                Image(systemName: action.systemImage)
                    .font(.system(size: 17, weight: .medium))
                    .frame(width: 24, alignment: .center)
                    .foregroundStyle(.secondary)
                Text(action.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.primary)
                Spacer()
            }
            .padding(7)
            .frame(height: 36)
            .contentShape(Rectangle())
        }
        .buttonStyle(WelcomeActionButtonStyle())
    }
}

private struct WelcomeActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                #if os(macOS)
                let bgOpacity: Double = configuration.isPressed ? 0.1 : 0.05
                Color(nsColor: .labelColor).opacity(bgOpacity)
                #else
                let bgOpacity: Double = configuration.isPressed ? 0.1 : 0.05
                Color.primary.opacity(bgOpacity)
                #endif
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
