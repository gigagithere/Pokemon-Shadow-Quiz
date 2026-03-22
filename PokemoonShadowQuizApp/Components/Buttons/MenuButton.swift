//
//  PokemonButton.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 14/07/2025.
//

import SwiftUI

struct MenuButton: View {
    let title: String
    let value: Route

    var body: some View {
        NavigationLink(value: value) {
            PokemonButtonContent(title: title)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}

private struct PokemonButtonContent: View {
    let title: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.retroButtonShadow)
                .offset(y: 4)
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.retroButton)
                .stroke(Color.retroButtonBorder, lineWidth: 2)
            Text(title)
                .textCase(.uppercase)
                .font(.custom("Pokemon Classic", size: 18))
                .foregroundStyle(.black)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
        }
        .frame(height: 54)
    }
}

#Preview {
    NavigationStack {
        MenuButton(title: "Start", value: .game)
        MenuButton(title: "Settings", value: .settings)
        MenuButton(title: "High Scores", value: .highScores)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .game:       GameView()
                case .settings:   SettingsView()
                case .highScores: HighScoresView()
                }
            }
    }
}
