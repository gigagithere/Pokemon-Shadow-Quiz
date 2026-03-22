//
//  RetroToggle.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 15/07/2025.
//

import SwiftUI

struct RetroToggle: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(.custom("Pokemon Classic", size: 14))
                .foregroundColor(.black)

            Spacer()

            HStack(spacing: 0) {
                toggleButton(label: "OFF", isActive: !isOn) { isOn = false }
                toggleButton(label: "ON",  isActive:  isOn) { isOn = true  }
            }
            .background(Color.black)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 2))
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .padding()
    }

    private func toggleButton(label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.custom("Pokemon Classic", size: 13))
                .foregroundColor(isActive ? .white : Color(white: 0.4))
                .frame(width: 52, height: 34)
                .background(
                    isActive
                        ? Color.green.opacity(0.8)
                        : Color.retroGray
                )
                .overlay(
                    Rectangle()
                        .strokeBorder(
                            isActive
                                ? Color.black.opacity(0.5)
                                : Color.white.opacity(0.7),
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var isOn = false
    RetroToggle(title: "Switch it", isOn: $isOn)
}
