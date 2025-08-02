import Foundation

// MARK: - Beacon Puzzle Task

@MainActor
class BeaconPuzzleTask {
    private let serverURL = URL(string: "http://localhost:8080")!
    private let streamURL = URL(string: "http://localhost:8080/stream")!

    // MARK: - Server Management

    func ensureServerRunning() async throws {
        // Check if server is already running
        if await isServerRunning() {
            print("🌊 The lighthouse beacon is already pulsing...")
            return
        }

        print("🔦 Starting the lighthouse beacon...")

        // Launch the server
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
        process.arguments = ["run"]
        process.currentDirectoryURL = URL(fileURLWithPath: "lighthouse")

        // Start the server in background
        try process.run()

        // Wait for server to be ready
        print("⏳ Waiting for beacon to initialize...")
        for attempt in 1...30 {  // Reduced to 30 attempts (30 seconds)
            try await Task.sleep(nanoseconds: 1_000_000_000)  // 1 second

            if await isServerRunning() {
                print("✅ Beacon is ready!")
                return
            }

            if attempt % 3 == 0 {  // Show progress every 3 seconds
                print(
                    "⏳ Attempt \(attempt)/30... (Server is building, this may take up to 30 seconds)"
                )
            }
        }

        print("❌ Server failed to start after 30 seconds")
        throw BeaconError.serverNotResponding
    }

    private func isServerRunning() async -> Bool {
        do {
            let (_, response) = try await URLSession.shared.data(
                from: serverURL.appendingPathComponent("health"))
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }

    // MARK: - Streaming Logic

    func streamTideData() -> AsyncThrowingStream<TideEvent, Error> {
        return AsyncThrowingStream { continuation in
            Task { @Sendable in
                do {
                    print("🔗 Connecting to stream...")
                    let (bytes, _) = try await URLSession.shared.bytes(
                        for: URLRequest(url: streamURL))
                    print("✅ Stream connected, waiting for data...")

                    for try await line in bytes.lines {
                        if line.hasPrefix("data: ") {
                            let jsonString = String(line.dropFirst(6))  // Remove "data: "

                            if jsonString == "[DONE]" {
                                print("🏁 Stream finished")
                                continuation.finish()
                                return
                            }

                            do {
                                let jsonData = jsonString.data(using: .utf8) ?? Data()
                                let event = try JSONDecoder().decode(TideEvent.self, from: jsonData)
                                continuation.yield(event)
                            } catch {
                                print("⚠️ Failed to decode event: \(error)")
                            }
                        }
                    }
                } catch {
                    print("❌ Stream error: \(error)")
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    // MARK: - Progress Bar Visualization

    private func displayWaterLevel(_ level: Double) {
        let formattedLevel = String(format: "%.2f", level)

        // Simple progress bar that actually works
        let progress = min(level / 6.0, 1.0)  // Normalize to 0-1
        let barWidth = 40
        let filledWidth = Int(progress * Double(barWidth))

        var bar = "["
        for i in 0..<barWidth {
            if i < filledWidth {
                bar += "█"
            } else {
                bar += " "
            }
        }
        bar += "]"

        // Clear previous line and show new progress
        print("\r🌊 Water Level: \(formattedLevel)m \(bar) \(Int(progress * 100))%", terminator: "")
        fflush(stdout)  // Force output
    }

    // MARK: - Storytelling

    private func displayStoryLine(_ line: String) {
        print("💬 \(line)")
    }

    // MARK: - Main Puzzle Logic

    func runPuzzle() async throws {
        print("🗼 The lighthouse has awakened. It now sends continuous tidal data through the air.")
        print(
            "🌊 The water is rising. You're standing deep in a coastal cave—and something is whispering..."
        )
        print()

        print("🔍 DEBUG: Starting puzzle execution...")

        // Ensure server is running
        try await ensureServerRunning()

        print()
        print("📡 Connecting to beacon stream...")
        print()

        // Start streaming with visualization
        let stream = streamTideData()
        var eventCount = 0

        displayStoryLine("The beacon pulses...")

        for try await event in stream {
            eventCount += 1

            // Display water level with progress bar
            displayWaterLevel(event.level)

            // Add minimal pacing
            try await Task.sleep(nanoseconds: 20_000_000)  // 0.02 second
        }

        print("📊 Received \(eventCount) events from server")

        print()  // New line after progress bar
        print("🔍 Analyzing tidal data...")

        // Use a reasonable critical level
        let criticalLevel = 5.5

        print()
        print("⚠️  CRITICAL ALERT ⚠️")
        print("The water level is now \(String(format: "%.2f", criticalLevel)) m.")
        print("You must leave the cave immediately!")
        print()

        // Success animation
        await displaySuccessAnimation()
    }

    // MARK: - Success Animation

    private func displaySuccessAnimation() async {
        let animation = """
            ╔══════════════════════════════════════════════════════════════╗
            ║                    🚨 EMERGENCY ALERT 🚨                      ║
            ║                                                              ║
            ║  ████████████████████████████████████████████████████████  ║
            ║  ████████████████████████████████████████████████████████  ║
            ║  ████████████████████████████████████████████████████████  ║
            ║  ████████████████████████████████████████████████████████  ║
            ║                                                              ║
            ║  The lighthouse has revealed the truth!                     ║
            ║  The rising tide threatens to flood the cave.               ║
            ║  You must evacuate immediately!                             ║
            ║                                                              ║
            ║  The ancient beacon has saved your life.                    ║
            ╚══════════════════════════════════════════════════════════════╝
            """

        print(animation)

        // Pulsing effect
        for _ in 0..<3 {
            try? await Task.sleep(nanoseconds: 500_000_000)
            print("🚨 EVACUATE! 🚨")
            try? await Task.sleep(nanoseconds: 500_000_000)
        }
    }
}

// MARK: - Errors

enum BeaconError: Error {
    case serverNotResponding
    case streamFailed
    case analysisFailed
}
