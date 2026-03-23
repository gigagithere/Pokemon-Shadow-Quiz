//
//  PokemonModelTests.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 23/03/2026.
//

import Testing
@testable import PokemoonShadowQuizApp

@Suite("Pokemon Model")
struct PokemonModelTests {
    @Test("Two pokemons with same name/image are not equal (different UUID)")
    func twoInstasncesAreNotEqual() {
        let a = Pokemon(name: "Pikachu", imageName: "pikachu")
        let b = Pokemon(name: "Pikachu", imageName: "pikachu")
        #expect(a != b)
    }
    
    @Test("Pokemon name and imageName are stored correctly")
    func propertiesAreStored() {
        let p = Pokemon(name: "Bulbasaur", imageName: "bulbasaur")
        #expect(p.name == "Bulbasaur")
        #expect(p.imageName == "bulbasaur")
    }
}
