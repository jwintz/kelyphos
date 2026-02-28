// KelyphosKeybindingRegistry.swift - Registry for keybindings

import SwiftUI

/// A registry of keybindings, grouped by category.
/// Client apps register their keybindings at startup.
@MainActor
@Observable
public final class KelyphosKeybindingRegistry {
    public var bindings: [KelyphosKeybinding] = []

    public init() {
        // Register built-in shell keybindings
        register(category: "Shell", label: "Show Keybindings", shortcut: "⌘?")
        register(category: "Shell", label: "Toggle Navigator", shortcut: "⌘1")
        register(category: "Shell", label: "Toggle Inspector", shortcut: "⌘⌥0")
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
