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
                                .fill(Color(red: 0.98, green: 0.93, blue: 0.75))
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
                                        .fill(difficulty.rawValue == selectedDifficulty ? Color.green.opacity(0.7) : Color(red: 0.98, green: 0.93, blue: 0.75))
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
        .background(Color(red: 0.96, green: 0.94, blue: 0.85).ignoresSafeArea())
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
                    .fill(Color(red: 1.0, green: 0.98, blue: 0.88))
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
