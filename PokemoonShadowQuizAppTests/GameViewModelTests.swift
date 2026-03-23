//
//  GameViewModelTests.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 23/03/2026.
//

import Testing
@testable import PokemoonShadowQuizApp

@MainActor
@Suite("GameViewModel")
struct GameViewModelTests {
    let vm: GameViewModel

    init() {
        vm = GameViewModel()
        vm.stopTimer()
    }

    // MARK: - startGame

    @Test("startGame resets score to 0, reset lives to 3, sets gameOver to false and sets up a first round")
    func startGameReset() throws {
        vm.score = 99
        vm.lives = 1
        vm.gameOver = true
        vm.startGame()
        #expect(vm.score == 0)
        #expect(vm.lives == 3)
        #expect(vm.gameOver == false)
        let correct = try #require(vm.correctPokemon)
        #expect(vm.options.contains(correct))
    }

    // MARK: - nextRound

    @Test("nextRound always puts correctPokemon in options")
    func correctPokemonAlwaysInOptions() throws {
        for _ in 0..<20 {
            vm.stopTimer()
            vm.nextRound()
            let correct = try #require(vm.correctPokemon)
            #expect(vm.options.contains(correct))
        }
    }

    @Test("nextRound always produces exactly 3 options")
    func nextRoundProducesThreeOptions() {
        vm.nextRound()
        #expect(vm.options.count == 3)
    }

    @Test("nextRound clears selectedPokemon")
    func nextRoundClearsSelection() throws {
        vm.nextRound()
        let correct = try #require(vm.correctPokemon)
        vm.choose(correct)
        vm.stopTimer()
        vm.nextRound()
        #expect(vm.selectedPokemon == nil)
    }

    // MARK: - choose – correct answer

    @Test("Choosing correct pokemon increments score")
    func chooseCorrectIncreasesScore() throws {
        vm.nextRound()
        let correct = try #require(vm.correctPokemon)
        let scoreBefore = vm.score
        vm.choose(correct)
        #expect(vm.score == scoreBefore + 1)
    }

    @Test("Choosing correct pokemon does not reduce lives")
    func chooseCorrectDoesNotReduceLives() throws {
        vm.nextRound()
        let correct = try #require(vm.correctPokemon)
        vm.choose(correct)
        #expect(vm.lives == 3)
    }

    // MARK: - choose – wrong answer

    @Test("Choosing wrong pokemon decreases lives")
    func chooseWrongDecreasesLives() throws {
        vm.nextRound()
        let correct = try #require(vm.correctPokemon)
        let wrong = try #require(vm.options.first(where: { $0 != correct }))
        vm.choose(wrong)
        #expect(vm.lives == 2)
    }

    @Test("Choosing wrong pokemon does not increment score")
    func chooseWrongDoesNotIncrementScore() throws {
        vm.nextRound()
        let correct = try #require(vm.correctPokemon)
        let wrong = try #require(vm.options.first(where: { $0 != correct }))
        vm.choose(wrong)
        #expect(vm.score == 0)
    }

    // MARK: - choose – double tap guard

    @Test("Calling choose twice is ignored (guard didSelectAnswer)")
    func chooseTwiceIsIgnored() throws {
        vm.nextRound()
        let correct = try #require(vm.correctPokemon)
        vm.choose(correct)         // pierwsze kliknięcie
        vm.choose(correct)         // drugie – powinno być zignorowane
        #expect(vm.score == 1)     // tylko +1, nie +2
    }

    // MARK: - game over

    @Test("Three wrong answers cause gameOver")
    func threeWrongAnswersCauseGameOver() throws {
        for _ in 0..<3 {
            vm.stopTimer()
            vm.nextRound()
            vm.didSelectAnswer = false  // reset między rundami (choose ustawia na true, nextRound nie resetuje)

            let correct = try #require(vm.correctPokemon)
            let wrong = try #require(vm.options.first(where: { $0 != correct }))
            vm.choose(wrong)
        }

        #expect(vm.gameOver == true)
        #expect(vm.lives == 0)
    }

    // MARK: - nextRound – timeRemaining

    @Test("nextRound sets timeRemaining from difficulty", arguments: GameViewModel.Difficulty.allCases)
    func nextRoundSetsTimeRemaining(difficulty: GameViewModel.Difficulty) {
        vm.difficulty = difficulty
        vm.nextRound()
        #expect(vm.timeRemaining == difficulty.timeLimit)
    }

    // MARK: - choose – selectedPokemon

    @Test("choose sets selectedPokemon")
    func chooseSetsSelectedPokemon() throws {
        vm.nextRound()
        let correct = try #require(vm.correctPokemon)
        vm.choose(correct)
        #expect(vm.selectedPokemon == correct)
    }

    // MARK: - game over – last life

    @Test("Choosing wrong pokemon with 1 life causes gameOver")
    func lastWrongAnswerCausesGameOver() throws {
        vm.lives = 1
        vm.nextRound()
        let correct = try #require(vm.correctPokemon)
        let wrong = try #require(vm.options.first(where: { $0 != correct }))
        vm.choose(wrong)
        #expect(vm.gameOver == true)
        #expect(vm.lives == 0)
    }

    // MARK: - state(for:)

    @Test("state returns .idle before any answer")
    func stateIsIdleBeforeAnswer() throws {
        vm.nextRound()
        let option = try #require(vm.options.first)
        #expect(vm.state(for: option) == .idle)
    }

    @Test("state returns .correct for correct pokemon after answering")
    func stateIsCorrectForCorrectPokemon() throws {
        vm.nextRound()
        let correct = try #require(vm.correctPokemon)
        vm.choose(correct)
        #expect(vm.state(for: correct) == .correct)
    }

    @Test("state returns .wrong for selected wrong pokemon after answering")
    func stateIsWrongForSelectedWrongPokemon() throws {
        vm.nextRound()
        let correct = try #require(vm.correctPokemon)
        let wrong = try #require(vm.options.first(where: { $0 != correct }))
        vm.choose(wrong)
        try #require(vm.gameOver == false)
        #expect(vm.state(for: wrong) == .wrong)
    }

    @Test("state returns .idle for unselected wrong options after answering")
    func stateIsIdleForOtherOptions() throws {
        vm.nextRound()
        let correct = try #require(vm.correctPokemon)
        vm.choose(correct)
        let others = vm.options.filter { $0 != correct }
        for option in others {
            #expect(vm.state(for: option) == .idle)
        }
    }
}
