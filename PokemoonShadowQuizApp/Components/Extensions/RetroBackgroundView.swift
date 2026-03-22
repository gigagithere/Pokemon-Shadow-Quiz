//
//  RetroBackgroundView.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 15/07/2025.
//
import SwiftUI

struct RetroBackgroundView: View {
    var body: some View {
        ZStack {
            Color.retroBackground
                .ignoresSafeArea()
        }
    }
}

#Preview {
    RetroBackgroundView()
}
