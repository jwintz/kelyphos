// KelyphosWelcomeAction.swift - Action button model for KelyphosWelcomeView

import SwiftUI

/// Describes a single action button displayed in the welcome view's left panel.
public struct KelyphosWelcomeAction: Identifiable {
    public let id = UUID()
    public let systemImage: String
    public let title: String
    public let action: @MainActor () -> Void

    public init(systemImage: String, title: String, action: @escaping @MainActor () -> Void) {
        self.systemImage = systemImage
        self.title = title
        self.action = action
    }
}
