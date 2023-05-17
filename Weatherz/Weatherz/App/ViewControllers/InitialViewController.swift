import UIKit

enum InitialViewControllerError: Error {
    case cityMissing
}

final class InitialViewController: UIViewController, WeatherDetailViewControllerDelegate, SettingsTableViewControllerDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Public properties
    
    var viewControllerBuilder = ViewControllerBuilder()
    var fileManager = FileManager.default
    
    // MARK: - <WeatherDetailViewControllerDelegate, SettingsViewController>
    
    func didTapClose() {
        dismiss(animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapCheckWeatherButton(_ sender: UIButton) {
        guard let city = validateCity() else {
            showError(error: .cityMissing)
            
            return
        }
        
        errorLabel.isHidden = true
        
        let weatherDetailViewController: WeatherDetailViewController = viewControllerBuilder.build(name: "WeatherDetailViewController")
        weatherDetailViewController.delegate = self
        weatherDetailViewController.cityToWeatherCheck = city
        
        navigationController?.pushViewController(weatherDetailViewController, animated: true)
    }
    
    @IBAction func didTapPreviousSearchesButton(_ sender: UIButton) {
        let previousSearchesViewController: PreviousSearchesViewController = viewControllerBuilder.build(name: "PreviousSearchesViewController")
        previousSearchesViewController.dataSource = fetchPreviousSearches()
        
        navigationController?.pushViewController(previousSearchesViewController, animated: true)
    }
    
    @IBAction func didTapSettingsBarButton(_ sender: UIBarButtonItem) {
        let rootViewController: UINavigationController = viewControllerBuilder.build(name: "SettingsTableViewController")
        
        let settingsViewController = rootViewController.topViewController as! SettingsTableViewController
        settingsViewController.delegate = self
        
        present(rootViewController, animated: true)
    }
    
    // MARK: - Private methods
    
    private func validateCity() -> String? {
        guard let city = cityTextField.text, city != "" else {
            return nil
        }
        
        return city
    }
    
    private func showError(error: InitialViewControllerError) {
        errorLabel.text = error.localizedDescription
        errorLabel.isHidden = false
    }
    
    private func hideError() {
        errorLabel.isHidden = false
    }
    
    private func fetchPreviousSearches() -> [WeatherModel] {
        let dataSourceFileName = Constants.FileManagerFileNames.PersistedWeatherModelsFileName
        
        return fileManager.readFromDocumentsDir(fileName: dataSourceFileName) ?? []
    }
}
