import Foundation

protocol WeatherDetailViewModelProtcol {
    var delegate: WeatherDetailViewModelDelegate? { get set }

    func activate(city: String)
}

// do something nice here

protocol WeatherDetailViewModelDelegate: AnyObject {
    func didUpdate(city: String, temperature: String)
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
    
    private func weatherNetworkServiceHander(result: Result<WeatherModel, Error>) {
        switch result {
        case .success(let weatherModel):
            persistWeather(weatherModel: weatherModel)
            
            let newTemperature = processTemperature(weatherModel: weatherModel)

            self.delegate?.didUpdate(city: weatherModel.city,
                                     temperature: newTemperature)
        case .failure(let error):
            self.delegate?.didError(error: error)
        }
    }
    
    private func persistWeather(weatherModel: WeatherModel) {
        let fileName = Constants.FileManagerFileNames.PersistedWeatherModelsFileName
        
        var previousWeatherModels: [WeatherModel] = fileManager.readFromDocumentsDir(fileName: fileName) ?? []
                
        previousWeatherModels.append(weatherModel)
                
        fileManager.saveToDocumentsDir(data: previousWeatherModels, fileName: fileName)
    }
    
    private func processTemperature(weatherModel: WeatherModel) -> String {
        if userDefaults.bool(forKey: Constants.UserDefaultKeys.ShouldShowWeatherInCelsiusKey) {
            return String(weatherModel.temperature)
        } else {
            let tempInFahrenheit = temperatureConverter.convertCelsiusToFahrenheit(temperature: weatherModel.temperature)
            
            return String(tempInFahrenheit)
        }
    }
}
