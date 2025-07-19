import Foundation
import SwiftData

@Model
final class PlayerProgress {
    var currentTaskIndex: Int
    var completedTasks: Set<Int>
    var createdAt: Date
    var lastPlayed: Date
    
    init() {
        self.currentTaskIndex = 0
        self.completedTasks = []
        self.createdAt = Date()
        self.lastPlayed = Date()
    }
}



struct Puzzle {
    let id: Int
    let title: String
    let description: String
    let hint: String
    let validator: (String) -> Bool
    let solution: String
    
    init(id: Int, title: String, description: String, hint: String, solution: String, validator: @escaping (String) -> Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.hint = hint
        self.solution = solution
        self.validator = validator
    }
    
    static var allPuzzles: [Puzzle] {
        return [
            Puzzle(
                id: 0,
                title: "The Sigil Compiler",
                description: "The compiler hums quietly. A message appears:\n> \"The ancients encoded their secrets inside the source.\n> Speak the sigil 'illumina' within the sacred file and reawaken me.\"\n\nYou must modify the Sigil.swift file and rebuild the project.",
                hint: "Open Sigil.swift and change the empty string to 'illumina', then run 'swift build'.",
                solution: "illumina",
                validator: { _ in
                    Sigil.playerSigil.lowercased() == "illumina"
                }
            ),
            Puzzle(
                id: 1,
                title: "Welcome Ritual",
                description: "To begin your journey, you must first prove you understand the ancient CLI ways. Launch this program with the '--initiate' flag to demonstrate your knowledge of argument parsing.",
                hint: "The ancient ones used flags to control their programs. You need to restart this program with a specific flag.",
                solution: "--initiate",
                validator: { _ in false } // Handled by main program logic
            ),
            Puzzle(
                id: 2,
                title: "The Echo Chamber",
                description: "The ancient terminal echoes your words back to you. To proceed, you must echo back exactly what the terminal says to you. The terminal will say: 'swift'",
                hint: "Simply type the word that the terminal displays to you.",
                solution: "swift",
                validator: { input in input.lowercased() == "swift" }
            ),
            Puzzle(
                id: 3,
                title: "The File of Truth",
                description: "A mysterious file has appeared in your current directory: 'secret_code.txt'. Read its contents and extract the secret code hidden within.",
                hint: "The file contains a simple text message. Look for any words that might be a code or password.",
                solution: "ancient",
                validator: { input in input.lowercased() == "ancient" }
            ),
            Puzzle(
                id: 4,
                title: "The JSON Codex",
                description: "The ancients left behind a JSON file called 'treasure.json'. Decode it to find the required answer. The file contains an object with a 'key' field.",
                hint: "Parse the JSON and look for the value of the 'key' field.",
                solution: "swiftdata",
                validator: { input in input.lowercased() == "swiftdata" }
            ),
            Puzzle(
                id: 5,
                title: "The Vault Gate",
                description: "The terminal displays corrupted data: 'T3rm1n4l_0f_th3_4nc13nts'. You must recover the correct content by replacing numbers with letters (3→e, 4→a, 1→l, 0→o).",
                hint: "Look at the pattern: numbers are being used as letters. 3=e, 4=a, 1=l, 0=o",
                solution: "terminal_of_the_ancients",
                validator: { input in input.lowercased() == "terminal_of_the_ancients" }
            )
        ]
    }
} 