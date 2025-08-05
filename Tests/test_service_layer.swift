#!/usr/bin/env swift

import Foundation
import SwiftData

// MARK: - Test Game Data Service
@MainActor
class TestGameDataService {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
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
        print("🗼 Seeded \(glyphCount) glyphs in the store, verified \(savedGlyphs.count) saved")
    }
    
    func getGlyphs() async throws -> [Glyph] {
        let descriptor = FetchDescriptor<Glyph>()
        return try modelContext.fetch(descriptor)
    }
}

// MARK: - Test Runner
@MainActor
class ServiceLayerTester {
    private let dataService: TestGameDataService
    
    init() throws {
        let modelContainer = try ModelContainer(for: PlayerProgress.self, Glyph.self)
        let modelContext = ModelContext(modelContainer)
        self.dataService = TestGameDataService(modelContext: modelContext)
    }
    
    func runAllTests() async throws {
        print("🧪 Testing Service Layer Refactoring")
        print("=" * 50)
        
        try await testProgressManagement()
        try await testGlyphManagement()
        try await testResetGame()
        
        print("\n✅ All tests passed! Service layer refactoring is working correctly.")
    }
    
    private func testProgressManagement() async throws {
        print("\n📊 Testing Progress Management...")
        
        // Test 1: Load or create progress
        let progress1 = try await dataService.loadOrCreateProgress()
        print("✅ Loaded progress: Task \(progress1.currentTaskIndex)")
        
        // Test 2: Update progress
        progress1.currentTaskIndex = 2
        progress1.completedTasks.insert(1)
        try await dataService.saveProgress(progress1)
        print("✅ Updated progress: Task \(progress1.currentTaskIndex)")
        
        // Test 3: Load progress again (should be the same)
        let progress2 = try await dataService.loadOrCreateProgress()
        print("✅ Reloaded progress: Task \(progress2.currentTaskIndex), Completed: \(progress2.completedTasks.count)")
        
        assert(progress2.currentTaskIndex == 2, "Progress should persist")
        assert(progress2.completedTasks.contains(1), "Completed tasks should persist")
    }
    
    private func testGlyphManagement() async throws {
        print("\n🗼 Testing Glyph Management...")
        
        // Test 1: Seed glyph matrix
        try await dataService.seedGlyphMatrix()
        
        // Test 2: Get glyphs
        let glyphs = try await dataService.getGlyphs()
        print("✅ Retrieved \(glyphs.count) glyphs")
        
        assert(glyphs.count > 0, "Should have glyphs after seeding")
        
        // Test 3: Verify glyph structure
        let firstGlyph = glyphs.first!
        print("✅ First glyph: x=\(firstGlyph.x), y=\(firstGlyph.y), symbol='\(firstGlyph.symbol)'")
        
        assert(firstGlyph.x >= 0, "Glyph should have valid coordinates")
        assert(firstGlyph.y >= 0, "Glyph should have valid coordinates")
    }
    
    private func testResetGame() async throws {
        print("\n🔄 Testing Reset Game...")
        
        // Test 1: Verify we have data before reset
        let progressBefore = try await dataService.loadOrCreateProgress()
        let glyphsBefore = try await dataService.getGlyphs()
        print("✅ Before reset: Progress exists, \(glyphsBefore.count) glyphs")
        
        // Test 2: Reset game
        try await dataService.resetGame()
        
        // Test 3: Verify reset worked
        let progressAfter = try await dataService.loadOrCreateProgress()
        let glyphsAfter = try await dataService.getGlyphs()
        print("✅ After reset: New progress created, \(glyphsAfter.count) glyphs")
        
        assert(progressAfter.currentTaskIndex == 0, "Progress should be reset")
        assert(progressAfter.completedTasks.isEmpty, "Completed tasks should be cleared")
        assert(glyphsAfter.isEmpty, "Glyphs should be cleared")
    }
}

// MARK: - Main Test Execution
print("🚀 Starting Service Layer Tests...")

do {
    let tester = try ServiceLayerTester()
    try await tester.runAllTests()
} catch {
    print("❌ Test failed: \(error)")
    exit(1)
} 