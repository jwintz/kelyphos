// KelyphosKeybindingsOverlay.swift - CMD+? glass overlay

import SwiftUI

/// A searchable Liquid Glass overlay showing all registered keybindings.
public struct KelyphosKeybindingsOverlay: View {
    @Binding var isPresented: Bool
    @State private var searchText = ""

    private let registry = KelyphosKeybindingRegistry()

    public init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }

    private var filteredBindings: [KelyphosKeybinding] {
        registry.search(searchText)
    }

    private var groupedBindings: [(String, [KelyphosKeybinding])] {
        let filtered = filteredBindings
        var seen = Set<String>()
        var result: [(String, [KelyphosKeybinding])] = []
        for binding in filtered {
            if seen.insert(binding.category).inserted {
                let group = filtered.filter { $0.category == binding.category }
                result.append((binding.category, group))
            }
        }
        return result
    }

    public var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }

            // Glass panel
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Keyboard Shortcuts")
                        .font(.headline)
                    Spacer()
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                .padding()

                // Search
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search shortcuts…", text: $searchText)
                        .textFieldStyle(.plain)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)

                Divider()

                // Content
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: KelyphosDesign.Spacing.comfortable) {
                        ForEach(groupedBindings, id: \.0) { category, bindings in
                            Section {
                                ForEach(bindings) { binding in
                                    HStack {
                                        Text(binding.label)
                                            .font(.system(size: KelyphosDesign.FontSize.body))
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
                            } header: {
                                Text(category)
                                    .font(.system(size: KelyphosDesign.FontSize.caption, weight: .semibold))
                                    .foregroundStyle(.secondary)
                                    .textCase(.uppercase)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .frame(width: 400, height: 500)
            .glassEffect(.regular, in: .rect(cornerRadius: KelyphosDesign.CornerRadius.glass))
        }
        .transition(.opacity)
        .onKeyPress(.escape) {
            isPresented = false
            return .handled
        }
    }
}
