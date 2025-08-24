import Foundation
import SwiftData

// MARK: - Game Data Service
class GameDataService {
    private let modelContext: ModelContext

    init(storePath: String? = nil) throws {
        let modelContainer: ModelContainer

        if let storePath = storePath, !storePath.isEmpty {
            // Use specified store path
            let storeURL = URL(fileURLWithPath: storePath)
            let config = ModelConfiguration(url: storeURL)
            modelContainer = try ModelContainer(
                for: PlayerProgress.self, Glyph.self, configurations: config)
        } else {
            // Use default store
            modelContainer = try ModelContainer(for: PlayerProgress.self, Glyph.self)
        }

        self.modelContext = ModelContext(modelContainer)
    }

    // MARK: - Progress Management
    func loadOrCreateProgress() async throws -> PlayerProgress {
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

    func saveProgress(_ progress: PlayerProgress) async throws {
        try modelContext.save()
    }

    func resetGame() async throws {
        // Clear progress
        let progressDescriptor = FetchDescriptor<PlayerProgress>()
        let existingProgress = try modelContext.fetch(progressDescriptor)
        for progress in existingProgress {
            modelContext.delete(progress)
        }

        // Clear glyphs
        let glyphDescriptor = FetchDescriptor<Glyph>()
        let existingGlyphs = try modelContext.fetch(glyphDescriptor)
        for glyph in existingGlyphs {
            modelContext.delete(glyph)
        }

        try modelContext.save()
    }

    func advanceToNextPuzzle(nextPuzzleIndex: Int? = nil) async throws {
        let progress = try await loadOrCreateProgress()

        if let nextPuzzleIndex = nextPuzzleIndex {
            progress.currentTaskIndex = nextPuzzleIndex
        } else {
            progress.currentTaskIndex += 1
        }

        // Complete current puzzle and advance to next
        progress.completedTasks.insert(progress.currentTaskIndex)
        progress.lastPlayed = Date()

        try await saveProgress(progress)
    }

    // MARK: - Glyph Management
    func seedGlyphMatrix() async throws {
        // Clear existing glyphs
        let descriptor = FetchDescriptor<Glyph>()
        let existingGlyphs = try modelContext.fetch(descriptor)
        for glyph in existingGlyphs {
            modelContext.delete(glyph)
        }

        // Create lighthouse ASCII art
        let lighthouseASCII = """
                    |
                    |
                   /_\\
                   |#|
                   |#|
                  /###\\
                  |###|
            ------|###|------
                  |###|
                  |###|
                  '---'
              EIERLAND LIGHTHOUSE
               53.179N 4.855E
            """

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
        if savedGlyphs.count != glyphCount {
            throw NSError(
                domain: "GameDataService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Glyph count mismatch"]
            )
        }
    }

    func getSortedGlyphs() async throws -> [Glyph] {
        let descriptor = FetchDescriptor<Glyph>(sortBy: [
            .init(\.y, order: .forward),
            .init(\.x, order: .forward),
        ])
        return try modelContext.fetch(descriptor)
    }

    // TODO: remove this once we do not need the tests anymore
    func getGlyphs() async throws -> [Glyph] {
        let descriptor = FetchDescriptor<Glyph>()
        return try modelContext.fetch(descriptor)
    }
}
