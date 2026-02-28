// KelyphosDemoApp.swift - @main with WindowGroup + Settings

import AppKit
import SwiftUI
import KelyphosKit

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
                    detail: { DemoContentView() },
                    statusBar: { DemoStatusBar(state: shellState) }
                )
            )
            .frame(minWidth: 800, minHeight: 500)
        }
        .commands {
            // P3: Proper keyboard shortcuts via menu commands
            KelyphosCommands(state: shellState)
        }

        Settings {
            KelyphosSettingsView(state: shellState)
        }
    }
}

// MARK: - Demo Status Bar (P7)

struct DemoStatusBar: View {
    @Bindable var state: KelyphosShellState

    var body: some View {
        HStack(spacing: KelyphosDesign.Spacing.standard) {
            Text("Ready")
                .font(.system(size: KelyphosDesign.FontSize.body))
                .foregroundStyle(.secondary)

            Spacer()

            Text("UTF-8")
                .font(.system(size: KelyphosDesign.FontSize.body))
                .foregroundStyle(.secondary)

            Divider().frame(maxHeight: 12)

            Text("LF")
                .font(.system(size: KelyphosDesign.FontSize.body))
                .foregroundStyle(.secondary)

            Divider().frame(maxHeight: 12)

            Button {
                withAnimation(.easeInOut(duration: 0.15)) {
                    state.utilityAreaVisible.toggle()
                }
            } label: {
                Image(systemName: "rectangle.bottomthird.inset.filled")
                    .font(.system(size: KelyphosDesign.FontSize.body))
                    .foregroundStyle(state.utilityAreaVisible ? .primary : .secondary)
            }
            .buttonStyle(.plain)
            .help(state.utilityAreaVisible ? "Hide Utility Area" : "Show Utility Area")
        }
        .padding(.horizontal, KelyphosDesign.Padding.horizontal)
    }
}
