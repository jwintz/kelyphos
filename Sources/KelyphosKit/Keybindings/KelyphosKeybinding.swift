// KelyphosKeybinding.swift - Model struct for keybindings

import Foundation

/// A single keybinding entry for display in the overlay.
public struct KelyphosKeybinding: Identifiable, Sendable {
    public let id: String
    public let category: String
    public let label: String
    public let shortcut: String

    public init(category: String, label: String, shortcut: String) {
        self.id = "\(category).\(label)"
        self.category = category
        self.label = label
        self.shortcut = shortcut
    }
}
