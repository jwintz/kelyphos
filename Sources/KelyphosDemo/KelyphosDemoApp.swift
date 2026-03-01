// KelyphosDemoApp.swift - @main with WindowGroup + Settings + Welcome + About

import AppKit
import SwiftUI
import KelyphosKit
import WelcomeWindow
import AboutWindow

@main
struct KelyphosDemoApp: App {
    @State private var shellState = KelyphosShellState(persistencePrefix: "kelyphos.demo")

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
        }
        .commands {
            KelyphosCommands(state: shellState)
        }

        SwiftUI.Settings {
            KelyphosSettingsView(state: shellState)
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
                    Link("sindresorhus/Settings", destination: URL(string: "https://github.com/sindresorhus/Settings")!)
                    Link("CodeEditApp/WelcomeWindow", destination: URL(string: "https://github.com/CodeEditApp/WelcomeWindow")!)
                    Link("CodeEditApp/AboutWindow", destination: URL(string: "https://github.com/CodeEditApp/AboutWindow")!)
                }
                .padding()
            }
        }
    }
}
