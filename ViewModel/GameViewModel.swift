//
//  GameViewModel.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 14/07/2025.
//

import Foundation
import Observation

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
    var didSelectAnswer = false
    var lives = 3
    var selectedPokemon: Pokemon? = nil
    var gameOver = false

    private var timerTask: Task<Void, any Error>?
    
    func startGame() {
        score = 0
        lives = 3
        gameOver = false
        didSelectAnswer = false
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
        guard !didSelectAnswer else { return }

        stopTimer()
        didSelectAnswer = true
        selectedPokemon = pokemon

        if pokemon == correctPokemon {
            score += 1
        } else {
            loseLife()
            if gameOver { return }
        }

        timerTask = Task {
            try await Task.sleep(for: .seconds(1.5))
            didSelectAnswer = false
            nextRound()
        }
    }

    func startTimer() {
        stopTimer()
        timerTask = Task {
            while true {
                try await Task.sleep(for: .seconds(1))

                timeRemaining -= 1

                if timeRemaining == 0 {
                    loseLife()
                    if gameOver { return }

                    try await Task.sleep(for: .seconds(1.5))
                    didSelectAnswer = false
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
        guard didSelectAnswer else {
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
