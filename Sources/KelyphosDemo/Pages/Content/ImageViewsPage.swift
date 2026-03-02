// ImageViewsPage.swift - Image/AsyncImage demos

import SwiftUI

struct ImageViewsPage: View {
    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("image-views")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "SF Symbol Images") {
                    HStack(spacing: 20) {
                        VStack {
                            Image(systemName: "star.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.yellow)
                            Text("Symbol")
                                .font(.caption)
                        }
                        VStack {
                            Image(systemName: "heart.fill")
                                .font(.largeTitle)
                                .symbolRenderingMode(.multicolor)
                            Text("Multicolor")
                                .font(.caption)
                        }
                        VStack {
                            Image(systemName: "cloud.sun.rain.fill")
                                .font(.largeTitle)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.blue)
                            Text("Hierarchical")
                                .font(.caption)
                        }
                        VStack {
                            Image(systemName: "person.crop.circle.badge.checkmark")
                                .font(.largeTitle)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.green, .blue)
                            Text("Palette")
                                .font(.caption)
                        }
                    }
                }

                GlassSection(title: "Image Modifiers") {
                    HStack(spacing: 16) {
                        VStack {
                            Image(systemName: "photo.artframe")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                            Text(".fit")
                                .font(.caption)
                        }
                        VStack {
                            Image(systemName: "photo.artframe")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipped()
                            Text(".fill")
                                .font(.caption)
                        }
                        VStack {
                            Image(systemName: "photo.artframe")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                            Text("Circle")
                                .font(.caption)
                        }
                        VStack {
                            Image(systemName: "photo.artframe")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            Text("Rounded")
                                .font(.caption)
                        }
                    }
                }

                GlassSection(title: "AsyncImage") {
                    Text("AsyncImage loads images from a URL asynchronously. It supports placeholder views and error handling via phases.")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
