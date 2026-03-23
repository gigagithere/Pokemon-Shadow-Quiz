//
//  GameView.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 14/07/2025.
//

import SwiftUI

struct GameView: View {
    @State private var viewModel = GameViewModel()
    @AppStorage("highScore") private var highScore: Int = 0
    @AppStorage("difficulty") private var selectedDifficulty: String = GameViewModel.Difficulty.medium.rawValue
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                HStack {
                    Lives(viewModel: viewModel)
                    
                    Spacer()
                    
                    Countdown(viewModel: viewModel)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Title()
                
                PokemonSilhouetteView(
                    pokemon: viewModel.correctPokemon,
                    isRevealed: viewModel.didSelectAnswer
                )
                
                Score(viewModel: viewModel)
                
                Answers(viewModel: viewModel)
            }
            
            GameOverPresenter(viewModel: viewModel, dismiss: { dismiss() })
        }
        .retroBackground()
        .onAppear {
            viewModel.difficulty = GameViewModel.Difficulty(rawValue: selectedDifficulty) ?? .medium
            viewModel.startGame()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
        .onChange(of: viewModel.score) { _, score in
            if score > highScore { highScore = score }
        }
        
    }
}

// MARK: - Subviews

private struct GameOverPresenter: View {
    let viewModel: GameViewModel
    let dismiss: () -> Void
    
    var body: some View {
        if viewModel.showGameOver {
            GameOverOverlay(score: viewModel.score) {
                withAnimation { viewModel.showGameOver = false }
                viewModel.startGame()
            } exitAction: {
                dismiss()
            }
            .zIndex(1)
        }
    }
}

private struct Score: View {
    let viewModel: GameViewModel
    
    var body: some View {
        Text("Score: \(viewModel.score)")
            .font(.pokemon(18))
            .foregroundStyle(.primary)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.retroCard)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.retroBorder, lineWidth: 2))
            )
    }
}

private struct Lives: View {
    let viewModel: GameViewModel
    
    var body: some View {
        HStack {
            ForEach(0..<3, id: \.self) { index in
                Image(viewModel.lives > index ? "heartfill" : "heartblank")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 54, height: 54)
                    .scaleEffect(viewModel.animateMissIndex == index ? 1.4 : 1.0)
                    .animation(.easeOut(duration: 0.2), value: viewModel.animateMissIndex)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
            }
        }
    }
}

private struct Countdown: View {
    let viewModel: GameViewModel
    
    var body: some View {
        Text("\(viewModel.timeRemaining)")
            .font(.pokemon(24))
            .foregroundStyle(.primary)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.retroCard)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.retroBorder, lineWidth: 2))
            )
    }
}

private struct Title: View {
    var body: some View {
        VStack(spacing: 4) {
            Text("Who's that")
                .font(.pokemon(24))
                .foregroundStyle(.primary)

            Text("Pokémon?")
                .font(.pokemon(32))
                .foregroundStyle(.primary)
        }
    }
}

private struct PokemonSilhouetteView: View {
    let pokemon: Pokemon?
    let isRevealed: Bool
    
    var body: some View {
        GeometryReader { geo in
            if let pokemon {
                Image(pokemon.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width)
                    .colorMultiply(isRevealed ? .white : .black)
                    .animation(.easeOut(duration: 0.3), value: isRevealed)
            }
        }
    }
}

private struct Answers: View {
    let viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.options.indices, id: \.self) { index in
                let option = viewModel.options[index]
                
                AnswerButton(
                    title: option.name,
                    state: viewModel.state(for: option),
                    action: { viewModel.choose(option) }
                )
                .id("\(option.name)-\(viewModel.score)")
            }
            .padding(.vertical, 5)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.retroCard)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.retroBorder, lineWidth: 2))
        )
        .padding()
    }
}

#Preview {
    GameView()
}
