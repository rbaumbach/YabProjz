import Foundation

struct Location: Codable {
    let city: String
    let region: String
    let country: String
    let lat: Double
    let long: Double
    let timestamp: Date
    let temperature: Double
}
