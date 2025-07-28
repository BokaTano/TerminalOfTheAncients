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
        
        printBanner()
        
        // Main game loop
        while progress.currentTaskIndex < tasks.count {
            print("📍 Current Location: Task \(progress.currentTaskIndex + 1) of \(tasks.count)")
            print("📊 Progress: \(progress.completedTasks.count)/\(tasks.count) tasks completed")
            print()
            
            let currentTask = tasks[progress.currentTaskIndex]
            print("🔮 \(currentTask.title)")
            print("📜 \(currentTask.description)")
            print()
            
            let completed = await playTask(currentTask, progress: progress)
            if !completed {
                return // User quit the game
            }
            
            // The task was completed, so the loop will continue to the next task
            // The progress.currentTaskIndex was already incremented in playTask
        }
        
        print("🎉 Congratulations! You have completed all the ancient trials!")
        print("You are now a master of the Terminal of the Ancients!")
    }
    
    private func playTask(_ task: Puzzle, progress: PlayerProgress) async -> Bool {
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
                    
                    progress.completedTasks.insert(task.id)
                    progress.currentTaskIndex += 1
                    progress.lastPlayed = Date()
                    
                    try? modelContext.save()
                    
                    // Check if we're moving to task 3 (File of Truth) and show trapdoor scene
                    if progress.currentTaskIndex == 3 { // After completing task 2 (Sigil Compiler)
                        print("\n🚪 As you step forward, the floor beneath you suddenly gives way...")
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
        
        try modelContext.save()
        print("🔄 Game reset! All progress has been cleared.")
    }
    
    private func printBanner() {
        print("""
        
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