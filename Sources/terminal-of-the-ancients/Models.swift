import Foundation
import SwiftData

protocol Puzzle {
    var id: Int { get }
    var title: String { get }
    var description: String { get }
    var hint: String { get }
    func validate(input: String) async -> Bool
    func setup() async throws
    func displaySuccess() async
    func displayError() async
}

extension Puzzle {
    static var allPuzzles: [any Puzzle] {
        return [
            WelcomeRitualPuzzle(),
            ShellScriptRitualPuzzle(),
            GlyphMatrixPuzzle(),
            BeaconPuzzle(),
        ]
    }

    // Default implementation for puzzles that don't need setup
    func setup() async throws {
        // No setup required
    }
}

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
