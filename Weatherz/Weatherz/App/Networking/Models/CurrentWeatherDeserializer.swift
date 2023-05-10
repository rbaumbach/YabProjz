import Foundation

struct CurrentWeatherDeserializer {
    func deserialize(response: [String: Any]) -> Location {
        let location = response["location"] as! [String: Any]
        let currentWeather = response["current"] as! [String: Any]
        
        let city = location["name"] as! String
        let region = location["region"] as! String
        let country = location["country"] as! String
        let lat = location["lat"] as! String
        let long = location["lon"] as! String
        let temperature = currentWeather["temperature"] as! Double
        
        return Location(city: city,
                        region: region,
                        country: country,
                        lat: Double(lat)!,
                        long: Double(long)!,
                        timestamp: Date(),
                        temperature: temperature)
    }
}
