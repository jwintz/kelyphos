// ShowcaseState.swift - Observable state for showcase navigation and bookmarks

import SwiftUI

@MainActor @Observable
final class ShowcaseState {
    var selectedItem: ShowcaseItem?

    var bookmarkedItemIDs: Set<String> {
        didSet { persistBookmarks() }
    }

    init() {
        let stored = UserDefaults.standard.stringArray(forKey: "kelyphos.demo.bookmarkedItems") ?? []
        self.bookmarkedItemIDs = Set(stored)
    }

    func toggleBookmark(_ item: ShowcaseItem) {
        if bookmarkedItemIDs.contains(item.id) {
            bookmarkedItemIDs.remove(item.id)
        } else {
            bookmarkedItemIDs.insert(item.id)
        }
    }

    func isBookmarked(_ item: ShowcaseItem) -> Bool {
        bookmarkedItemIDs.contains(item.id)
    }

    var bookmarkedItems: [ShowcaseItem] {
        ShowcaseCatalog.allItems.filter { bookmarkedItemIDs.contains($0.id) }
    }

    private func persistBookmarks() {
        UserDefaults.standard.set(Array(bookmarkedItemIDs), forKey: "kelyphos.demo.bookmarkedItems")
    }
}
