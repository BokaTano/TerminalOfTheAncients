import CryptoKit
import Foundation
import SwiftData

class GameEngine {
    private let tasks: [Puzzle]
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.tasks = Puzzle.allPuzzles
    }

    func startGame() async throws {
        let progress = try await loadOrCreateProgress()

        // Main game loop
        while progress.currentTaskIndex < tasks.count {
            let currentTask = tasks[progress.currentTaskIndex]

            // Only show task info if it's not the first task (Welcome Ritual)
            // since the temple entrance already provided the context
            if progress.currentTaskIndex > 0 {
                print("📍 Current Location: Task \(progress.currentTaskIndex + 1) of \(tasks.count)")
                print()
            }

            let completed = await playTask(currentTask, progress: progress)
            if !completed {
                return  // User quit the game
            }

            // The task was completed, so the loop will continue to the next task
            // The progress.currentTaskIndex was already incremented in playTask
        }

        print("🎉 Congratulations! You have completed all the ancient trials!")
        print("You are now a master of the Terminal of the Ancients!")
    }

    private func playTask(_ task: Puzzle, progress: PlayerProgress) async -> Bool {
        // Special handling for Glyph Matrix puzzle
        if task.id == 2 {  // Glyph Matrix puzzle
            return await playGlyphMatrixTask(task, progress: progress)
        }

        // Special handling for Beacon puzzle
        if task.id == 3 {  // Beacon puzzle
            return await playBeaconTask(task, progress: progress)
        }

        while true {
            print("💭 Enter your answer (or 'hint' for help, 'quit' to exit):")
            guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                // If readLine returns nil, it might be EOF or no input available
                // In a real CLI scenario, this would be unusual, so we'll break
                print("❌ No input available. Exiting...")
                return false
            }

            switch input.lowercased() {
            case "quit", "exit":
                print("👋 Farewell, digital archaeologist. Your progress has been saved.")
                return false

            case "hint":
                print("💡 Hint: \(task.hint)")
                print()
                continue

            case "xyzzy":
                print("🌟 Nothing happens... or does it? You've discovered an ancient easter egg!")
                print()
                continue

            default:
                if task.validator(input) {
                    print("✅ Correct! The ancient terminal accepts your answer.")
                    print("🔓 Access granted to the next chamber...")
                    print()

                    // Show ASCII art for puzzle completion
                    await ASCIIArt.showChamberUnlocked(taskId: task.id)

                    // Wait for user to press Enter to continue
                    print("Press Enter to continue your journey...")
                    _ = readLine()

                    progress.completedTasks.insert(task.id)
                    progress.currentTaskIndex += 1
                    progress.lastPlayed = Date()

                    try? modelContext.save()

                    // Check if we're moving to task 3 (Sigil Compiler) and show trapdoor scene
                    if progress.currentTaskIndex == 3 {  // After completing task 2 (Glyph Matrix)
                        print(
                            "\n🚪 As you step forward, the floor beneath you suddenly gives way...")
                        await ASCIIArt.showTrapdoorScene()
                        print("\n🎮 Continue your journey in the hidden chamber below...")
                    }

                    // Task completed, return to main loop
                    return true
                } else {
                    print("❌ Incorrect. The ancient terminal rejects your answer.")
                    print("💡 Try again or type 'hint' for guidance.")
                    print()
                }
            }
        }
    }

    private func playGlyphMatrixTask(_ task: Puzzle, progress: PlayerProgress) async -> Bool {
        // Seed the glyph matrix first
        do {
            try await seedGlyphMatrix()
        } catch {
            print("❌ Failed to seed glyph matrix: \(error)")
            return false
        }

        print("🗼 The lighthouse beacon has gone dark. Glyphs have been seeded in SwiftData.")
        print("💡 Use render_glyphs.swift to reconstruct the ASCII art.")
        print()

        // Show what the lighthouse should look like
        print("🎯 This is what your script should output:")
        print(String(repeating: "─", count: 60))
        let red = "\u{001B}[31m"
        let gray = "\u{001B}[90m"
        let reset = "\u{001B}[0m"

        let lighthouseASCII =
            "\(gray)        |\n        |\n       /_\\\n       |\(red)#\(gray)|\n       |\(red)#\(gray)|\n      /\(red)###\(gray)\\\n      |\(red)###\(gray)|\n------|\(red)###\(gray)|------\n      |\(red)###\(gray)|\n      |\(red)###\(gray)|\n      '---'\n  \(reset)EIERLAND LIGHTHOUSE\n   53.179N 4.855E"
        print(lighthouseASCII)
        print(String(repeating: "─", count: 60))
        print()

        while true {
            print(
                "💭 Enter the path to your compiled Swift binary (or 'hint' for help, 'quit' to exit):"
            )
            guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("❌ No input available. Exiting...")
                return false
            }

            switch input.lowercased() {
            case "quit", "exit":
                print("👋 Farewell, digital archaeologist. Your progress has been saved.")
                return false

            case "hint":
                print("💡 Hint: \(task.hint)")
                print("📁 The script should be compiled and executable.")
                print("🔧 Example: swiftc render_glyphs.swift -o render_glyphs")
                print()
                continue

            case "xyzzy":
                print("🌟 Nothing happens... or does it? You've discovered an ancient easter egg!")
                print()
                continue

            default:
                // Validate the binary path
                let fileManager = FileManager.default
                guard fileManager.fileExists(atPath: input) else {
                    print("❌ Binary not found at path: \(input)")
                    print("💡 Make sure the path is correct and the file exists.")
                    print()
                    continue
                }

                // Try to run the script
                do {
                    let isValid = try await validateGlyphMatrixScript(binaryPath: input)

                    if isValid {
                        print("✅ The beacon shines again. Its coordinates are 53.179N 4.855E.")
                        print("🔓 In the next puzzle, you will need these numbers...")
                        print()

                        // Show ASCII art for puzzle completion
                        await ASCIIArt.showChamberUnlocked(taskId: task.id)

                        // Wait for user to press Enter to continue
                        print("Press Enter to continue your journey...")
                        _ = readLine()

                        progress.completedTasks.insert(task.id)
                        progress.currentTaskIndex += 1
                        progress.lastPlayed = Date()

                        try? modelContext.save()

                        // Check if we're moving to task 3 (Sigil Compiler) and show trapdoor scene
                        if progress.currentTaskIndex == 3 {  // After completing task 2 (Glyph Matrix)
                            print(
                                "\n🚪 As you step forward, the floor beneath you suddenly gives way..."
                            )
                            await ASCIIArt.showTrapdoorScene()
                            print("\n🎮 Continue your journey in the hidden chamber below...")
                        }

                        return true
                    } else {
                        print(
                            "❌ The matrix is malformed. Perhaps you have a missing glyph? Or the spacing is off?"
                        )
                        print("💡 Try again.")
                        print()
                    }
                } catch {
                    print("❌ Failed to run script: \(error)")
                    print("💡 Make sure the script is compiled and executable.")
                    print()
                }
            }
        }
    }

    // MARK: - Beacon Puzzle

    private func playBeaconTask(_ task: Puzzle, progress: PlayerProgress) async -> Bool {
        print("🗼 The lighthouse has awakened. It now sends continuous tidal data through the air.")
        print(
            "🌊 The water is rising. You're standing deep in a coastal cave—and something is whispering..."
        )
        print()

        let beaconTask = BeaconPuzzleTask()

        do {
            try await beaconTask.runPuzzle()

            print("✅ The beacon analysis is complete!")
            print("🔓 Access granted to the next chamber...")
            print()

            // Show ASCII art for puzzle completion
            await ASCIIArt.showChamberUnlocked(taskId: task.id)

            // Wait for user to press Enter to continue
            print("Press Enter to continue your journey...")
            _ = readLine()

            progress.completedTasks.insert(task.id)
            progress.currentTaskIndex += 1
            progress.lastPlayed = Date()

            try? modelContext.save()

            return true
        } catch {
            print("❌ Beacon analysis failed: \(error)")
            print("💡 Try again or type 'hint' for guidance.")
            print()
            return false
        }
    }

    private func loadOrCreateProgress() async throws -> PlayerProgress {
        let descriptor = FetchDescriptor<PlayerProgress>()
        let existingProgress = try modelContext.fetch(descriptor)

        if let progress = existingProgress.first {
            return progress
        } else {
            let newProgress = PlayerProgress()
            modelContext.insert(newProgress)
            try modelContext.save()
            return newProgress
        }
    }

    func resetGame() async throws {
        let descriptor = FetchDescriptor<PlayerProgress>()
        let existingProgress = try modelContext.fetch(descriptor)

        for progress in existingProgress {
            modelContext.delete(progress)
        }

        // Also clear glyphs
        let glyphDescriptor = FetchDescriptor<Glyph>()
        let existingGlyphs = try modelContext.fetch(glyphDescriptor)
        for glyph in existingGlyphs {
            modelContext.delete(glyph)
        }

        try modelContext.save()
        print("🔄 Game reset! All progress has been cleared.")
    }

    // MARK: - Glyph Matrix Puzzle

    func seedGlyphMatrix() async throws {
        // Clear existing glyphs
        let descriptor = FetchDescriptor<Glyph>()
        let existingGlyphs = try modelContext.fetch(descriptor)
        for glyph in existingGlyphs {
            modelContext.delete(glyph)
        }

        // Create lighthouse ASCII art
        let lighthouseASCII =
            "        |\n        |\n       /_\\\n       |#|\n       |#|\n      /###\\\n      |###|\n------|###|------\n      |###|\n      |###|\n      '---'\n  EIERLAND LIGHTHOUSE\n   53.179N 4.855E"

        // Convert ASCII to glyphs
        let lines = lighthouseASCII.components(separatedBy: .newlines)
        var glyphCount = 0
        for (y, line) in lines.enumerated() {
            for (x, char) in line.enumerated() {
                let glyph = Glyph(x: x, y: y, symbol: String(char))
                modelContext.insert(glyph)
                glyphCount += 1
            }
        }

        try modelContext.save()

        // Verify the glyphs were saved
        let glyphDescriptor = FetchDescriptor<Glyph>()
        let savedGlyphs = try modelContext.fetch(glyphDescriptor)
        print("🗼 Seeded \(glyphCount) glyphs in the store, verified \(savedGlyphs.count) saved")
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

    private func printBanner() {
        print(
            """

            ╔══════════════════════════════════════════════════════════════╗
            ║                    TERMINAL OF THE ANCIENTS                  ║
            ║                                                              ║
            ║  You are a digital archaeologist on the island of Texel.    ║
            ║  Hidden beneath the dunes, you discover an ancient CLI      ║
            ║  terminal — a remnant of a lost civilization of Swift       ║
            ║  developers. To unlock the secrets of their knowledge,      ║
            ║  you must complete puzzles encoded in Swift code.           ║
            ║                                                              ║
            ║  Each puzzle grants you access to the next part of the      ║
            ║  story. Your progress is saved locally so you can return    ║
            ║  later and continue where you left off.                     ║
            ╚══════════════════════════════════════════════════════════════╝

            """)
    }

}
