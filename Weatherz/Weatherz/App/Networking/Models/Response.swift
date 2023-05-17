import Foundation

struct Response: Codable {
    let location: Location
    let current: Current
}

struct Location: Codable {
    let city: String
    let region: String
    let country: String
    let lat: String
    let lon: String
    
    enum CodingKeys: String, CodingKey {
        case city = "name"
        case region
        case country
        case lat
        case lon
    }
}

struct Current: Codable {
    let temperature: Int
}
