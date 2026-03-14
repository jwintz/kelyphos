---
title: Kelyphos
description: SwiftUI shell framework for multi-panel applications
icon: i-lucide-layout-panel-left
order: 0
navigation:
  title: Home
  icon: i-lucide-home
  order: 0
---

Kelyphos is a SwiftUI shell framework for building professional multi-panel applications on macOS and iPadOS. It provides an IDE-style chrome — navigator sidebar, detail content area, utility panel, and inspector — with a unified API that adapts to each platform's conventions.

## Quick Start

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
        }
        .commands { KelyphosCommands(state: shellState) }
    }
}
```

## Requirements

- **macOS 26** (Tahoe) / **iPadOS 26** or later
- **Xcode 26** or later
- **Swift 6.2**

## Documentation

- [[1.guide/1.installation|Installation]]
- [[1.guide/2.shell-state|Shell State]]
- [[1.guide/3.panels|Defining Panels]]
- [[1.guide/4.appearance|Appearance & Vibrancy]]
- [[1.guide/5.keybindings|Keyboard Shortcuts]]
- [[2.api/1.kelyphos-shell-view|KelyphosShellView]]
- [[2.api/2.kelyphos-shell-state|KelyphosShellState]]
- [[2.api/3.kelyphos-panel|KelyphosPanel]]
- [[Changelog]]
