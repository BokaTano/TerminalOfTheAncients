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

// MARK: - SwiftData Logic and Models (same as GameDataService)

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

func createModelContainer(storePath: String?) throws -> ModelContainer {
    if let storePath = storePath, !storePath.isEmpty {
        // Use specified store path
        let storeURL = URL(fileURLWithPath: storePath)
        let config = ModelConfiguration(url: storeURL)
        return try ModelContainer(for: PlayerProgress.self, Glyph.self, configurations: config)
    } else {
        // Use default store
        return try ModelContainer(for: PlayerProgress.self, Glyph.self)
    }
}

func getSortedGlyphs(context: ModelContext) throws -> [Glyph] {
    let descriptor = FetchDescriptor<Glyph>(sortBy: [
        .init(\.y, order: .forward),
        .init(\.x, order: .forward),
    ])
    return try context.fetch(descriptor)
}

// MARK: - Main Execution

// Create container and context using same logic as GameDataService
let container = try createModelContainer(storePath: args.store.isEmpty ? nil : args.store)
let context = ModelContext(container)

// Get sorted glyphs using same logic as GameDataService
let glyphs = try getSortedGlyphs(context: context)

guard let maxX = glyphs.map(\.x).max(),
    let maxY = glyphs.map(\.y).max()
else {
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
