import UIKit

// Note: This view controller was replaced with SettingsTableViewController
// I'm only keeping this and the storyboard around for potential future reference

protocol SettingsViewControllerDelegate: AnyObject {
    func didTapClose()
}

final class SettingsViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var celsiusToggle: UISwitch!
    
    // MARK: - Public properties
    
    var userDefaults = UserDefaults.standard
    
    weak var delegate: SettingsViewControllerDelegate?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        celsiusToggle.isOn = userDefaults.bool(forKey: Constants.UserDefaultKeys.ShouldShowWeatherInCelsiusKey)
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        delegate?.didTapClose()
    }
    
    @IBAction func celsiusToggleValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            userDefaults.set(true, forKey: Constants.UserDefaultKeys.ShouldShowWeatherInCelsiusKey)
        } else {
            userDefaults.set(false, forKey: Constants.UserDefaultKeys.ShouldShowWeatherInCelsiusKey)
        }
    }
}
