//
//  PokemonModel.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 14/07/2025.
//

import Foundation

struct Pokemon: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String
}
