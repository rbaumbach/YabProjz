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
        let weatherDetailViewController = buildViewController(name: "WeatherDetailViewController") as! WeatherDetailViewController
        weatherDetailViewController.city = cityTextField.text
        weatherDetailViewController.delegate = self
                
        present(weatherDetailViewController, animated: true)
    }
    
    @IBAction func didTapCheckWeatherNavButton(_ sender: UIButton) {
        let weatherDetailViewController = buildViewController(name: "WeatherDetailViewController") as! WeatherDetailViewController
        weatherDetailViewController.delegate = self
                
        navigationController?.pushViewController(weatherDetailViewController, animated: true)
    }
    
    @IBAction func didTapPreviousSearchesButton(_ sender: UIButton) {
        let previousSearchesViewController = buildViewController(name: "PreviousSearchesViewController") as! PreviousSearchesViewController
        
        navigationController?.pushViewController(previousSearchesViewController, animated: true)
    }
    
    // MARK: - Private methods
    
    private func buildViewController(name: String) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        return storyboard.instantiateInitialViewController()!
    }
}
