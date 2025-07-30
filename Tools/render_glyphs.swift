#!/usr/bin/env swift

import Foundation
import SwiftData

// MARK: - Minimal argument parsing

struct Args {
    var store: String = ""
}

func parseArgs() -> Args {
    var args = Args()
    var it = CommandLine.arguments.dropFirst().makeIterator()
    while let a = it.next() {
        switch a {
        case "--store":
            args.store = it.next() ?? ""
        default:
            break
        }
    }
    return args
}

let args = parseArgs()
// Use default store if no store path provided (same as game)
let storePath = args.store.isEmpty ? "" : args.store

// MARK: - Model

@Model
final class PlayerProgress {
    var currentTaskIndex: Int
    var completedTasks: Set<Int>
    var lastPlayed: Date
    var createdAt: Date
    
    init() {
        self.currentTaskIndex = 0
        self.completedTasks = []
        self.lastPlayed = Date()
        self.createdAt = Date()
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

// MARK: - SwiftData bootstrap

// Use the exact same ModelContainer configuration as the game
let container: ModelContainer
if storePath.isEmpty {
    // Use default store (same as game)
    container = try ModelContainer(for: PlayerProgress.self, Glyph.self)
} else {
    // Use specified store path with same configuration as game
    let storeURL = URL(fileURLWithPath: storePath)
    let config = ModelConfiguration(url: storeURL)
    container = try ModelContainer(for: PlayerProgress.self, Glyph.self, configurations: config)
}
let context = ModelContext(container)

let fetch = FetchDescriptor<Glyph>(sortBy: [
    .init(\.y, order: .forward),
    .init(\.x, order: .forward)
])

let glyphs = try context.fetch(fetch)

guard let maxX = glyphs.map(\.x).max(),
      let maxY = glyphs.map(\.y).max() else {
    fputs("No glyphs found in store.\n", stderr)
    exit(1)
}

// Fill grid with spaces
var grid = Array(
    repeating: Array(repeating: " ", count: maxX + 1),
    count: maxY + 1
)

// Place symbols
for g in glyphs {
    grid[g.y][g.x] = g.symbol.isEmpty ? " " : String(g.symbol.prefix(1))
}

// Join into ASCII and trim only trailing spaces from each line (keep leading spaces)
let ascii = grid.map { line in
    let joined = line.joined()
    // Only trim trailing spaces, keep leading spaces
    return joined.replacingOccurrences(of: #" +$"#, with: "", options: .regularExpression)
}.joined(separator: "\n")

// For now, output plain ASCII (colors can be added later as enhancement)
// Only remove trailing newline, keep leading spaces
print(ascii.replacingOccurrences(of: #"\n+$"#, with: "", options: .regularExpression)) 