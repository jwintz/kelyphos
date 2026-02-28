// KelyphosPanel.swift - Protocol for panel tab definitions
// Client apps conform their enums to this protocol.

import SwiftUI

/// A panel tab that can be displayed in navigator, inspector, or utility areas.
/// Conform your enum cases to this protocol:
///
///     enum MyNavigatorTab: String, KelyphosPanel {
///         case files, search, git
///         var title: String { rawValue.capitalized }
///         var systemImage: String { ... }
///         var body: some View { ... }
///     }
public protocol KelyphosPanel: View, Identifiable, Hashable, CaseIterable, Sendable {
    var title: String { get }
    var systemImage: String { get }
}
