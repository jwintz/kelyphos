---
title: About Kelyphos
description: Background and design philosophy behind the Kelyphos framework
icon: i-lucide-info
order: 99
navigation:
  title: About
  icon: i-lucide-info
  order: 99
---

Kelyphos (κέλυφος — Greek for shell or casing) is a SwiftUI framework that provides the outer structure for professional multi-panel applications on macOS and iPadOS.

## Motivation

Building an IDE-style shell in SwiftUI requires coordinating NavigationSplitView, `NSVisualEffectView`, `NSToolbar`, keyboard shortcuts, and per-platform layout differences. Kelyphos encapsulates that complexity behind a clean, type-safe API.

Rather than scaffolding the same chrome for every project, Kelyphos provides:

1. **A unified shell view** — one `KelyphosShellView` that handles navigator, editor, inspector, and utility panels
2. **Observable state** — `KelyphosShellState` drives the entire shell; pass it wherever you need panel control
3. **Type-safe panels** — define tabs as enums conforming to `KelyphosPanel`; the framework handles icons, shortcuts, and tab bars

## Design Philosophy

### Platform Adaptability

The same `KelyphosShellView` works on both macOS and iPadOS. Panel visibility, vibrancy materials, toolbar layout, and keyboard shortcuts all adapt to platform conventions automatically.

### Composability

Kelyphos is a shell, not an application framework. It makes no assumptions about your data model, navigation strategy, or feature set. Bring your own views, drop them into panel tabs, and the chrome handles the rest.

### Liquid Glass

Kelyphos targets macOS 26 Tahoe and iPadOS 26. Panels use `NSVisualEffectView` vibrancy on macOS and `.ultraThinMaterial` on iPadOS. Appearance presets — clear, balanced, solid — let you tune the look without writing material code.

## Credits

Kelyphos is used as the shell layer in [Kytos](../kytos) and [Hyalo](../hyalo).
