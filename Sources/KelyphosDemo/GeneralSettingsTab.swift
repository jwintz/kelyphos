// GeneralSettingsTab.swift - General settings pane (P22/P23)

import SwiftUI
import KelyphosKit

struct GeneralSettingsTab: View {
    @AppStorage("kelyphos.demo.showWelcomeOnStartup") private var showWelcomeOnStartup = true

    var body: some View {
        Form {
            Section("Startup") {
                Toggle("Show Welcome Window on startup", isOn: $showWelcomeOnStartup)
            }
        }
        .formStyle(.grouped)
        #if os(macOS)
        .frame(width: 450, height: 200)
        #endif
    }
}

struct DemoSettingsWindowView: View {
    let shellState: KelyphosShellState

    var body: some View {
        TabView {
            GeneralSettingsTab()
                .tabItem { Label("General", systemImage: "gearshape") }
            KelyphosSettingsView(state: shellState)
                .tabItem { Label("Appearance", systemImage: "paintbrush") }
        }
        #if os(macOS)
        .frame(width: 450)
        #endif
    }
}
