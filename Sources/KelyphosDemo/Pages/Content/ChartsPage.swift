// ChartsPage.swift - Swift Charts demos

import SwiftUI
import Charts

struct ChartsPage: View {
    private let salesData: [(month: String, sales: Double)] = [
        ("Jan", 120), ("Feb", 150), ("Mar", 180),
        ("Apr", 200), ("May", 170), ("Jun", 220),
    ]

    private let categoryData: [(category: String, value: Double)] = [
        ("Swift", 40), ("Python", 25), ("Rust", 15), ("Go", 20),
    ]

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("charts")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Bar Chart") {
                    Chart(salesData, id: \.month) { item in
                        BarMark(
                            x: .value("Month", item.month),
                            y: .value("Sales", item.sales)
                        )
                        .foregroundStyle(.blue.gradient)
                    }
                    .frame(height: 200)
                }

                GlassSection(title: "Line Chart") {
                    Chart(salesData, id: \.month) { item in
                        LineMark(
                            x: .value("Month", item.month),
                            y: .value("Sales", item.sales)
                        )
                        .foregroundStyle(.green)
                        PointMark(
                            x: .value("Month", item.month),
                            y: .value("Sales", item.sales)
                        )
                        .foregroundStyle(.green)
                    }
                    .frame(height: 200)
                }

                GlassSection(title: "Horizontal Bar Chart") {
                    Chart(categoryData, id: \.category) { item in
                        BarMark(
                            x: .value("Percentage", item.value),
                            y: .value("Language", item.category)
                        )
                        .foregroundStyle(.orange.gradient)
                    }
                    .frame(height: 160)
                }
            }
        }
    }
}
