import Foundation

struct TemperatureConverter {
    func convertCelsiusToFahrenheit(temperature: Double) -> Double {
        return (temperature * Double(9) / 5 ) + 32
    }
}
