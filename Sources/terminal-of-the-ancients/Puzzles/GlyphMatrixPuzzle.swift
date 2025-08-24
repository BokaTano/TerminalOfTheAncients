import CryptoKit
import Foundation
import ShellOut
import System

struct GlyphMatrixPuzzle: Puzzle {
    let id = 2
    let title = "Restore the Glyph Matrix"
    let description =
        "The ancients gave you rights to an old database. Write a Swift script that reads their glyphs and reconstructs the ancient ASCII art. "
    let hint =
        "Use the provided render_glyphs.swift from tools folder. Run it with: ./Tools/run_render_glyphs.sh and search for MARK: Puzzle Nr. 3"

    func validate(input: String) async -> Bool {

        // Try to run the script
        do {
            return try await validateGlyphMatrixScript()
        } catch {
            print("❌ Failed to run script: \(error)")
            print("💡 Make sure the script is compiled and executable.")
            return false
        }
    }

    private func validateGlyphMatrixScript() async throws -> Bool {
        // Execute the binary using ShellOut. The script should print the
        // reconstructed ASCII art to standard output.
        let output = try shellOut(to: "./Tools/run_render_glyphs.sh")

        // Normalize line endings, strip ANSI color codes, and trim only trailing whitespace
        let normalizedOutput =
            output
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(
                of: #"\u{001B}\[[0-9;]*m"#, with: "",
                options: String.CompareOptions.regularExpression
            )
            .replacingOccurrences(
                of: #" +$"#, with: "", options: String.CompareOptions.regularExpression
            )  // Only trim trailing spaces
            .replacingOccurrences(
                of: #"\n+$"#, with: "", options: String.CompareOptions.regularExpression)  // Remove trailing newlines

        // Get expected ASCII
        let expectedASCII =
            "        |\n        |\n       /_\\\n       |#|\n       |#|\n      /###\\\n      |###|\n------|###|------\n      |###|\n      |###|\n      '---'\n  EIERLAND LIGHTHOUSE\n   53.179N 4.855E"

        // Compare using SHA256
        let outputHash = SHA256.hash(
            data: normalizedOutput.data(using: String.Encoding.utf8) ?? Data())
        let expectedHash = SHA256.hash(
            data: expectedASCII.data(using: String.Encoding.utf8) ?? Data())

        return outputHash == expectedHash
    }

    func setup() async throws {
        // This will be handled by GameEngine with dataService.seedGlyphMatrix()
        // We don't implement it here since it needs access to dataService
    }

    func displaySuccess() async {
        print("✅ Glyph Matrix restored! The ancient lighthouse emerges from the digital depths.")
    }

    func displayError() async {
        print("❌ The glyph matrix remains fragmented. The ancient ASCII art is not recognizable.")
        print("💡 Try again or type 'hint' for guidance.")
    }
}
