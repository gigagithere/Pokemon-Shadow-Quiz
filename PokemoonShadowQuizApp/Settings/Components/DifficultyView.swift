//
//  DifficultyView.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 22/03/2026.
//

import SwiftUI

struct DifficultyView: View {
    
    @AppStorage("difficulty") private var selectedDifficulty: String = GameViewModel.Difficulty.medium.rawValue
    
    var body: some View {
        Text("Difficulty")
            .font(.custom("Pokemon Classic", size: 16))
            .foregroundColor(.primary)
        
        HStack(spacing: 12) {
            ForEach(GameViewModel.Difficulty.allCases) { difficulty in
                Button(action: {
                    selectedDifficulty = difficulty.rawValue
                }) {
                    Text(difficulty.rawValue.capitalized)
                        .retroPickerButton(isActive: difficulty.rawValue == selectedDifficulty)
                }
            }
        }
    }
}

#Preview {
    DifficultyView()
}
