#!/usr/bin/env swift

import Foundation
import SwiftData

// MARK: Puzzle Nr. 3: Glyph Matrix Puzzle 𐦉

// MARK: Step 1: Get the glyphs from the data store
@Model
final class PlayerProgress {
    var currentTaskIndex: Int
    var completedTasks: Set<Int>
    var lastPlayed: Date
    var createdAt: Date

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

func getSortedGlyphs() throws -> [Glyph] {
    let container = try ModelContainer(for: PlayerProgress.self, Glyph.self)
    let context = ModelContext(container)

    // Sort glyphs: first by row (y), then by column (x) within each row
    let sortByRow = SortDescriptor<Glyph>(\.y, order: .forward)
    let sortByColumn = SortDescriptor<Glyph>(\.x, order: .forward)
    let descriptor = FetchDescriptor<Glyph>(sortBy: [sortByRow, sortByColumn])
    return try context.fetch(descriptor)
}

let glyphs = try getSortedGlyphs()

//MARK: Step 2: Create a string from the glyphs and print it 🎉

/*
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
*/

// Idea 1: just add all to one string and the print it

// Idea 2: create a grid and print it

// Idea 3: create a grid and print it with a nice ASCII art and check the solutions

// MARK: Step 3: Start TOTA and check if the glyphs are correctly printed, what can you see?
