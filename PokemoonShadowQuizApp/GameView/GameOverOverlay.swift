//
//  GameOverOverlay.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 15/07/2025.
//

import SwiftUI

struct GameOverOverlay: View {
    let score: Int
    let tryAgainAction: () -> Void
    let exitAction: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("You Lost!")
                    .font(.custom("Pokemon Classic", size: 28))
                    .foregroundColor(.white)

                Text("Your score: \(score)")
                    .font(.custom("Pokemon Classic", size: 20))
                    .foregroundColor(.white)

                Button(action: tryAgainAction) {
                    Text("Try Again")
                        .font(.custom("Pokemon Classic", size: 18))
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.retroButton)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                        )
                }
                

                Button(action: exitAction) {
                    Text("Exit to Main Menu")
                        .font(.custom("Pokemon Classic", size: 16))
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.retroGray)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                        )
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.retroDialogBg)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white, lineWidth: 2))
            )
            .padding(.horizontal, 40)
            .scaleEffect(1.1)
            .transition(.scale)
        }
    }
}

#Preview {
    GameOverOverlay(score: 2, tryAgainAction: {}, exitAction: {})
}
