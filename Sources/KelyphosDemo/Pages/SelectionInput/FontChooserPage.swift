// FontChooserPage.swift - Rich font chooser with in-picker preview

import SwiftUI
import AppKit
import KelyphosKit

struct FontChooserPage: View {
    @State private var selectedFamily: KelyphosFontFamily = KelyphosFontStack.sfPro
    @State private var fontSize: CGFloat = 13
    @State private var selectedSystemFont: String = "Helvetica Neue"
    @State private var previewText: String = "The quick brown fox jumps over the lazy dog. 0123456789"
    @State private var showSystemFonts = false

    private static let systemFontFamilies: [String] = {
        NSFontManager.shared.availableFontFamilies.sorted()
    }()

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("font-chooser")!) {
            VStack(alignment: .leading, spacing: 20) {
                // Kelyphos curated font chooser
                GlassSection(title: "Kelyphos Font Chooser") {
                    KelyphosFontChooser(selectedFamily: $selectedFamily, fontSize: $fontSize)
                }

                // System font picker with in-picker font preview
                GlassSection(title: "System Font Picker (with preview)") {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Font Family")
                                .frame(width: 100, alignment: .trailing)
                            SystemFontPicker(
                                selection: $selectedSystemFont,
                                families: Self.systemFontFamilies
                            )
                            .frame(maxWidth: 300)
                        }

                        HStack {
                            Text("Size")
                                .frame(width: 100, alignment: .trailing)
                            HStack(spacing: 4) {
                                Button { if fontSize > 8 { fontSize -= 1 } } label: {
                                    Image(systemName: "minus")
                                }
                                .buttonStyle(.bordered)

                                Text("\(Int(fontSize)) pt")
                                    .monospacedDigit()
                                    .frame(width: 50, alignment: .center)

                                Button { if fontSize < 72 { fontSize += 1 } } label: {
                                    Image(systemName: "plus")
                                }
                                .buttonStyle(.bordered)

                                Slider(value: $fontSize, in: 8...72, step: 1)
                                    .frame(maxWidth: 180)
                            }
                        }

                        Divider()

                        // Live preview
                        TextEditor(text: $previewText)
                            .font(.custom(selectedSystemFont, size: fontSize))
                            .frame(height: 100)
                            .scrollContentBackground(.hidden)
                            .background(.fill.tertiary, in: RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }
}

/// NSPopUpButton-based font picker where each font name is rendered in its own typeface.
private struct SystemFontPicker: NSViewRepresentable {
    @Binding var selection: String
    let families: [String]

    func makeNSView(context: Context) -> NSPopUpButton {
        let popup = NSPopUpButton(frame: .zero, pullsDown: false)
        popup.target = context.coordinator
        popup.action = #selector(Coordinator.selectionChanged(_:))

        // Build attributed menu items
        let menu = NSMenu()
        for family in families {
            let item = NSMenuItem(title: family, action: nil, keyEquivalent: "")
            if let font = NSFont(name: family, size: 13) {
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: NSColor.labelColor
                ]
                item.attributedTitle = NSAttributedString(string: family, attributes: attrs)
            }
            menu.addItem(item)
        }
        popup.menu = menu

        // Set initial selection
        if let idx = families.firstIndex(of: selection) {
            popup.selectItem(at: idx)
        }

        return popup
    }

    func updateNSView(_ nsView: NSPopUpButton, context: Context) {
        if let idx = families.firstIndex(of: selection) {
            nsView.selectItem(at: idx)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(selection: $selection, families: families)
    }

    final class Coordinator: NSObject {
        @Binding var selection: String
        let families: [String]

        init(selection: Binding<String>, families: [String]) {
            self._selection = selection
            self.families = families
        }

        @MainActor @objc func selectionChanged(_ sender: NSPopUpButton) {
            let idx = sender.indexOfSelectedItem
            if idx >= 0 && idx < families.count {
                selection = families[idx]
            }
        }
    }
}
