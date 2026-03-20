//
//  StartView.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 14/07/2025.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        ZStack {
            RetroBackgroundView()

            VStack(spacing: 30) {
                Spacer()
                PokemonButton(title: "Start Game", destination: GameView())
                PokemonButton(title: "Settings", destination: SettingsView())
                PokemonButton(title: "High Scores", destination: HighScoresView())
                Spacer()
            }
        }
    }
}

#Preview {
    StartView()
}
