# MindLink

![Swift](https://img.shields.io/badge/Swift-F05138?logo=swift&logoColor=white&style=for-the-badge)
![SwiftUI](https://img.shields.io/badge/SwiftUI-0D96F6?logo=swift&logoColor=white&style=for-the-badge)

## About

**MindLink** is an iOS party game app built with **SwiftUI** where players compete by answering creative prompts and voting on each other's responses. Games are hosted with a 6-digit code, and bonus points are awarded to players who both give and vote for the most popular answer — the "MindLink."

## Features

- Host/join game flow using a shareable 6-digit room code
- Five distinct game phases: lobby, prompt display, timed answering (30s), anonymous voting (20s), and score reveal
- 20+ creative open-ended prompts spanning absurd and reflective categories
- Anonymous answer shuffling so players can't identify each other's submissions
- MindLink bonus scoring that rewards players who vote with the crowd
- 10-round game structure with a final leaderboard at the end
- MVVM architecture with ObservableObject-based reactive state management

## Technology Stack

- **Mobile**: Swift, SwiftUI
- **Architecture**: MVVM, ObservableObject, NavigationStack
