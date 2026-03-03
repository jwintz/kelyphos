# Kelyphos

A cross-platform SwiftUI shell framework for building professional multi-panel applications on macOS and iPadOS. Provides an IDE-style chrome — navigator sidebar, detail content area, utility panel, and inspector — with a unified API that adapts to each platform's conventions.

## Requirements

- **macOS 26** (Tahoe) / **iPadOS 26** or later
- **Xcode 26** or later
- **Swift 6.2**

## Package Structure

| Target | Type | Description |
|--------|------|-------------|
| `KelyphosKit` | Library | Reusable shell framework — panels, navigation, theming, keybindings |
| `KelyphosDemo` | Executable | HIG component showcase app with 34 interactive demo pages |
| `KelyphosWidget` | App Extension | Desktop widget (Small / Medium / Large / Extra Large) — built via XcodeGen project |
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

Widget extensions cannot be built by SPM alone — they require an Xcode project with proper app extension targets. This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) to generate `Kelyphos.xcodeproj` from `project.yml`.

The generated `.xcodeproj` is gitignored; regenerate it after cloning.

```bash
swift run --package-path .build/checkouts/XcodeGen xcodegen generate --spec project.yml
open Kelyphos.xcodeproj
```

| Scheme | Description |
|--------|-------------|
| `KelyphosDemo` | Host app — builds the demo app with the widget extension embedded |
| `KelyphosWidget` | Widget extension — builds the widget independently |

---

# Using KelyphosKit

## Minimal App

Three things are needed: a `KelyphosShellState`, a `KelyphosShellConfiguration` with your panel tabs, and the `KelyphosShellView`.

```swift
import SwiftUI
import KelyphosKit

@main
struct MyApp: App {
    @State private var shellState = KelyphosShellState(persistencePrefix: "myapp")

    var body: some Scene {
        WindowGroup("My App") {
            KelyphosShellView(
                state: shellState,
                configuration: KelyphosShellConfiguration(
                    navigatorTabs: Array(MyNavigatorTab.allCases),
                    inspectorTabs: Array(MyInspectorTab.allCases),
                    utilityTabs: Array(MyUtilityTab.allCases),
                    detail: { MyDetailView() }
                )
            )
            .onAppear {
                shellState.title = "My App"
                shellState.subtitle = "Workspace"
            }
        }
        .commands {
            KelyphosCommands(state: shellState)
        }
    }
}
```

## Defining Panels

Each panel area (navigator, inspector, utility) is populated by an enum conforming to `KelyphosPanel`. This gives you type-safe, tab-switchable panels with SF Symbols icons and built-in keyboard shortcut support.

```swift
enum MyNavigatorTab: String, KelyphosPanel, CaseIterable {
    case files, search, bookmarks

    nonisolated var id: String { rawValue }

    nonisolated var title: String {
        switch self {
        case .files: "Files"
        case .search: "Search"
        case .bookmarks: "Bookmarks"
        }
    }

    nonisolated var systemImage: String {
        switch self {
        case .files: "folder"
        case .search: "magnifyingglass"
        case .bookmarks: "bookmark"
        }
    }

    var body: some View {
        switch self {
        case .files: FilesNavigatorView()
        case .search: SearchNavigatorView()
        case .bookmarks: BookmarksNavigatorView()
        }
    }
}
```

Inspector and utility tabs follow the same pattern:

```swift
enum MyInspectorTab: String, KelyphosPanel, CaseIterable {
    case details, properties

    nonisolated var id: String { rawValue }
    nonisolated var title: String { rawValue.capitalized }

    nonisolated var systemImage: String {
        switch self {
        case .details: "info.circle"
        case .properties: "slider.horizontal.3"
        }
    }

    var body: some View {
        switch self {
        case .details: DetailsInspectorView()
        case .properties: PropertiesInspectorView()
        }
    }
}

enum MyUtilityTab: String, KelyphosPanel, CaseIterable {
    case output, log

    nonisolated var id: String { rawValue }
    nonisolated var title: String { rawValue.capitalized }

    nonisolated var systemImage: String {
        switch self {
        case .output: "terminal"
        case .log: "list.bullet.rectangle"
        }
    }

    var body: some View {
        switch self {
        case .output: OutputUtilityView()
        case .log: LogUtilityView()
        }
    }
}
```

## Shell State

`KelyphosShellState` is the single source of truth for the entire shell. It's an `@Observable` class that drives visibility, appearance, and panel selection across both platforms.

### Title and Subtitle

```swift
shellState.title = "Project Name"
shellState.subtitle = "3 files modified"
```

On macOS, these appear in the window toolbar. On iPadOS, the title appears in the navigation bar.

### Panel Visibility

```swift
// Toggle panels programmatically
shellState.navigatorVisible.toggle()
shellState.inspectorVisible.toggle()
shellState.utilityAreaVisible.toggle()

// Disable panels entirely (removes toggle buttons too)
shellState.inspectorEnabled = false
shellState.utilityEnabled = false
```

### Tab Selection

```swift
// Select tabs by index (0-based)
shellState.selectedNavigatorIndex = 1   // Switch to second navigator tab
shellState.selectedInspectorIndex = 0   // Switch to first inspector tab
```

### Appearance

```swift
// Vibrancy material (behind-window blur)
shellState.vibrancyMaterial = .ultraThin  // .none, .ultraThin, .thin, .regular, .thick, .ultraThick

// Background tint
shellState.backgroundAlpha = 0.3  // 0.0 (transparent) to 1.0 (opaque)

// System appearance override
shellState.windowAppearance = "dark"  // "auto", "light", "dark"
```

### Persistence

State is automatically persisted to UserDefaults using the `persistencePrefix` you provide:

```swift
let shellState = KelyphosShellState(persistencePrefix: "myapp.editor")
```

## Appearance Presets

```swift
AppearancePreset.clear.apply(to: shellState)     // Fully transparent + ultraThin material
AppearancePreset.balanced.apply(to: shellState)   // 50% opacity + thin material
AppearancePreset.solid.apply(to: shellState)      // Fully opaque, no material
```

## Color Theme

The color theme provides semantic colors that adapt to light and dark mode:

```swift
@Environment(\.kelyphosShellState) var shellState

var body: some View {
    Text("Hello")
        .foregroundStyle(shellState?.colorTheme.accent ?? .accentColor)
}
```

Available color slots: `accent`, `accentSecondary`, `foreground`, `foregroundDim`, `background`, `backgroundDim`, `error`, `warning`, `success`, `link`, `border`, `selection`.

Customize with hex values:

```swift
shellState.colorTheme.update(variant: "dark", from: [
    "accent": "#8B5CF6",
    "background": "#18181B"
])
```

## Keyboard Shortcuts

`KelyphosCommands` provides built-in shortcuts:

| Shortcut | Action |
|----------|--------|
| `Cmd+0` | Toggle navigator |
| `Cmd+1-9` | Select navigator tab |
| `Cmd+Opt+0` | Toggle inspector |
| `Cmd+Opt+1-9` | Select inspector tab |
| `Cmd+Opt+Shift+0` | Toggle utility area |
| `Cmd+Opt+Shift+1-9` | Select utility tab |
| `Cmd+Shift+/` | Show keybindings overlay (macOS) |
| `Cmd+,` | Settings |

Register custom keybindings for the overlay:

```swift
@Environment(\.kelyphosKeybindingRegistry) var registry

.onAppear {
    registry.register(category: "Editor", label: "Save", shortcut: "⌘S")
    registry.register(category: "Editor", label: "Find", shortcut: "⌘F")
}
```

## Settings View

Drop in a ready-made settings panel:

```swift
var body: some Scene {
    WindowGroup { /* ... */ }

    #if os(macOS)
    Settings {
        KelyphosSettingsView(state: shellState)
    }
    #endif
}
```

## Design Constants

`KelyphosDesign` provides consistent spacing, sizing, and typography:

```swift
KelyphosDesign.Padding.horizontal      // 12
KelyphosDesign.Padding.compact         // 8
KelyphosDesign.Spacing.standard        // 12
KelyphosDesign.CornerRadius.content    // 14
KelyphosDesign.Height.tabBar           // 27
KelyphosDesign.Height.utilityArea      // 260
KelyphosDesign.FontSize.body           // 11
KelyphosDesign.IconSize.standard       // 14
KelyphosDesign.Animation.standard      // 0.25
KelyphosDesign.Width.sidebarIdeal      // 280
KelyphosDesign.Width.inspectorIdeal    // 300
```

## Font Stack

Built-in font families with weight support:

```swift
let font = KelyphosFontStack.sfMono.font(size: 12, weight: .medium)

KelyphosFontStack.sfPro       // System proportional (9 weights)
KelyphosFontStack.sfMono      // System monospaced (6 weights)
KelyphosFontStack.lilex       // Lilex monospaced (6 weights)
KelyphosFontStack.geistMono   // Geist Mono (8 weights)
KelyphosFontStack.recursive   // Recursive proportional (7 weights)
```

## Platform Behavior

Kelyphos adapts to each platform while sharing the same API:

| Feature | macOS | iPadOS |
|---------|-------|--------|
| Navigator | NavigationSplitView sidebar | NavigationSplitView sidebar with system toggle |
| Inspector | Native `.inspector()` column | Trailing-edge overlay with vibrancy material |
| Utility area | Bottom panel with material | Bottom panel with material |
| Title/subtitle | Window toolbar (inline) | Navigation bar title |
| Toolbar buttons | `ToolbarSpacer` + `ToolbarItem` | `ToolbarItemGroup(.topBarTrailing)` |
| Keybindings overlay | `Cmd+Shift+/` (NSEvent) | Not available |
| Panel font sizing | System default | Capped at `.dynamicTypeSize(.xSmall ... .medium)` |
| Vibrancy | NSVisualEffectView (behind-window) | SwiftUI `.ultraThinMaterial` |

---

## Demo App

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

---

## Widget

### Adding the widget to your desktop

1. Build and run **KelyphosDemo** (`Cmd+R`)
2. Right-click on the macOS desktop -> **Edit Widgets...**
3. Search for "Kelyphos" and drag the desired size:
   - **Small** — App icon with component count
   - **Medium** — Sections overview with item counts
   - **Large** — Full section list with timestamps
   - **Extra Large** — Featured components grid

### Troubleshooting

| Problem | Solution |
|---------|----------|
| Widget doesn't appear in widget gallery | Ensure both targets are signed with the same team and the widget bundle ID is a child of the host app's |
| Widget shows placeholder only | `killall widgetextensionhost` and re-add |
| Code changes not reflected | Clean build folder (`Cmd+Shift+K`), rebuild, and re-add |

---

## Architecture

```
Sources/
  KelyphosKit/          # Reusable shell framework
    Core/               # ShellState, Panel protocol, Design tokens, environment keys
    Appearance/         # Vibrancy, themes, color system, presets
    Shell/              # NavigationSplitView shell, content area, commands, configuration
    Panels/             # Tab bar, panel containers
    Font/               # Font stack, font families
    Keybindings/        # Registry, overlay
    Settings/           # Appearance settings view

  KelyphosDemo/         # HIG showcase app
    Model/              # ShowcaseItem, Catalog, State
    Chrome/             # GlassSection, PageChrome, WelcomePage
    Navigator/          # Explore, Search, Bookmarks views
    Inspector/          # Selected item details
    Pages/              # 34 interactive demo pages

  KelyphosWidget/       # Desktop widget
```

## License

See LICENSE file.
