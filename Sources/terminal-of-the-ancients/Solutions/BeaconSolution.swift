// import Foundation
// import Network

// extension BeaconPuzzle {
//     // MARK: Puzzle Nr. 4: Beacon Puzzle 𐦊

//     private var streamUrl: URL {
//         return URL(string: "http://localhost:8080/stream")!
//     }

//     private var streamRequest: URLRequest {
//         var request = URLRequest(url: streamUrl)
//         request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
//         request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
//         return request
//     }

//     // MARK: Step 1: Create an AsyncStream of TideEvents

//     private func streamTideData() -> AsyncStream<TideEvent> {
//         // @Sendable is needed to make the continuation thread safe
//         return AsyncStream { @Sendable continuation in
//             Task {
//                 // MARK: Step 2: Use URLSession.shared.bytes(for:) to get our lighthouse stream data
//                 do {
//                     let (asyncBytes, response) = try await URLSession.shared.bytes(
//                         for: streamRequest)

//                     // MARK: Step 3: Check if the response is 200 OK
//                     guard let httpResponse = response as? HTTPURLResponse,
//                         httpResponse.statusCode == 200
//                     else {
//                         throw TideStreamError.serverError
//                     }

//                     // MARK: Step 4: for await loop over the asyncBytes.lines and process the data
//                     // MARK: Step 5: yield the TideEvents and finish the stream correctly
//                     for try await line in asyncBytes.lines {
//                         if line.hasPrefix("data: ") {
//                             let dataString = String(line.dropFirst(6))  // Remove "data: "

//                             if dataString == "[DONE]" {
//                                 continuation.finish()
//                                 return
//                             }

//                             do {
//                                 if let data = dataString.data(using: .utf8) {
//                                     let event = try JSONDecoder().decode(
//                                         TideEvent.self, from: data)
//                                     continuation.yield(event)
//                                 }
//                             } catch {
//                                 print("⚠️ Parse error: \(error)")
//                             }
//                         }
//                     }

//                     continuation.finish()
//                 } catch {
//                     print("❌ Stream error: \(error)")
//                     continuation.finish()
//                 }
//             }
//         }
//     }
