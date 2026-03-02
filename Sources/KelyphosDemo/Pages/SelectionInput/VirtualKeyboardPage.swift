// VirtualKeyboardPage.swift - Info page (macOS note)

import SwiftUI

struct VirtualKeyboardPage: View {
    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("virtual-keyboard")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Virtual Keyboard") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Virtual keyboards are primarily an iOS and iPadOS feature. On these platforms, the system provides context-appropriate keyboard types.")
                            .foregroundStyle(.secondary)

                        Divider()

                        Text("Keyboard Types (iOS):")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 4) {
                            Label(".default — Standard alphanumeric", systemImage: "keyboard")
                            Label(".numberPad — Numbers only", systemImage: "textformat.123")
                            Label(".emailAddress — Email-optimized", systemImage: "envelope")
                            Label(".URL — URL-optimized", systemImage: "link")
                            Label(".phonePad — Phone number entry", systemImage: "phone")
                            Label(".decimalPad — Numbers with decimal", systemImage: "number")
                            Label(".asciiCapable — ASCII characters", systemImage: "character")
                        }
                        .font(.system(size: 12))
                        .padding(.leading, 4)

                        Divider()

                        Text("On macOS, physical keyboards are the primary input method. The Accessibility Keyboard and Character Viewer are available via System Settings.")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
