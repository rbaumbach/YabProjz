import UIKit

final class PreviousWeatherDetailViewController: UIViewController {
    
    // TODO: Use the temperature view here too
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var temperatureView: TemperatureView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    // MARK: - Public methods
    
    var userDefaults: UserDefaultsProtocol = UserDefaults.standard
    var temperatureConverter = TemperatureConverter()
    
    var weatherModel: WeatherModel!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        temperatureView.cityLabel.isHidden = false
        temperatureView.weatherLabel.isHidden = false
        temperatureView.degreesLabel.isHidden = false
        
        temperatureView.cityLabel.text = weatherModel.city
        
        if userDefaults.bool(forKey: Constants.UserDefaultKeys.ShouldShowWeatherInCelsiusKey) {
            temperatureView.degreesLabel.text = String(weatherModel.temperature)
        } else {
            let tempInFahrenheit = temperatureConverter.convertCelsiusToFahrenheit(temperature: weatherModel.temperature)
            
            temperatureView.degreesLabel.text = String(tempInFahrenheit)
        }
                
        timestampLabel.text = String(weatherModel.timestamp.description)
    }
}
