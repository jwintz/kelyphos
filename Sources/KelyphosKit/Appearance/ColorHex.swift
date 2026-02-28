// ColorHex.swift - Color(hex:) extension

import SwiftUI

extension Color {
    /// Initialize a Color from a hex string like "#A58AF9" or "A58AF9".
    public init?(hex: String) {
        let trimmed = hex.trimmingCharacters(in: .whitespaces)
        let str = trimmed.hasPrefix("#") ? String(trimmed.dropFirst()) : trimmed
        guard str.count == 6 else { return nil }
        var rgb: UInt64 = 0
        Scanner(string: str).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
