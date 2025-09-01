# 🏛️ Terminal of the Ancients

An interactive CLI adventure game written in Swift, where you play as a digital archaeologist discovering ancient Swift code puzzles.

## 🎮 About

You are a digital archaeologist on the island of Texel. Hidden beneath the dunes, you discover an ancient CLI terminal — a remnant of a lost civilization of Swift developers. To unlock the secrets of their knowledge, you must complete puzzles encoded in Swift code.

Each puzzle grants you access to the next part of the story. Your progress is saved locally so you can return later and continue where you left off.

## 🚀 Getting Started

### Prerequisites

- Swift 6.2 or later
- macOS (for CLI development)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd TerminalOfTheAncients
```

2. Build and run the game:
```bash
./build_and_run.sh
```

The game will automatically start the required lighthouse server for the BeaconPuzzle.

## 🎯 How to Play

### Starting the Game

- **New Game**: Run `./build/debug/TOTA`
- **Reset Progress**: Use `--reset` flag
- **Check Status**: Use `--status` flag
- **Skip First Puzzle**: Use `--welcome` flag (for testing)

### Game Controls

- **Answer Puzzles**: Type your answer when prompted
- **Get Hints**: Type `hint` during a puzzle
- **Quit Game**: Type `quit` or `exit`
- **Easter Egg**: Type `xyzzy` for a surprise

## 🧩 Puzzles

The game features 4 unique puzzles that teach Swift programming concepts:

1. **Welcome Ritual** - Learn CLI help discovery and argument parsing
2. **The Shell Script Ritual** - Execute shell scripts with Subprocess
3. **Restore the Glyph Matrix** - SwiftData, Process execution, and ASCII reconstruction
4. **The Voice of the Lighthouse** - Real-time streaming, async/await, and data analysis

## 🏗️ Project Structure

```
TerminalOfTheAncients/
├── Sources/
│   └── terminal-of-the-ancients/
│       ├── Models.swift          # Data models and puzzle definitions
│       ├── GameEngine.swift      # Core game logic
│       ├── ASCIIArt.swift        # Visual effects and animations
│       ├── Sigil.swift           # First puzzle file
│       └── terminal_of_the_ancients.swift  # CLI entry point
├── Package.swift                 # Swift Package Manager configuration
└── README.md                     # This file
```

## 🛠️ Development

### Adding New Puzzles

Puzzles are defined in `Models.swift` in the `Puzzle.allPuzzles` array. Each puzzle has:

- `id`: Unique identifier
- `title`: Display name
- `description`: What the player needs to do
- `hint`: Help text when player types "hint"
- `solution`: The correct answer (for reference)
- `validator`: A closure that validates player input

### Building and Testing

```bash
# Build the project
swift build

# Run tests (if any)
swift test

# Run the game
.build/debug/TOTA
```

## 🎉 Acknowledgments

- Inspired by classic text adventure games
- Built with modern Swift features (SwiftData, ArgumentParser, async/await)
- ASCII art created with love for the terminal aesthetic

---

**Happy coding, digital archaeologist!** 🏛️✨ 