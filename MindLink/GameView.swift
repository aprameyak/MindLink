import SwiftUI

struct GameView: View {
    @ObservedObject var gameManager: GameManager
    @Binding var path: [Page]
    
    var body: some View {
        VStack {
            if let game = gameManager.game {
                GameHeader(game: game, gameManager: gameManager)
                
                Spacer()
                
                switch game.phase {
                case .waiting:
                    WaitingView(game: game, gameManager: gameManager)
                case .prompt:
                    PromptView(game: game, gameManager: gameManager)
                case .answering:
                    AnsweringView(game: game, gameManager: gameManager)
                case .voting:
                    VotingView(game: game, gameManager: gameManager)
                case .reveal:
                    RevealView(game: game, gameManager: gameManager)
                case .finished:
                    FinishedView(game: game, gameManager: gameManager, path: $path)
                }
                
                Spacer()
            } else {
                Text("Loading game...")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

struct GameHeader: View {
    let game: Game
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Round \(game.round)/\(game.maxRounds)")
                    .font(.headline)
                    .foregroundColor(.purple)
                
                Spacer()
                
                if gameManager.isHost {
                    Text("Host")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            if game.timeRemaining > 0 {
                HStack {
                    Image(systemName: "clock")
                    Text("\(game.timeRemaining)s")
                }
                .font(.subheadline)
                .foregroundColor(.orange)
            }
            
            Text("Game Code: \(game.code)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct WaitingView: View {
    let game: Game
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Waiting for Players")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Share this code with friends:")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text(game.code)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.purple)
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Players (\(game.players.count)):")
                    .font(.headline)
                
                ForEach(game.players) { player in
                    HStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        Text(player.name)
                        Spacer()
                        if player.id == game.host.id {
                            Text("Host")
                                .font(.caption)
                                .foregroundColor(.purple)
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            if gameManager.isHost && game.players.count >= 2 {
                Button("Start Game") {
                    gameManager.startGame()
                }
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple)
                .cornerRadius(12)
            }
        }
    }
}

struct PromptView: View {
    let game: Game
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Get Ready!")
                .font(.title)
                .fontWeight(.bold)
            
            if let prompt = game.currentPrompt {
                Text(prompt.text)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(12)
            }
            
            Text("The question will appear in a moment...")
                .font(.headline)
                .foregroundColor(.gray)
        }
    }
}

struct AnsweringView: View {
    let game: Game
    @ObservedObject var gameManager: GameManager
    @State private var answerText = ""
    
    var body: some View {
        VStack(spacing: 20) {
            if let prompt = game.currentPrompt {
                Text(prompt.text)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Answer:")
                    .font(.headline)
                
                TextField("Type your answer here...", text: $answerText, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(3...6)
            }
            
            HStack {
                Button("Submit Answer") {
                    if !answerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        gameManager.submitAnswer(answerText)
                    }
                }
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(answerText.isEmpty ? Color.gray : Color.purple)
                .cornerRadius(12)
                .disabled(answerText.isEmpty)
            }
            
            if gameManager.hasSubmittedAnswer() {
                Text("Answer submitted! Waiting for others...")
                    .font(.headline)
                    .foregroundColor(.green)
            }
        }
    }
}

struct VotingView: View {
    let game: Game
    @ObservedObject var gameManager: GameManager
    @State private var selectedAnswerId: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Vote for Your Favorite!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Choose the answer you like most (can't vote for your own)")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(game.answers) { answer in
                        let isOwnAnswer = answer.playerId == gameManager.currentPlayer?.id
                        
                        Button(action: {
                            if !isOwnAnswer {
                                selectedAnswerId = answer.id
                                gameManager.voteForAnswer(answer.id)
                            }
                        }) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(answer.text)
                                    .font(.body)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.primary)
                                
                                if isOwnAnswer {
                                    Text("Your answer")
                                        .font(.caption)
                                        .foregroundColor(.purple)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(
                                isOwnAnswer ? Color.gray.opacity(0.3) :
                                selectedAnswerId == answer.id ? Color.purple.opacity(0.3) :
                                Color.gray.opacity(0.1)
                            )
                            .cornerRadius(12)
                        }
                        .disabled(isOwnAnswer)
                    }
                }
            }
            
            if selectedAnswerId != nil {
                Text("Vote submitted! Waiting for others...")
                    .font(.headline)
                    .foregroundColor(.green)
            }
        }
    }
}

struct RevealView: View {
    let game: Game
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Results!")
                .font(.title)
                .fontWeight(.bold)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(game.answers.sorted(by: { $0.votes > $1.votes })) { answer in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(answer.text)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                            
                            HStack {
                                Text(gameManager.getPlayerName(for: answer.playerId))
                                    .font(.caption)
                                    .foregroundColor(.purple)
                                
                                Spacer()
                                
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                    Text("\(answer.votes)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
}

struct FinishedView: View {
    let game: Game
    @ObservedObject var gameManager: GameManager
    @Binding var path: [Page]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Game Over!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Final Scores")
                .font(.headline)
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(game.players.sorted(by: { $0.score > $1.score })) { player in
                        HStack {
                            Text(player.name)
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("\(player.score)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
            
            Button("Play Again") {
                gameManager.resetGame()
                path = []
            }
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.purple)
            .cornerRadius(12)
        }
    }
}

