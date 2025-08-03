import Foundation
import ShellOut

struct ShellScriptRitualPuzzle: Puzzle {
    let id = 1
    let title = "The Shell Script Ritual"
    let description =
        "The ancient terminal displays a message:\n> \"The ancients automated their workflows with shell scripts.\n> Execute the sacred build script to prove your mastery.\"\n\nRun the build_and_run.sh script with swift. But then enter `start` to try to run it."
    let hint =
        "Run the build script and look for the word that represents the ancient practice of automating tasks."

    func validate(input: String) async -> Bool {
        do {
            // Run the build script and capture its output
            // print something that shows the user is running the script
            print("🔨 Running build script...")
            try shellOut(to: "./build_and_run.sh")
            return true
        } catch {
            return false
        }
    }

    func displaySuccess() async {
        print("✅ Shell Script Ritual completed! You have mastered the ancient art of automation.")
    }

    func displayError() async {
        print("❌ The ancient automation chamber rejects your offering.")
        print("💡 Try again or type 'hint' for guidance.")
    }
}
