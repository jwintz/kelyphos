// KelyphosWidget.swift - macOS desktop widget with multiple sizes

import SwiftUI
import WidgetKit

// MARK: - Timeline Provider

struct KelyphosTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> KelyphosWidgetEntry {
        KelyphosWidgetEntry(date: .now, componentCount: 34, sectionCount: 8)
    }

    func getSnapshot(in context: Context, completion: @escaping (KelyphosWidgetEntry) -> Void) {
        completion(KelyphosWidgetEntry(date: .now, componentCount: 34, sectionCount: 8))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<KelyphosWidgetEntry>) -> Void) {
        let entry = KelyphosWidgetEntry(date: .now, componentCount: 34, sectionCount: 8)
        let timeline = Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(3600)))
        completion(timeline)
    }
}

// MARK: - Entry

struct KelyphosWidgetEntry: TimelineEntry {
    let date: Date
    let componentCount: Int
    let sectionCount: Int
}

// MARK: - Widget Definition

struct KelyphosWidget: Widget {
    let kind: String = "KelyphosWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: KelyphosTimelineProvider()) { entry in
            KelyphosWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Kelyphos")
        .description("HIG Component Showcase at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
    }
}

// MARK: - Views

struct KelyphosWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: KelyphosWidgetEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        case .systemExtraLarge:
            ExtraLargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Small

private struct SmallWidgetView: View {
    let entry: KelyphosWidgetEntry

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "cube.transparent")
                .font(.system(size: 28))
                .foregroundStyle(.secondary)
            Text("Kelyphos")
                .font(.headline)
            Text("\(entry.componentCount) Components")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Medium

private struct MediumWidgetView: View {
    let entry: KelyphosWidgetEntry

    private let sections = [
        ("Components", "square.on.square", 8),
        ("Presentation", "rectangle.on.rectangle", 7),
        ("Selection", "hand.tap", 12),
        ("Status", "gauge.medium", 3),
    ]

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Image(systemName: "cube.transparent")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text("Kelyphos")
                    .font(.headline)
                Text("HIG Showcase")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 6) {
                ForEach(sections, id: \.0) { name, icon, count in
                    HStack(spacing: 4) {
                        Image(systemName: icon)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .frame(width: 14)
                        Text(name)
                            .font(.caption2)
                        Spacer()
                        Text("\(count)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(4)
    }
}

// MARK: - Large

private struct LargeWidgetView: View {
    let entry: KelyphosWidgetEntry

    private let allSections: [(String, String, Int)] = [
        ("Settings", "gearshape", 1),
        ("Components", "square.on.square", 8),
        ("Navigation & Search", "magnifyingglass", 4),
        ("Presentation", "rectangle.on.rectangle", 7),
        ("Selection & Input", "hand.tap", 12),
        ("Status", "gauge.medium", 3),
        ("Content", "photo.on.rectangle", 2),
        ("System Experience", "bell", 2),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "cube.transparent")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                VStack(alignment: .leading) {
                    Text("Kelyphos")
                        .font(.headline)
                    Text("HIG Component Showcase")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(entry.componentCount)")
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundStyle(.secondary)
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                ForEach(allSections, id: \.0) { name, icon, count in
                    HStack(spacing: 8) {
                        Image(systemName: icon)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(width: 16)
                        Text(name)
                            .font(.callout)
                        Spacer()
                        Text("\(count)")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer(minLength: 0)

            Text("Updated \(entry.date, style: .relative) ago")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(4)
    }
}

// MARK: - Extra Large

private struct ExtraLargeWidgetView: View {
    let entry: KelyphosWidgetEntry

    private let highlights: [(String, String, String)] = [
        ("Buttons", "rectangle.and.hand.point.up.left", "All button styles with Liquid Glass"),
        ("Alerts", "exclamationmark.triangle", "Alert variants and text field alerts"),
        ("Charts", "chart.bar", "Swift Charts: bar, line, horizontal"),
        ("Font Chooser", "textformat", "System font picker with live preview"),
        ("Toggles", "switch.2", "Switch, checkbox, and button styles"),
        ("Color Wells", "paintpalette", "ColorPicker with opacity support"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "cube.transparent")
                    .font(.title)
                    .foregroundStyle(.secondary)
                VStack(alignment: .leading) {
                    Text("Kelyphos HIG Showcase")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("\(entry.sectionCount) sections — \(entry.componentCount) components")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            Divider()

            Text("Featured Components")
                .font(.headline)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(highlights, id: \.0) { name, icon, desc in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: icon)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .frame(width: 24)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(name)
                                .font(.callout)
                                .fontWeight(.medium)
                            Text(desc)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(4)
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    KelyphosWidget()
} timeline: {
    KelyphosWidgetEntry(date: .now, componentCount: 34, sectionCount: 8)
}

#Preview(as: .systemMedium) {
    KelyphosWidget()
} timeline: {
    KelyphosWidgetEntry(date: .now, componentCount: 34, sectionCount: 8)
}

#Preview(as: .systemLarge) {
    KelyphosWidget()
} timeline: {
    KelyphosWidgetEntry(date: .now, componentCount: 34, sectionCount: 8)
}
