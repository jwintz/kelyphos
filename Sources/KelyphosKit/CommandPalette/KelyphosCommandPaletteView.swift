// KelyphosCommandPaletteView.swift - Searchable command palette overlay

import SwiftUI

/// A searchable command palette overlay with fuzzy matching.
/// Follows the same pattern as `KelyphosKeybindingsOverlay`.
public struct KelyphosCommandPaletteView: View {
    @Binding var isPresented: Bool
    @State private var query = ""
    @State private var selectedIndex = 0
    @FocusState private var isSearchFocused: Bool
    @Environment(\.kelyphosCommandPaletteRegistry) private var registry

    public init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }

    private var results: [(command: KelyphosCommand, match: KelyphosFuzzyMatch)] {
        registry.search(query)
    }

    public var body: some View {
        ZStack {
            // Dimmed background — tapping dismisses
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            // Glass panel
            palettePanel
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .focusable()
        .onKeyPress(.escape) {
            dismiss()
            return .handled
        }
        .onKeyPress(.upArrow) {
            moveSelection(-1)
            return .handled
        }
        .onKeyPress(.downArrow) {
            moveSelection(1)
            return .handled
        }
        .onKeyPress(.return) {
            confirmSelection()
            return .handled
        }
    }

    // MARK: - Panel

    private var palettePanel: some View {
        VStack(spacing: 0) {
            searchField
            Divider()
            resultsList
        }
        .frame(width: 500, height: 400)
        .glassEffect(in: .rect(cornerRadius: KelyphosDesign.CornerRadius.glass))
        .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
    }

    // MARK: - Search Field

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.tertiary)
                .font(.system(size: KelyphosDesign.FontSize.large))

            TextField("Type a command…", text: $query)
                .textFieldStyle(.plain)
                .font(.system(size: KelyphosDesign.FontSize.large))
                .focused($isSearchFocused)
                .onAppear { isSearchFocused = true }
                .onChange(of: query) { _, _ in
                    selectedIndex = 0
                }

            if !query.isEmpty {
                Button {
                    query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.tertiary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    // MARK: - Results List

    private var resultsList: some View {
        let items = results
        return ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    if items.isEmpty && !query.isEmpty {
                        Text("No matching commands")
                            .font(.system(size: KelyphosDesign.FontSize.emphasized))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 40)
                    } else {
                        ForEach(Array(items.enumerated()), id: \.element.command.id) { index, result in
                            CommandRow(
                                command: result.command,
                                match: result.match,
                                isSelected: index == selectedIndex
                            )
                            .id(result.command.id)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedIndex = index
                                confirmSelection()
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .onChange(of: selectedIndex) { _, newIndex in
                let items = results
                if newIndex >= 0 && newIndex < items.count {
                    withAnimation(.easeOut(duration: 0.08)) {
                        proxy.scrollTo(items[newIndex].command.id, anchor: .center)
                    }
                }
            }
        }
    }

    // MARK: - Actions

    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.15)) {
            isPresented = false
        }
    }

    private func moveSelection(_ delta: Int) {
        let count = results.count
        guard count > 0 else { return }
        selectedIndex = max(0, min(count - 1, selectedIndex + delta))
    }

    private func confirmSelection() {
        let items = results
        guard selectedIndex >= 0 && selectedIndex < items.count else { return }
        let command = items[selectedIndex].command
        dismiss()
        command.action()
    }
}

// MARK: - Command Row

private struct CommandRow: View {
    let command: KelyphosCommand
    let match: KelyphosFuzzyMatch
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: command.systemImage)
                .font(.system(size: KelyphosDesign.FontSize.emphasized))
                .foregroundStyle(isSelected ? .primary : .secondary)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 1) {
                Text(highlightedTitle)
                    .font(.system(size: KelyphosDesign.FontSize.emphasized))

                if !command.subtitle.isEmpty {
                    Text(command.subtitle)
                        .font(.system(size: KelyphosDesign.FontSize.caption))
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: KelyphosDesign.CornerRadius.small)
                .fill(isSelected ? Color.accentColor.opacity(0.18) : Color.clear)
                .padding(.horizontal, 4)
        )
    }

    /// Build an AttributedString with matched characters highlighted.
    private var highlightedTitle: AttributedString {
        var str = AttributedString(command.title)
        let baseWeight: Font.Weight = isSelected ? .semibold : .regular
        str.font = .system(size: KelyphosDesign.FontSize.emphasized, weight: baseWeight)
        str.foregroundColor = .primary

        let text = command.title
        let matchSet = Set(match.matchedIndices)
        for idx in matchSet {
            if let attrRange = Range(idx..<text.index(after: idx), in: str) {
                str[attrRange].font = .system(size: KelyphosDesign.FontSize.emphasized, weight: .semibold)
                str[attrRange].foregroundColor = Color.accentColor
            }
        }
        return str
    }
}
