import Foundation
import ShellOut
import SwiftData

@Model
final class PlayerProgress {
    var currentTaskIndex: Int
    var completedTasks: Set<Int>
    var createdAt: Date
    var lastPlayed: Date

    init() {
        self.currentTaskIndex = 0
        self.completedTasks = []
        self.createdAt = Date()
        self.lastPlayed = Date()
    }
}

@Model
final class Glyph {
    var x: Int
    var y: Int
    var symbol: String

    init(x: Int, y: Int, symbol: String) {
        self.x = x
        self.y = y
        self.symbol = symbol
    }
}

struct Puzzle {
    let id: Int
    let title: String
    let description: String
    let hint: String
    let validator: (String) -> Bool
    let solution: String

    init(
        id: Int, title: String, description: String, hint: String, solution: String,
        validator: @escaping (String) -> Bool
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.hint = hint
        self.solution = solution
        self.validator = validator
    }

    static var allPuzzles: [Puzzle] {
        return [
            Puzzle(
                id: 0,
                title: "Welcome Ritual",
                description:
                    "To begin your journey, you must first prove you understand the ancient CLI ways. Launch this program with a specific flag to demonstrate your knowledge of argument parsing.",
                hint:
                    "The ancient ones used flags to control their programs. Try using the help flag to discover available options.",
                solution: "--initiate",
                validator: { _ in false }  // Handled by main program logic
            ),
            Puzzle(
                id: 1,
                title: "The Shell Script Ritual",
                description:
                    "The ancient terminal displays a message:\n> \"The ancients automated their workflows with shell scripts.\n> Execute the sacred build script to prove your mastery.\"\n\nYou must run the build_and_run.sh script and provide the word 'automation' to prove you understand shell scripting.",
                hint: "Run the build script and then type 'automation' as your answer.",
                solution: "automation",
                validator: { input in
                    // This will be handled by the ShellOut puzzle logic
                    ShellOutPuzzle.validateShellScriptExecution(input: input)
                }
            ),
            Puzzle(
                id: 2,
                title: "Restore the Glyph Matrix",
                description:
                    "The lighthouse beacon has gone dark. Write a Swift script that reads glyphs from SwiftData and reconstructs the ASCII art.",
                hint:
                    "Use the provided render_glyphs.swift tool. Run it with: ./run_render_glyphs.sh",
                solution: "glyph_matrix",
                validator: { input in
                    // This will be handled by the GlyphMatrixPuzzle logic
                    GlyphMatrixPuzzle.validateGlyphMatrix(input: input)
                }
            ),
            Puzzle(
                id: 3,
                title: "The Voice of the Lighthouse",
                description:
                    "The lighthouse has awakened and now sends continuous tidal data through the air. The water is rising. You're standing deep in a coastal cave—and something is whispering...",
                hint:
                    "The beacon streams data that you must analyze. Connect to the server and extract the critical water level.",
                solution: "beacon_analysis",
                validator: { input in
                    // This will be handled by the BeaconPuzzle logic
                    BeaconPuzzle.validateBeaconAnalysis(input: input)
                }
            ),

        ]
    }
}

// Helper class for ShellOut puzzle
class ShellOutPuzzle {
    static func validateShellScriptExecution(input: String) -> Bool {
        do {
            // First, try to run the build script to ensure it exists and works
            _ = try shellOut(to: "chmod +x build_and_run.sh && ./build_and_run.sh --status")

            // Check if the input is the expected answer
            return input.lowercased() == "automation"
        } catch {
            print("❌ Shell script execution failed: \(error)")
            return false
        }
    }
}

// Helper class for Glyph Matrix puzzle
class GlyphMatrixPuzzle {
    static func validateGlyphMatrix(input: String) -> Bool {
        // This will be handled by the main game logic
        // The actual validation happens in the GameEngine
        return false
    }
}

// Helper class for Beacon puzzle
class BeaconPuzzle {
    static func validateBeaconAnalysis(input: String) -> Bool {
        // This will be handled by the main game logic
        // The actual validation happens in the GameEngine
        return false
    }
}
