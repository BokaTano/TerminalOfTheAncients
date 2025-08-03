import CryptoKit
import Foundation
import ShellOut

class GameEngine {
    private let tasks: [any Puzzle]
    private let dataService: GameDataService

    init(dataService: GameDataService) {
        self.dataService = dataService
        self.tasks = WelcomeRitualPuzzle.allPuzzles
    }

    func startGame() async throws {
        let progress = try await dataService.loadOrCreateProgress()

        // Main game loop
        while progress.currentTaskIndex < tasks.count {
            let currentTask = tasks[progress.currentTaskIndex]

            // Only show task info if it's not the first task (Welcome Ritual)
            // since the temple entrance already provided the context
            if progress.currentTaskIndex > 0 {
                print("📍 Current Location: Task \(progress.currentTaskIndex + 1) of \(tasks.count)")
                print()
            }

            let completed = await playPuzzle(currentTask, progress: progress)
            if !completed {
                return  // User quit the game
            }

            // The task was completed, so the loop will continue to the next task
            // The progress.currentTaskIndex was already incremented in playTask
        }

        print("🎉 Congratulations! You have completed all the ancient trials!")
        print("You are now a master of the Terminal of the Ancients!")
    }

    private func playPuzzle(_ puzzle: Puzzle, progress: PlayerProgress) async -> Bool {
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

        print()

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

                    progress.completedTasks.insert(puzzle.id)
                    progress.currentTaskIndex += 1
                    progress.lastPlayed = Date()

                    try? await dataService.saveProgress(progress)
                    return true
                } else {
                    print("❌ Incorrect. The ancient terminal rejects your answer.")
                    print("💡 Try again or type 'hint' for guidance.")
                    print()
                }
            }
        }
    }

    func resetGame() async throws {
        try await dataService.resetGame()
        print("🔄 Game reset! All progress has been cleared.")
    }

    func validateGlyphMatrixScript(binaryPath: String) async throws -> Bool {
        // Create process to run the script - use the same default store as the game
        let process = Process()
        process.executableURL = URL(fileURLWithPath: binaryPath)
        // Don't pass store URL - let the script use the same default store as the game
        process.arguments = []

        // Capture stdout
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""

        // Normalize line endings, strip ANSI color codes, and trim only trailing whitespace
        let normalizedOutput =
            output
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: #"\u{001B}\[[0-9;]*m"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #" +$"#, with: "", options: .regularExpression)  // Only trim trailing spaces
            .replacingOccurrences(of: #"\n+$"#, with: "", options: .regularExpression)  // Remove trailing newlines

        // Get expected ASCII
        let expectedASCII =
            "        |\n        |\n       /_\\\n       |#|\n       |#|\n      /###\\\n      |###|\n------|###|------\n      |###|\n      |###|\n      '---'\n  EIERLAND LIGHTHOUSE\n   53.179N 4.855E"

        // Compare using SHA256
        let outputHash = SHA256.hash(data: normalizedOutput.data(using: .utf8) ?? Data())
        let expectedHash = SHA256.hash(data: expectedASCII.data(using: .utf8) ?? Data())

        return outputHash == expectedHash
    }
}
