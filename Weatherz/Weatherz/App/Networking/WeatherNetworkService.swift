import Foundation

final class WeatherNetworkService {
    // MARK: - Private properties
    
    private let apiClient: APIClient
    private let deserializer: CurrentWeatherDeserializer
            
    // MARK: - Init method
    
    init(apiClient: APIClient = APIClient(baseURL: Constants.WeatherStackAPI.BaseURLString),
         deserializer: CurrentWeatherDeserializer = CurrentWeatherDeserializer()) {
        self.apiClient = apiClient
        self.deserializer = deserializer
    }
    
    // MARK: - Public methods
    
    func getCurrentWeather(city: String,
                           completionHandler: @escaping (Result<Location, Error>) -> Void) {
        apiClient.request(endpoint: endpoint(),
                          parameters: parameters(city: city)) { [weak self] result in
            self?.apiReponseHandler(result: result,
                                    completionHandler: completionHandler)
        }
    }
    
    // MARK: - Private methods
    
    private func apiKey() -> String {
        return Constants.WeatherStackAPI.AccessKey
    }
    
    private func endpoint() -> String {
        return "/current"
    }
    
    private func parameters(city: String) -> [String: String] {
        return ["access_key": apiKey(),
                "query": city]
    }
    
    private func apiReponseHandler(result: Result<[String: Any], Error>,
                                   completionHandler: (Result<Location, Error>) -> Void) {
        switch result {
        case .success(let response):
            self.handleResponse(response: response) { result in
                switch result {
                case .success(_):
                    completionHandler(result)
                case .failure(let error):
                    let failure: Result<Location, Error> = .failure(error)
                    
                    completionHandler(failure)
                }
            }
        case .failure(let error):
            let failure: Result<Location, Error> = .failure(error)
            
            completionHandler(failure)
        }
    }
    
    private func handleResponse(response: [String: Any],
                                completionHandler: (Result<Location, Error>) -> Void) {
        deserializer.deserialize(response: response) { result in
            switch result {
            case .success(_):
                completionHandler(result)
            case .failure(let error):
                let failure: Result<Location, Error> = .failure(error)
                
                completionHandler(failure)
            }
        }
    }
}
