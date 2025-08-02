import ArgumentParser
import Foundation
import SwiftData

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
        let modelContainer = try ModelContainer(for: PlayerProgress.self, Glyph.self)
        let modelContext = ModelContext(modelContainer)
        let gameEngine = GameEngine(modelContext: modelContext)

        // Handle special commands first
        if reset {
            try await gameEngine.resetGame()
            return
        }

        if status {
            await showStatus(modelContext: modelContext)
            return
        }

        if let jumpPuzzle = jump {
            try await jumpToPuzzle(jumpPuzzle, modelContext: modelContext)
            return
        }

        // Check if this is the first task (Welcome Ritual)
        let descriptor = FetchDescriptor<PlayerProgress>()
        let existingProgress = try modelContext.fetch(descriptor)
        let progress = existingProgress.first ?? PlayerProgress()

        if progress.currentTaskIndex == 0 && !initiate {
            print(
                """

                ╔══════════════════════════════════════════════════════════════╗
                ║                    🏛️  TERMINAL OF THE ANCIENTS  🏛️           ║
                ║                                                              ║
                ║                  ___            %.                           ║
                ║           __  __/__/I__  ______% %%'                         ║
                ║          / __/_[___]/_/I--.   /%%%%                          ║
                ║         / /  I_/=/I__I/  /I  // )(                           ║
                ║        / /____/=/ /_____//  //                               ║
                ║       /  I___/=/ /_____I/  //                                ║
                ║      /______/=/ /_________//                                 ║
                ║      I_____/=/ /_________I/MJP                               ║
                ║           /=/_/                                              ║
                ║                                                              ║
                ║  Welcome, digital archaeologist!                             ║
                ║                                                              ║
                ║  You stand before the ancient temple, its weathered          ║
                ║  stones bearing the marks of countless centuries.            ║
                ║  The ancient terminal awaits your command...                 ║
                ║                                                              ║
                ║  > "To begin your journey, you must first prove you          ║
                ║  > understand the ancient CLI ways. Discover the             ║
                ║  > available commands to proceed."                           ║
                ║                                                              ║
                ║  You must first demonstrate your knowledge of                ║
                ║  command-line argument parsing.                              ║
                ║                                                              ║
                ║  Press Enter to begin your journey...                        ║
                ╚══════════════════════════════════════════════════════════════╝

                """)

            // Wait for user input and then start the game
            _ = readLine()
        }

        // Handle --initiate flag (complete Welcome Ritual automatically)
        if initiate && progress.currentTaskIndex == 0 {
            print(
                "✅ Welcome Ritual completed! You have proven your knowledge of CLI argument parsing."
            )
            print("🔓 Access granted to the next chamber...")
            print()

            // Show ASCII art for puzzle completion
            await ASCIIArt.showChamberUnlocked(taskId: 0)

            // If this is a new progress object, insert it into the context
            if existingProgress.isEmpty {
                modelContext.insert(progress)
            }

            progress.completedTasks.insert(0)
            progress.currentTaskIndex += 1
            progress.lastPlayed = Date()

            try modelContext.save()

            print("🎮 You can now continue your journey by running the game without flags.")
            return
        }

        // Start the interactive game
        try await gameEngine.startGame()
    }

    private func showStatus(modelContext: ModelContext) async {
        let descriptor = FetchDescriptor<PlayerProgress>()
        do {
            let existingProgress = try modelContext.fetch(descriptor)
            if let progress = existingProgress.first {
                let tasks = Puzzle.allPuzzles
                print(
                    """

                    📊 GAME STATUS
                    ──────────────────────────────────────────────────────────
                    🎮 Current Task: \(progress.currentTaskIndex + 1) of \(tasks.count)
                    ✅ Completed Tasks: \(progress.completedTasks.count)/\(tasks.count)
                    📅 Last Played: \(progress.lastPlayed.formatted())
                    🕐 Created: \(progress.createdAt.formatted())

                    """)

                if progress.currentTaskIndex < tasks.count {
                    let currentTask = tasks[progress.currentTaskIndex]
                    print("🔮 Current Challenge: \(currentTask.title)")
                    print("📜 Description: \(currentTask.description)")
                } else {
                    print(
                        "🎉 All tasks completed! You are a master of the Terminal of the Ancients!")
                }
            } else {
                print("❌ No game progress found. Use --initiate to start a new game.")
            }
        } catch {
            print("❌ Error loading game status: \(error)")
        }
    }

    private func jumpToPuzzle(_ puzzleId: Int, modelContext: ModelContext) async throws {
        let tasks = Puzzle.allPuzzles

        guard puzzleId >= 0 && puzzleId < tasks.count else {
            print("❌ Invalid puzzle ID. Available puzzles: 0-\(tasks.count - 1)")
            return
        }

        let descriptor = FetchDescriptor<PlayerProgress>()
        let existingProgress = try modelContext.fetch(descriptor)
        let progress = existingProgress.first ?? PlayerProgress()

        // If this is a new progress object, insert it into the context
        if existingProgress.isEmpty {
            modelContext.insert(progress)
        }

        // Complete all puzzles up to the target puzzle
        for i in 0..<puzzleId {
            progress.completedTasks.insert(i)
        }

        // Set current task to the target puzzle
        progress.currentTaskIndex = puzzleId
        progress.lastPlayed = Date()

        try modelContext.save()

        print("✅ Jumped to puzzle \(puzzleId): \(tasks[puzzleId].title)")
        print("🎮 You can now continue your journey by running the game without flags.")
    }
}
