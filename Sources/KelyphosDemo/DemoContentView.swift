// DemoContentView.swift - Router switching on selected showcase item

import SwiftUI
import KelyphosKit

struct DemoContentView: View {
    @Environment(\.showcaseState) private var showcaseState

    var body: some View {
        Group {
            if let item = showcaseState?.selectedItem {
                pageView(for: item)
                    .id(item.id)
            } else {
                ShowcaseWelcomePage()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func pageView(for item: ShowcaseItem) -> some View {
        switch item.id {
        // Settings
        case "kelyphos-settings":
            KelyphosSettingsPage()

        // Components
        case "buttons":
            ButtonsPage()
        case "context-menus":
            ContextMenusPage()
        case "dock-menus":
            DockMenusPage()
        case "edit-menus":
            EditMenusPage()
        case "menus":
            MenusPage()
        case "popup-buttons":
            PopupButtonsPage()
        case "pulldown-buttons":
            PulldownButtonsPage()
        case "toolbars":
            ToolbarsPage()

        // Navigation & Search
        case "path-controls":
            PathControlsPage()
        case "search-fields":
            SearchFieldsPage()
        case "tab-bars":
            TabBarsPage()
        case "token-fields":
            TokenFieldsPage()

        // Presentation
        case "action-sheets":
            ActionSheetsPage()
        case "alerts":
            AlertsPage()
        case "page-controls":
            PageControlsPage()
        case "panels":
            PanelsPage()
        case "popovers":
            PopoversPage()
        case "scroll-views":
            ScrollViewsPage()
        case "sheets":
            SheetsPage()

        // Selection & Input
        case "font-chooser":
            FontChooserPage()
        case "color-wells":
            ColorWellsPage()
        case "combo-boxes":
            ComboBoxesPage()
        case "digit-entry":
            DigitEntryPage()
        case "image-wells":
            ImageWellsPage()
        case "pickers":
            PickersPage()
        case "segmented-controls":
            SegmentedControlsPage()
        case "sliders":
            SlidersPage()
        case "steppers":
            SteppersPage()
        case "text-fields":
            TextFieldsPage()
        case "toggles":
            TogglesPage()
        case "virtual-keyboard":
            VirtualKeyboardPage()

        // Status
        case "gauges":
            GaugesPage()
        case "progress-indicators":
            ProgressIndicatorsPage()
        case "rating-indicators":
            RatingIndicatorsPage()

        // Content
        case "charts":
            ChartsPage()
        case "image-views":
            ImageViewsPage()

        // System Experience
        case "notifications":
            NotificationsPage()
        case "widgets":
            WidgetsPage()

        default:
            DeferredPage(item: item)
        }
    }
}
