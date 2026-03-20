//
//  AnswerButton.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 15/07/2025.
//

import SwiftUI

struct AnswerButton: View {
    let title: String
    let isCorrect: Bool
    let isSelected: Bool
    let wasAnswered: Bool
    let action: () -> Void
    
    var showFlash: Bool {
        wasAnswered && isCorrect
    }

    var backgroundColor: Color {
        if wasAnswered {
            if isCorrect {
                return Color(red: 0.6, green: 0.8, blue: 0.45) // retro green
            } else if isSelected {
                return Color(red: 0.94, green: 0.4, blue: 0.4) // retro red
            }
        } else if isSelected {
            return Color(red: 0.95, green: 0.85, blue: 0.55) // zaznaczony retro-żółty
        }

        return Color(red: 0.98, green: 0.93, blue: 0.75) // default retro cream
    }

    var body: some View {
        Button(action: {
            if !wasAnswered {
                action()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(red: 0.18, green: 0.18, blue: 0.18))
                    .offset(y: 4)

                RoundedRectangle(cornerRadius: 4)
                    .fill(backgroundColor)
                    .opacity(showFlash ? 1.0 : 0.85)
                    .scaleEffect(showFlash ? 1.02 : 1.0)
                    .animation(.easeOut(duration: 0.2), value: showFlash)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.black, lineWidth: 2)
                    )

                Text(title.uppercased())
                    .font(.custom("Pokemon Classic", size: 18))
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
            }
            .frame(height: 54)
            .scaleEffect(isSelected ? 1.05 : 1.0) // efekt kliknięcia
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isSelected)
        }
        .disabled(wasAnswered)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}

#Preview {
    AnswerButton(
        title: "Poprawna Odpowiedz",
        isCorrect: true,
        isSelected: true,
        wasAnswered: true,
        action: { print("poprawna odpowiedz") }
    )
}

#Preview {
    AnswerButton(
        title: "Niepoprawna odpowiedz",
        isCorrect: false,
        isSelected: true,
        wasAnswered: true,
        action: { print("poprawna odpowiedz") }
    )
}
