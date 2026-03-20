//
//  Untitled.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 14/07/2025.
//

import SwiftUI

struct PokemonButton<Destination: View>: View {
    let title: String
    let action: (() -> Void)?
    let destination: Destination?

    init(title: String, action: (() -> Void)? = nil, destination: Destination? = nil) {
        self.title = title
        self.action = action
        self.destination = destination
    }

    var body: some View {
        Group {
            if let destination = destination {
                NavigationLink(destination: destination) {
                    buttonContent
                }
                .buttonStyle(PlainButtonStyle())
            } else if let action = action {
                Button(action: action) {
                    buttonContent
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }

    private var buttonContent: some View {
        ZStack {
            // Tło: cień dolny (ciemniejszy odcień)
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(red: 0.18, green: 0.18, blue: 0.18)) // np. ciemnoszary cień
                .offset(y: 4)

            // Główna warstwa przycisku
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(red: 0.98, green: 0.93, blue: 0.75)) // kremowy przycisk
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(red: 0.13, green: 0.14, blue: 0.15), lineWidth: 2) // border retro
                )

            // Tekst
            Text(title.uppercased())
                .font(.custom("Pokemon Classic", size: 18))
                .foregroundColor(.black)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
        }
        .frame(height: 54)
    }
}

extension PokemonButton where Destination == EmptyView {
    init(title: String, action: (() -> Void)? = nil) {
        self.init(title: title, action: action, destination: nil)
    }
}

#Preview {
    PokemonButton<GameView>(title: "Start", destination: GameView())
}
