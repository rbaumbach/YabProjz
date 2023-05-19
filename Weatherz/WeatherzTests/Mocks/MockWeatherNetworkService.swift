@testable import Weatherz

final class MockWeatherNetworkService: WeatherNetworkServiceProtocol {
    var capturedGetCurrentWeatherCity: String?
    var capturedGetCurrentWeatherCompletionHandler: ((Result<WeatherModel, Error>) -> Void)?
    
    func getCurrentWeather(city: String,
                           completionHandler: @escaping (Result<WeatherModel, Error>) -> Void) {
        capturedGetCurrentWeatherCity = city
        capturedGetCurrentWeatherCompletionHandler = completionHandler
    }
}
