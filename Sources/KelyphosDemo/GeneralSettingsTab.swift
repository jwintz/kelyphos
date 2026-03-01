// GeneralSettingsTab.swift - General settings pane (P22/P23)

import SwiftUI

struct GeneralSettingsTab: View {
    @AppStorage("kelyphos.demo.showWelcomeOnStartup") private var showWelcomeOnStartup = true

    var body: some View {
        Form {
            Section("Startup") {
                Toggle("Show Welcome Window on startup", isOn: $showWelcomeOnStartup)
            }
        }
        .formStyle(.grouped)
        .frame(width: 450, height: 200)
    }
}
