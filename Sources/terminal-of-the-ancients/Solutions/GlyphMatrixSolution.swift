// #!/usr/bin/env swift

// import Foundation
// import SwiftData

// // MARK: Step 1: Get the glyphs from the data store
// @Model
// final class PlayerProgress {
//     var currentTaskIndex: Int = 0
//     var completedTasks: Set<Int> = []
//     var lastPlayed: Date = Date()
//     var createdAt: Date = Date()
// }

// @Model
// final class Glyph {
//     var x: Int
//     var y: Int
//     var symbol: String
// }

// func getSortedGlyphs() throws -> [Glyph] {
//     let container = try ModelContainer(for: PlayerProgress.self, Glyph.self)
//     let context = ModelContext(container)

//     // Sort glyphs: first by row (y), then by column (x) within each row
//     let sortByRow = SortDescriptor<Glyph>(\.y, order: .forward)
//     let sortByColumn = SortDescriptor<Glyph>(\.x, order: .forward)
//     let descriptor = FetchDescriptor<Glyph>(sortBy: [sortByRow, sortByColumn])
//     return try context.fetch(descriptor)
// }

// // MARK: Step 2: Render the glyphs

// // Get sorted glyphs
// let glyphs = try getSortedGlyphs()

//MARK: Step 3: Create a string from the glyphs and print it 🎉

// // Find the grid boundaries by getting the maximum x and y coordinates
// let allXCoordinates = glyphs.map(\.x)
// let allYCoordinates = glyphs.map(\.y)

// guard let maxX = allXCoordinates.max(),
//     let maxY = allYCoordinates.max()
// else {
//     fputs("No glyphs found in store.\n", stderr)
//     exit(1)
// }

// // Create a grid filled with spaces
// // Grid size: (maxX + 1) columns × (maxY + 1) rows
// let gridWidth = maxX + 1
// let gridHeight = maxY + 1
// var grid = Array(repeating: Array(repeating: " ", count: gridWidth), count: gridHeight)

// // Place symbols in grid
// for g in glyphs {
//     grid[g.y][g.x] = g.symbol
// }

// // Convert grid to ASCII art
// // Step 1: Convert each row to a string and clean up trailing spaces
// let asciiRows = grid.map { row in
//     let rowString = row.joined()  // Join all characters in the row
//     // Remove trailing spaces but keep leading spaces (for proper alignment)
//     let cleanedRow = rowString.replacingOccurrences(
//         of: #" +$"#, with: "", options: .regularExpression)
//     return cleanedRow
// }

// // Step 2: Join all rows with newlines
// let asciiArt = asciiRows.joined(separator: "\n")

// // Step 3: Remove any trailing newlines
// let finalOutput = asciiArt.replacingOccurrences(of: #"\n+$"#, with: "", options: .regularExpression)

// // Step 4:Print the final output
// print(finalOutput)


// #!/usr/bin/env swift

// import Foundation
// import SwiftData

// // MARK: Puzzle Nr. 3: Glyph Matrix Puzzle 𐦉

// // MARK: Step 1: Get the glyphs from the data store
// @Model
// final class PlayerProgress {
//     var currentTaskIndex: Int = 0
//     var completedTasks: Set<Int> = []
//     var lastPlayed: Date = Date()
//     var createdAt: Date = Date()
// }

// @Model
// final class Glyph {
//     var x: Int
//     var y: Int
//     var symbol: String
// }

// func getSortedGlyphs() throws -> [Glyph] {
//     let container = try ModelContainer(for: PlayerProgress.self, Glyph.self)
//     let context = ModelContext(container)

//     // Sort glyphs: first by row (y), then by column (x) within each row
//     let sortByRow = SortDescriptor<Glyph>(\.y, order: .forward)
//     let sortByColumn = SortDescriptor<Glyph>(\.x, order: .forward)
//     let descriptor = FetchDescriptor<Glyph>(sortBy: [sortByRow, sortByColumn])
//     return try context.fetch(descriptor)
// }

// let glyphs = try getSortedGlyphs()

// //MARK: Step 2: Create a string from the glyphs and print it 🎉

// Idea 1: just add all to one string and the print it
// Idea 2: create a grid and print it
// Idea 3: create a grid and print it with a nice ASCII art and check the solutions

//MARK: Step 3: Start TOTA and check if the glyphs are correctly printed, what can you see?




