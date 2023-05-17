import Foundation

enum CurrentWeatherDeserializerError: Error {
    case responseError
}

struct CurrentWeatherDeserializer {
    func deserialize(response: [String: Any],
                     completionHandler: (Result<WeatherModel, Error>) -> Void) {
        guard response["error"] == nil else {
            let error: Result<WeatherModel, Error> = .failure(CurrentWeatherDeserializerError.responseError)
            
            completionHandler(error)
            
            return
        }
        
        let location = response["location"] as! [String: Any]
        let currentWeather = response["current"] as! [String: Any]
        
        let city = location["name"] as! String
        let region = location["region"] as! String
        let country = location["country"] as! String
        let lat = location["lat"] as! String
        let long = location["lon"] as! String
        let temperature = currentWeather["temperature"] as! Double
        
        let weatherModel =  WeatherModel(city: city,
                                         region: region,
                                         country: country,
                                         lat: Double(lat)!,
                                         long: Double(long)!,
                                         timestamp: Date(),
                                         temperature: temperature)
        
        let success: Result<WeatherModel, Error> = .success(weatherModel)
        
        completionHandler(success)
    }
}
