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
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let location = self.deserializer.deserialize(response: response)
                
                completionHandler(.success(location))
            case .failure(let error):
                completionHandler(.failure(error))
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
    
    private func parameters(city: String) -> [String: String] {
        return ["access_key": apiKey(),
                "query": city]
    }
}
