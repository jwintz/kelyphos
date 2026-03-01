// KelyphosShellStateTests.swift

import Testing
@testable import KelyphosKit

@MainActor
@Suite
struct KelyphosShellStateTests {
    @Test
    func defaultValues() {
        let state = KelyphosShellState(persistencePrefix: "test")
        #expect(state.backgroundAlpha == 0.5)
        #expect(state.vibrancyMaterial == .ultraThin)
        #expect(state.navigatorVisible == true)
        #expect(state.inspectorVisible == false)
        #expect(state.utilityAreaVisible == true)
        #expect(state.decorationsVisible == true)
        #expect(state.persistencePrefix == "test")
    }

    @Test
    func persistencePrefixIsolation() {
        let state1 = KelyphosShellState(persistencePrefix: "app1")
        let state2 = KelyphosShellState(persistencePrefix: "app2")
        #expect(state1.persistencePrefix != state2.persistencePrefix)
    }

    @Test
    func isDarkModeComputedFromAppearance() {
        let state = KelyphosShellState(persistencePrefix: "test")
        state.windowAppearance = "dark"
        #expect(state.isDarkMode == true)
        state.windowAppearance = "light"
        #expect(state.isDarkMode == false)
    }
}
