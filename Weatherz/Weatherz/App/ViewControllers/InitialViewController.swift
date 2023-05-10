import UIKit

final class InitialViewController: UIViewController, WeatherDetailViewControllerDelegate, SettingsViewControllerDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var cityTextField: UITextField!
        
    // MARK: - <WeatherDetailViewControllerDelegate, SettingsViewController>
    
    func didTapClose() {
        dismiss(animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapCheckWeatherButton(_ sender: UIButton) {
        let weatherDetailViewController: WeatherDetailViewController = buildViewController(name: "WeatherDetailViewController")
        weatherDetailViewController.delegate = self
        weatherDetailViewController.city = cityTextField.text
                
        navigationController?.pushViewController(weatherDetailViewController, animated: true)
    }
    
    @IBAction func didTapPreviousSearchesButton(_ sender: UIButton) {
        let previousSearchesViewController: PreviousSearchesViewController = buildViewController(name: "PreviousSearchesViewController")
        
        navigationController?.pushViewController(previousSearchesViewController, animated: true)
    }
    
    @IBAction func didTapSettingsBarButton(_ sender: UIBarButtonItem) {
        let settingsViewController: SettingsViewController = buildViewController(name: "SettingsViewController")
        settingsViewController.delegate = self
        
        present(settingsViewController, animated: true)
    }
    
    // MARK: - Private methods
    
    private func buildViewController<T: UIViewController>(name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        return storyboard.instantiateInitialViewController()!
    }
}
