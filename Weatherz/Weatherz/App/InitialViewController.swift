import UIKit

class InitialViewController: UIViewController, WeatherDetailViewControllerDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var cityTextField: UITextField!
    
    // MARK: - Properties
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - <WeatherDetailViewControllerDelegate>
    
    func didTapClose() {
        dismiss(animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapCheckWeatherModalButton(_ sender: UIButton) {
        let weatherDetailViewController = buildWeatherDetailsViewController()
        weatherDetailViewController.delegate = self
                
        present(weatherDetailViewController, animated: true)
    }
    
    @IBAction func didTapCheckWeatherNavButton(_ sender: UIButton) {
        let weatherDetailViewController = buildWeatherDetailsViewController()
        weatherDetailViewController.delegate = self
                
        navigationController?.pushViewController(weatherDetailViewController, animated: true)
    }
    
    // MARK: - Private methods
    
    func buildWeatherDetailsViewController() -> WeatherDetailViewController {
        let storyboard = UIStoryboard(name: "WeatherDetailViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as! WeatherDetailViewController
    }
}
