import Foundation
import Vapor

// MARK: - Models

struct TideEvent: Codable {
    let timestamp: Date
    let level: Double
    let type: TideType
}

enum TideType: String, Codable {
    case low, high, rising, falling
}

// MARK: - Server Setup

@main
struct LighthouseApp {
    static func main() async throws {
        let app = try await Application.make()

        // Configure CORS for local development
        app.middleware.use(CORSMiddleware())

        // Setup routes
        try routes(app)

        // Start server
        try await app.execute()
    }
}

// MARK: - Routes

func routes(_ app: Application) throws {
    // Health check endpoint
    app.get("health") { req async throws -> String in
        return "beacon_is_ready"
    }

    // Streaming endpoint
    app.get("stream") { req async throws -> Response in
        let response = Response()
        response.headers.replaceOrAdd(name: "Content-Type", value: "text/event-stream")
        response.headers.replaceOrAdd(name: "Cache-Control", value: "no-cache")
        response.headers.replaceOrAdd(name: "Connection", value: "keep-alive")
        response.headers.replaceOrAdd(name: "Access-Control-Allow-Origin", value: "*")

        // Create streaming response
        let stream = req.eventLoop.makePromise(of: Response.self)

        Task {
            var waterLevel: Double = 2.0
            let startTime = Date()
            var allData = ""

            for i in 0..<10 {  // 10 events over 2 seconds
                let event = TideEvent(
                    timestamp: startTime.addingTimeInterval(Double(i) * 0.2),
                    level: waterLevel,
                    type: waterLevel > 4.5 ? .high : .rising
                )

                let jsonData = try JSONEncoder().encode(event)
                let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
                let sseData = "data: \(jsonString)\n\n"

                // Accumulate all data
                allData += sseData

                // Increase water level (simulate rising tide)
                waterLevel += 0.35 + Double.random(in: 0...0.1)

                // Wait 200ms
                try await Task.sleep(nanoseconds: 200_000_000)
            }

            // End the stream
            allData += "data: [DONE]\n\n"
            response.body = .init(string: allData)
            stream.succeed(response)
        }

        return try await stream.futureResult.get()
    }
}

// MARK: - CORS Middleware

struct CORSMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        return next.respond(to: request).map { response in
            response.headers.replaceOrAdd(name: "Access-Control-Allow-Origin", value: "*")
            response.headers.replaceOrAdd(
                name: "Access-Control-Allow-Methods", value: "GET, POST, PUT, DELETE, OPTIONS")
            response.headers.replaceOrAdd(
                name: "Access-Control-Allow-Headers", value: "Content-Type, Authorization")
            return response
        }
    }
}
