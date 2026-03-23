//
//  DifficultyTests.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 23/03/2026.
//

import Testing
@testable import PokemoonShadowQuizApp

@Suite("Difficulty")
struct DifficultyTests {
    @Test("Time limit matches difficulty", arguments: [
        (GameViewModel.Difficulty.easy, 30),
        (GameViewModel.Difficulty.medium, 20),
        (GameViewModel.Difficulty.hard, 10),
    ])
    func timeLimitPerDifficulty(difficulty: GameViewModel.Difficulty, expected: Int)
    {
        #expect(difficulty.timeLimit == expected)
    }
    
    @Test("All difficulties have a positive time limit", arguments: GameViewModel.Difficulty.allCases)
    func allDifficultiesHavePositiveTimeLimit(difficulty: GameViewModel.Difficulty) {
        #expect(difficulty.timeLimit > 0)
    }
}
