import Foundation

// MARK: - Shared Models

struct TideEvent: Codable {
    let timestamp: Date
    let level: Double
    let type: TideType
}

enum TideType: String, Codable {
    case low, high, rising, falling
}

// MARK: - Tide Analyzer

struct TideAnalyzer {
    /// Analyzes the incoming tidal stream and returns the highest water level.
    static func extractCriticalLevel<S: AsyncSequence>(
        from stream: S
    ) async throws -> Double where S.Element == TideEvent {
        var highest: Double = .leastNormalMagnitude

        for try await event in stream {
            if event.level > highest {
                highest = event.level
            }
        }

        if highest == .leastNormalMagnitude {
            throw TideError.noData
        }

        return highest
    }

    enum TideError: Error {
        case noData
    }
} 