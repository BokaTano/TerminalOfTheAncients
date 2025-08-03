import Foundation

struct WelcomeRitualPuzzle: Puzzle {
    let id = 0
    let title = "Welcome Ritual"
    let description =
        "To begin your journey, you must first prove you understand the ancient CLI ways. Launch this program with a specific flag to demonstrate your knowledge of argument parsing."
    let hint =
        "The ancient ones used flags to control their programs. Try using the help flag to discover available options."
    let solution = "--initiate"

    func validate(input: String) async -> Bool {
        // This is handled by the main program logic for --initiate flag
        return false
    }
}
