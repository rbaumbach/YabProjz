import Foundation

protocol WeatherNetworkServiceProtocol {
    func getCurrentWeather(city: String,
                           completionHandler: @escaping (Result<WeatherModel, Error>) -> Void)
}

final class WeatherNetworkService: WeatherNetworkServiceProtocol {
    // MARK: - Private properties
    
    private let apiClient: APIClient
    private let deserializer: CurrentWeatherDeserializer
    private let userDefaults: UserDefaultsProtocol
    
    // MARK: - Init method
    
    init(apiClient: APIClient = APIClient(baseURL: Constants.WeatherStackAPI.BaseURLString),
         deserializer: CurrentWeatherDeserializer = CurrentWeatherDeserializer(),
         userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.apiClient = apiClient
        self.deserializer = deserializer
        self.userDefaults = userDefaults
    }
    
    // MARK: - Public methods
    
    func getCurrentWeather(city: String,
                           completionHandler: @escaping (Result<WeatherModel, Error>) -> Void) {
        switch jsonDeserializationMode().mode {
        case .manualMode:
            apiClient.request(endpoint: endpoint(),
                              headers: headers(),
                              parameters: parameters(city: city)) { [weak self] result in
                self?.apiReponseHandler(result: result,
                                        completionHandler: completionHandler)
            }
        case .codableMode:
            apiClient.requestAndDeserialize(endpoint: endpoint(),
                                            parameters: parameters(city: city)) { (result: Result<Response, Error>) in
                switch result {
                case .success(let response):
                    let weatherModel = WeatherModel(city: response.location.city,
                                                    region: response.location.region,
                                                    country: response.location.country,
                                                    lat: Double(response.location.lat)!,
                                                    long: Double(response.location.lon)!,
                                                    timestamp: Date(),
                                                    temperature: Double(response.current.temperature))
                    
                    let success: Result<WeatherModel, Error> = .success(weatherModel)
                    
                    completionHandler(success)
                case .failure(let error):
                    let failure: Result<WeatherModel, Error> = .failure(error)
                    
                    completionHandler(failure)
                }
            }
        case .crazyCodable:
            apiClient.requestAndDeserializeFakeResponse(response: FakeCurrentWeatherJSON().build()) { (result: Result<Response, Error>) in
                switch result {
                case .success(let response):
                    let weatherModel = WeatherModel(city: response.location.city,
                                                    region: response.location.region,
                                                    country: response.location.country,
                                                    lat: Double(response.location.lat)!,
                                                    long: Double(response.location.lon)!,
                                                    timestamp: Date(),
                                                    temperature: Double(response.current.temperature))
                    
                    let success: Result<WeatherModel, Error> = .success(weatherModel)
                    
                    completionHandler(success)
                case .failure(let error):
                    let failure: Result<WeatherModel, Error> = .failure(error)
                    
                    completionHandler(failure)
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func apiKey() -> String {
        return Constants.WeatherStackAPI.AccessKey
    }
    
    private func endpoint() -> String {
        return "/current"
    }
    
    private func headers() -> [String: String] {
        return ["bogus": "just-to-do-it"]
    }
    
    private func parameters(city: String) -> [String: String] {
        return ["access_key": apiKey(),
                "query": city]
    }
    
    private func jsonDeserializationMode() -> JSONDeserializationMode {
        let persistedModeKey = Constants.UserDefaultKeys.StoredJSONDeserializationModeKey
        
        guard let persistedMode = userDefaults.object(forKey: persistedModeKey) else {
            return JSONDeserializationMode(mode: .manualMode)
        }
        
        guard let persistedModeData = persistedMode as? Data else {
            return JSONDeserializationMode(mode: .manualMode)
        }
        
        guard let deserializedMode = try? JSONDecoder().decode(JSONDeserializationMode.self,
                                                               from: persistedModeData) else {
            return JSONDeserializationMode(mode: .manualMode)
        }
        
        return deserializedMode
    }
    
    private func apiReponseHandler(result: Result<[String: Any], Error>,
                                   completionHandler: (Result<WeatherModel, Error>) -> Void) {
        switch result {
        case .success(let response):
            self.handleResponse(response: response) { result in
                switch result {
                case .success(_):
                    completionHandler(result)
                case .failure(let error):
                    let failure: Result<WeatherModel, Error> = .failure(error)
                    
                    completionHandler(failure)
                }
            }
        case .failure(let error):
            let failure: Result<WeatherModel, Error> = .failure(error)
            
            completionHandler(failure)
        }
    }
    
    private func handleResponse(response: [String: Any],
                                completionHandler: (Result<WeatherModel, Error>) -> Void) {
        deserializer.deserialize(response: response) { result in
            switch result {
            case .success(_):
                completionHandler(result)
            case .failure(let error):
                let failure: Result<WeatherModel, Error> = .failure(error)
                
                completionHandler(failure)
            }
        }
    }
}
