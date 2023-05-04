import UIKit

final class InitialViewController: UIViewController, WeatherDetailViewControllerDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var cityTextField: UITextField!
        
    // MARK: - <WeatherDetailViewControllerDelegate>
    
    func didTapClose() {
        dismiss(animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapCheckWeatherModalButton(_ sender: UIButton) {        
        let weatherDetailViewController = buildWeatherDetailsViewController()
        weatherDetailViewController.city = cityTextField.text
        weatherDetailViewController.delegate = self
                
        present(weatherDetailViewController, animated: true)
    }
    
    @IBAction func didTapCheckWeatherNavButton(_ sender: UIButton) {
        let weatherDetailViewController = buildWeatherDetailsViewController()
        weatherDetailViewController.delegate = self
                
        navigationController?.pushViewController(weatherDetailViewController, animated: true)
    }
    
    // MARK: - Private methods
    
    private func buildWeatherDetailsViewController() -> WeatherDetailViewController {
        let storyboard = UIStoryboard(name: "WeatherDetailViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as! WeatherDetailViewController
    }
}
