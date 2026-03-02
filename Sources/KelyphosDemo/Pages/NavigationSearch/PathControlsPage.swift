// PathControlsPage.swift - NSPathControl wrapper (macOS only)

import SwiftUI

#if os(macOS)
import AppKit

struct PathControlsPage: View {
    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("path-controls")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Path Control") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Path controls display a file system path and allow navigation through it. They are a macOS-specific component.")
                            .foregroundStyle(.secondary)

                        PathControlRepresentable(url: FileManager.default.homeDirectoryForCurrentUser)
                            .frame(height: 24)
                    }
                }

                GlassSection(title: "Standard Style") {
                    PathControlRepresentable(url: FileManager.default.homeDirectoryForCurrentUser, style: .standard)
                        .frame(height: 24)
                }

                GlassSection(title: "Pop-Up Style") {
                    PathControlRepresentable(url: FileManager.default.homeDirectoryForCurrentUser, style: .popUp)
                        .frame(height: 24)
                }
            }
        }
    }
}

private struct PathControlRepresentable: NSViewRepresentable {
    let url: URL
    var style: NSPathControl.Style = .standard

    func makeNSView(context: Context) -> NSPathControl {
        let control = NSPathControl()
        control.pathStyle = style
        control.url = url
        control.isEditable = false
        return control
    }

    func updateNSView(_ nsView: NSPathControl, context: Context) {
        nsView.url = url
    }
}
#else
struct PathControlsPage: View {
    var body: some View {
        ContentUnavailableView(
            "macOS Only",
            systemImage: "macbook",
            description: Text("Path Controls are only available on macOS.")
        )
    }
}
#endif
