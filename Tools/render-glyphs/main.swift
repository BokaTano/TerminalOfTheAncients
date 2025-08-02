#!/usr/bin/env swift

import Foundation

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

// MARK: - Use GameDataService from main package

// This executable can import the main package's GameDataService
// because it's part of the same Swift package

// Create GameDataService instance with optional store path
let dataService = try GameDataService(storePath: args.store.isEmpty ? nil : args.store)

// Get sorted glyphs using the service
let glyphs = try await dataService.getSortedGlyphs()

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
