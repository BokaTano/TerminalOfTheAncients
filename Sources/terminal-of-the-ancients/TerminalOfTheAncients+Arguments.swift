import Foundation

extension TerminalOfTheAncients {

    func showStatus(dataService: GameDataService) async {
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

    func jumpToPuzzle(_ puzzleId: Int, dataService: GameDataService) async throws {
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

    func resetGame(dataService: GameDataService) async throws {
        try await dataService.resetGame()
        print("🔄 Game reset! All progress has been cleared.")
    }
}
