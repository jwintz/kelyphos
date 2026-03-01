// KelyphosKeybindingRegistry.swift - Registry for keybindings

import SwiftUI

// MARK: - Environment Key

private struct KelyphosKeybindingRegistryKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue = KelyphosKeybindingRegistry()
}

extension EnvironmentValues {
    /// The shared keybinding registry, injected by KelyphosShellView.
    public var kelyphosKeybindingRegistry: KelyphosKeybindingRegistry {
        get { self[KelyphosKeybindingRegistryKey.self] }
        set { self[KelyphosKeybindingRegistryKey.self] = newValue }
    }
}

/// A registry of keybindings, grouped by category.
/// Client apps register their keybindings at startup.
@MainActor
@Observable
public final class KelyphosKeybindingRegistry {
    public var bindings: [KelyphosKeybinding] = []

    public init() {
        registerDefaults()
    }

    private func registerDefaults() {
        register(category: "Navigator", label: "Toggle Navigator", shortcut: "⌘0")
        register(category: "Navigator", label: "Navigator Tab 1", shortcut: "⌘1")
        register(category: "Navigator", label: "Navigator Tab 2", shortcut: "⌘2")
        register(category: "Navigator", label: "Navigator Tab 3", shortcut: "⌘3")
        register(category: "Navigator", label: "Navigator Tab 4", shortcut: "⌘4")
        register(category: "Navigator", label: "Navigator Tab 5", shortcut: "⌘5")
        register(category: "Navigator", label: "Navigator Tab 6", shortcut: "⌘6")
        register(category: "Navigator", label: "Navigator Tab 7", shortcut: "⌘7")
        register(category: "Navigator", label: "Navigator Tab 8", shortcut: "⌘8")
        register(category: "Navigator", label: "Navigator Tab 9", shortcut: "⌘9")
        register(category: "Inspector", label: "Toggle Inspector", shortcut: "⌘⌥0")
        register(category: "Inspector", label: "Inspector Tab 1", shortcut: "⌘⌥1")
        register(category: "Inspector", label: "Inspector Tab 2", shortcut: "⌘⌥2")
        register(category: "Inspector", label: "Inspector Tab 3", shortcut: "⌘⌥3")
        register(category: "Inspector", label: "Inspector Tab 4", shortcut: "⌘⌥4")
        register(category: "Inspector", label: "Inspector Tab 5", shortcut: "⌘⌥5")
        register(category: "Inspector", label: "Inspector Tab 6", shortcut: "⌘⌥6")
        register(category: "Inspector", label: "Inspector Tab 7", shortcut: "⌘⌥7")
        register(category: "Inspector", label: "Inspector Tab 8", shortcut: "⌘⌥8")
        register(category: "Inspector", label: "Inspector Tab 9", shortcut: "⌘⌥9")
        register(category: "Utility", label: "Toggle Utility Area", shortcut: "⌘⌥⇧0")
        register(category: "Utility", label: "Utility Tab 1", shortcut: "⌘⌥⇧1")
        register(category: "Utility", label: "Utility Tab 2", shortcut: "⌘⌥⇧2")
        register(category: "Utility", label: "Utility Tab 3", shortcut: "⌘⌥⇧3")
        register(category: "Utility", label: "Utility Tab 4", shortcut: "⌘⌥⇧4")
        register(category: "Utility", label: "Utility Tab 5", shortcut: "⌘⌥⇧5")
        register(category: "Utility", label: "Utility Tab 6", shortcut: "⌘⌥⇧6")
        register(category: "Utility", label: "Utility Tab 7", shortcut: "⌘⌥⇧7")
        register(category: "Utility", label: "Utility Tab 8", shortcut: "⌘⌥⇧8")
        register(category: "Utility", label: "Utility Tab 9", shortcut: "⌘⌥⇧9")
        register(category: "Shell", label: "Keyboard Shortcuts", shortcut: "⇧⌘/")
        register(category: "Shell", label: "Settings", shortcut: "⌘,")
    }

    /// Register a keybinding.
    public func register(category: String, label: String, shortcut: String) {
        let binding = KelyphosKeybinding(category: category, label: label, shortcut: shortcut)
        bindings.append(binding)
    }

    /// Register multiple keybindings at once.
    public func register(_ newBindings: [KelyphosKeybinding]) {
        bindings.append(contentsOf: newBindings)
    }

    /// All unique categories, in insertion order.
    public var categories: [String] {
        var seen = Set<String>()
        return bindings.compactMap { binding in
            if seen.insert(binding.category).inserted {
                return binding.category
            }
            return nil
        }
    }

    /// Bindings filtered by category.
    public func bindings(for category: String) -> [KelyphosKeybinding] {
        bindings.filter { $0.category == category }
    }

    /// Bindings matching a search query.
    public func search(_ query: String) -> [KelyphosKeybinding] {
        guard !query.isEmpty else { return bindings }
        let lower = query.lowercased()
        return bindings.filter {
            $0.label.lowercased().contains(lower) ||
            $0.category.lowercased().contains(lower) ||
            $0.shortcut.lowercased().contains(lower)
        }
    }
}
