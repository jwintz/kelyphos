// RatingIndicatorsPage.swift - Custom star rating

import SwiftUI

struct RatingIndicatorsPage: View {
    @State private var rating = 3

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("rating-indicators")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Star Rating") {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .foregroundStyle(star <= rating ? .yellow : .secondary)
                                    .font(.title2)
                                    .onTapGesture { rating = star }
                            }
                        }

                        Text("Rating: \(rating) / 5")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                GlassSection(title: "About Rating Indicators") {
                    Text("macOS uses a built-in NSLevelIndicator for rating displays. SwiftUI doesn't provide a native rating view, so custom implementations using SF Symbols are common.")
                        .foregroundStyle(.secondary)
                }

                GlassSection(title: "Read-Only Ratings") {
                    VStack(alignment: .leading, spacing: 8) {
                        ratingRow("Excellent", 5)
                        ratingRow("Good", 4)
                        ratingRow("Average", 3)
                        ratingRow("Fair", 2)
                        ratingRow("Poor", 1)
                    }
                }
            }
        }
    }

    private func ratingRow(_ label: String, _ count: Int) -> some View {
        HStack {
            Text(label)
                .frame(width: 80, alignment: .leading)
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= count ? "star.fill" : "star")
                        .font(.caption)
                        .foregroundStyle(star <= count ? .yellow : .secondary.opacity(0.3))
                }
            }
        }
    }
}
