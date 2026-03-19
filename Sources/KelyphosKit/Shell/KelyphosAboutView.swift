// KelyphosAboutView.swift - Vibrancy-aware about view for Kelyphos apps

import SwiftUI
#if os(macOS)
import AppKit
#endif

/// A reusable about view showing app icon, name, version, and optional action buttons.
///
/// Mimics the standard macOS About window layout at 280pt wide.
/// Uses NSVisualEffectView for proper vibrancy behind the content.
public struct KelyphosAboutView<ButtonContent: View>: View {
    private let title: String
    private let icon: Image?
    private let buttons: () -> ButtonContent

    #if os(macOS)
    @Environment(\.colorScheme) private var colorScheme
    #endif

    public init(
        title: String,
        icon: Image? = nil,
        @ViewBuilder buttons: @escaping () -> ButtonContent = { EmptyView() }
    ) {
        self.title = title
        self.icon = icon
        self.buttons = buttons
    }

    public var body: some View {
        VStack(spacing: 0) {
            appIcon
                .padding(.top, 16)
                .padding(.bottom, 8)

            Text(title)
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)

            Text("Version \(Self.appVersion) (\(Self.buildNumber))")
                .font(.body)
                .foregroundStyle(.tertiary)
                .padding(.top, 4)

            if !Self.copyright.isEmpty {
                Text(Self.copyright)
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
            }

            let buttonContent = buttons()
            if !(buttonContent is EmptyView) {
                VStack(spacing: 14) {
                    buttonContent
                }
                .padding(.top, 12)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 24)
        .frame(width: 280)
        .ignoresSafeArea()
        .background { vibrancyBackground.ignoresSafeArea() }
    }

    @ViewBuilder
    private var vibrancyBackground: some View {
        #if os(macOS)
        VibrancyBackgroundView(
            material: colorScheme == .dark
                ? NSVisualEffectView.Material.hudWindow
                : NSVisualEffectView.Material.menu,
            blendingMode: .behindWindow,
            isActive: true
        )
        #else
        VibrancyBackgroundView(isActive: true)
        #endif
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

    private static var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }

    private static var buildNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }

    private static var copyright: String {
        Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String ?? ""
    }
}
