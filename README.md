# Terminal of the Ancients

An interactive CLI adventure game where you play as a digital archaeologist discovering an ancient Swift terminal on the island of Texel.

## 🎮 Story

You are a digital archaeologist on the island of Texel. Hidden beneath the dunes, you discover an ancient CLI terminal — a remnant of a lost civilization of Swift developers. To unlock the secrets of their knowledge, you must complete puzzles encoded in Swift code.

Each puzzle grants you access to the next part of the story. Your progress is saved locally using SwiftData so you can return later and continue where you left off.

## 🚀 Features

- **Interactive CLI Adventure**: Solve puzzles through command-line interaction
- **Progress Persistence**: Your progress is automatically saved using SwiftData
- **Multiple Challenges**: 5 unique puzzles testing different Swift concepts
- **ASCII Art**: Beautiful terminal-based UI with banners and emojis
- **Hints System**: Get help when stuck on puzzles
- **Easter Eggs**: Discover hidden secrets throughout the game

## 📋 Requirements

- macOS 14.0+ (Sonoma or later)
- Swift 6.2+

## 🛠️ Installation

1. Clone or navigate to the project directory
2. Build the project:
   ```bash
   swift build
   ```
3. Run the executable:
   ```bash
   .build/debug/terminal-of-the-ancients
   ```

## 🎯 How to Play

### Starting the Game

```bash
# Start a new game
./terminal-of-the-ancients --initiate

# Check your progress
./terminal-of-the-ancients --status

# Reset the game (start over)
./terminal-of-the-ancients --reset
```

### Game Commands

During gameplay, you can use these commands:
- `hint` - Get a hint for the current puzzle
- `quit` or `exit` - Save and exit the game
- `xyzzy` - Discover an easter egg

## 🧩 Puzzles

### 1. Welcome Ritual
**Concept**: CLI Argument Parsing  
**Challenge**: Launch the program with the correct flag to begin your journey.

### 2. The Echo Chamber
**Concept**: `readLine()` and Input/Output  
**Challenge**: Echo back exactly what the terminal says to you.

### 3. The File of Truth
**Concept**: File Reading  
**Challenge**: Read a text file and extract the secret code hidden within.

### 4. The JSON Codex
**Concept**: `Codable` and JSON Decoding  
**Challenge**: Decode a JSON file to find the required answer.

### 5. The Vault Gate
**Concept**: String Manipulation and Pattern Recognition  
**Challenge**: Recover correct content from corrupted data by replacing numbers with letters.

## 💾 Data Persistence

The game uses SwiftData to automatically save your progress locally. This means:
- Your progress is preserved between game sessions
- You can quit and return later to continue where you left off
- Progress is stored in your app's container directory

## 🎨 Technical Details

### Architecture
- **SwiftData**: Local database storage for player progress
- **ArgumentParser**: Robust CLI argument handling
- **Async/Await**: Modern Swift concurrency for smooth gameplay
- **Modular Design**: Clean separation of concerns with dedicated game engine

### File Structure
```
Sources/terminal-of-the-ancients/
├── terminal_of_the_ancients.swift  # Main CLI entry point
├── GameEngine.swift                # Core game logic
└── Models.swift                    # SwiftData models
```

## 🐛 Troubleshooting

### Common Issues

1. **"No game progress found"**
   - Use `--initiate` to start a new game

2. **Permission errors with file creation**
   - Ensure you have write permissions in the current directory

3. **SwiftData errors**
   - Try using `--reset` to clear corrupted data

### Debug Mode

For development, you can add debug prints by modifying the source code. The game includes comprehensive error handling and will provide clear feedback for most issues.

## 🎉 Easter Eggs

- Type `xyzzy` during gameplay for a special message
- Look for hidden patterns in the ASCII art
- Check the file timestamps for additional lore

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add new puzzles or improve existing ones
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🏆 Completion

Once you complete all puzzles, you'll be recognized as a master of the Terminal of the Ancients and gain access to the secrets of the lost Swift civilization!

---

*"In the depths of Texel's dunes, the ancient terminal awaits those worthy of its knowledge..."* 