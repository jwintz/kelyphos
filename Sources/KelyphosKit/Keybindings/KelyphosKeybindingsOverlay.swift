// KelyphosKeybindingsOverlay.swift - Searchable keybindings overlay

import SwiftUI

/// A searchable overlay showing all registered keybindings, grouped by category.
public struct KelyphosKeybindingsOverlay: View {
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @Environment(\.kelyphosKeybindingRegistry) private var registry

    public init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }

    public var body: some View {
        ZStack {
            // Dimmed background — tapping dismisses
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }

            // Glass panel
            overlayPanel
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .focusable()
        .onKeyPress(.escape) {
            isPresented = false
            return .handled
        }
    }

    private var overlayPanel: some View {
        VStack(spacing: 0) {
            overlayHeader
            overlaySearch
            Divider()
            overlayContent
        }
        .frame(width: 420, height: 480)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: KelyphosDesign.CornerRadius.glass))
        .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
    }

    private var overlayHeader: some View {
        HStack {
            Text("Keyboard Shortcuts")
                .font(.headline)
            Spacer()
            Button {
                isPresented = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding()
    }

    private var overlaySearch: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.tertiary)
            TextField("Search shortcuts…", text: $searchText)
                .textFieldStyle(.plain)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    private var overlayContent: some View {
        let filtered = registry.search(searchText)
        let grouped = groupByCategory(filtered)

        return ScrollView {
            LazyVStack(alignment: .leading, spacing: KelyphosDesign.Spacing.comfortable) {
                ForEach(grouped, id: \.0) { category, bindings in
                    VStack(alignment: .leading, spacing: KelyphosDesign.Spacing.compact) {
                        Text(category)
                            .font(.system(size: KelyphosDesign.FontSize.caption, weight: .semibold))
                            .foregroundStyle(.tertiary)
                            .textCase(.uppercase)
                            .padding(.horizontal)

                        ForEach(bindings) { binding in
                            HStack {
                                Text(binding.label)
                                    .font(.system(size: KelyphosDesign.FontSize.emphasized))
                                Spacer()
                                Text(binding.shortcut)
                                    .font(.system(size: KelyphosDesign.FontSize.body, design: .monospaced))
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(.quaternary, in: .capsule)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }

    private func groupByCategory(_ bindings: [KelyphosKeybinding]) -> [(String, [KelyphosKeybinding])] {
        var seen = Set<String>()
        var result: [(String, [KelyphosKeybinding])] = []
        for binding in bindings {
            if seen.insert(binding.category).inserted {
                let group = bindings.filter { $0.category == binding.category }
                result.append((binding.category, group))
            }
        }
        return result
    }
}
