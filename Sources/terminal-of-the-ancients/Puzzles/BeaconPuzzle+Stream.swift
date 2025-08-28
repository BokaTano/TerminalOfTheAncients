import Foundation
import Network

// MARK: - Swift 6.2+ Features Only

// Note: @Observable is for UI frameworks, not CLI
// Task groups existed since Swift 5.7
// Result type existed since Swift 5.0

struct TideEvent: Codable, Identifiable {
    let id = UUID()  // For SwiftUI lists
    let timestamp: Date
    let level: Double
    let type: TideType

    // Custom coding keys for better JSON handling
    enum CodingKeys: String, CodingKey {
        case timestamp, level, type
    }
}

enum TideType: String, Codable, CaseIterable {
    case low, high, rising, falling

    // Computed property for UI
    var emoji: String {
        switch self {
        case .low: return "🌊"
        case .high: return "🌊"
        case .rising: return "📈"
        case .falling: return "📉"
        }
    }
}

extension BeaconPuzzle {
    private var streamUrl: URL {
        return URL(string: "http://localhost:8080/stream")!
    }

    private var streamRequest: URLRequest {
        var request = URLRequest(url: streamUrl)
        request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        return request
    }

    // Create an AsyncStream of TideEvents

    func streamTideData() -> AsyncStream<TideEvent> {
        return AsyncStream { @Sendable continuation in
            Task {
                do {
                    // let (asyncBytes, response) = try await URLSession.shared.bytes(
                    //     for: streamRequest)
                    let (_, response) = try await URLSession.shared.bytes(
                        for: streamRequest)

                    // Check if the response is 200 OK
                    guard let httpResponse = response as? HTTPURLResponse,
                        httpResponse.statusCode == 200
                    else {
                        throw TideStreamError.serverError
                    }

                    // Puzzle Nr. 4: Beacon Puzzle 𐦊

                    // Step 1: for await loop over the asyncBytes.lines and process the data
                    // Step 2: yield the TideEvents and finish the stream correctly
                    /*
                    ... Your code here ...
                    */

                    continuation.finish()
                } catch {
                    print("❌ Stream error: \(error)")
                    continuation.finish()
                }
            }
        }
    }

    // MARK: - Public API with timeout
    // MARK: Step 6(Optional): timeout the Task if it takes longer than 60 seconds
    func streamTideDataWithTimeout() async throws -> [TideEvent] {
        let streamTask = Task {
            var events: [TideEvent] = []
            for try await event in streamTideData() {
                events.append(event)
            }
            return events
        }

        /*
        ... Your code here ...
        */

        return try await streamTask.value
    }

    enum TideStreamError: LocalizedError {
        case serverError
        case invalidData
        case timeout

        var errorDescription: String? {
            switch self {
            case .serverError:
                return "Server responded with an error"
            case .invalidData:
                return "Invalid data received from stream"
            case .timeout:
                return "Stream connection timed out"
            }
        }
    }
}
