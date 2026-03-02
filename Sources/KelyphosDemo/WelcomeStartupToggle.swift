// WelcomeStartupToggle.swift - "Show on startup" checkbox for WelcomeWindow (P23b)

import SwiftUI

/// Shown in the WelcomeWindow's subtitle slot — displays the version string
/// plus a "Show this window on startup" checkbox.
struct WelcomeStartupToggle: View {
    @AppStorage("kelyphos.demo.showWelcomeOnStartup") private var showOnStartup = true

    var body: some View {
        VStack(spacing: 6) {
            Toggle("Show this window on startup", isOn: $showOnStartup)
                #if os(macOS)
                .toggleStyle(.checkbox)
                #endif
                .font(.system(size: 12))
        }
    }
}
