import Foundation
import Network

struct BeaconPuzzle: Puzzle {
    let id = 3
    let title = "The Voice of the Lighthouse"
    let description =
        "The lighthouse has awakened and now sends continuous tidal data through the air. The water is rising. You're standing deep in a coastal cave—and something is whispering..."
    let hint =
        "The beacon streams data that you must analyze. Connect to the server and extract the critical water level."

    func validate(input: String) async -> Bool {
        do {
            try await runPuzzle()
            return true
        } catch {
            print("❌ Beacon analysis failed: \(error)")
            print(
                "💡 The lighthouse server may not be running. Try again or type 'hint' for guidance."
            )
            return false
        }
    }

    func setup() async throws {
        try await ensureServerRunning()
    }

    // MARK: - Puzzle Implementation

    @MainActor
    private func runPuzzle() async throws {
        print()
        print("💬 The beacon pulses...")
        print()

        // Start streaming with visualization
        let stream = streamTideData()

        for try await event: TideEvent in stream {
            // Display water level with progress bar
            displayWaterLevel(event.level)

            // Add minimal pacing for the animation
            try await Task.sleep(nanoseconds: 20_000_000)  // 0.02 second
        }

        print()
        print("🔍 Analyzing tidal data...")
        print()
        try await Task.sleep(nanoseconds: 1_000_000_000)  // 1 second
    }

    // MARK: - Server Management

    private func ensureServerRunning() async throws {
        // First, try to connect to see if server is already running
        if await isServerRunning() {
            return
        }

        // Start the lighthouse server using the script
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["./start_lighthouse.sh"]
        process.currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        try process.run()

        // Don't wait for the script to exit since it runs the server in background
        // Instead, wait a moment and then check if server is running
        try await Task.sleep(nanoseconds: 3_000_000_000)  // 3 seconds

        // Check if server is now running
        if await isServerRunning() == false {
            throw BeaconError.serverStartFailed
        }
    }

    private func isServerRunning() async -> Bool {
        guard let url = URL(string: "http://localhost:8080/health") else {
            return false
        }

        do {
            let (_, response) = try await URLSession.shared.data(from: url)
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }

    enum BeaconError: Error {
        case serverStartFailed
    }

    // MARK: - Data Streaming

    private func streamTideData() -> AsyncStream<TideEvent> {
        return AsyncStream { @Sendable continuation in
            Task {
                do {
                    // Create URL for the lighthouse server stream endpoint
                    guard let url = URL(string: "http://localhost:8080/stream") else {
                        print("❌ Invalid URL")
                        continuation.finish()
                        return
                    }

                    var request = URLRequest(url: url)
                    request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
                    request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")

                    let (asyncBytes, response) = try await URLSession.shared.bytes(for: request)

                    guard let httpResponse = response as? HTTPURLResponse,
                        httpResponse.statusCode == 200
                    else {
                        print("❌ Server responded with error")
                        continuation.finish()
                        return
                    }

                    // Parse Server-Sent Events
                    for try await line in asyncBytes.lines {
                        if line.hasPrefix("data: ") {
                            let dataString = String(line.dropFirst(6))  // Remove "data: "

                            if dataString == "[DONE]" {
                                continuation.finish()
                                return
                            }

                            // Parse JSON data
                            if let data = dataString.data(using: .utf8),
                                let event = try? JSONDecoder().decode(TideEvent.self, from: data)
                            {
                                continuation.yield(event)
                            }
                        }
                    }

                    continuation.finish()
                } catch {
                    print("❌ Stream error: \(error)")
                    continuation.finish()
                }
            }
        }
    }

    // MARK: - Display Functions

    private func displayWaterLevel(_ level: Double) {
        // Use a more realistic maximum water level for the progress bar
        let maxLevel = 8.0  // 8 meters is a reasonable high tide level
        let percentage = min(Int((level / maxLevel) * 100), 100)
        let barLength = 50
        let filledLength = Int((Double(percentage) / 100.0) * Double(barLength))
        let bar =
            String(repeating: "█", count: filledLength)
            + String(repeating: " ", count: barLength - filledLength)

        print(
            "🌊 Water Level: \(String(format: "%.2f", level))m [\(bar)] \(percentage)%",
            terminator: "\r")
        fflush(stdout)  // Force output
    }

    func displaySuccess() async {
        let criticalLevel = 5.5

        let emergencyAlert = """
            ╔══════════════════════════════════════════════════════════════╗
            ║                    🚨 EMERGENCY ALERT 🚨                      ║
            ║                                                              ║
            ║                                                              ║
            ║  The lighthouse has revealed the truth!                     ║
            ║  The water level is now \(String(format: "%.2f", criticalLevel)) m.                    ║
            ║  The rising tide threatens to flood the cave.               ║
            ║  You must evacuate immediately!                             ║
            ║                                                              ║
            ║  The ancient beacon has saved your life.                    ║
            ╚══════════════════════════════════════════════════════════════╝
            """

        print(emergencyAlert)
        print()

        try? await Task.sleep(nanoseconds: 3_000_000_000)

        // Pulsing effect
        for _ in 0..<3 {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            print("🚨 EVACUATE! 🚨")
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
        print()
    }

    func displayError() async {
        print("❌ The beacon's signal is unclear. The ancient lighthouse cannot guide you.")
        print("💡 Try again or type 'hint' for guidance.")
    }
}
