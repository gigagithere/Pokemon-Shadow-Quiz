//
//  HighScoresView.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 14/07/2025.
//

import Foundation
import SwiftUI

struct HighScoresView: View {
    @AppStorage("highScore") private var highScore: Int = 0
    @AppStorage("difficulty") private var selectedDifficulty: String = GameViewModel.Difficulty.medium.rawValue

    var body: some View {
        VStack {
            Text("High Score")
                .font(.custom("Pokemon Solid", size: 32))
                .padding()
            Text("\(highScore) Points (\(selectedDifficulty.capitalized))")
                .font(.title2)
        }
        .navigationTitle("Records")
    }
}

#Preview {
    HighScoresView()
}
