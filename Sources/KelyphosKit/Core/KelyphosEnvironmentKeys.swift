// KelyphosEnvironmentKeys.swift - Environment keys for the shell

import SwiftUI

// MARK: - Shell State Environment Key

private struct KelyphosShellStateKey: EnvironmentKey {
    static let defaultValue: KelyphosShellState? = nil
}

extension EnvironmentValues {
    /// The shell state, injected by KelyphosShellView.
    public var kelyphosShellState: KelyphosShellState? {
        get { self[KelyphosShellStateKey.self] }
        set { self[KelyphosShellStateKey.self] = newValue }
    }
}
