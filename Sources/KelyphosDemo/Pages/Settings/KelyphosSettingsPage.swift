// KelyphosSettingsPage.swift - Inspector/utility toggles and shortcut hints

import SwiftUI
import KelyphosKit

struct KelyphosSettingsPage: View {
    @Environment(\.kelyphosShellState) private var shellState

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("kelyphos-settings")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Panel Visibility") {
                    if let state = shellState {
                        Form {
                            Toggle("Inspector", isOn: Binding(
                                get: { state.inspectorEnabled },
                                set: { state.inspectorEnabled = $0 }
                            ))
                            Toggle("Utility Area", isOn: Binding(
                                get: { state.utilityEnabled },
                                set: { state.utilityEnabled = $0 }
                            ))
                        }
                        .formStyle(.grouped)
                    }
                }

                GlassSection(title: "Keyboard Shortcuts") {
                    Grid(alignment: .leading, verticalSpacing: 6) {
                        shortcutRow("⌘⇧/", "Toggle Keyboard Shortcuts Panel")
                        shortcutRow("⌘0", "Toggle Navigator")
                        shortcutRow("⌘⌥0", "Toggle Inspector")
                        shortcutRow("⌘⌥⇧0", "Toggle Utility Area")
                    }
                    .font(.system(size: 12))
                }
            }
        }
    }

    private func shortcutRow(_ shortcut: String, _ label: String) -> some View {
        GridRow {
            Text(shortcut)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(.secondary)
                .gridColumnAlignment(.trailing)
            Text(label)
                .gridColumnAlignment(.leading)
        }
    }
}
