import SwiftUI

enum Page : Hashable {
    case home, join, create, game
}

struct ContentView: View {
    @State private var path: [Page] = []
    @StateObject private var gameManager = GameManager()
    
    var body: some View {
        NavigationStack(path: $path) {
            HomePage(path: $path, gameManager: gameManager)
                .navigationDestination(for: Page.self) { page in 
                    switch page {
                    case .home:
                        HomePage(path: $path, gameManager: gameManager)
                    case .join:
                        JoinGame(path: $path, gameManager: gameManager)
                    case .create:
                        CreateGame(path: $path, gameManager: gameManager)
                    case .game:
                        GameView(gameManager: gameManager, path: $path)
                    }
                }
        }
    }
}
struct HomePage: View {
    @Binding var path: [Page]
    @ObservedObject var gameManager: GameManager
    
    func joinGame() {
        path.append(.join)
    }
    
    func createGame() {
        path.append(.create)
    }
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 16) {
                Text("MindLink")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                
                Text("Connect minds through creative answers")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            Spacer()
            
            VStack(spacing: 20) {
                Button(action: joinGame) {
                    HStack {
                        Image(systemName: "person.2.fill")
                        Text("Join Game")
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(12)
                }
                
                Button(action: createGame) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Create Game")
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
            
            Spacer()
        }
        .padding()
    }
}
struct JoinGame: View {
    @Binding var path: [Page]
    @ObservedObject var gameManager: GameManager
    @State private var gameCode = ""
    @State private var playerName = ""
    
    func goHome() {
        path = []
    }
    
    func joinGame() {
        if !gameCode.isEmpty && !playerName.isEmpty {
            gameManager.joinGame(gameCode: gameCode, playerName: playerName)
            path.append(.game)
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Join Game")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.purple)
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Name")
                        .font(.headline)
                    TextField("Enter your nickname", text: $playerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Game Code")
                        .font(.headline)
                    TextField("Enter 6-digit code", text: $gameCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
            }
            
            Button(action: joinGame) {
                Text("Join Game")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(gameCode.isEmpty || playerName.isEmpty ? Color.gray : Color.purple)
                    .cornerRadius(12)
            }
            .disabled(gameCode.isEmpty || playerName.isEmpty)
            
            Button(action: goHome) {
                Text("Back to Home")
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}
struct CreateGame: View {
    @Binding var path: [Page]
    @ObservedObject var gameManager: GameManager
    @State private var username: String = ""
    
    func goHome() {
        path = []
    }
    
    func createGame() {
        if !username.isEmpty {
            gameManager.createGame(hostName: username)
            path.append(.game)
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Create Game")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.purple)
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Name")
                        .font(.headline)
                    TextField("Enter your nickname", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            
            Button(action: createGame) {
                Text("Create Game")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(username.isEmpty ? Color.gray : Color.purple)
                    .cornerRadius(12)
            }
            .disabled(username.isEmpty)
            
            Button(action: goHome) {
                Text("Back to Home")
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}
#Preview {
    ContentView()
}
