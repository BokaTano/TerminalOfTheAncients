import Foundation
import Network
import ShellOut

struct BeaconPuzzle: Puzzle {
    let id = 3
    let title = "The Voice of the Lighthouse"
    let description =
        "The lighthouse has awakened and now sends continuous tidal data through the air. The water is rising. You're standing deep in a coastal cave—and and suddenly you feel water on your feet..."
    let hint =
        "The beacon streams data that you must analyze. Connect to the server and extract the critical water level. Search for MARK: Puzzle Nr. 4"

    func validate(input: String) async -> Bool {
        do {
            try await runPuzzle()
            return true
        } catch {
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
        print("💬 The beacon pulses... Wait a few seconds for the data to start flowing...")
        print()

        // Start streaming with visualization
        do {
            let stream = try await streamTideDataWithTimeout()

            // Validation: Ensure we got meaningful data
            var eventCount = 0
            for try await event in stream {
                eventCount += 1
                // Display water level with progress bar
                displayWaterLevel(event.level)

                // Add minimal pacing for the animation
                try await Task.sleep(nanoseconds: 20_000_000)  // 0.02 second
            }

            // Check if we received any events
            if eventCount == 0 {
                throw BeaconError.noDataReceived
            }

            print()
            print("🔍 Analyzing tidal data...")
            print()
            try await Task.sleep(nanoseconds: 1_000_000_000)  // 1 second
        } catch let error as TideStreamError {
            switch error {
            case .incompleteImplementation:
                throw BeaconError.incompleteImplementation
            case .timeout:
                throw BeaconError.timeout
            case .serverError:
                throw BeaconError.serverError
            case .invalidData:
                throw BeaconError.invalidData
            }
        } catch {
            throw error
        }
    }

    // MARK: - Server Management

    private func ensureServerRunning() async throws {
        // First, try to connect to see if server is already running
        if await isServerRunning() {
            return
        }

        // Start the Lighthouse server using the provided script. We run the
        // script with ShellOut; it will start the server in the background and
        // then exit.
        try shellOut(to: "./Tools/start_lighthouse.sh")

        // Wait a bit to give the server time to launch
        try await Task.sleep(nanoseconds: 5_000_000_000)  // 5 seconds

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

    enum BeaconError: LocalizedError {
        case serverStartFailed
        case noDataReceived
        case incompleteImplementation
        case timeout
        case serverError
        case invalidData

        var errorDescription: String? {
            switch self {
            case .serverStartFailed:
                return "Failed to start the lighthouse server"
            case .noDataReceived:
                return "No tidal data was received from the beacon"
            case .incompleteImplementation:
                return
                    "You need to implement the streaming logic! Look for the comments in the code."
            case .timeout:
                return "Connection to the beacon timed out"
            case .serverError:
                return "The lighthouse server responded with an error"
            case .invalidData:
                return "Invalid data received from the beacon"
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
            ║  The lighthouse has revealed the truth!                      ║
            ║  The water level is now over \(String(format: "%.2f", criticalLevel)) m.                    ║
            ║  The rising tide threatens to flood the cave.                ║
            ║  You must evacuate immediately!                              ║
            ║                                                              ║
            ║  The ancient beacon has saved your life.                     ║
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
