//
//  GameView.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 14/07/2025.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @AppStorage("highScore") private var highScore: Int = 0
    @AppStorage("difficulty") private var selectedDifficulty: String = GameViewModel.Difficulty.medium.rawValue

    @State private var animateMissIndex: Int? = nil
    @State private var showGameOver = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geo in
            ZStack {
                RetroBackgroundView()

                VStack(spacing: 16) {
                    // TIMER + LIVES
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            Image(viewModel.lives > index ? "heartfill" : "heartblank")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 54, height: 54)
                                .scaleEffect(animateMissIndex == index ? 1.4 : 1.0)
                                .animation(.easeOut(duration: 0.2), value: animateMissIndex)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                        }

                        Spacer()

                        Text("\(viewModel.timeRemaining)")
                            .font(.custom("Pokemon Classic", size: 24))
                            .foregroundColor(.black)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(red: 1.0, green: 0.98, blue: 0.88))
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                            )
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    Spacer()

                    // TYTUŁ
                    VStack(spacing: 4) {
                        Text("Who's that")
                            .font(.custom("Pokemon Classic", size: 24))
                            .foregroundColor(.black)

                        Text("Pokémon?")
                            .font(.custom("Pokemon Classic", size: 32))
                            .foregroundColor(.black)
                    }

                    // POKÉMON Z MASKĄ
                    if let correct = viewModel.correctPokemon {
                        ZStack {
                            Image(correct.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.5)

                            if !viewModel.didSelectAnswer {
                                Image(correct.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.5)
                                    .colorMultiply(.black)
                            }
                        }
                    }

                    // SCORE
                    Text("Score: \(viewModel.score)")
                        .font(.custom("Pokemon Classic", size: 18))
                        .foregroundColor(.black)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 1.0, green: 0.98, blue: 0.88))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                        )

                    // OPCJE
                    VStack(spacing: 8) {
                        ForEach(viewModel.options.indices, id: \.self) { index in
                            let option = viewModel.options[index]

                            AnswerButton(
                                title: option.name,
                                isCorrect: option == viewModel.correctPokemon,
                                isSelected: option == viewModel.selectedPokemon,
                                wasAnswered: viewModel.didSelectAnswer,
                                action: {
                                    viewModel.choose(option)

                                    if option != viewModel.correctPokemon {
                                        animateMissIndex = viewModel.lives
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            animateMissIndex = nil
                                        }
                                    }

                                    if viewModel.score > highScore {
                                        highScore = viewModel.score
                                    }
                                }
                            )
                            .id("\(option.name)-\(viewModel.score)") // 👈 unikalne ID dla każdej rundy
                        }
                        .padding(.vertical, 5)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 1.0, green: 0.98, blue: 0.88))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                    )
                    .padding()

                    Spacer(minLength: 8)
                }
            }
            .onAppear {
                viewModel.difficulty = GameViewModel.Difficulty(rawValue: selectedDifficulty) ?? .medium
                viewModel.startGame()
            }
            .onDisappear {
                viewModel.stopTimer()
            }
            .onReceive(viewModel.$isGameOver) { isOver in
                if isOver {
                    viewModel.stopTimer()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation {
                            showGameOver = true
                        }
                    }
                }
            }
            if showGameOver {
                GameOverOverlay(score: viewModel.score) {
                    // Try Again
                    withAnimation {
                        showGameOver = false
                    }
                    viewModel.startGame()
                } exitAction: {
                    // Exit to main menu
                    presentationMode.wrappedValue.dismiss()
                }
                .zIndex(1) // <- zapewnia, że nakładka jest na wierzchu
            }
        }
    }
}

#Preview {
    GameView()
}
