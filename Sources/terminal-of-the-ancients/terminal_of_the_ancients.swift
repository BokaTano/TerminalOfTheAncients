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
        let gameEngine = GameEngine(dataService: dataService)

        // Handle convenience commands first
        if reset {
            try await gameEngine.resetGame()
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

        // Check if this is the first task (Welcome Ritual)
        let progress = try await dataService.loadOrCreateProgress()

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

            progress.completedTasks.insert(0)
            progress.currentTaskIndex += 1
            progress.lastPlayed = Date()

            try await dataService.saveProgress(progress)

            print("🎮 You can now continue your journey by running the game without flags.")
            return
        }

        // Start the interactive game
        try await gameEngine.startGame()
    }

    private func showStatus(dataService: GameDataService) async {
        do {
            let progress = try await dataService.loadOrCreateProgress()
            let tasks = WelcomeRitualPuzzle.allPuzzles
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
        } catch {
            print("❌ Error loading game status: \(error)")
        }
    }

    private func jumpToPuzzle(_ puzzleId: Int, dataService: GameDataService) async throws {
        let tasks = WelcomeRitualPuzzle.allPuzzles

        guard puzzleId >= 0 && puzzleId < tasks.count else {
            print("❌ Invalid puzzle ID. Available puzzles: 0-\(tasks.count - 1)")
            return
        }

        let progress = try await dataService.loadOrCreateProgress()

        // Complete all puzzles up to the target puzzle
        for i in 0..<puzzleId {
            progress.completedTasks.insert(i)
        }

        // Set current task to the target puzzle
        progress.currentTaskIndex = puzzleId
        progress.lastPlayed = Date()

        try await dataService.saveProgress(progress)

        print("✅ Jumped to puzzle \(puzzleId): \(tasks[puzzleId].title)")
        print("🎮 You can now continue your journey by running the game without flags.")
    }
}
