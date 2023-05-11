import Foundation

struct Constants {
    struct WeatherStackAPI {
        static let AccessKey = "ENTER_YOUR_ACCESS_KEY_HERE"
        static let BaseURLString = "http://api.weatherstack.com/"
    }
    
    struct UserDefaultKeys {
        static let ShouldShowWeatherInCelsiusKey = "ShouldShowWeatherInCelsiusKey"
        static let HasRanAppOnce = "HasRanAppOnce"
    }
    
    struct FileManagerFileNames {
        static let PersistedLocationsFileName = "persistedLocations.json"
    }
    
    struct SystemImageName {
        static let DownArrow = "arrow.down"
        static let UpArrow = "arrow.up"
    }
}
