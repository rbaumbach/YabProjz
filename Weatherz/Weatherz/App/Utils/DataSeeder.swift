import Foundation

struct DataSeeder {
    // MARK: - Private properties
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func seed() {
        userDefaults.set(true, forKey: Constants.UserDefaultKeys.ShouldShowWeatherInCelsiusKey)
    }
}
