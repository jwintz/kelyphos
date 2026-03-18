// KelyphosCommandPaletteRegistry.swift - Environment-injected command registry

import SwiftUI

// MARK: - Environment Key

private struct KelyphosCommandPaletteRegistryKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue = KelyphosCommandPaletteRegistry()
}

extension EnvironmentValues {
    /// The shared command palette registry, injected by KelyphosShellView.
    public var kelyphosCommandPaletteRegistry: KelyphosCommandPaletteRegistry {
        get { self[KelyphosCommandPaletteRegistryKey.self] }
        set { self[KelyphosCommandPaletteRegistryKey.self] = newValue }
    }
}

/// Registry of commands available in the command palette.
/// Client apps register their commands at startup or dynamically.
@MainActor
@Observable
public final class KelyphosCommandPaletteRegistry {
    public var commands: [KelyphosCommand] = []

    public init() {}

    /// Register a single command.
    public func register(_ command: KelyphosCommand) {
        commands.append(command)
    }

    /// Register multiple commands at once.
    public func register(_ newCommands: [KelyphosCommand]) {
        commands.append(contentsOf: newCommands)
    }

    /// Remove a command by id.
    public func remove(id: String) {
        commands.removeAll { $0.id == id }
    }

    /// Remove all commands whose id starts with a given prefix.
    public func removeAll(withPrefix prefix: String) {
        commands.removeAll { $0.id.hasPrefix(prefix) }
    }

    /// Search commands by fuzzy matching against title.
    /// Returns all commands (sorted by score) when query is empty.
    public func search(_ query: String) -> [(command: KelyphosCommand, match: KelyphosFuzzyMatch)] {
        KelyphosFuzzyMatcher.filter(commands, query: query, keyPath: \.title)
            .map { (command: $0.item, match: $0.match) }
    }
}
