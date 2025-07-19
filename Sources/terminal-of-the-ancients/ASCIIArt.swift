import Foundation
import Rainbow

class ASCIIArt {
    
    static func showTempleEntrance() {
        let temple = """
        
        ╔══════════════════════════════════════════════════════════════╗
        ║                    🏛️  TEMPLE OF THE ANCIENTS  🏛️              ║
        ║                                                              ║
        ║                  ___            %.                           ║
        ║           __  __/__/I__  ______% %%'                         ║
        ║          / __/_[___]/_/I--.   /%%%%                         ║
        ║         / /  I_/=/I__I/  /I  // )(                          ║
        ║        / /____/=/ /_____//  //                               ║
        ║       /  I___/=/ /_____I/  //                                ║
        ║      /______/=/ /_________//                                 ║
        ║      I_____/=/ /_________I/MJP                               ║
        ║           /=/_/                                               ║
        ║                                                              ║
        ║  You stand before the ancient temple, its weathered          ║
        ║  stones bearing the marks of countless centuries.            ║
        ║  The entrance beckons you forward...                         ║
        ╚══════════════════════════════════════════════════════════════╝
        
        """
        print(temple.green.bold)
    }
    
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
        
        print("\u{1B}[2J\u{1B}[H") // Clear screen
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
    
    static func animateDoorOpening() async {
        let frames = [
            // Frame 1: Closed door - realistic stone door
            """
            
            ╔══════════════════════════════════════════════════════════════╗
            ║                    🚪 ANCIENT DOOR 🚪                        ║
            ║                                                              ║
            ║      ______                                                  ║
            ║   ,-' ;  ! `-.                                               ║
            ║  / :  !  :  . \\                                              ║
            ║ |_ ;   __:  ;  |                                             ║
            ║ )| .  :)(.  !  |                                             ║
            ║ |"    (##)  _  |                                             ║
            ║ |  :  ;`'  (_) (                                             ║
            ║ |  :  :  .     |                                             ║
            ║ )_ !  ,  ;  ;  |                                             ║
            ║ || .  .  :  :  |                                             ║
            ║ |" .  |  :  .  |                                             ║
            ║ |mt-2_;----.___|                                             ║
            ║                                                              ║
            ║  The ancient stone door stands before you,                  ║
            ║  its surface covered in mysterious runes...                 ║
            ╚══════════════════════════════════════════════════════════════╝
            """,
            
            // Frame 2: Door starting to open - showing gap
            """
            
            ╔══════════════════════════════════════════════════════════════╗
            ║                    🚪 ANCIENT DOOR 🚪                        ║
            ║                                                              ║
            ║      ______                                                  ║
            ║   ,-' ;  ! `-.                                               ║
            ║  / :  !  :  . \\                                              ║
            ║ |_ ;   __:  ;  |                                             ║
            ║ )| .  :)(.  !  |                                             ║
            ║ |"    (##)  _  |                                             ║
            ║ |  :  ;`'  (_) (                                             ║
            ║ |  :  :  .     |                                             ║
            ║ )_ !  ,  ;  ;  |                                             ║
            ║ || .  .  :  :  |                                             ║
            ║ |" .  |  :  .  |                                             ║
            ║ |mt-2_;----.___|                                             ║
            ║                                                              ║
            ║  The door begins to creak open, revealing                   ║
            ║  a sliver of golden light from within...                    ║
            ╚══════════════════════════════════════════════════════════════╝
            """,
            
            // Frame 3: Door partially open - wider gap
            """
            
            ╔══════════════════════════════════════════════════════════════╗
            ║                    🚪 ANCIENT DOOR 🚪                        ║
            ║                                                              ║
            ║      ______                                                  ║
            ║   ,-' ;  ! `-.                                               ║
            ║  / :  !  :  . \\                                              ║
            ║ |_ ;   __:  ;  |                                             ║
            ║ )| .  :)(.  !  |                                             ║
            ║ |"    (##)  _  |                                             ║
            ║ |  :  ;`'  (_) (                                             ║
            ║ |  :  :  .     |                                             ║
            ║ )_ !  ,  ;  ;  |                                             ║
            ║ || .  .  :  :  |                                             ║
            ║ |" .  |  :  .  |                                             ║
            ║ |mt-2_;----.___|                                             ║
            ║                                                              ║
            ║  The door swings wider, ancient mechanisms                   ║
            ║  grinding as stone slides against stone...                   ║
            ╚══════════════════════════════════════════════════════════════╝
            """,
            
            // Frame 4: Door mostly open - large opening
            """
            
            ╔══════════════════════════════════════════════════════════════╗
            ║                    🚪 ANCIENT DOOR 🚪                        ║
            ║                                                              ║
            ║      ______                                                  ║
            ║   ,-' ;  ! `-.                                               ║
            ║  / :  !  :  . \\                                              ║
            ║ |_ ;   __:  ;  |                                             ║
            ║ )| .  :)(.  !  |                                             ║
            ║ |"    (##)  _  |                                             ║
            ║ |  :  ;`'  (_) (                                             ║
            ║ |  :  :  .     |                                             ║
            ║ )_ !  ,  ;  ;  |                                             ║
            ║ || .  .  :  :  |                                             ║
            ║ |" .  |  :  .  |                                             ║
            ║ |mt-2_;----.___|                                             ║
            ║                                                              ║
            ║  The door is nearly fully open, revealing                   ║
            ║  the chamber beyond...                                       ║
            ╚══════════════════════════════════════════════════════════════╝
            """,
            
            // Frame 5: Door fully open - revealed chamber
            """
            
            ╔══════════════════════════════════════════════════════════════╗
            ║                    🚪 ANCIENT DOOR 🚪                        ║
            ║                                                              ║
            ║      ______                                                  ║
            ║   ,-' ;  ! `-.                                               ║
            ║  / :  !  :  . \\                                              ║
            ║ |_ ;   __:  ;  |                                             ║
            ║ )| .  :)(.  !  |                                             ║
            ║ |"    (##)  _  |                                             ║
            ║ |  :  ;`'  (_) (                                             ║
            ║ |  :  :  .     |                                             ║
            ║ )_ !  ,  ;  ;  |                                             ║
            ║ || .  .  :  :  |                                             ║
            ║ |" .  |  :  .  |                                             ║
            ║ |mt-2_;----.___|                                             ║
            ║                                                              ║
            ║  The door stands fully open, revealing the                   ║
            ║  ancient chamber within...                                   ║
            ╚══════════════════════════════════════════════════════════════╝
            """
        ]
        
        for (index, frame) in frames.enumerated() {
            print("\u{1B}[2J\u{1B}[H") // Clear screen
            print(frame.cyan)
            
            // Add some dramatic text
            if index == 0 {
                print("\n🔍 Ancient mechanisms begin to stir...")
            } else if index == 1 {
                print("\n⚙️  Gears grind and stone shifts...")
            } else if index == 2 {
                print("\n💫 Mystical energy flows through the door...")
            } else if index == 3 {
                print("\n✨ The ancient barrier yields...")
            } else if index == 4 {
                print("\n🌟 The chamber reveals itself!")
            }
            
            try? await Task.sleep(for: .milliseconds(800)) // 0.8 seconds per frame
        }
    }
    
    static func showChamberUnlocked(taskId: Int) async {
        await showProgressBar()
        
        // Animate the door opening
        await animateDoorOpening()
        
        // Show the final chamber art
        let art = getChamberArt(taskId: taskId)
        print("\u{1B}[2J\u{1B}[H") // Clear screen
        print(art.green.bold)
        
        // Add some dramatic pause
        try? await Task.sleep(for: .seconds(2)) // 2 seconds to appreciate the art
    }
    
    private static func getChamberArt(taskId: Int) -> String {
        switch taskId {
        case 0: // Welcome Ritual
            return """
            
            ╔══════════════════════════════════════════════════════════════╗
            ║                    🏛️  CHAMBER UNLOCKED  🏛️                   ║
            ║                                                              ║
            ║  ████████████████████████████████████████████████████████    ║
            ║  ████████████████████████████████████████████████████████    ║
            ║  ████████████████████████████████████████████████████████    ║
            ║  ████████████████████████████████████████████████████████    ║
            ║  ████████████████████████████████████████████████████████    ║
            ║  ████████████████████████████████████████████████████████    ║
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
            
        case 1: // The Echo Chamber
            return """
            
            ╔══════════════════════════════════════════════════════════════╗
            ║                    🎵  ECHO RESONANCE  🎵                     ║
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
            ║  The chamber walls shimmer with ethereal light as your      ║
            ║  voice echoes back perfectly. The ancient acoustic          ║
            ║  crystals embedded in the walls begin to glow.              ║
            ║                                                              ║
            ║  A hidden passage reveals itself, the stone sliding         ║
            ║  away to expose the next challenge.                         ║
            ║                                                              ║
            ║  The Echo Chamber recognizes your harmony with the          ║
            ║  ancient frequencies...                                     ║
            ╚══════════════════════════════════════════════════════════════╝
            
            """
            
        case 2: // The File of Truth
            return """
            
            ╔══════════════════════════════════════════════════════════════╗
            ║                    📜  ARCHIVES UNSEALED  📜                  ║
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
            ║  The ancient scrolls glow with mystical energy as you       ║
            ║  decipher the hidden code. Dust swirls in the air as        ║
            ║  centuries-old knowledge is revealed.                       ║
            ║                                                              ║
            ║  The stone floor beneath you begins to shift, opening       ║
            ║  a passage to the deeper archives.                          ║
            ║                                                              ║
            ║  The wisdom of the ancients flows through you...            ║
            ╚══════════════════════════════════════════════════════════════╝
            
            """
            
        case 3: // The JSON Codex
            return """
            
            ╔══════════════════════════════════════════════════════════════╗
            ║                    🔐  CODEX DECRYPTED  🔐                    ║
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
            ║  The ancient JSON structure pulses with digital life as     ║
            ║  you unlock its secrets. Binary patterns dance across       ║
            ║  the walls like living code.                                ║
            ║                                                              ║
            ║  A holographic projection materializes, showing the         ║
            ║  path to the final vault.                                   ║
            ║                                                              ║
            ║  The data flows like a digital river, carrying you          ║
            ║  toward the ultimate challenge...                           ║
            ╚══════════════════════════════════════════════════════════════╝
            
            """
            
        case 4: // The Vault Gate
            return """
            
            ╔══════════════════════════════════════════════════════════════╗
            ║                    🏆  MASTERY ACHIEVED  🏆                    ║
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
            ║  The final vault door swings open with a thunderous         ║
            ║  roar. Golden light floods the chamber as you step           ║
            ║  into the heart of the Terminal of the Ancients.             ║
            ║                                                              ║
            ║  Ancient holographic displays surround you, showing         ║
            ║  the complete knowledge of the lost Swift civilization.      ║
            ║                                                              ║
            ║  You have become a true master of the CLI arts!             ║
            ║  The secrets of the ancients are now yours...               ║
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
            ║  ████████████████████████████████████████████████████████  ║
            ║  ████████████████████████████████████████████████████████  ║
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