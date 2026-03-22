//
//  SwiftUIView.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 14/07/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss

    @AppStorage("showNameBeforeStart") private var showNameBeforeStart: Bool = false
    @AppStorage("highScore") private var highScore: Int = 0

    @State private var showResetAlert = false

    var body: some View {
        VStack(spacing: 24) {
            BackButton()
            
            Text("Settings")
                .font(.custom("Pokemon Classic", size: 24))
                .foregroundColor(.black)

            settingsCard {
                DifficultyView()
            }

            settingsCard {
                RetroToggle(title: "Show name before start", isOn: $showNameBeforeStart)
            }

            Spacer()
        }
        .padding()
        .background(Color.retroSettingsBg.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    func settingsCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12, content: content)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.retroCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 2)
                    )
            )
    }
}

#Preview {
    SettingsView()

}
