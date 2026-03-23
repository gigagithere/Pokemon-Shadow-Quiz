# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

**Build and run:**
```bash
xcodebuild -project PokemoonShadowQuizApp.xcodeproj -scheme PokemoonShadowQuizApp -destination 'platform=iOS Simulator,name=iPhone 16' build
```

**Run all tests:**
```bash
xcodebuild test -project PokemoonShadowQuizApp.xcodeproj -scheme PokemoonShadowQuizApp -destination 'platform=iOS Simulator,name=iPhone 16'
```

**Run a single test:**
```bash
xcodebuild test -project PokemoonShadowQuizApp.xcodeproj -scheme PokemoonShadowQuizApp -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing PokemoonShadowQuizAppTests/GameViewModelTests
```

## Architecture

**MVVM with SwiftUI + @Observable.** No external dependencies — pure native iOS.

### Navigation
`StartView` owns a `Route` enum (`game`, `settings`, `highScores`) and drives a `NavigationStack`. All three routes are child views pushed from `StartView`.

### State management
- `GameViewModel` is `@Observable` and `@MainActor`. Views observe it directly (no `@ObservedObject`/`@StateObject`).
- Persistent data (`isDarkMode`, `highScore`, `showNameBeforeStart`, `difficulty`) lives in `@AppStorage` — in `SettingsView` and `GameViewModel`.
- Dark mode preference is applied at the app root in `PokemoonShadowQuizAppApp.swift` via `.preferredColorScheme`.

### Game logic (`GameViewModel`)
- Hardcoded pool of 10 Gen 1–3 starter Pokémon.
- Each round: one correct Pokémon + 3 random wrong options, shuffled.
- Timer is a `Task` using `Task.sleep`; cancellation is tracked via a stored `Task` reference.
- `AnswerState` enum drives answer button appearance: `idle → selected → correct/wrong`.
- 3 lives; game over when lives reach 0. High score persisted via `@AppStorage`.

### Key file locations
| Concern | Path |
|---|---|
| Model | `Model/PokemonModel.swift` |
| Game logic | `PokemoonShadowQuizApp/GameView/GameViewModel.swift` |
| Game screen | `PokemoonShadowQuizApp/GameView/GameView.swift` |
| Start/nav | `PokemoonShadowQuizApp/Start/StartView.swift` |
| Settings | `PokemoonShadowQuizApp/Settings/SettingsView.swift` |
| Shared components | `PokemoonShadowQuizApp/Components/` |
| View extensions | `PokemoonShadowQuizApp/Components/Extensions/` and `Settings/Extensions/` |

### Styling conventions
- `retroBackground()` — view modifier applied to full-screen views for consistent background.
- `retroPickerButton(isActive:)` — view modifier for segmented-style picker buttons (used in `DifficultyView`).
- Custom fonts: `Pokemon Classic`, `Pokemon Hollow`, `Pokemon Solid` (registered in `Info.plist`).
- Portrait-only orientation.

## Tests

Uses **Swift Testing** (not XCTest) — `@Suite`, `@Test`, `#expect`, `#require` macros. Test files are in `PokemoonShadowQuizAppTests/`.
