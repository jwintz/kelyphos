// KelyphosDemoApp.swift - @main with WindowGroup + Settings + Welcome + About

import SwiftUI
import KelyphosKit

#if os(macOS)
import AppKit

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
    @State private var welcomeShellState = KelyphosShellState(persistencePrefix: "kelyphos.demo")
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
            DemoSettingsWindowView(shellState: settingsShellState)
        }
    }

    private var welcomeScene: some Scene {
        Window("Welcome to Kelyphos", id: "welcome") {
            KelyphosWelcomeView(
                title: "Kelyphos",
                state: welcomeShellState,
                actions: [
                    KelyphosWelcomeAction(systemImage: "play.circle", title: "Continue") {
                        Self.showMainWindow()
                        Self.dismissWelcome()
                    },
                    KelyphosWelcomeAction(systemImage: "plus.square", title: "New Project") {
                        Self.showMainWindow()
                        Self.dismissWelcome()
                    },
                    KelyphosWelcomeAction(systemImage: "folder", title: "Open Project") {
                        Self.showMainWindow()
                        Self.dismissWelcome()
                    },
                ],
                footer: { WelcomeStartupToggle() }
            )
            .task {
                if let window = NSApp.windows.first(where: { $0.title == "Welcome to Kelyphos" }) {
                    window.standardWindowButton(.closeButton)?.isHidden = true
                    window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                    window.standardWindowButton(.zoomButton)?.isHidden = true
                    window.backgroundColor = .clear
                    window.isMovableByWindowBackground = true
                }
            }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }

    @MainActor
    private static func dismissWelcome() {
        for window in NSApp.windows where window.title == "Welcome to Kelyphos" {
            window.close()
            return
        }
    }

    private var aboutScene: some Scene {
        KelyphosAboutScene(title: "Kelyphos")
    }
    #endif
}

// MARK: - Per-scene root view

/// Each window/tab gets its own instance of this view, owning independent
/// shell and showcase state so tabs can navigate independently.
private struct DemoSceneView: View {
    @State private var shellState = KelyphosShellState(persistencePrefix: "kelyphos.demo")
    @State private var welcomeShellState = KelyphosShellState(persistencePrefix: "kelyphos.demo")
    @State private var showcaseState = ShowcaseState()
    @State private var commandPaletteRegistry = KelyphosCommandPaletteRegistry()
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
                settingsView: { [shellState] in
                    AnyView(
                        DemoSettingsWindowView(shellState: shellState)
                    )
                },
                welcomeView: { [shellState, welcomeShellState] in
                    AnyView(
                        KelyphosWelcomeView(
                            title: "Kelyphos",
                            state: welcomeShellState,
                            actions: [
                                KelyphosWelcomeAction(systemImage: "play.circle", title: "Continue") {
                                    shellState.showWelcome = false
                                },
                                KelyphosWelcomeAction(systemImage: "plus.square", title: "New Project") {
                                    shellState.showWelcome = false
                                },
                                KelyphosWelcomeAction(systemImage: "folder", title: "Open Project") {
                                    shellState.showWelcome = false
                                },
                            ]
                        )
                    )
                },
                content: { DemoContentColumnView() },
                detail: { DemoContentView() }
            ),
            commandPaletteRegistry: commandPaletteRegistry
        )
        .environment(\.showcaseState, showcaseState)
        .onAppear {
            shellState.title = "Kelyphos Demo"
            shellState.subtitle = "HIG Showcase"

            registerDemoCommands()

            #if os(macOS)
            if showWelcomeOnStartup {
                for window in NSApp.windows where window.isVisible && window.title.isEmpty {
                    window.orderOut(nil)
                }
                openWindow(id: "welcome")
            }
            #else
            shellState.showWelcome = true
            #endif
        }
        .onChange(of: showcaseState.selectedItem) { _, newItem in
            shellState.subtitle = newItem?.title ?? "HIG Showcase"
        }
    }

    private func registerDemoCommands() {
        // Shell commands
        commandPaletteRegistry.register([
            KelyphosCommand(id: "shell.toggle-navigator", title: "Toggle Navigator", systemImage: "sidebar.left") { [shellState] in
                withAnimation(.easeInOut(duration: 0.15)) {
                    shellState.navigatorVisible.toggle()
                }
            },
            KelyphosCommand(id: "shell.toggle-inspector", title: "Toggle Inspector", systemImage: "sidebar.right") { [shellState] in
                withAnimation(.easeInOut(duration: 0.15)) {
                    shellState.inspectorVisible.toggle()
                }
            },
            KelyphosCommand(id: "shell.toggle-utility", title: "Toggle Utility Area", systemImage: "rectangle.bottomthird.inset.filled") { [shellState] in
                withAnimation(.easeInOut(duration: 0.15)) {
                    shellState.utilityAreaVisible.toggle()
                }
            },
            KelyphosCommand(id: "shell.keyboard-shortcuts", title: "Keyboard Shortcuts", systemImage: "keyboard") { [shellState] in
                withAnimation(.easeInOut(duration: 0.15)) {
                    shellState.showKeybindingsOverlay = true
                }
            },
        ])

        commandPaletteRegistry.register(
            KelyphosCommand(id: "shell.toggle-content-column", title: "Toggle Content Column", systemImage: "rectangle.split.3x1") { [shellState] in
                withAnimation(.easeInOut(duration: 0.15)) {
                    shellState.contentColumnVisible.toggle()
                }
            }
        )

        // Navigation commands for each showcase page
        for item in ShowcaseCatalog.allItems {
            commandPaletteRegistry.register(
                KelyphosCommand(
                    id: "go.\(item.id)",
                    title: "Go to \(item.title)",
                    subtitle: item.section.title,
                    systemImage: item.systemImage
                ) { [showcaseState] in
                    showcaseState.selectedItem = item
                }
            )
        }
    }
}
