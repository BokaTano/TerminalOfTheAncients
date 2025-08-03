import ArgumentParser
import Foundation

@main
struct TerminalOfTheAncients: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Terminal of the Ancients - An interactive CLI adventure game",
        version: "1.0.0"
    )

    @Flag(name: .long, help: "Initialize the game and begin your journey")
    var initiate = false

    @Flag(name: .long, help: "Reset the game and start over")
    var reset = false

    @Flag(name: .long, help: "Show game status and progress")
    var status = false

    @Option(name: .long, help: "Jump to a specific puzzle (0-3)")
    var jump: Int?

    mutating func run() async throws {
        let dataService = try GameDataService()

        // Handle convenience commands first
        if reset {
            try await resetGame(dataService: dataService)
            return
        }

        if status {
            await showStatus(dataService: dataService)
            return
        }

        if let jumpPuzzle = jump {
            try await jumpToPuzzle(jumpPuzzle, dataService: dataService)
            return
        }

        // Handle --initiate flag (skip to puzzle 1)
        if initiate {
            try await dataService.advanceToNextPuzzle()

            print(
                "✅ Welcome Ritual completed! You have proven your knowledge of CLI argument parsing."
            )
            print("🔓 Access granted to the next chamber...")
            print()
            print("🎮 You can now continue your journey by running the game without flags.")
            return
        }

        // Start the interactive game
        try await startGame(dataService: dataService)
    }

    func startGame(dataService: GameDataService) async throws {
        let progress = try await dataService.loadOrCreateProgress()
        let tasks = WelcomeRitualPuzzle.allPuzzles

        // Main game loop
        while progress.currentTaskIndex < tasks.count {
            let currentTask = tasks[progress.currentTaskIndex]

            // Show task info for all puzzles
            print("📍 Current Location: Task \(progress.currentTaskIndex + 1) of \(tasks.count)")
            print()

            let completed = await playPuzzle(
                currentTask, progress: progress, dataService: dataService)
            if !completed {
                return  // User quit the game
            }

            // The task was completed, so the loop will continue to the next task
            // The progress.currentTaskIndex was already incremented in playTask
        }

        print("🎉 Congratulations! You have completed all the ancient trials!")
        print("You are now a master of the Terminal of the Ancients!")
    }

    private func playPuzzle(
        _ puzzle: Puzzle, progress: PlayerProgress, dataService: GameDataService
    ) async -> Bool {
        // Show puzzle description
        print("🧩 \(puzzle.title)")
        print("📝 \(puzzle.description)")

        do {
            if puzzle is GlyphMatrixPuzzle {
                try await dataService.seedGlyphMatrix()
            } else {
                try await puzzle.setup()
            }
        } catch {
            print("❌ Puzzle setup failed: \(error)")
            return false
        }

        while true {
            print("💭 Enter your answer (or 'hint' for help, 'quit' to exit):")
            guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("❌ No input available. Exiting...")
                return false
            }

            switch input.lowercased() {
            case "quit", "exit":
                print("👋 Farewell, digital archaeologist. Your progress has been saved.")
                return false

            case "hint":
                print("💡 Hint: \(puzzle.hint)")
                print()
                continue

            case "xyzzy":
                print("🌟 Nothing happens... or does it? You've discovered an ancient easter egg!")
                print()
                continue

            default:
                // Use the puzzle's validate method
                let isValid = await puzzle.validate(input: input)

                if isValid {
                    print("✅ Correct! The ancient terminal accepts your answer.")
                    print("🔓 Access granted to the next chamber...")
                    print()

                    try? await dataService.advanceToNextPuzzle()
                    return true
                } else {
                    print("❌ Incorrect. The ancient terminal rejects your answer.")
                    print("💡 Try again or type 'hint' for guidance.")
                    print()
                }
            }
        }
    }
}
