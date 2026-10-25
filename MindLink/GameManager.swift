import Foundation
import SwiftUI

class GameManager: ObservableObject {
    @Published var game: Game?
    @Published var currentPlayer: Player?
    @Published var isHost: Bool = false
    
    private var timer: Timer?
    private let answerTimeLimit = 30
    private let votingTimeLimit = 20
    
    func createGame(hostName: String) {
        let host = Player(name: hostName)
        let newGame = Game(host: host)
        
        self.game = newGame
        self.currentPlayer = host
        self.isHost = true
        
        startGame()
    }
    
    func joinGame(gameCode: String, playerName: String) {
        let player = Player(name: playerName)
        self.currentPlayer = player
        self.isHost = false
        
        if game == nil {
            let mockHost = Player(name: "Host")
            var mockGame = Game(host: mockHost)
            mockGame.players.append(player)
            self.game = mockGame
        }
    }
    
    func startGame() {
        guard var game = game else { return }
        game.phase = .prompt
        game.round = 1
        self.game = game
        nextPrompt()
    }
    
    func nextPrompt() {
        guard var game = game else { return }
        
        game.currentPrompt = PromptLibrary.randomPrompt()
        game.phase = .answering
        game.answers = []
        game.timeRemaining = answerTimeLimit
        
        self.game = game
        startAnswerTimer()
    }
    
    func submitAnswer(_ text: String) {
        guard var game = game,
              let player = currentPlayer else { return }
        
        let answer = Answer(playerId: player.id, text: text)
        game.answers.append(answer)
        self.game = game
    }
    
    func startVoting() {
        guard var game = game else { return }
        
        game.phase = .voting
        game.timeRemaining = votingTimeLimit
        self.game = game
        startVotingTimer()
    }
    
    func voteForAnswer(_ answerId: String) {
        guard var game = game,
              let player = currentPlayer else { return }
        
        if let index = game.answers.firstIndex(where: { $0.id == answerId }) {
            game.answers[index].votes += 1
        }
        
        self.game = game
    }
    
    func revealResults() {
        guard var game = game else { return }
        
        game.phase = .reveal
        game.answers = game.answers.shuffled()
        self.game = game
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.calculateScores()
        }
    }
    
    func calculateScores() {
        guard var game = game else { return }
        
        for answer in game.answers {
            if let playerIndex = game.players.firstIndex(where: { $0.id == answer.playerId }) {
                game.players[playerIndex].score += answer.votes
            }
        }
        
        let mostPopularAnswer = game.answers.max(by: { $0.votes < $1.votes })
        if let popularAnswer = mostPopularAnswer {
            if let playerIndex = game.players.firstIndex(where: { $0.id == popularAnswer.playerId }) {
                game.players[playerIndex].score += 2
            }
        }
        
        self.game = game
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.nextRound()
        }
    }
    
    func nextRound() {
        guard var game = game else { return }
        
        game.round += 1
        
        if game.round > game.maxRounds {
            game.phase = .finished
        } else {
            nextPrompt()
        }
        
        self.game = game
    }
    
    private func startAnswerTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            guard var game = self.game else { return }
            
            game.timeRemaining -= 1
            
            if game.timeRemaining <= 0 {
                self.timer?.invalidate()
                self.startVoting()
            } else {
                self.game = game
            }
        }
    }
    
    private func startVotingTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            guard var game = self.game else { return }
            
            game.timeRemaining -= 1
            
            if game.timeRemaining <= 0 {
                self.timer?.invalidate()
                self.revealResults()
            } else {
                self.game = game
            }
        }
    }
    
    func resetGame() {
        timer?.invalidate()
        game = nil
        currentPlayer = nil
        isHost = false
    }
    
    func getPlayerName(for playerId: String) -> String {
        return game?.players.first { $0.id == playerId }?.name ?? "Unknown"
    }
    
    func getCurrentAnswer() -> Answer? {
        guard let player = currentPlayer else { return nil }
        return game?.answers.first { $0.playerId == player.id }
    }
    
    func hasSubmittedAnswer() -> Bool {
        return getCurrentAnswer() != nil
    }
}
