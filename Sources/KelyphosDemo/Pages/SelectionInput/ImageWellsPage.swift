// ImageWellsPage.swift - Image drop target (macOS only)

import SwiftUI

#if os(macOS)
import AppKit

struct ImageWellsPage: View {
    @State private var droppedImage: NSImage?

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("image-wells")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Image Well") {
                    VStack(spacing: 12) {
                        if let image = droppedImage {
                            Image(nsImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6, 3]))
                                .foregroundStyle(.secondary)
                                .frame(width: 120, height: 120)
                                .overlay {
                                    VStack(spacing: 4) {
                                        Image(systemName: "photo.badge.plus")
                                            .font(.title2)
                                        Text("Drop Image")
                                            .font(.caption)
                                    }
                                    .foregroundStyle(.secondary)
                                }
                        }

                        Text("Drag and drop an image file here")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .dropDestination(for: Data.self) { items, _ in
                        guard let data = items.first,
                              let image = NSImage(data: data) else { return false }
                        droppedImage = image
                        return true
                    }
                }
            }
        }
    }
}
#else
struct ImageWellsPage: View {
    var body: some View {
        ContentUnavailableView(
            "macOS Only",
            systemImage: "macbook",
            description: Text("Image Wells are only available on macOS.")
        )
    }
}
#endif
