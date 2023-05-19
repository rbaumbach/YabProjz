@testable import Weatherz

final class MockWeatherDetailViewModelDelegate: WeatherDetailViewModelDelegate {
    var capturedDidUpdateCity: String?
    var capturedDidUpateTemperature: String?
    
    var capturedDidError: Error?
    
    func didUpdate(city: String, temperature: String) {
        capturedDidUpdateCity = city
        capturedDidUpateTemperature = temperature
    }
    
    func didError(error: Error) {
        capturedDidError = error
    }
}
