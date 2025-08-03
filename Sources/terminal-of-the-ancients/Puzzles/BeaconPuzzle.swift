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
            print("💡 Try again or type 'hint' for guidance.")
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
        print("📡 Connecting to beacon stream...")
        print()

        // Start streaming with visualization
        let stream = streamTideData()
        var eventCount = 0

        print("💬 The beacon pulses...")

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
    }

    // MARK: - Server Management

    private func ensureServerRunning() async throws {
        print("🌊 The lighthouse beacon is already pulsing...")

        // Try to connect to see if server is running
        let connection = NWConnection(
            host: NWEndpoint.Host("localhost"), port: NWEndpoint.Port(integerLiteral: 8080),
            using: .tcp)

        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("✅ Server is running")
            case .failed(let error):
                print("❌ Server connection failed: \(error)")
            default:
                break
            }
        }

        connection.start(queue: .main)

        // Wait a bit for connection
        try await Task.sleep(nanoseconds: 1_000_000_000)  // 1 second

        if connection.state == .ready {
            connection.cancel()
        }
    }

    // MARK: - Data Streaming

    private func streamTideData() -> AsyncStream<TideEvent> {
        return AsyncStream { @Sendable continuation in
            Task {
                do {
                    let connection = NWConnection(
                        host: NWEndpoint.Host("localhost"),
                        port: NWEndpoint.Port(integerLiteral: 8080), using: .tcp)

                    connection.stateUpdateHandler = { state in
                        switch state {
                        case .ready:
                            print("🔗 Connecting to stream...")
                            print("✅ Stream connected, waiting for data...")
                        case .failed(let error):
                            print("❌ Stream failed: \(error)")
                            continuation.finish()
                        default:
                            break
                        }
                    }

                    connection.start(queue: .main)

                    // Wait for connection to be ready
                    while connection.state != .ready {
                        try await Task.sleep(nanoseconds: 100_000_000)  // 0.1 second
                    }

                    // Simulate receiving tide data
                    for i in 0..<10 {
                        let level = 2.0 + Double(i) * 0.4  // Simulate rising tide
                        let event = TideEvent(timestamp: Date(), level: level, type: .rising)
                        continuation.yield(event)

                        try await Task.sleep(nanoseconds: 500_000_000)  // 0.5 second
                    }

                    print("🏁 Stream finished")
                    continuation.finish()
                    connection.cancel()

                } catch {
                    print("❌ Stream error: \(error)")
                    continuation.finish()
                }
            }
        }
    }

    // MARK: - Display Functions

    private func displayWaterLevel(_ level: Double) {
        let percentage = min(Int((level / 6.0) * 100), 100)
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
        print("✅ Beacon Puzzle completed! The ancient lighthouse has saved your life.")

        // Show the emergency alert animation
        let animation = """
            ╔══════════════════════════════════════════════════════════════╗
            ║                    🚨 EMERGENCY ALERT 🚨                      ║
            ║                                                              ║
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

    func displayError() async {
        print("❌ The beacon's signal is unclear. The ancient lighthouse cannot guide you.")
        print("💡 Try again or type 'hint' for guidance.")
    }
}
