// ButtonsPage.swift - All button styles

import SwiftUI

struct ButtonsPage: View {
    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("buttons")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Standard Styles") {
                    HStack(spacing: 12) {
                        Button("Default") {}
                        Button("Bordered") {}
                            .buttonStyle(.bordered)
                        Button("Bordered Prominent") {}
                            .buttonStyle(.borderedProminent)
                        Button("Plain") {}
                            .buttonStyle(.plain)
                    }
                }

                GlassSection(title: "With Icons") {
                    HStack(spacing: 12) {
                        Button { } label: {
                            Label("Add", systemImage: "plus")
                        }
                        Button { } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        .buttonStyle(.bordered)
                        Button { } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                }

                GlassSection(title: "Control Sizes") {
                    HStack(spacing: 12) {
                        Button("Mini") {}
                            .controlSize(.mini)
                        Button("Small") {}
                            .controlSize(.small)
                        Button("Regular") {}
                            .controlSize(.regular)
                        Button("Large") {}
                            .controlSize(.large)
                        Button("Extra Large") {}
                            .controlSize(.extraLarge)
                    }
                    .buttonStyle(.bordered)
                }

                GlassSection(title: "Destructive & Disabled") {
                    HStack(spacing: 12) {
                        Button(role: .destructive) { } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Disabled") {}
                            .buttonStyle(.bordered)
                            .disabled(true)
                    }
                }
            }
        }
    }
}
