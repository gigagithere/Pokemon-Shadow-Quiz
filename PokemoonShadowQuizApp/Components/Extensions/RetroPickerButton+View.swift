//
//  RetroPickerButton+View.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 22/03/2026.
//

import SwiftUI

private struct RetroPickerButtonModifier: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .font(.custom("Pokemon Classic", size: 14))
            .foregroundColor(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(isActive ? Color.retroActive : Color.retroButton)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.black, lineWidth: 2)
                    )
            )
    }
}

extension View {
    func retroPickerButton(isActive: Bool) -> some View {
        modifier(RetroPickerButtonModifier(isActive: isActive))
    }
}
