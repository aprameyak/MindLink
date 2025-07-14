//
//  ContentView.swift
//  MindLink
//
//  Created by Aprameya Kannan on 6/29/25.
//

import SwiftUI
enum Page : Hashable {
    case home, join, create
}
struct ContentView: View {
    @State private var path: [Page] = []
    var body: some View {
        NavigationStack(path: $path) {
            HomePage(path: $path)
                .navigationDestination(for: Page.self) { page in switch page {
                case .home:
                    HomePage(path: $path)
                case .join:
                    JoinGame(path: $path)
                case .create:
                    CreateGame(path: $path)
                }
            }
        }
    }
}
struct HomePage: View {
    @Binding var path: [Page]
    func joinGame() {
        print("Join")
        path.append(.join)
    }
    func createGame() {
        print("Create")
        path.append(.create)
    }
    var body: some View {
        VStack {
            Text("MindLink")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                .foregroundColor(.purple)
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Button(action: joinGame) {
                Text("Join Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .background(Color.purple)
                    .cornerRadius(12)

            }
            Spacer()
            Button(action: createGame) {
                Text("Create Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .background(Color.purple)
                    .cornerRadius(12)
            }
        }
        .padding()
    }
}
struct JoinGame: View {
    @Binding var path: [Page]
    func goHome() {
        print("Home")
        path = []
    }
    var body: some View {
        Text("This is Join")
            .font(.largeTitle)
        Text("Enter game code here")
        Button(action: goHome) {
            Text("Go Home")
        }
    }
}
struct CreateGame: View {
    @Binding var path: [Page]
    @State private var username: String = ""
    func goHome() {
        print("Home")
        path = []
    }
    var body: some View {
        Text("This is Create")
            .font(.largeTitle)
        TextField("Enter your nickname", text: $username)
        Text("Game code here")
        Button(action: goHome) {
            Text("Go Home")
        }
    }
}
#Preview {
    ContentView()
}
