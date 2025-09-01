import Foundation
import Network

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
    func streamTideData() async throws -> AsyncStream<TideEvent> {
        //MARK: Puzzle Nr. 4: Beacon Puzzle 𐦊
        // remove this when you are implementing the stream
        throw TideStreamError.incompleteImplementation

        // return AsyncStream { @Sendable continuation in
        //     Task {
        //         // let (asyncBytes, response) = try await URLSession.shared.bytes(
        //         //     for: streamRequest)
        //         let (_, response) = try await URLSession.shared.bytes(
        //             for: streamRequest)

        //         // Check if the response is 200 OK
        //         guard let httpResponse = response as? HTTPURLResponse,
        //             httpResponse.statusCode == 200
        //         else {
        //             print("🔍 DEBUG: Server error - status code not 200")
        //             throw TideStreamError.serverError
        //         }

        //         // Puzzle Nr. 4: Beacon Puzzle 𐦊

        //         // Step 1: for await loop over the asyncBytes.lines and process the data
        //         // Step 2: yield the TideEvents and finish the stream correctly
        //         /*
        //         ... Your code here ...
        //         */

        //         // Step 3: comment this back in
        //         continuation.finish()
        //     }
        // }
    }

    // MARK: - Public API with timeout
    func streamTideDataWithTimeout() async throws -> AsyncStream<TideEvent> {
        // Race between stream completion and timeout
        do {
            return try await withThrowingTaskGroup(of: AsyncStream<TideEvent>.self) { group in
                group.addTask { try await streamTideData() }
                group.addTask {
                    try await Task.sleep(nanoseconds: 60_000_000_000)  // 60 seconds
                    throw TideStreamError.timeout
                }

                let stream = try await group.next()!
                group.cancelAll()
                return stream
            }
        } catch {
            throw error
        }
    }

    enum TideStreamError: LocalizedError {
        case serverError
        case invalidData
        case timeout
        case incompleteImplementation

        var errorDescription: String? {
            switch self {
            case .serverError:
                return "Server responded with an error"
            case .invalidData:
                return "Invalid data received from stream"
            case .timeout:
                return "Stream connection timed out"
            case .incompleteImplementation:
                return "Incomplete implementation"
            }
        }
    }
}
