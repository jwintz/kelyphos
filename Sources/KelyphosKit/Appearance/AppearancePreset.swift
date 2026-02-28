// AppearancePreset.swift - Clear/Balanced/Solid presets

/// Quick presets for window appearance.
public enum AppearancePreset: String, CaseIterable, Identifiable, Sendable {
    case clear = "Clear"
    case balanced = "Balanced"
    case solid = "Solid"

    public var id: String { rawValue }

    /// Apply this preset to the given shell state.
    @MainActor
    public func apply(to state: KelyphosShellState) {
        switch self {
        case .clear:
            state.backgroundAlpha = 0.0
            state.vibrancyMaterial = .ultraThin
        case .balanced:
            state.backgroundAlpha = 0.5
            state.vibrancyMaterial = .thin
        case .solid:
            state.backgroundAlpha = 1.0
            state.vibrancyMaterial = .none
        }
    }

    /// Detect which preset matches the current state, if any.
    @MainActor
    public static func detect(from state: KelyphosShellState) -> AppearancePreset? {
        if state.backgroundAlpha == 0.0 && state.vibrancyMaterial == .ultraThin { return .clear }
        if state.backgroundAlpha == 0.5 && state.vibrancyMaterial == .thin { return .balanced }
        if state.backgroundAlpha == 1.0 && state.vibrancyMaterial == .none { return .solid }
        return nil
    }
}
