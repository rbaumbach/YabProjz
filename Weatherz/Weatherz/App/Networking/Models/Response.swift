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
    
    let fancyString: String
    
    enum CodingKeys: String, CodingKey {
        case city = "name"
        case region
        case country
        case lat
        case lon
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        city = try container.decode(String.self, forKey: .city)
        region = try container.decode(String.self, forKey: .region)
        country = try container.decode(String.self, forKey: .country)
        lat = try container.decode(String.self, forKey: .lat)
        lon = try container.decode(String.self, forKey: .lon)
        
        fancyString = "\(city) is @ lat: \(lat), lon: \(lon)"
    }
}

struct Current: Codable {
    let temperature: Int
}
