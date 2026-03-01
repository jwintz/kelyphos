// KelyphosDemoApp.swift - @main with WindowGroup + Settings + Welcome + About

import AppKit
import SwiftUI
import KelyphosKit
import WelcomeWindow
import AboutWindow

@main
struct KelyphosDemoApp: App {
    @State private var shellState = KelyphosShellState(persistencePrefix: "kelyphos.demo")
    @AppStorage("kelyphos.demo.showWelcomeOnStartup") private var showWelcomeOnStartup = true
    @Environment(\.openWindow) private var openWindow

    init() {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
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
                if showWelcomeOnStartup {
                    // Hide main window immediately (no async) to prevent flash
                    for window in NSApp.windows where window.title == "Kelyphos Demo" {
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
