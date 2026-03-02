// ComboBoxesPage.swift - NSComboBox wrapper

import SwiftUI
import AppKit

struct ComboBoxesPage: View {
    @State private var selectedItem = "Swift"

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("combo-boxes")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Combo Box") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("A combo box combines a text field with a drop-down list, allowing both selection and free-text entry.")
                            .foregroundStyle(.secondary)

                        ComboBoxRepresentable(
                            items: ["Swift", "Objective-C", "C++", "Rust", "Python", "JavaScript"],
                            selection: $selectedItem
                        )
                        .frame(height: 24, alignment: .leading)
                        .frame(maxWidth: 200)

                        Text("Selected: \(selectedItem)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

private struct ComboBoxRepresentable: NSViewRepresentable {
    let items: [String]
    @Binding var selection: String

    func makeNSView(context: Context) -> NSComboBox {
        let comboBox = NSComboBox()
        comboBox.addItems(withObjectValues: items)
        comboBox.stringValue = selection
        comboBox.delegate = context.coordinator
        return comboBox
    }

    func updateNSView(_ nsView: NSComboBox, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(selection: $selection)
    }

    final class Coordinator: NSObject, NSComboBoxDelegate {
        @Binding var selection: String

        init(selection: Binding<String>) {
            self._selection = selection
        }

        func comboBoxSelectionDidChange(_ notification: Notification) {
            if let comboBox = notification.object as? NSComboBox {
                selection = comboBox.stringValue
            }
        }

        func controlTextDidEndEditing(_ obj: Notification) {
            if let comboBox = obj.object as? NSComboBox {
                selection = comboBox.stringValue
            }
        }
    }
}
