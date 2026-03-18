// KelyphosCommandItem.swift - Protocol and concrete type for command palette items

import SwiftUI

/// A command that can appear in the Kelyphos command palette.
public protocol KelyphosCommandItem: Identifiable, Sendable {
    var title: String { get }
    var subtitle: String { get }
    var systemImage: String { get }
}

/// A concrete command for the command palette.
///
///     KelyphosCommand(id: "toggle-nav", title: "Toggle Navigator", systemImage: "sidebar.left") {
///         shellState.navigatorVisible.toggle()
///     }
public struct KelyphosCommand: KelyphosCommandItem, @unchecked Sendable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let systemImage: String
    public let action: @MainActor () -> Void

    public init(
        id: String,
        title: String,
        subtitle: String = "",
        systemImage: String = "command",
        action: @escaping @MainActor () -> Void
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.action = action
    }
}
