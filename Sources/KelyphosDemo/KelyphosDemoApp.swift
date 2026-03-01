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
                // P23: Show welcome window on startup if enabled
                if showWelcomeOnStartup {
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

        // Welcome window — title configures the display name
        WelcomeWindow(
            title: "Kelyphos"
        ) { dismiss in
            WelcomeButton(
                iconName: "plus.square",
                title: "New Project",
                action: { dismiss() }
            )
            WelcomeButton(
                iconName: "folder",
                title: "Open Project",
                action: { dismiss() }
            )
            WelcomeButton(
                iconName: "arrow.down.doc",
                title: "Clone Repository",
                action: { dismiss() }
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
