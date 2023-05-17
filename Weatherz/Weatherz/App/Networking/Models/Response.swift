import Foundation

struct Response: Codable {
    let location: Location
    let current: Current
}

struct Location: Codable {
    let region: String
    let country: String
    let lat: String
    let lon: String
}

struct Current: Codable {
    let temperature: Int
}
