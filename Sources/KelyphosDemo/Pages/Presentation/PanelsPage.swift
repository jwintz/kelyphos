// PanelsPage.swift - NSPanel/floating window

import SwiftUI

struct PanelsPage: View {
    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("panels")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Panels") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Panels are secondary windows used for auxiliary controls. NSPanel is a subclass of NSWindow that provides floating behavior.")
                            .foregroundStyle(.secondary)

                        Divider()

                        Text("Common Panel Types:")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 4) {
                            Label("Inspector — Shows details about selected content", systemImage: "info.circle")
                            Label("Color Picker — NSColorPanel for color selection", systemImage: "paintpalette")
                            Label("Font Panel — NSFontPanel for font selection", systemImage: "textformat")
                            Label("Save/Open — NSSavePanel, NSOpenPanel for file I/O", systemImage: "folder")
                            Label("Utility — Floating tool palette", systemImage: "wrench.and.screwdriver")
                        }
                        .font(.system(size: 12))
                        .padding(.leading, 4)
                    }
                }

                GlassSection(title: "Kelyphos Panels") {
                    Text("The Kelyphos shell framework implements an inspector and utility panel system. Toggle them with ⌘⌥0 (Inspector) and ⌘⌥⇧0 (Utility Area).")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
