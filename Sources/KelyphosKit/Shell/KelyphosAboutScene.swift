// KelyphosAboutScene.swift - Reusable about window scene for Kelyphos apps

import SwiftUI
#if os(macOS)
import AppKit
#endif

/// A reusable Scene that presents a `KelyphosAboutView` in a properly configured window.
///
/// Usage in your `App.body`:
/// ```swift
/// KelyphosAboutScene(title: "MyApp")
/// KelyphosAboutScene(title: "MyApp", icon: Image("AppIcon")) {
///     Link("Website", destination: URL(string: "https://example.com")!)
/// }
/// ```
public struct KelyphosAboutScene<ButtonContent: View>: Scene {
    private let title: String
    private let icon: Image?
    private let buttons: () -> ButtonContent

    public init(
        title: String,
        icon: Image? = nil,
        @ViewBuilder buttons: @escaping () -> ButtonContent = { EmptyView() }
    ) {
        self.title = title
        self.icon = icon
        self.buttons = buttons
    }

    public var body: some Scene {
        #if os(macOS)
        Window("About \(title)", id: "about") {
            KelyphosAboutView(title: title, icon: icon, buttons: buttons)
                .task { @MainActor in
                    if let window = NSApp.windows.first(where: { $0.title == "About \(title)" }) {
                        window.standardWindowButton(.zoomButton)?.isHidden = true
                        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                        window.backgroundColor = .clear
                        window.isMovableByWindowBackground = true
                    }
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        #else
        WindowGroup("About \(title)", id: "about") {
            KelyphosAboutView(title: title, icon: icon, buttons: buttons)
        }
        #endif
    }
}
