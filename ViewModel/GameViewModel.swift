//
//  GameViewModel.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 14/07/2025.
//

import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var pokemons: [Pokemon] = [
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

    @Published var correctPokemon: Pokemon?
    @Published var options: [Pokemon] = []
    @Published var score = 0
    @Published var timeRemaining: Int = 10
    @Published var difficulty: Difficulty = .medium
    @Published var didSelectAnswer = false
    @Published var lives = 3
    @Published var selectedPokemon: Pokemon? = nil
    @Published var isGameOver = false
    
    var timer: Timer?

    func startGame() {
        score = 0
        lives = 3
        didSelectAnswer = false
        nextRound()
    }

    func nextRound() {
        guard pokemons.count >= 4 else { return }
        
        // 👉 Resetuj flagę
        didSelectAnswer = false
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
        didSelectAnswer = true
        selectedPokemon = pokemon

        if pokemon == correctPokemon {
            score += 1
        } else {
            lives -= 1
            if lives == 0 {
                stopTimer()
                isGameOver = true
                // Można tu aktywować ekran przegranej, np. przez binding
                return
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.didSelectAnswer = false
            self.nextRound()
        }
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeRemaining -= 1
            if self.timeRemaining == 0 {
                self.lives -= 1
                self.didSelectAnswer = true

                if self.lives == 0 {
                    self.stopTimer()
                    self.isGameOver = true
                    // Możesz tu wywołać np. binding do GameOverView
                    return
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.didSelectAnswer = false
                    self.nextRound()
                }
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
    }

    enum Difficulty: String, CaseIterable, Identifiable {
        case easy, medium, hard

        var id: String { self.rawValue }
        var timeLimit: Int {
            switch self {
            case .easy: return 30
            case .medium: return 20
            case .hard: return 10
            }
        }
    }
}

