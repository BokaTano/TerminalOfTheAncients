import CryptoKit
import Foundation
import Subprocess
import System

struct GlyphMatrixPuzzle: Puzzle {
    let id = 2
    let title = "Restore the Glyph Matrix"
    let description =
        "The lighthouse beacon has gone dark. Write a Swift script that reads glyphs from SwiftData and reconstructs the ASCII art."
    let hint =
        "Use the provided render_glyphs.swift tool. Run it with: ./Tools/run_render_glyphs.sh"

    func validate(input: String) async -> Bool {
        // Validate the binary path
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: input) else {
            print("❌ Binary not found at path: \(input)")
            print("💡 Make sure the path is correct and the file exists.")
            return false
        }

        // Try to run the script
        do {
            return try await validateGlyphMatrixScript(binaryPath: input)
        } catch {
            print("❌ Failed to run script: \(error)")
            print("💡 Make sure the script is compiled and executable.")
            return false
        }
    }

    private func validateGlyphMatrixScript(binaryPath: String) async throws -> Bool {
        // Execute the binary using Subprocess. The script should print the
        // reconstructed ASCII art to standard output.
        let result = try await run(.path(FilePath(binaryPath)), output: .string(limit: 1024 * 1024))
        guard result.terminationStatus == .exited(0) else {
            return false
        }
        let output = result.standardOutput ?? ""

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
        print("❌ The glyph matrix remains fragmented. The lighthouse beacon stays dark.")
        print("💡 Try again or type 'hint' for guidance.")
    }
}
