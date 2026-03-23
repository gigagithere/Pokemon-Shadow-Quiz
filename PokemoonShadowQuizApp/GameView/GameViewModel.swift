//
//  GameViewModel.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 14/07/2025.
//

import Observation
import SwiftUI

@Observable
@MainActor
class GameViewModel {
    var pokemons: [Pokemon] = [
        Pokemon(name: "Bulbasaur", imageName: "bulbasaur"),
        Pokemon(name: "Charmander", imageName: "charmander"),
        Pokemon(name: "Squirtle", imageName: "squirtle"),
        Pokemon(name: "Chikorita", imageName: "chikorita"),
        Pokemon(name: "Cyndaquil", imageName: "cyndaquil"),
        Pokemon(name: "Totodile", imageName: "totodile"),
        Pokemon(name: "Treecko", imageName: "treecko"),
        Pokemon(name: "Torchic", imageName: "torchic"),
        Pokemon(name: "Mudkip", imageName: "mudkip"),
        Pokemon(name: "Pikachu", imageName: "pikachu")
    ]

    var correctPokemon: Pokemon?
    var options: [Pokemon] = []
    var score = 0
    var timeRemaining: Int = 10
    var difficulty: Difficulty = .medium
    var isRoundLocked = false
    var lives = 3
    var selectedPokemon: Pokemon? = nil
    var gameOver = false
    var animateMissIndex: Int? = nil
    var showGameOver = false

    private var timerTask: Task<Void, any Error>?
    
    func startGame() {
        score = 0
        lives = 3
        gameOver = false
        showGameOver = false
        isRoundLocked = false
        nextRound()
    }

    func nextRound() {
        guard pokemons.count >= 4 else { return }

        selectedPokemon = nil

        correctPokemon = pokemons.randomElement()
        options = Array(pokemons.shuffled().prefix(3))

        if let correct = correctPokemon, !options.contains(correct) {
            options[0] = correct
        }

        options.shuffle()
        timeRemaining = difficulty.timeLimit
        startTimer()
    }

    func choose(_ pokemon: Pokemon) {
        guard !isRoundLocked else { return }

        stopTimer()
        isRoundLocked = true
        selectedPokemon = pokemon

        if pokemon == correctPokemon {
            score += 1
        } else {
            loseLife()
            if gameOver { return }
            animateMissIndex = lives
            Task {
                try? await Task.sleep(for: .milliseconds(400))
                animateMissIndex = nil
            }
        }

        timerTask = Task {
            try await Task.sleep(for: .seconds(1.5))
            isRoundLocked = false
            nextRound()
        }
    }

    private func startTimer() {
        stopTimer()
        timerTask = Task {
            while true {
                try await Task.sleep(for: .seconds(1))

                timeRemaining -= 1

                if timeRemaining == 0 {
                    loseLife()
                    if gameOver { return }

                    try await Task.sleep(for: .seconds(1.5))
                    isRoundLocked = false
                    nextRound()
                    return
                }
            }
        }
    }

    func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }
    
    func state(for option: Pokemon) -> AnswerState {
        guard isRoundLocked else {
            return option == selectedPokemon ? .selected : .idle
        }
        if option == correctPokemon { return .correct }
        if option == selectedPokemon { return .wrong }
        return .idle
    }

    private func loseLife() {
        lives -= 1
        if lives == 0 {
            stopTimer()
            gameOver = true
            Task {
                try? await Task.sleep(for: .seconds(1))
                withAnimation { showGameOver = true }
            }
        }
    }
     
 
    enum Difficulty: String, CaseIterable, Identifiable {
        case easy, medium, hard

        var id: String { rawValue }

        var timeLimit: Int {
            switch self {
            case .easy:   return 30
            case .medium: return 20
            case .hard:   return 10
            }
        }
    }
}
