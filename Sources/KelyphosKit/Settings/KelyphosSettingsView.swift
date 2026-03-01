// KelyphosSettingsView.swift - Standard macOS settings form

import SwiftUI

/// A ready-to-use Settings view for the Kelyphos shell.
/// Use in your app's `Settings` scene:
///
///     Settings {
///         KelyphosSettingsView(state: shellState)
///     }
public struct KelyphosSettingsView: View {
    @Bindable var state: KelyphosShellState

    public init(state: KelyphosShellState) {
        self.state = state
    }

    public var body: some View {
        Form {
            AppearanceSettingsSection(state: state)
        }
        .formStyle(.grouped)
        .frame(width: 450)
    }
}
