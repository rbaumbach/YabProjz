import UIKit

protocol SettingsTableViewControllerDelegate: AnyObject {
    func didTapClose()
}

final class SettingsTableViewController: UITableViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var tempUnitTableViewCell: UITableViewCell!
    
    // MARK: - Views
    
    var celsiusSwitch = UISwitch()
    
    // MARK: - Public properties
    
    weak var delegate: SettingsTableViewControllerDelegate?
    
    var userDefaults = UserDefaults.standard
    
   // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        
        setupCells()
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapClose(_ sender: UIBarButtonItem) {
        delegate?.didTapClose()
    }
    
    // MARK: - Actions
    
    @objc
    func celsiusToggleValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            userDefaults.set(true, forKey: Constants.UserDefaultKeys.ShouldShowWeatherInCelsiusKey)
        } else {
            userDefaults.set(false, forKey: Constants.UserDefaultKeys.ShouldShowWeatherInCelsiusKey)
        }
    }
    
    // MARK: - Private methods
    
    private func setupCells() {
        celsiusSwitch.addTarget(self,
                                action: #selector(celsiusToggleValueChanged),
                                for: .valueChanged)
        
        celsiusSwitch.isOn = userDefaults.bool(forKey: Constants.UserDefaultKeys.ShouldShowWeatherInCelsiusKey)
        
        tempUnitTableViewCell.accessoryView = celsiusSwitch
    }
}
