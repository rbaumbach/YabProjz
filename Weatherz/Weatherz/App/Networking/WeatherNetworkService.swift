import Foundation

final class WeatherNetworkService {
    // MARK: - Private properties
    
    private let apiClient: APIClient
            
    // MARK: - Init method
    
    init(apiClient: APIClient = APIClient(baseURL: Constants.WeatherStackAPI.BaseURLString)) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public methods
    
    func getCurrentWeather(city: String,
                           completionHandler: @escaping (Result<[String: Any], Error>) -> Void) {
        apiClient.request(endpoint: endpoint(),
                          parameters: parameters(city: city)) { result in
            completionHandler(result)
        }
    }
    
    // MARK: - Private methods
    
    private func apiKey() -> String {
        return Constants.WeatherStackAPI.BaseURLString
    }
    
    private func endpoint() -> String {
        return "/current"
    }
    
    private func parameters(city: String) -> [String: String] {
        return ["access_key": apiKey(),
                "query": city]
    }
}
