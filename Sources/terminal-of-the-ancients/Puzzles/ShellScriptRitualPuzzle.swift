import Foundation
import ShellOut

struct ShellScriptRitualPuzzle: Puzzle {
    let id = 1
    let title = "The Shell Script Ritual"
    let description =
        "The ancient terminal displays a message:\n> \"The ancients automated their workflows with shell scripts.\n> Execute the sacred build script to prove your mastery.\"\n\nFirst, run the build_and_run.sh script to prove you can execute shell scripts. Find the ✨Mark✨ to run it inside the game.Then, in a separate terminal, build a release version and install the CLI globally to complete the automation ritual."
    let hint =
        "First run './build_and_run.sh' to test shell script execution. Search for MARK: Puzzle Nr.2 and run the script with ShellOut. Then in another terminal: 'swift build -c release' and 'sudo cp .build/release/TOTA /usr/local/bin/tota'"

    func validate(input: String) async -> Bool {
        // MARK: Puzzle Nr. 2: Check if the build script can be executed successfully with ShellOut

        print("🔨 Running build script...")
        /*
            do {
            ... Your code here ...
                return true
            } catch {
                return false
            }
        */
        return false
    }

    func displaySuccess() async {
        print("✅ Shell Script Ritual completed! You have mastered the ancient art of automation.")
        print("🎯 You can now use 'tota' as a global CLI tool, just like git, npm, or docker!")
    }

    func displayError() async {
        print("❌ The ancient automation chamber rejects your offering.")
        print("💡 Follow the automation ritual:")
        print("   1. Run './build_and_run.sh' to test shell script execution")
        print("   2. In another terminal:")
        print(
            "       ```swift build -c release && sudo cp .build/release/TOTA /usr/local/bin/tota```"
        )
        print("   3. Then come back and try again")
    }

}
