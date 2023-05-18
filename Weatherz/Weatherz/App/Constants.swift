import Foundation

struct Constants {
    struct WeatherStackAPI {
        static let AccessKey = "ENTER_YOUR_ACCESS_KEY_HERE"
        static let BaseURLString = "http://api.weatherstack.com/"
    }
    
    struct UserDefaultKeys {
        static let ShouldShowWeatherInCelsiusKey = "ShouldShowWeatherInCelsiusKey"
        static let HasRanAppOnceKey = "HasRanAppOnceKey"
        static let StoredJSONDeserializationModeKey = "StoredJSONDeserializationModeKey"
    }
    
    struct FileManagerFileNames {
        static let PersistedWeatherModelsFileName = "persistedWeatherModels.json"
    }
    
    struct SystemImageName {
        static let DownArrow = "arrow.down"
        static let UpArrow = "arrow.up"
        static let Checkmark = "checkmark"
    }
    
    struct Messages {
        static let Hello = "Hello Sir =)"
        static let YoureBack = "I see you're back"
        static let IsItColdOutside = "Is it cold outside?"
        static let AvengersAssemble = "Avengers Assemble!"
        static let PowerAndResponsibility = "With great power comes great responsibility."
    }
}
