import Foundation
import Rainbow

class ASCIIArt {

    static func showTrapdoorScene() async {
        let trapdoor = """

            ╔══════════════════════════════════════════════════════════════╗
            ║                    ⚠️  TRAPDOOR DISCOVERED  ⚠️                  ║
            ║                                                              ║
            ║  ████████████████████████████████████████████████████████  ║
            ║  ████████████████████████████████████████████████████████  ║
            ║  ████████████████████████████████████████████████████████  ║
            ║  ████████████████████████████████████████████████████████  ║
            ║  ████████████████████████████████████████████████████████  ║
            ║  ████████████████████████████████████████████████████████  ║
            ║  ████████████████████████████████████████████████████████  ║
            ║  ████████████████████████████████████████████████████████  ║
            ║                                                              ║
            ║  ████████████████████████████████████████████████████████  ║
            ║  ████████████████████████████████████████████████████████  ║
            ║  ████████████████████████████████████████████████████████  ║
            ║  ████████████████████████████████████████████████████████  ║
            ║                                                              ║
            ║  The floor beneath you suddenly gives way!                   ║
            ║  You plummet into darkness as the trapdoor closes above...   ║
            ║                                                              ║
            ║  ═══════════════════════════════════════════════════════════  ║
            ║                                                              ║
            ║  You land with a thud in a hidden chamber deep below         ║
            ║  the temple. The air is thick with ancient dust and          ║
            ║  the scent of forgotten knowledge...                         ║
            ╚══════════════════════════════════════════════════════════════╝

            """

        print("\u{1B}[2J\u{1B}[H")  // Clear screen
        print(trapdoor.red.bold)

        // Add dramatic pause
        try? await Task.sleep(for: .seconds(3))

        // Show falling animation
        for i in 0..<5 {
            print("\rFalling deeper into the temple... \(".".repeating(i + 1))", terminator: "")
            try? await Task.sleep(for: .milliseconds(500))
        }
        print()
    }

    static func showProgressBar(duration: TimeInterval = 2.0) async {
        let steps = 20
        let stepDuration = duration / Double(steps)

        print("🔍 Analyzing ancient patterns...")

        for i in 0...steps {
            let progress = Double(i) / Double(steps)
            let filled = Int(progress * 50)
            let empty = 50 - filled

            let bar = "█".repeating(filled) + "░".repeating(empty)
            let percentage = Int(progress * 100)

            print("\r[\(bar)] \(percentage)%", terminator: "")
            fflush(stdout)

            if i < steps {
                try? await Task.sleep(for: .seconds(stepDuration))
            }
        }
        print()
    }

    static func showChamberUnlocked(taskId: Int) async {
        await showProgressBar()

        // Show the final chamber art
        let art = getChamberArt(taskId: taskId)
        print("\u{1B}[2J\u{1B}[H")  // Clear screen
        print(art.green.bold)

        // Add some dramatic pause
        try? await Task.sleep(for: .seconds(2))  // 2 seconds to appreciate the art
    }

    private static func getChamberArt(taskId: Int) -> String {
        switch taskId {
        case 0:  // Welcome Ritual
            return """
                ╔══════════════════════════════════════════════════════════════╗
                ║                    🏛️  CHAMBER UNLOCKED  🏛️                   ║
                ║                                                              ║
                ║  ████████████████████████████████████████████████████████  ║
                ║  ████████████████████████████████████████████████████████  ║
                ║  ████████████████████████████████████████████████████████  ║
                ║                                                              ║
                ║  The ancient stone door slowly grinds open, revealing        ║
                ║  the inner sanctum of the Terminal of the Ancients.          ║
                ║                                                              ║
                ║  Golden light streams through the opening, illuminating      ║
                ║  ancient Swift runes carved into the walls.                  ║
                ║                                                              ║
                ║  You have proven yourself worthy of the CLI arts.            ║
                ║  The next chamber awaits your arrival...                     ║
                ╚══════════════════════════════════════════════════════════════╝
                """

        case 1:  // Shell Script Ritual
            return """
                ╔══════════════════════════════════════════════════════════════╗
                ║                    ⚙️  AUTOMATION CHAMBER  ⚙️                  ║
                ║                                                              ║
                ║  ████████████████████████████████████████████████████████  ║
                ║  ████████████████████████████████████████████████████████  ║
                ║  ████████████████████████████████████████████████████████  ║
                ║                                                              ║
                ║  The ancient automation chamber hums with renewed energy.    ║
                ║  Shell scripts flow like digital rivers through the system.  ║
                ║                                                              ║
                ║  You have mastered the art of command orchestration.         ║
                ║  The next challenge awaits in the depths below...            ║
                ╚══════════════════════════════════════════════════════════════╝
                """

        case 2:  // Glyph Matrix
            return """
                ╔══════════════════════════════════════════════════════════════╗
                ║                    🗼 GLYPH MATRIX RESTORED 🗼                ║
                ║                                                              ║
                ║  ████████████████████████████████████████████████████████  ║
                ║  ████████████████████████████████████████████████████████  ║
                ║  ████████████████████████████████████████████████████████  ║
                ║                                                              ║
                ║  The ancient lighthouse beacon shines again!                 ║
                ║  Coordinates revealed: 53.179N 4.855E                        ║
                ║                                                              ║
                ║  The glyph matrix has been reconstructed perfectly.          ║
                ║  Ancient knowledge flows through your veins...               ║
                ╚══════════════════════════════════════════════════════════════╝
                """

        case 3:  // Beacon Analysis
            return """
                ╔══════════════════════════════════════════════════════════════╗
                ║                    🌊 BEACON ANALYSIS COMPLETE 🌊              ║
                ║                                                              ║
                ║  ████████████████████████████████████████████████████████  ║
                ║  ████████████████████████████████████████████████████████  ║
                ║  ████████████████████████████████████████████████████████  ║
                ║                                                              ║
                ║  The lighthouse has revealed the truth!                     ║
                ║  The rising tide threatens to flood the cave.               ║
                ║                                                              ║
                ║  You have successfully analyzed the tidal data,             ║
                ║  and the ancient beacon has saved your life...              ║
                ║                                                              ║
                ║  The wisdom of the ancients flows through you...            ║
                ╚══════════════════════════════════════════════════════════════╝
                """

        default:
            return """
                ╔══════════════════════════════════════════════════════════════╗
                ║                    ✨  CHAMBER UNLOCKED  ✨                    ║
                ║                                                              ║
                ║  ████████████████████████████████████████████████████████  ║
                ║  ████████████████████████████████████████████████████████  ║
                ║  ████████████████████████████████████████████████████████  ║
                ║                                                              ║
                ║  Another ancient barrier falls before your knowledge.       ║
                ║  The path forward reveals itself...                         ║
                ╚══════════════════════════════════════════════════════════════╝
                """
        }
    }
}

extension String {
    func repeating(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }
}
