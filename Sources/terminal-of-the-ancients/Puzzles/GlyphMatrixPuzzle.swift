import CryptoKit
import Foundation

struct GlyphMatrixPuzzle: Puzzle {
    let id = 2
    let title = "Restore the Glyph Matrix"
    let description =
        "The lighthouse beacon has gone dark. Write a Swift script that reads glyphs from SwiftData and reconstructs the ASCII art."
    let hint = "Use the provided render_glyphs.swift tool. Run it with: ./run_render_glyphs.sh"
    let solution = "glyph_matrix"

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
        // Create process to run the script - use the same default store as the game
        let process = Process()
        process.executableURL = URL(fileURLWithPath: binaryPath)
        process.arguments = []

        // Capture stdout
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""

        // Normalize line endings, strip ANSI color codes, and trim only trailing whitespace
        let normalizedOutput =
            output
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: #"\u{001B}\[[0-9;]*m"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #" +$"#, with: "", options: .regularExpression)  // Only trim trailing spaces
            .replacingOccurrences(of: #"\n+$"#, with: "", options: .regularExpression)  // Remove trailing newlines

        // Get expected ASCII
        let expectedASCII =
            "        |\n        |\n       /_\\\n       |#|\n       |#|\n      /###\\\n      |###|\n------|###|------\n      |###|\n      |###|\n      '---'\n  EIERLAND LIGHTHOUSE\n   53.179N 4.855E"

        // Compare using SHA256
        let outputHash = SHA256.hash(data: normalizedOutput.data(using: .utf8) ?? Data())
        let expectedHash = SHA256.hash(data: expectedASCII.data(using: .utf8) ?? Data())

        return outputHash == expectedHash
    }

    func setup() async throws {
        // This will be handled by GameEngine with dataService.seedGlyphMatrix()
        // We don't implement it here since it needs access to dataService
    }
}
