---
title: Changelog
description: Release history and notable changes to Kelyphos
navigation:
  icon: i-lucide-history
  order: 98
order: 98
tags:
  - changelog
  - releases
---

All notable changes to Kelyphos are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

:changelog-versions{:versions='[{"title":"Unreleased","description":"Initial revision"}]'}

---

## Unreleased

### Added

- Initial release of KelyphosKit framework
- `KelyphosShellView` — multi-panel shell for macOS and iPadOS
- `KelyphosShellState` — `@Observable` state driving visibility, appearance, and panel selection
- `KelyphosPanel` protocol — type-safe panel tab definitions with SF Symbols and keyboard shortcuts
- `KelyphosCommands` — built-in keyboard shortcuts (`Cmd+0–9`, `Cmd+Opt+0–9`)
- `KelyphosSettingsView` — drop-in settings panel for appearance and keybindings
- `KelyphosDesign` — design constants for spacing, sizing, and typography
- `KelyphosFontStack` — built-in font families: SF Pro, SF Mono, Lilex, Geist Mono, Recursive
- Appearance presets: `clear`, `balanced`, `solid`
- `AppearancePreset` — one-call vibrancy + alpha configuration
- `KelyphosShellConfiguration` — navigator, inspector, utility tab arrays + detail view builder
- Desktop widget extension in Small / Medium / Large / Extra Large sizes
- KelyphosDemo — 34 interactive HIG component pages across 8 sections
- Widget integration with `WidgetCenter.shared.reloadAllTimelines()`
- iPadOS support: `.ultraThinMaterial` vibrancy, capped Dynamic Type, trailing inspector overlay
