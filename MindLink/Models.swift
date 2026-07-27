import Foundation

struct Game: Identifiable, Codable {
    let id: String
    var code: String
    var host: Player
    var players: [Player]
    var currentPrompt: Prompt?
    var answers: [Answer]
    var phase: GamePhase
    var round: Int
    var maxRounds: Int
    var timeRemaining: Int
    var isActive: Bool
    
    init(host: Player, maxRounds: Int = 10) {
        self.id = UUID().uuidString
        self.code = String(Int.random(in: 100000...999999))
        self.host = host
        self.players = [host]
        self.currentPrompt = nil
        self.answers = []
        self.phase = .waiting
        self.round = 0
        self.maxRounds = maxRounds
        self.timeRemaining = 0
        self.isActive = true
    }
}

struct Player: Identifiable, Codable {
    let id: String
    var name: String
    var score: Int
    var streak: Int
    var isConnected: Bool
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
        self.score = 0
        self.streak = 0
        self.isConnected = true
    }
}

struct Prompt: Identifiable, Codable {
    let id: String
    let text: String
    let category: PromptCategory
    
    init(text: String, category: PromptCategory) {
        self.id = UUID().uuidString
        self.text = text
        self.category = category
    }
}

struct Answer: Identifiable, Codable {
    let id: String
    let playerId: String
    let text: String
    var votes: Int
    var isRevealed: Bool
    
    init(playerId: String, text: String) {
        self.id = UUID().uuidString
        self.playerId = playerId
        self.text = text
        self.votes = 0
        self.isRevealed = false
    }
}

enum GamePhase: String, CaseIterable, Codable {
    case waiting = "waiting"
    case prompt = "prompt"
    case answering = "answering"
    case voting = "voting"
    case reveal = "reveal"
    case finished = "finished"
}

enum PromptCategory: String, CaseIterable, Codable {
    case absurd = "absurd"
    case reflective = "reflective"
    case creative = "creative"
    case funny = "funny"
}

struct PromptLibrary {
    static let prompts: [Prompt] = [
        Prompt(text: "What's the worst possible first date idea?", category: .absurd),
        Prompt(text: "If your group were a cult, what would it be called?", category: .absurd),
        Prompt(text: "What would be the most useless superpower?", category: .absurd),
        Prompt(text: "If you had to replace your hands with something else, what would it be?", category: .absurd),
        Prompt(text: "What's the weirdest thing you've ever eaten?", category: .absurd),
        Prompt(text: "What's something you wish you could tell your younger self?", category: .reflective),
        Prompt(text: "What's a moment that changed your perspective on life?", category: .reflective),
        Prompt(text: "What's something you're grateful for that others might not think of?", category: .reflective),
        Prompt(text: "What's a fear you've overcome?", category: .reflective),
        Prompt(text: "What's something you learned the hard way?", category: .reflective),
        Prompt(text: "If you could create a new holiday, what would it be?", category: .creative),
        Prompt(text: "What would be the title of your autobiography?", category: .creative),
        Prompt(text: "If you could have dinner with anyone, living or dead, who would it be?", category: .creative),
        Prompt(text: "What's a skill you wish you had?", category: .creative),
        Prompt(text: "If you could live anywhere in the world, where would it be?", category: .creative),
        Prompt(text: "What's the most embarrassing thing that's happened to you?", category: .funny),
        Prompt(text: "What's the weirdest dream you've ever had?", category: .funny),
        Prompt(text: "What's something you do that you know is weird?", category: .funny),
        Prompt(text: "What's the funniest thing you've seen a pet do?", category: .funny),
        Prompt(text: "What's a joke that always makes you laugh?", category: .funny)
    ]
    
    static func randomPrompt() -> Prompt {
        prompts.randomElement() ?? prompts[0]
    }
}
