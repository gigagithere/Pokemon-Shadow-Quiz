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
                .font(.pokemon(16))
                .foregroundColor(.primary)

            Spacer()

            HStack(spacing: 12) {
                toggleButton(label: "OFF", isActive: !isOn) { isOn = false }
                toggleButton(label: "ON",  isActive:  isOn) { isOn = true  }
            }
        }
    }

    private func toggleButton(label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .retroPickerButton(isActive: isActive)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var isOn = false
    RetroToggle(title: "Switch it", isOn: $isOn)
}
