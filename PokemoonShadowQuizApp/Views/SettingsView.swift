//
//  SwiftUIView.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 14/07/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss

    @AppStorage("difficulty") private var selectedDifficulty: String = GameViewModel.Difficulty.medium.rawValue
    @AppStorage("showNameBeforeStart") private var showNameBeforeStart: Bool = false
    @AppStorage("highScore") private var highScore: Int = 0

    @State private var showResetAlert = false

    var body: some View {
        VStack(spacing: 24) {
            // Retro-style back button
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Text("← Back")
                        .font(.custom("Pokemon Classic", size: 14))
                        .foregroundColor(.black)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.retroButton)
                                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 2))
                        )
                }
                Spacer()
            }

            Text("Settings")
                .font(.custom("Pokemon Classic", size: 24))
                .foregroundColor(.black)

            // Difficulty
            settingsCard {
                Text("Difficulty")
                    .font(.custom("Pokemon Classic", size: 16))
                    .foregroundColor(.black)

                HStack(spacing: 12) {
                    ForEach(GameViewModel.Difficulty.allCases) { difficulty in
                        Button(action: {
                            selectedDifficulty = difficulty.rawValue
                        }) {
                            Text(difficulty.rawValue.capitalized)
                                .font(.custom("Pokemon Classic", size: 14))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(difficulty.rawValue == selectedDifficulty ? Color.green.opacity(0.7) : Color.retroButton)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(Color.black, lineWidth: 2)
                                        )
                                )
                        }
                    }
                }
            }

            // Training toggle
            settingsCard {
               
                RetroToggle(title: "Show name before start", isOn: $showNameBeforeStart)
                }

            Spacer()
        }
        .padding()
        .background(Color.retroSettingsBg.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }

    // Retro-stylizowana karta o pełnej szerokości
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
