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
        // Simply check if the user entered the correct answer
        return input.lowercased() == "automation"
    }

    func displaySuccess() async {
        print("✅ Shell Script Ritual completed! You have mastered the ancient art of automation.")
    }

    func displayError() async {
        print("❌ The ancient automation chamber rejects your offering.")
        print("💡 Try again or type 'hint' for guidance.")
    }
}
