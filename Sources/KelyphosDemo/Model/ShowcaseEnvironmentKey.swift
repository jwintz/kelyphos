// ShowcaseEnvironmentKey.swift - Environment key for ShowcaseState

import SwiftUI

private struct ShowcaseStateKey: EnvironmentKey {
    static let defaultValue: ShowcaseState? = nil
}

extension EnvironmentValues {
    var showcaseState: ShowcaseState? {
        get { self[ShowcaseStateKey.self] }
        set { self[ShowcaseStateKey.self] = newValue }
    }
}
