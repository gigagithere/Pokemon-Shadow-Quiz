//
//  RetroBackgroundView.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 22/03/2026.
//

import SwiftUI

extension View {
    func retroBackground() -> some View {
        self.background(Color.retroBackground.ignoresSafeArea())
    }
}
