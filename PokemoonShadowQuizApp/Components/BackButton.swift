//
//  BackButton.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 22/03/2026.
//
import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Text("← Back")
                    .font(.custom("Pokemon Classic", size: 14))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.retroButton)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.retroBorder, lineWidth: 2))
                    )
            }
            .buttonStyle(.plain)
            Spacer()
        }
    }
}

#Preview {
    BackButton()
}
