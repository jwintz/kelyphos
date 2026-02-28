// KelyphosColorThemeTests.swift

import Testing
import SwiftUI
@testable import KelyphosKit

@MainActor
@Suite
struct KelyphosColorThemeTests {
    @Test
    func defaultVariants() {
        let theme = KelyphosColorTheme()
        #expect(theme.light == KelyphosColorVariant.defaultLight)
        #expect(theme.dark == KelyphosColorVariant.defaultDark)
    }

    @Test
    func activeVariantFollowsIsDark() {
        let theme = KelyphosColorTheme()
        theme.isDark = true
        #expect(theme.active == KelyphosColorVariant.defaultDark)
        theme.isDark = false
        #expect(theme.active == KelyphosColorVariant.defaultLight)
    }

    @Test
    func updateVariantFromDictionary() {
        let theme = KelyphosColorTheme()
        theme.update(variant: "dark", from: [
            "background": "#000000",
            "accent": "#FF0000"
        ])
        #expect(theme.dark.background == "#000000")
        #expect(theme.dark.accent == "#FF0000")
    }

    @Test
    func colorHexInitializer() {
        let color = Color(hex: "#A58AF9")
        #expect(color != nil)

        let invalid = Color(hex: "invalid")
        #expect(invalid == nil)

        let noHash = Color(hex: "A58AF9")
        #expect(noHash != nil)
    }
}
