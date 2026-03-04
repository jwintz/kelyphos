// KelyphosDemoApp.swift - @main with WindowGroup + Settings + Welcome + About

import SwiftUI
import KelyphosKit

#if os(macOS)
import AppKit
import WelcomeWindow
import AboutWindow

/// Helper class that holds an observer token and can invalidate itself.
/// Used to intercept the main window during launch and auto-remove after first fire.
@MainActor
private final class LaunchSuppressor: @unchecked Sendable {
    private var observer: NSObjectProtocol?

    init() {
        observer = NotificationCenter.default.addObserver(
            forName: NSNotification.Name("NSWindowWillBecomeKeyNotification"),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let window = notification.object as? NSWindow else { return }
            Task { @MainActor [weak self] in
                guard let self = self,
                      window.title == "Kelyphos Demo" else { return }
                window.orderOut(nil)
                self.invalidate()
            }
        }
    }

    func invalidate() {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
            self.observer = nil
        }
    }
}
#endif

@main
struct KelyphosDemoApp: App {
    /// Dedicated shell state for the Settings panel (appearance prefs).
    /// Each scene owns its own shellState; this one is only used by KelyphosSettingsView.
    @State private var settingsShellState = KelyphosShellState(persistencePrefix: "kelyphos.demo")
    @Environment(\.openWindow) private var openWindow

    #if os(macOS)
    @AppStorage("kelyphos.demo.showWelcomeOnStartup") private var showWelcomeOnStartup = true
    private let launchSuppressor: LaunchSuppressor?

    init() {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
        let shouldShowWelcome = UserDefaults.standard.bool(forKey: "kelyphos.demo.showWelcomeOnStartup")
        launchSuppressor = shouldShowWelcome ? LaunchSuppressor() : nil
    }

    @MainActor
    private static func showMainWindow() {
        for window in NSApp.windows where window.title == "Kelyphos Demo" {
            window.makeKeyAndOrderFront(nil)
            return
        }
    }
    #endif

    var body: some Scene {
        mainWindowGroup

        #if os(macOS)
        settingsScene
        welcomeScene
        aboutScene
        #endif
    }

    private var mainWindowGroup: some Scene {
        WindowGroup("Kelyphos Demo") {
            DemoSceneView()
        }
        .commands {
            KelyphosCommands()
            #if os(macOS)
            CommandGroup(replacing: .appInfo) {
                Button("About Kelyphos") {
                    openWindow(id: "about")
                }
            }
            #endif
        }
    }

    #if os(macOS)
    private var settingsScene: some Scene {
        SwiftUI.Settings {
            TabView {
                GeneralSettingsTab()
                    .tabItem { Label("General", systemImage: "gearshape") }
                KelyphosSettingsView(state: settingsShellState)
                    .tabItem { Label("Appearance", systemImage: "paintbrush") }
            }
        }
    }

    private var welcomeScene: some Scene {
        WelcomeWindow(
            title: "Kelyphos",
            subtitleView: { WelcomeStartupToggle() }
        ) { dismiss in
            WelcomeButton(
                iconName: "play.circle",
                title: "Continue",
                action: {
                    Self.showMainWindow()
                    dismiss()
                }
            )
            WelcomeButton(
                iconName: "plus.square",
                title: "New Project",
                action: {
                    Self.showMainWindow()
                    dismiss()
                }
            )
            WelcomeButton(
                iconName: "folder",
                title: "Open Project",
                action: {
                    Self.showMainWindow()
                    dismiss()
                }
            )
        }
    }

    private var aboutScene: some Scene {
        AboutWindow(title: "Kelyphos") {
            AboutButton(title: "Acknowledgements") {
                VStack(alignment: .leading, spacing: 12) {
                    Link("CodeEditApp/WelcomeWindow", destination: URL(string: "https://github.com/CodeEditApp/WelcomeWindow")!)
                    Link("CodeEditApp/AboutWindow", destination: URL(string: "https://github.com/CodeEditApp/AboutWindow")!)
                }
                .padding()
            }
        }
    }
    #endif
}

// MARK: - Per-scene root view

/// Each window/tab gets its own instance of this view, owning independent
/// shell and showcase state so tabs can navigate independently.
private struct DemoSceneView: View {
    @State private var shellState = KelyphosShellState(persistencePrefix: "kelyphos.demo")
    @State private var showcaseState = ShowcaseState()
    @Environment(\.openWindow) private var openWindow
    #if os(macOS)
    @AppStorage("kelyphos.demo.showWelcomeOnStartup") private var showWelcomeOnStartup = true
    #endif

    var body: some View {
        KelyphosShellView(
            state: shellState,
            configuration: KelyphosShellConfiguration(
                navigatorTabs: DemoNavigatorTab.allCases.map { $0 },
                inspectorTabs: DemoInspectorTab.allCases.map { $0 },
                utilityTabs: DemoUtilityTab.allCases.map { $0 },
                detail: { DemoContentView() }
            )
        )
        .environment(\.showcaseState, showcaseState)
        .onAppear {
            shellState.title = "Kelyphos Demo"
            shellState.subtitle = "HIG Showcase"

            #if os(macOS)
            if showWelcomeOnStartup {
                for window in NSApp.windows where window.isVisible && window.title.isEmpty {
                    window.orderOut(nil)
                }
                openWindow(id: "welcome")
            }
            #endif
        }
        .onChange(of: showcaseState.selectedItem) { _, newItem in
            shellState.subtitle = newItem?.title ?? "HIG Showcase"
        }
    }
}
