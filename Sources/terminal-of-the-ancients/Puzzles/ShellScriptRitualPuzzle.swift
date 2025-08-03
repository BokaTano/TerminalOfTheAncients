import Foundation
import ShellOut

struct ShellScriptRitualPuzzle: Puzzle {
    let id = 1
    let title = "The Shell Script Ritual"
    let description =
        "The ancient terminal displays a message:\n> \"The ancients automated their workflows with shell scripts.\n> Execute the sacred build script to prove your mastery.\"\n\nYou must run the build_and_run.sh script and provide the word 'automation' to prove you understand shell scripting."
    let hint = "Run the build script and then type 'automation' as your answer."
    let solution = "automation"

    func validate(input: String) async -> Bool {
        do {
            // First, try to run the build script to ensure it exists and works
            _ = try shellOut(to: "chmod +x build_and_run.sh && ./build_and_run.sh --status")

            // Check if the input is the expected answer
            return input.lowercased() == "automation"
        } catch {
            print("❌ Shell script execution failed: \(error)")
            return false
        }
    }
}
