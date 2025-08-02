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
    app.get("stream") { req -> Response in
        var headers = HTTPHeaders()
        headers.replaceOrAdd(name: .contentType, value: "text/event-stream")
        headers.replaceOrAdd(name: .cacheControl, value: "no-cache")
        headers.replaceOrAdd(name: .connection, value: "keep-alive")
        headers.replaceOrAdd(name: "Access-Control-Allow-Origin", value: "*")

        let res = Response(status: .ok, headers: headers)
        res.body = .init { writer in
            var waterLevel: Double = 2.0
            let startTime = Date()
            func sendEvent(i: Int) {
                guard i < 10 else {
                    writer.write(.init(string: "data: [DONE]\n\n")).whenComplete { _ in
                        writer.close()
                    }
                    return
                }
                let event = TideEvent(
                    timestamp: startTime.addingTimeInterval(Double(i) * 0.2),
                    level: waterLevel,
                    type: waterLevel > 4.5 ? .high : .rising
                )
                let jsonData = try! JSONEncoder().encode(event)
                let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
                let sseData = "data: \(jsonString)\n\n"
                waterLevel += 0.35 + Double.random(in: 0...0.1)
                writer.write(.init(string: sseData)).whenComplete { _ in
                    writer.flush()
                    usleep(200_000)  // 200ms
                    sendEvent(i: i + 1)
                }
            }
            sendEvent(i: 0)
            return ()
        }
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
