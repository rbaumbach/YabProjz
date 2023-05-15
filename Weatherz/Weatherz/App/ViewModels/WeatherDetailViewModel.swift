import Foundation

protocol WeatherDetailViewModelProtcol {
    var delegate: WeatherDetailViewModelDelegate? { get set }

    func activate(city: String)
}

protocol WeatherDetailViewModelDelegate: AnyObject {
    func didUpdateTemperature(temperature: String)
    func didError(error: Error)
}

final class WeatherDetailViewModel: WeatherDetailViewModelProtcol {
    // MARK: - Private properties
    
    private let userDefaults: UserDefaultsProtocol
    private let fileManager: FileManagerProtocol
    private let weatherNetworkService: WeatherNetworkServiceProtocol
    private let temperatureConverter: TemperatureConverter
    
    // MARK: - Public properties
    
    weak var delegate: WeatherDetailViewModelDelegate?
    
    // MARK: - Init methods
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard,
         fileManager: FileManagerProtocol = FileManager.default,
         weatherNetworkService: WeatherNetworkServiceProtocol = WeatherNetworkService(),
         temperatureConverter: TemperatureConverter = TemperatureConverter()) {
        self.userDefaults = userDefaults
        self.fileManager = fileManager
        self.weatherNetworkService = weatherNetworkService
        self.temperatureConverter = temperatureConverter
    }
    
    // MARK: - Public methods
    
    func activate(city: String) {
        weatherNetworkService.getCurrentWeather(city: city) { [weak self] result in
            self?.weatherNetworkServiceHander(result: result)
        }
    }
    
    // MARK: - Private methods
    
    private func weatherNetworkServiceHander(result: Result<Location, Error>) {
        switch result {
        case .success(let location):
            persistWeather(location: location)
            
            let newTemperature = processTemperature(location: location)
            
            self.delegate?.didUpdateTemperature(temperature: newTemperature)
        case .failure(let error):
            self.delegate?.didError(error: error)
        }
    }
    
    private func persistWeather(location: Location) {
        let fileName = Constants.FileManagerFileNames.PersistedLocationsFileName
        
        var previousLocations: [Location] = fileManager.readFromDocumentsDir(fileName: fileName) ?? []
                
        previousLocations.append(location)
                
        fileManager.saveToDocumentsDir(data: previousLocations, fileName: fileName)
    }
    
    private func processTemperature(location: Location) -> String {
        if userDefaults.bool(forKey: Constants.UserDefaultKeys.ShouldShowWeatherInCelsiusKey) {
            return String(location.temperature)
        } else {
            let tempInFahrenheit = temperatureConverter.convertCelsiusToFahrenheit(temperature: location.temperature)
            
            return String(tempInFahrenheit)
        }
    }
}
