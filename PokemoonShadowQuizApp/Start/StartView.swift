//
//  StartView.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 14/07/2025.
//

import SwiftUI

enum Route: Hashable {
    case game
    case settings
    case highScores
}

struct StartView: View {
    var body: some View {
        NavigationStack {
                VStack(spacing: 30) {
                    Spacer()
                    MenuButton(title: "Start Game", value: .game)
                    MenuButton(title: "Settings", value: .settings)
                    MenuButton(title: "High Scores", value: .highScores)
                    Spacer()
                }
                .retroBackground()
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .game:       GameView()
                case .settings:   SettingsView()
                case .highScores: HighScoresView()
                }
            }
        }
    }
}

#Preview {
    StartView()
}
