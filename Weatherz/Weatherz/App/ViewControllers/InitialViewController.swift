import UIKit

final class InitialViewController: UIViewController, WeatherDetailViewControllerDelegate, SettingsViewControllerDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var cityTextField: UITextField!
    
    // MARK: - Public properties
    
    var viewControllerBuilder = ViewControllerBuilder()
    
    // MARK: - <WeatherDetailViewControllerDelegate, SettingsViewController>
    
    func didTapClose() {
        dismiss(animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapCheckWeatherButton(_ sender: UIButton) {
        let weatherDetailViewController: WeatherDetailViewController = viewControllerBuilder.build(name: "WeatherDetailViewController")
        weatherDetailViewController.delegate = self
        weatherDetailViewController.city = cityTextField.text
        
        navigationController?.pushViewController(weatherDetailViewController, animated: true)
    }
    
    @IBAction func didTapPreviousSearchesButton(_ sender: UIButton) {
        let previousSearchesViewController: PreviousSearchesViewController = viewControllerBuilder.build(name: "PreviousSearchesViewController")
        
        navigationController?.pushViewController(previousSearchesViewController, animated: true)
    }
    
    @IBAction func didTapSettingsBarButton(_ sender: UIBarButtonItem) {
        let settingsViewController: SettingsViewController = viewControllerBuilder.build(name: "SettingsViewController")
        settingsViewController.delegate = self
        
        present(settingsViewController, animated: true)
    }
}
