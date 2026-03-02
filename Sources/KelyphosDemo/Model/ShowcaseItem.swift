// ShowcaseItem.swift - Data types for the HIG component showcase

import Foundation

enum ShowcasePlatform: String, Identifiable, CaseIterable, Sendable {
    case iOS, iPadOS, macOS, tvOS, watchOS

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .iOS: "iphone"
        case .iPadOS: "ipad"
        case .macOS: "macbook"
        case .tvOS: "appletv"
        case .watchOS: "applewatch"
        }
    }
}

enum ShowcasePriority: Sendable {
    case ultraTop, top, normal, deferred
}

enum ShowcaseSection: String, CaseIterable, Identifiable, Sendable {
    case settings
    case components
    case navigationSearch
    case presentation
    case selectionInput
    case status
    case content
    case systemExperience

    var id: String { rawValue }

    var title: String {
        switch self {
        case .settings: "Settings"
        case .components: "Components"
        case .navigationSearch: "Navigation & Search"
        case .presentation: "Presentation"
        case .selectionInput: "Selection & Input"
        case .status: "Status"
        case .content: "Content"
        case .systemExperience: "System Experience"
        }
    }

    var systemImage: String {
        switch self {
        case .settings: "gearshape"
        case .components: "square.on.square"
        case .navigationSearch: "magnifyingglass"
        case .presentation: "rectangle.on.rectangle"
        case .selectionInput: "hand.tap"
        case .status: "gauge.medium"
        case .content: "photo.on.rectangle"
        case .systemExperience: "bell"
        }
    }
}

struct ShowcaseItem: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let systemImage: String
    let section: ShowcaseSection
    let platforms: [ShowcasePlatform]
    let priority: ShowcasePriority

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ShowcaseItem, rhs: ShowcaseItem) -> Bool {
        lhs.id == rhs.id
    }
}
