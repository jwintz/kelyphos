// KelyphosKeybindingsOverlay.swift - Searchable keybindings overlay

import SwiftUI

/// A searchable overlay showing all registered keybindings, grouped by category.
/// Uses a multi-column layout for efficient scanning.
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
            Color.black.opacity(0.4)
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
        .frame(width: 640, height: 480)
        .glassEffect(in: .rect(cornerRadius: KelyphosDesign.CornerRadius.glass))
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
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .glassEffect(in: .capsule)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    private var overlayContent: some View {
        let filtered = registry.search(searchText)
        let grouped = groupByCategory(filtered)
        // Split categories into two columns
        let (left, right) = splitColumns(grouped)

        return ScrollView {
            HStack(alignment: .top, spacing: KelyphosDesign.Spacing.comfortable) {
                categoryColumn(left)
                categoryColumn(right)
            }
            .padding()
        }
    }

    private func categoryColumn(_ groups: [(String, [KelyphosKeybinding])]) -> some View {
        VStack(alignment: .leading, spacing: KelyphosDesign.Spacing.comfortable) {
            ForEach(groups, id: \.0) { category, bindings in
                VStack(alignment: .leading, spacing: KelyphosDesign.Spacing.compact) {
                    Text(category)
                        .font(.system(size: KelyphosDesign.FontSize.caption, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .textCase(.uppercase)

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
                                .glassEffect(in: .capsule)
                        }
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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

    /// Split categories into two balanced columns by item count.
    private func splitColumns(_ groups: [(String, [KelyphosKeybinding])]) -> (
        [(String, [KelyphosKeybinding])],
        [(String, [KelyphosKeybinding])]
    ) {
        let total = groups.reduce(0) { $0 + $1.1.count + 1 } // +1 for header
        var leftCount = 0
        var splitIndex = groups.count
        for (i, group) in groups.enumerated() {
            leftCount += group.1.count + 1
            if leftCount >= total / 2 {
                splitIndex = i + 1
                break
            }
        }
        let left = Array(groups.prefix(splitIndex))
        let right = Array(groups.suffix(from: splitIndex))
        return (left, right)
    }
}
