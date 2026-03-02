// ShowcaseCatalog.swift - Static catalog of all HIG showcase items

import Foundation

enum ShowcaseCatalog {
    static let sections: [(ShowcaseSection, [ShowcaseItem])] = [
        (.settings, [
            ShowcaseItem(id: "kelyphos-settings", title: "Kelyphos Settings", systemImage: "gearshape", section: .settings, platforms: [.macOS], priority: .top),
        ]),
        (.components, [
            ShowcaseItem(id: "buttons", title: "Buttons", systemImage: "rectangle.and.hand.point.up.left", section: .components, platforms: [.iOS, .iPadOS, .macOS, .tvOS, .watchOS], priority: .top),
            ShowcaseItem(id: "context-menus", title: "Context Menus", systemImage: "contextualmenu.and.cursorarrow", section: .components, platforms: [.iOS, .iPadOS, .macOS], priority: .top),
            ShowcaseItem(id: "dock-menus", title: "Dock Menus", systemImage: "dock.rectangle", section: .components, platforms: [.macOS], priority: .top),
            ShowcaseItem(id: "edit-menus", title: "Edit Menus", systemImage: "pencil", section: .components, platforms: [.iOS, .iPadOS], priority: .top),
            ShowcaseItem(id: "menus", title: "Menus", systemImage: "filemenu.and.cursorarrow", section: .components, platforms: [.iOS, .iPadOS, .macOS], priority: .top),
            ShowcaseItem(id: "popup-buttons", title: "Pop-Up Buttons", systemImage: "chevron.up.chevron.down", section: .components, platforms: [.macOS], priority: .top),
            ShowcaseItem(id: "pulldown-buttons", title: "Pull-Down Buttons", systemImage: "chevron.down", section: .components, platforms: [.macOS], priority: .top),
            ShowcaseItem(id: "toolbars", title: "Toolbars", systemImage: "hammer", section: .components, platforms: [.iOS, .iPadOS, .macOS], priority: .top),
        ]),
        (.navigationSearch, [
            ShowcaseItem(id: "path-controls", title: "Path Controls", systemImage: "chevron.compact.right", section: .navigationSearch, platforms: [.macOS], priority: .top),
            ShowcaseItem(id: "search-fields", title: "Search Fields", systemImage: "magnifyingglass", section: .navigationSearch, platforms: [.iOS, .iPadOS, .macOS], priority: .top),
            ShowcaseItem(id: "tab-bars", title: "Tab Bars", systemImage: "tab.fill", section: .navigationSearch, platforms: [.iOS, .iPadOS, .macOS, .tvOS], priority: .top),
            ShowcaseItem(id: "token-fields", title: "Token Fields", systemImage: "textformat.abc", section: .navigationSearch, platforms: [.macOS], priority: .top),
        ]),
        (.presentation, [
            ShowcaseItem(id: "action-sheets", title: "Action Sheets", systemImage: "rectangle.bottomhalf.filled", section: .presentation, platforms: [.iOS, .iPadOS], priority: .top),
            ShowcaseItem(id: "alerts", title: "Alerts", systemImage: "exclamationmark.triangle", section: .presentation, platforms: [.iOS, .iPadOS, .macOS, .tvOS, .watchOS], priority: .top),
            ShowcaseItem(id: "page-controls", title: "Page Controls", systemImage: "circle.fill", section: .presentation, platforms: [.iOS, .iPadOS], priority: .top),
            ShowcaseItem(id: "panels", title: "Panels", systemImage: "uiwindow.split.2x1", section: .presentation, platforms: [.macOS], priority: .top),
            ShowcaseItem(id: "popovers", title: "Popovers", systemImage: "text.bubble", section: .presentation, platforms: [.iOS, .iPadOS, .macOS], priority: .top),
            ShowcaseItem(id: "scroll-views", title: "Scroll Views", systemImage: "scroll", section: .presentation, platforms: [.iOS, .iPadOS, .macOS, .tvOS, .watchOS], priority: .top),
            ShowcaseItem(id: "sheets", title: "Sheets", systemImage: "rectangle.bottomthird.inset.filled", section: .presentation, platforms: [.iOS, .iPadOS, .macOS], priority: .top),
        ]),
        (.selectionInput, [
            ShowcaseItem(id: "font-chooser", title: "Font Chooser", systemImage: "textformat", section: .selectionInput, platforms: [.macOS], priority: .ultraTop),
            ShowcaseItem(id: "color-wells", title: "Color Wells", systemImage: "paintpalette", section: .selectionInput, platforms: [.macOS], priority: .top),
            ShowcaseItem(id: "combo-boxes", title: "Combo Boxes", systemImage: "rectangle.and.pencil.and.ellipsis", section: .selectionInput, platforms: [.macOS], priority: .top),
            ShowcaseItem(id: "digit-entry", title: "Digit Entry Views", systemImage: "textformat.123", section: .selectionInput, platforms: [.iOS, .iPadOS], priority: .top),
            ShowcaseItem(id: "image-wells", title: "Image Wells", systemImage: "photo", section: .selectionInput, platforms: [.macOS], priority: .top),
            ShowcaseItem(id: "pickers", title: "Pickers", systemImage: "list.bullet", section: .selectionInput, platforms: [.iOS, .iPadOS, .macOS, .tvOS, .watchOS], priority: .top),
            ShowcaseItem(id: "segmented-controls", title: "Segmented Controls", systemImage: "square.split.2x1", section: .selectionInput, platforms: [.iOS, .iPadOS, .macOS], priority: .top),
            ShowcaseItem(id: "sliders", title: "Sliders", systemImage: "slider.horizontal.3", section: .selectionInput, platforms: [.iOS, .iPadOS, .macOS], priority: .top),
            ShowcaseItem(id: "steppers", title: "Steppers", systemImage: "minus.slash.plus", section: .selectionInput, platforms: [.iOS, .iPadOS, .macOS, .watchOS], priority: .top),
            ShowcaseItem(id: "text-fields", title: "Text Fields", systemImage: "character.cursor.ibeam", section: .selectionInput, platforms: [.iOS, .iPadOS, .macOS, .tvOS], priority: .top),
            ShowcaseItem(id: "toggles", title: "Toggles", systemImage: "switch.2", section: .selectionInput, platforms: [.iOS, .iPadOS, .macOS, .watchOS], priority: .top),
            ShowcaseItem(id: "virtual-keyboard", title: "Virtual Keyboard", systemImage: "keyboard", section: .selectionInput, platforms: [.iOS, .iPadOS], priority: .top),
        ]),
        (.status, [
            ShowcaseItem(id: "gauges", title: "Gauges", systemImage: "gauge.medium", section: .status, platforms: [.iOS, .iPadOS, .macOS, .watchOS], priority: .top),
            ShowcaseItem(id: "progress-indicators", title: "Progress Indicators", systemImage: "clock.arrow.circlepath", section: .status, platforms: [.iOS, .iPadOS, .macOS, .tvOS, .watchOS], priority: .top),
            ShowcaseItem(id: "rating-indicators", title: "Rating Indicators", systemImage: "star.fill", section: .status, platforms: [.macOS], priority: .top),
        ]),
        (.content, [
            ShowcaseItem(id: "charts", title: "Charts", systemImage: "chart.bar", section: .content, platforms: [.iOS, .iPadOS, .macOS, .tvOS, .watchOS], priority: .top),
            ShowcaseItem(id: "image-views", title: "Image Views", systemImage: "photo.artframe", section: .content, platforms: [.iOS, .iPadOS, .macOS, .tvOS, .watchOS], priority: .top),
        ]),
        (.systemExperience, [
            ShowcaseItem(id: "notifications", title: "Notifications", systemImage: "bell.badge", section: .systemExperience, platforms: [.iOS, .iPadOS, .macOS, .watchOS], priority: .top),
            ShowcaseItem(id: "widgets", title: "Widgets", systemImage: "square.grid.2x2", section: .systemExperience, platforms: [.iOS, .iPadOS, .macOS, .watchOS], priority: .top),
        ]),
    ]

    static let allItems: [ShowcaseItem] = sections.flatMap(\.1)

    static func item(_ id: String) -> ShowcaseItem? {
        allItems.first { $0.id == id }
    }
}
