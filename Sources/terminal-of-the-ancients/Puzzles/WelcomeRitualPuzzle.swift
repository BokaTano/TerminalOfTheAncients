import Foundation

struct WelcomeRitualPuzzle: Puzzle {
    let id = 0
    let title = "Welcome Ritual"
    let description =
        "To begin your journey, you must first prove you understand the ancient CLI ways. Launch this program with a specific flag to demonstrate your knowledge of argument parsing."
    let hint =
        "The ancient ones used flags to control their programs. Try to quit the CLI and use the help flag to discover available options."

    func validate(input: String) async -> Bool {
        // This is handled by the main program logic for --welcome flag
        return false
    }

    func displaySuccess() async {
        print("✅ Welcome Ritual completed! You have proven your knowledge of CLI argument parsing.")
    }

    func displayError() async {
        print("❌ The ancient terminal remains silent. You must demonstrate your CLI knowledge.")
        print("💡 Try again or type 'hint' for guidance.")
    }
}
