# MindLink

A fun, creative party game app built with SwiftUI that connects minds through creative answers!

## How to Play

### Game Flow

1. **Create or Join a Game**
   - Host creates a game and gets a 6-digit code
   - Players join using the game code

2. **Prompt Phase**
   - A creative, open-ended question appears
   - Questions range from absurd to reflective

3. **Answer Phase** (30 seconds)
   - All players type their answers anonymously
   - Answers are submitted when time runs out

4. **Voting Phase** (20 seconds)
   - All answers are displayed (shuffled)
   - Players vote for their favorite answer
   - Can't vote for your own answer

5. **Reveal & Scoring**
   - Results are revealed with vote counts
   - Points awarded for votes received
   - "MindLink bonus" for voting for the most popular answer

6. **Next Round**
   - Game continues for 10 rounds
   - Final scores determine the winner

## Features

- **Real-time Game Flow**: Smooth transitions between game phases
- **Timer System**: Automatic progression with visual countdowns
- **Anonymous Voting**: Fair voting system
- **Score Tracking**: Points for votes and MindLink bonuses
- **Beautiful UI**: Modern SwiftUI design with purple theme
- **Multiple Prompts**: 20+ creative questions across different categories

## Technical Implementation

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **MVVM Pattern**: Clean separation of concerns
- **ObservableObject**: Reactive state management
- **NavigationStack**: Modern navigation system

### Key Components
- `GameManager`: Central game state management
- `Models.swift`: Data models for Game, Player, Answer, Prompt
- `GameView.swift`: Complete game interface with all phases
- `ContentView.swift`: Navigation and entry points

### Game Phases
- **Waiting**: Lobby for players to join
- **Prompt**: Display question
- **Answering**: Submit answers with timer
- **Voting**: Vote for favorite answers
- **Reveal**: Show results and scores
- **Finished**: Final leaderboard

## Game Rules

- **Minimum Players**: 2 players to start
- **Answer Time**: 30 seconds per question
- **Voting Time**: 20 seconds per round
- **Rounds**: 10 rounds per game
- **Scoring**: 
  - 1 point per vote received
  - 2 points MindLink bonus for voting for most popular answer

## UI Design

- **Color Scheme**: Purple primary with clean grays
- **Typography**: Clear hierarchy with bold headings
- **Layout**: Card-based design with rounded corners
- **Animations**: Smooth transitions between phases
- **Accessibility**: Clear labels and intuitive navigation

## Getting Started

1. Open `MindLink.xcodeproj` in Xcode
2. Build and run on iOS Simulator or device
3. Create a game or join with a code
4. Start playing with friends!

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## Ready to Play!

Your MindLink app is now complete with all the core functionality! The app includes:

- Complete game flow from lobby to final scores  
- Beautiful, modern UI with smooth animations  
- Timer system for answer and voting phases  
- Anonymous voting system  
- Score tracking with MindLink bonuses  
- 20+ creative prompts across different categories  
- Host and player roles  
- Game code system for joining  

The app is ready to build and run!
