//
//  AnswerButton.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 15/07/2025.
//

import SwiftUI

enum AnswerState {
    case idle
    case selected
    case correct
    case wrong
}

struct AnswerButton: View {
    let title: String
    let state: AnswerState
    let action: () -> Void

    var backgroundColor: Color {
        switch state {
        case .idle:     return .retroButton
        case .selected: return .retroSelected
        case .correct:  return .retroCorrect
        case .wrong:    return .retroWrong
        }
    }

    var body: some View {
        Button(action: {
            if state == .idle {
                action()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.retroButtonShadow)
                    .offset(y: 4)

                RoundedRectangle(cornerRadius: 4)
                    .fill(backgroundColor)
                    .opacity(state == .correct ? 1.0 : 0.85)
                    .animation(.easeOut(duration: 0.2), value: state == .correct)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.retroBorder, lineWidth: 2)
                    )

                Text(title.uppercased())
                    .font(.custom("Pokemon Classic", size: 18))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
            }
            .frame(height: 54)
            .scaleEffect(state == .selected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: state == .selected)
        }
        .disabled(state != .idle)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}

#Preview {
    VStack {
        AnswerButton(title: "Poprawna", state: .correct, action: {})
        AnswerButton(title: "Zła", state: .wrong, action: {})
        AnswerButton(title: "Zaznaczona", state: .selected, action: {})
        AnswerButton(title: "Domyślna", state: .idle, action: {})
    }
}
