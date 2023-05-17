import UIKit

final class PreviousWeatherDetailViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    // MARK: - Public methods
    
    var userDefaults = UserDefaults.standard
    var temperatureConverter = TemperatureConverter()
    
    var weatherModel: WeatherModel!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        cityLabel.text = weatherModel.city
        
        if userDefaults.bool(forKey: Constants.UserDefaultKeys.ShouldShowWeatherInCelsiusKey) {
            degreesLabel.text = String(weatherModel.temperature)
        } else {
            let tempInFahrenheit = temperatureConverter.convertCelsiusToFahrenheit(temperature: weatherModel.temperature)
            
            degreesLabel.text = String(tempInFahrenheit)
        }
                
        timestampLabel.text = String(weatherModel.timestamp.description)
    }
}
