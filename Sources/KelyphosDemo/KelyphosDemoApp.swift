// KelyphosDemoApp.swift - @main with WindowGroup + Settings + Welcome + About

import AppKit
import SwiftUI
import KelyphosKit
import WelcomeWindow
import AboutWindow



/// Helper class that holds an observer token and can invalidate itself.
/// Used to intercept the main window during launch and auto-remove after first fire.
@MainActor
private final class LaunchSuppressor: @unchecked Sendable {
    private var observer: NSObjectProtocol?

    init() {
        // Observe willBecomeKey to hide the main window if it becomes key
        // (backup in case onAppear hide misses it)
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

@main
struct KelyphosDemoApp: App {
    @State private var shellState = KelyphosShellState(persistencePrefix: "kelyphos.demo")
    @AppStorage("kelyphos.demo.showWelcomeOnStartup") private var showWelcomeOnStartup = true
    @Environment(\.openWindow) private var openWindow

    /// Helper that intercepts the main window appearance during launch
    private let launchSuppressor: LaunchSuppressor?

    init() {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)

        // Read directly from UserDefaults since @AppStorage isn't available in init
        let shouldShowWelcome = UserDefaults.standard.bool(forKey: "kelyphos.demo.showWelcomeOnStartup")

        // Intercept the main window if it becomes key (backup mechanism)
        launchSuppressor = shouldShowWelcome ? LaunchSuppressor() : nil
    }

    /// Bring the main "Kelyphos Demo" window back after the welcome window is dismissed.
    @MainActor
    private static func showMainWindow() {
        for window in NSApp.windows where window.title == "Kelyphos Demo" {
            window.makeKeyAndOrderFront(nil)
            return
        }
    }

    var body: some Scene {
        WindowGroup("Kelyphos Demo") {
            KelyphosShellView(
                state: shellState,
                configuration: KelyphosShellConfiguration(
                    navigatorTabs: DemoNavigatorTab.allCases.map { $0 },
                    inspectorTabs: DemoInspectorTab.allCases.map { $0 },
                    utilityTabs: DemoUtilityTab.allCases.map { $0 },
                    detail: { DemoContentView() }
                )
            )
            .onAppear {
                shellState.title = "Kelyphos Demo"
                shellState.subtitle = "Untitled"

                if showWelcomeOnStartup {
                    // Hide the main window immediately - at this point it has empty title
                    // but is already visible, so we detect it by visibility + empty title
                    for window in NSApp.windows where window.isVisible && window.title.isEmpty {
                        window.orderOut(nil)
                    }
                    openWindow(id: "welcome")
                }
            }
        }
        .commands {
            KelyphosCommands(state: shellState)

            // P24: Override default About menu to open our AboutWindow
            CommandGroup(replacing: .appInfo) {
                Button("About Kelyphos") {
                    openWindow(id: "about")
                }
            }
        }

        // P22: Tabbed settings with General + Appearance panes
        SwiftUI.Settings {
            TabView {
                GeneralSettingsTab()
                    .tabItem { Label("General", systemImage: "gearshape") }
                KelyphosSettingsView(state: shellState)
                    .tabItem { Label("Appearance", systemImage: "paintbrush") }
            }
        }

        // P23b: "Show on startup" checkbox via subtitleView
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

        // About window
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
}
