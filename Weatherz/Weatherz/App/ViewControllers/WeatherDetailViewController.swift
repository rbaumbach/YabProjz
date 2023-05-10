import UIKit

protocol WeatherDetailViewControllerDelegate: AnyObject {
    func didTapClose()
}

final class WeatherDetailViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
            
    // MARK: - Public methods
    
    var weatherNetworkService = WeatherNetworkService()

    var userDefaults = UserDefaults.standard
    
    var temperatureConverter = TemperatureConverter()
    
    var fileManager = FileManager.default
    
    var city: String?
    
    // MARK: - Properties
    
    weak var delegate: WeatherDetailViewControllerDelegate?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = city
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        weatherNetworkService.getCurrentWeather(city: city!) { [weak self] result in
            guard let self = self else { return }
            
            self.weatherNetworkServiceHander(result: result)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        delegate?.didTapClose()
    }
    
    // MARK: - Private methods
    
    private func weatherNetworkServiceHander(result: Result<Location, Error>) {
        switch result {
        case .success(let location):
            updateDegreesLabel(temperature: location.temperature)
            
            persistWeather(location: location)
        case .failure(let error):
            errorLabel.text = error.localizedDescription
        }
    }
    
    private func updateDegreesLabel(temperature: Double) {
        if userDefaults.bool(forKey: Constants.UserDefaultKeys.ShouldShowWeatherInCelsiusKey) {
            degreesLabel.text = String(temperature)
        } else {
            let tempInFahrenheit = temperatureConverter.convertCelsiusToFahrenheit(temperature: temperature)
            
            degreesLabel.text = String(tempInFahrenheit)
        }
        
        degreesLabel.isHidden = false
    }
    
    private func persistWeather(location: Location) {
        let fileName = Constants.FileManagerFileNames.PersistedLocationsFileName
        
        var previousLocations: [Location] = fileManager.readFromDocumentsDir(fileName: fileName) ?? []
                
        previousLocations.append(location)
        
        print(previousLocations)
        
        fileManager.saveToDocumentsDir(data: previousLocations, fileName: fileName)
    }
}
