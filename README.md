# 🎮 Pokemoon Shadow Quiz

A native iOS quiz game where players identify Pokémon from their silhouettes — built with SwiftUI and modern Swift concurrency as a portfolio/learning project.

![Swift](https://img.shields.io/badge/Swift-6.0-orange?logo=swift)
![iOS](https://img.shields.io/badge/iOS-17%2B-blue?logo=apple)
![Xcode](https://img.shields.io/badge/Xcode-16%2B-147EFB?logo=xcode)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 🛠 Technologies Used

- **Swift**
- **SwiftUI**
- **Swift Observation** (`@Observable`)
- **Swift Concurrency** (`async/await`, `Task`)
- **AppStorage** (UserDefaults persistence)

---

## 📸 App Screenshots

| Start | Game | Settings(Dark mode) |
|-------|------|----------|
|<img width="250" height="736" alt="Start" src="https://github.com/user-attachments/assets/0983614a-8314-4b2a-aaa4-2ff3e30d27d2" /> | <img width="250" height="736" alt="Game" src="https://github.com/user-attachments/assets/4d0f4cfb-853f-446a-a7bf-99a97d45e3b7" /> |<img width="250" height="736" alt="Settings" src="https://github.com/user-attachments/assets/534e9ac9-e310-44ae-98ca-07fd53fe5d83" />
---

## 📋 General Info

Pokemoon Shadow Quiz presents the player with a silhouette of a Pokémon and four answer options. The player must identify the correct one before the timer runs out. Wrong answers and timeouts cost lives — lose all three and the game ends. The high score is persisted across sessions.

⚠️ This is a portfolio / learning project.

---

## 🚀 Features

- 🕵️ **Shadow reveal mechanic** — Pokémon silhouette animates to full color on answer
- ⏱ **Countdown timer per round** — implemented with `Task.sleep`, no `Timer` dependency
- ❤️ **3-lives system** — animated heart indicator on life loss
- 🏆 **Persistent high score** — stored via `@AppStorage`
- 🎮 **3 difficulty levels** — Easy (30s), Medium (20s), Hard (10s)
- 🌙 **Dark mode support** — user toggle, applied at app root
- 🎨 **Retro visual style** — custom Pokémon fonts, pixel-inspired color palette

---

## 🧠 Learning Goals

- **MVVM with `@Observable`** — adopting the modern Observation framework over `ObservableObject`
- **Swift Concurrency** — replacing `Timer` with structured `Task`/`async-await` patterns
- **SwiftUI component design** — extracting reusable view modifiers (`retroBackground()`, `retroCard()`, `retroPickerButton()`)
- **Access control discipline** — `private` on implementation details, clear public API surface
- **Single source of truth** — `@AppStorage` shared across views without prop drilling

---

## 🧪 Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/gigagithere/PokemoonShadowQuizApp.git
   ```
2. Open `PokemoonShadowQuizApp.xcodeproj` in Xcode 16+
3. Select a simulator or device (iPhone, iOS 17+)
4. Press **Cmd + R** to run

No external dependencies, no API keys required.

---

## 📁 Project Structure

```
PokemoonShadowQuizApp/
├── Model/
│   └── PokemonModel.swift          # Pokemon struct (Identifiable, Equatable)
│
├── PokemoonShadowQuizApp/
│   ├── GameView/
│   │   ├── GameView.swift          # Game screen + private subviews (Lives, Countdown, Score, Answers)
│   │   ├── GameViewModel.swift     # All game logic, timer, state machine
│   │   ├── GameOverOverlay.swift   # Game over modal
│   │   └── Components/
│   │       └── AnswerButton.swift  # Answer button with 4 states (idle/selected/correct/wrong)
│   │
│   ├── Start/
│   │   ├── StartView.swift         # Navigation root, Route enum
│   │   └── Components/
│   │       └── MenuButton.swift    # Main menu button
│   │
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   ├── Components/
│   │   │   ├── DifficultyView.swift    # Segmented difficulty picker
│   │   │   └── RetroToggle.swift       # Custom boolean toggle
│   │   └── Extensions/
│   │       └── RetroPickerButton+View.swift  # Picker button style modifier
│   │
│   ├── Views/
│   │   └── HighScoresView.swift    # Best score display
│   │
│   └── Components/
│       ├── BackButton.swift
│       └── Extensions/
│           ├── Background+View.swift   # retroBackground() modifier
│           └── Font+Pokemon.swift      # .pokemon(_ size:) font modifier
│
└── PokemoonShadowQuizAppTests/
    ├── GameViewModelTests.swift    # 17 tests covering game logic
    ├── DifficultyTests.swift
    └── PokemonModelTests.swift
```

---

## ✅ What's Done Well

- **`@Observable` + `@MainActor`** on `GameViewModel` — thread-safe state updates without `DispatchQueue.main` boilerplate
- **Task-based timer** — `timerTask` is a stored `Task` reference, cancelled cleanly on round end or view disappear; no `Timer.invalidate()` lifecycle management needed
- **`AnswerState` state machine** — `idle → selected → correct/wrong` drives button appearance declaratively, keeping all display logic out of the view
- **View modifier system** — `retroBackground()`, `retroCard()`, `.pokemon(_:)` create a consistent design language without repeated styling code
- **Swift Testing** — test suite uses modern `@Suite`/`@Test`/`#expect` macros, not XCTest
- **`private` access control** — implementation details like `startTimer()` and `loseLife()` are correctly hidden from consumers

---

## 💡 Room for Improvement

- **Expand Pokémon pool** — currently 10 hardcoded Gen 1–3 starters; could load from a local JSON or the [PokéAPI](https://pokeapi.co)
- **`difficulty` in `GameViewModel`** — currently read via `@AppStorage` in `GameView` and passed in `onAppear`; moving `@AppStorage("difficulty")` directly into the VM would eliminate the view as a coordinator
- **`ForEach` with indices** — `Answers` uses `ForEach(viewModel.options.indices, id: \.self)` with a string-based `.id()`; since `Pokemon` is `Identifiable` this could be simplified
- **No animations on score** — a small bump animation on score increment would improve game feel
- **Single high score** — no per-difficulty leaderboard; a player on Hard is compared against Easy scores
- **High Scores screen** (to be completed)

---

## 📄 Status

Project is: **Functional prototype — actively developed**

---

## ✉️ Contact

Created by **Bartosz Mrugała**
GitHub: [github.com/gigagithere](https://github.com/gigagithere)

---

## 📝 License

This project is licensed under the [MIT License](LICENSE).
