---
title: Kelyphos
description: A SwiftUI shell framework for multi-panel applications on macOS and iPadOS
navigation: false
---

::u-page-hero
---
title: Kelyphos
description: A SwiftUI shell framework for building professional multi-panel applications on macOS and iPadOS. IDE-style chrome — navigator, editor, inspector, utility — with a unified API that adapts to each platform's conventions.
links:
  - label: Get Started
    to: /guide/installation
    icon: i-lucide-arrow-right
    color: neutral
    size: xl
  - label: View on GitHub
    to: https://github.com/jwintz/kelyphos
    icon: simple-icons-github
    color: neutral
    variant: outline
    size: xl
---
::

::u-page-grid{class="lg:grid-cols-3 max-w-(--ui-container) mx-auto px-4 pb-24"}

:::u-page-card
---
spotlight: true
class: col-span-3 lg:col-span-1
to: /guide/shell-state
icon: i-lucide-layout-panel-left
---
#title
Multi-Panel Shell

#description
Navigator sidebar, detail content area, utility panel, and inspector — all in a single `KelyphosShellView`. One API, both platforms.
:::

:::u-page-card
---
spotlight: true
class: col-span-3 lg:col-span-1
to: /api/kelyphos-panel
icon: i-lucide-puzzle
---
#title
Type-Safe Panels

#description
Define panel tabs as enums conforming to `KelyphosPanel`. SF Symbols icons, keyboard shortcuts, and SwiftUI views — all in one place.
:::

:::u-page-card
---
spotlight: true
class: col-span-3 lg:col-span-1
to: /api/kelyphos-shell-state
icon: i-lucide-sliders-horizontal
---
#title
Observable State

#description
`KelyphosShellState` is `@Observable`. Drive visibility, appearance, vibrancy, and tab selection from anywhere in your app.
:::

:::u-page-card
---
spotlight: true
class: col-span-3 lg:col-span-1
to: /guide/appearance
icon: i-lucide-sparkles
---
#title
Liquid Glass

#description
NSVisualEffectView vibrancy on macOS, `.ultraThinMaterial` on iPadOS. Appearance presets from clear to solid. Dark mode synchronization built in.
:::

:::u-page-card
---
spotlight: true
class: col-span-3 lg:col-span-1
to: /guide/keybindings
icon: i-lucide-keyboard
---
#title
Keyboard Shortcuts

#description
`KelyphosCommands` provides `Cmd+0–9` for panels out of the box. Register custom shortcuts for your own commands with the keybinding overlay.
:::

:::u-page-card
---
spotlight: true
class: col-span-3 lg:col-span-1
to: /guide/demo
icon: i-lucide-monitor
---
#title
Demo App

#description
34 interactive HIG component pages across 8 sections. Browse, search, and bookmark components. Desktop widget in all four sizes.
:::

::
