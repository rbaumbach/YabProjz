import Foundation

struct WeatherModel: Codable, Equatable {
    let city: String
    let region: String
    let country: String
    let lat: Double
    let long: Double
    let timestamp: Date
    let temperature: Double
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.city == rhs.city && lhs.temperature == rhs.temperature
    }
}
