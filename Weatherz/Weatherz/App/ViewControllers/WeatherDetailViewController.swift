import UIKit

protocol WeatherDetailViewControllerDelegate: AnyObject {
    func didTapClose()
}

final class WeatherDetailViewController: UIViewController, WeatherDetailViewModelDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var temperatureView: TemperatureView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Public methods
    
    var cityToWeatherCheck: String!
    
    var weatherDetailViewModel: WeatherDetailViewModel!
    
    // MARK: - Properties
    
    weak var delegate: WeatherDetailViewControllerDelegate?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherDetailViewModel = WeatherDetailViewModel()
        weatherDetailViewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        weatherDetailViewModel.activate(city: cityToWeatherCheck)
    }
    
    // MARK: - <WeatherDetailViewModel>
    
    func didUpdate(city: String, temperature: String) {
        updateView(city: city,
                   temperature: temperature)
    }
    
    func didError(error: Error) {
        updateViewToError(error: error)
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        delegate?.didTapClose()
    }
    
    // MARK: - Private methods
    
    private func updateView(city: String,
                            temperature: String) {
        temperatureView.cityLabel.text = city
        temperatureView.degreesLabel.text = temperature
        
        temperatureView.cityLabel.isHidden = false
        temperatureView.weatherLabel.isHidden = false
        temperatureView.degreesLabel.isHidden = false
        
        activityIndicatorView.stopAnimating()
    }
    
    private func updateViewToError(error: Error) {
        errorLabel.text = error.localizedDescription
        errorLabel.isHidden = false
        
        temperatureView.cityLabel.isHidden = true
        temperatureView.weatherLabel.isHidden = true
        temperatureView.degreesLabel.isHidden = true
        
        activityIndicatorView.stopAnimating()
    }
}
