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
        var headers = HTTPHeaders()
        headers.replaceOrAdd(name: .contentType, value: "text/event-stream")
        headers.replaceOrAdd(name: .cacheControl, value: "no-cache")
        headers.replaceOrAdd(name: .connection, value: "keep-alive")
        headers.replaceOrAdd(name: "Access-Control-Allow-Origin", value: "*")

        let res = Response(status: .ok, headers: headers)

        // Create a simple streaming response with realistic tide levels
        var responseBody = ""
        var waterLevel: Double = 1.5  // Start at low tide level
        let startTime = Date()

        for i in 0..<50 {
            let event = TideEvent(
                timestamp: startTime.addingTimeInterval(Double(i) * 0.2),
                level: waterLevel,
                type: waterLevel > 4.0 ? .high : .rising
            )

            let jsonData = try! JSONEncoder().encode(event)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            responseBody += "data: \(jsonString)\n\n"

            // More realistic tide progression: smaller increments
            waterLevel += 0.08 + Double.random(in: 0...0.05)
        }

        responseBody += "data: [DONE]\n\n"
        res.body = .init(string: responseBody)

        return res
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
