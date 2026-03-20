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
            Color(red: 0.98, green: 0.95, blue: 0.90) // kremowe tło
                .ignoresSafeArea()
        }
    }
}

#Preview {
    RetroBackgroundView()
}
