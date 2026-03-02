// SelectedItemDetailsView.swift - Shows selected item metadata and bookmark action

import SwiftUI

struct SelectedItemDetailsView: View {
    @Environment(\.showcaseState) private var showcaseState

    var body: some View {
        if let state = showcaseState, let item = state.selectedItem {
            Form {
                Section("Component") {
                    LabeledContent("Name", value: item.title)
                    LabeledContent("Section", value: item.section.title)
                    LabeledContent("ID", value: item.id)
                }

                Section("Platforms") {
                    PlatformCartridgeRow(supported: item.platforms)
                        .padding(.vertical, 4)
                }

                Section("Actions") {
                    Button {
                        state.toggleBookmark(item)
                    } label: {
                        Label(
                            state.isBookmarked(item) ? "Remove Bookmark" : "Add Bookmark",
                            systemImage: state.isBookmarked(item) ? "bookmark.slash" : "bookmark"
                        )
                    }
                }
            }
            .formStyle(.grouped)
        } else {
            VStack(spacing: 8) {
                Image(systemName: "info.circle")
                    .font(.system(size: 32))
                    .foregroundStyle(.quaternary)
                Text("No Selection")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
