import UIKit

final class PreviousWeatherDetailViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    // MARK: - Public methods
    
    var userDefaults = UserDefaults.standard
    var temperatureConverter = TemperatureConverter()
    
    var location: Location!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        cityLabel.text = location.city
        
        if userDefaults.bool(forKey: Constants.UserDefaultKeys.ShouldShowWeatherInCelsiusKey) {
            degreesLabel.text = String(location.temperature)
        } else {
            let tempInFahrenheit = temperatureConverter.convertCelsiusToFahrenheit(temperature: location.temperature)
            
            degreesLabel.text = String(tempInFahrenheit)
        }
                
        timestampLabel.text = String(location.timestamp.description)
    }
}
