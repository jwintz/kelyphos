# Kelyphos

A macOS Liquid Glass shell framework and HIG component showcase, built with SwiftUI for macOS 26 (Tahoe).

## Requirements

- **macOS 26** (Tahoe) or later
- **Xcode 26** or later
- **Swift 6.2**

## Package Structure

| Target | Type | Description |
|--------|------|-------------|
| `KelyphosKit` | Library | Reusable shell framework — panels, navigation, theming, keybindings |
| `KelyphosDemo` | Executable | HIG component showcase app with 34 interactive demo pages |
| `KelyphosWidget` | App Extension | macOS desktop widget (Small / Medium / Large / Extra Large) — built via XcodeGen project |
| `KelyphosKitTests` | Tests | Unit tests for KelyphosKit |

## Quick Start

### Build everything

```bash
swift build
```

### Run the demo app

```bash
swift run KelyphosDemo
```

### Run tests

```bash
swift test
```

> **Note:** When running via `swift run`, the executable has no app bundle identity. Features requiring a bundle identifier (e.g. notifications) will show a warning instead of crashing. Build from Xcode for full functionality.

## Xcode Project (XcodeGen)

Widget extensions cannot be built by SPM alone — they require an Xcode project with proper app extension targets. This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) (included as an SPM dependency) to generate `Kelyphos.xcodeproj` from `project.yml`.

The generated `.xcodeproj` is gitignored; regenerate it after cloning.

### Generate the Xcode project

```bash
swift run --package-path .build/checkouts/XcodeGen xcodegen generate --spec project.yml
```

Then open the project:

```bash
open Kelyphos.xcodeproj
```

### Schemes

| Scheme | Description |
|--------|-------------|
| `KelyphosDemo` | Host app — builds the demo app with the widget extension embedded |
| `KelyphosWidget` | Widget extension — builds the widget independently |

### Adding the widget to your desktop

1. Build and run **KelyphosDemo** (`Cmd+R`)
2. Right-click on the macOS desktop → **Edit Widgets...**
3. Search for "Kelyphos" and drag the desired size:
   - **Small** — App icon with component count
   - **Medium** — Sections overview with item counts
   - **Large** — Full section list with timestamps
   - **Extra Large** — Featured components grid

### Previewing widgets

Open `Sources/KelyphosWidget/KelyphosWidget.swift` in Xcode and use the Canvas (`Cmd+Opt+Return`) to see `#Preview` renders.

### Troubleshooting

| Problem | Solution |
|---------|----------|
| Widget doesn't appear in widget gallery | Ensure both targets are signed with the same team and the widget bundle ID is a child of the host app's |
| Widget shows placeholder only | `killall widgetextensionhost` and re-add |
| Code changes not reflected | Clean build folder (`Cmd+Shift+K`), rebuild, and re-add |

## Demo App Overview

The showcase presents Apple HIG components organized into 8 sections:

| Section | Items | Examples |
|---------|-------|---------|
| Settings | 1 | Panel visibility, keyboard shortcuts |
| Components | 8 | Buttons, context menus, toolbars, menus |
| Navigation & Search | 4 | Path controls, search fields, tab bars, token fields |
| Presentation | 7 | Alerts, sheets, popovers, scroll views |
| Selection & Input | 12 | Font chooser, color wells, pickers, toggles, sliders |
| Status | 3 | Gauges, progress indicators, rating indicators |
| Content | 2 | Swift Charts, image views |
| System Experience | 2 | Notifications, widgets |

### Navigation

- **Tab 1 (Explore)** — Hierarchical list of all sections and items; right-click to bookmark
- **Tab 2 (Search)** — Full-text search across component titles and sections
- **Tab 3 (Bookmarks)** — Quick access to bookmarked items

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Cmd+0` | Toggle Navigator |
| `Cmd+1–9` | Select Navigator Tab |
| `Cmd+Opt+0` | Toggle Inspector |
| `Cmd+Opt+1–9` | Select Inspector Tab |
| `Cmd+Opt+Shift+0` | Toggle Utility Area |
| `Cmd+Shift+/` | Keyboard Shortcuts Overlay |
| `Cmd+,` | Settings |

## Architecture

```
Sources/
  KelyphosKit/          # Reusable shell framework
    Core/               # ShellState, Panel protocol, Design tokens
    Appearance/         # Vibrancy, themes, color system
    Shell/              # NavigationSplitView shell, commands
    Panels/             # Tab bar, panel containers
    Font/               # Font stack, font chooser
    Keybindings/        # Registry, overlay
    Settings/           # Appearance settings

  KelyphosDemo/         # HIG showcase app
    Model/              # ShowcaseItem, Catalog, State, EnvironmentKey
    Chrome/             # GlassSection, PageChrome, WelcomePage
    Navigator/          # Explore, Search, Bookmarks views
    Inspector/          # Selected item details
    Pages/              # 34 interactive demo pages
      Components/       # Buttons, menus, toolbars
      NavigationSearch/ # Path controls, search, tabs, tokens
      Presentation/     # Alerts, sheets, popovers, scroll views
      SelectionInput/   # Font chooser, pickers, toggles, sliders
      Status/           # Gauges, progress, ratings
      Content/          # Charts, images
      SystemExperience/ # Notifications, widgets
      Settings/         # Kelyphos settings page

  KelyphosWidget/       # macOS desktop widget
    KelyphosWidgetBundle.swift
    KelyphosWidget.swift
```

### Design Decisions

- **Liquid Glass throughout** — All demo sections use `GlassSection`, a container backed by `.glassEffect(in: RoundedRectangle)`. Standard controls get Liquid Glass automatically via macOS 26 SDK.
- **Selection-based navigation** — `List(selection:)` drives `ShowcaseState.selectedItem` via local `@State` with `onChange` sync (avoids `NSTableView` reentrant delegate warnings).
- **Observable routing** — `ShowcaseState` (`@Observable`) is injected via a custom `EnvironmentKey`. `DemoContentView` switches on `selectedItem.id` to route to the correct page.
- **Static catalog** — All 34 items are defined in `ShowcaseCatalog` as compile-time data. No dynamic loading.

## License

See LICENSE file.
