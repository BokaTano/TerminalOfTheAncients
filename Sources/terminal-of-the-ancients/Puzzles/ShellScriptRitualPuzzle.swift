import Foundation

struct ShellScriptRitualPuzzle: Puzzle {
    let id = 1
    let title = "The Shell Script Ritual"
    let description =
        "The ancient terminal displays a message:\n> \"The ancients automated their workflows with shell scripts.\n> Execute the sacred build script to prove your mastery.\"\n\nFirst, run the build_and_run.sh script to prove you can execute shell scripts. Then, in a separate terminal, build a release version and install the CLI globally to complete the automation ritual."
    let hint =
        "First run './build_and_run.sh' to test shell script execution. Then in another terminal: 'swift build -c release' and 'sudo cp .build/release/TOTA /usr/local/bin/tota'"

    func validate(input: String) async -> Bool {
        // Step 1: Check if the build script can be executed successfully
        do {
            print("🔨 Running build script...")
            let result = try await runCommand("./build_and_run.sh")
            print("📝 Build output: \(result)")
        } catch {
            print("❌ Build script failed: \(error)")
            return false
        }

        // Step 2: Check if the global CLI is installed
        do {
            print("🔨 Validating global CLI installation...")
            let result = try await runCommand("tota", "--status")
            print("📝 CLI status: \(result)")
            return true
        } catch {
            print("❌ CLI not found: \(error)")
            return false
        }
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
    
    // MARK: - Modern Swift Process Execution (Swift 6.2+ compatible)

    private func runCommand(_ command: String, _ arguments: String...) async throws -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = [command] + arguments

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""

        if process.terminationStatus != 0 {
            throw ProcessError.nonZeroExit(code: process.terminationStatus, output: output)
        }

        return output.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    enum ProcessError: LocalizedError {
        case nonZeroExit(code: Int32, output: String)

        var errorDescription: String? {
            switch self {
            case .nonZeroExit(let code, let output):
                return "Process exited with code \(code): \(output)"
            }
        }
    }
}
