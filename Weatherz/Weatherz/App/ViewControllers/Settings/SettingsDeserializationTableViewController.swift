import UIKit

final class SettingsDeserializationTableViewController: UITableViewController {
    // MARK: - IBOutlets
    
    @IBOutlet var deserializationModeTableViewCells: [UITableViewCell]!
    
    // MARK: - Views
    
    var checkMarkImageView = UIImageView(image: UIImage(systemName: Constants.SystemImageName.Checkmark))
        
    // MARK: - Public properties
    
    var userDefaults = UserDefaults.standard

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
    }
    
    // MARK: - UITableViewController
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let deserializationMode = DeserializationMode(rawValue: indexPath.row) else {
            return
        }
        
        let jsonDeserializationMode = JSONDeserializationMode(mode: deserializationMode)
        
        guard let jsonDeserializationModeData = try? JSONEncoder().encode(jsonDeserializationMode) else {
            return
        }
        
        let persistedModeKey = Constants.UserDefaultKeys.StoredJSONDeserializationModeKey
        
        userDefaults.set(jsonDeserializationModeData, forKey: persistedModeKey)
        
        deserializationModeTableViewCells.forEach { cell in
            cell.accessoryView = nil
        }
        
        deserializationModeTableViewCells[indexPath.row].accessoryView = checkMarkImageView
        
    }
    
    // MARK: - Private methods
    
    private func setupViewController() {
        let persistedModeKey = Constants.UserDefaultKeys.StoredJSONDeserializationModeKey
        
        guard let persistedMode = userDefaults.object(forKey: persistedModeKey) else {
            deserializationModeTableViewCells[0].accessoryView = checkMarkImageView
            
            return
        }
        
        guard let persistedModeData = persistedMode as? Data else {
            deserializationModeTableViewCells[0].accessoryView = checkMarkImageView
            
            return
        }
        
        guard let deserializedMode = try? JSONDecoder().decode(JSONDeserializationMode.self,
                                                               from: persistedModeData) else {
            deserializationModeTableViewCells[0].accessoryView = checkMarkImageView
            
            return
        }
        
        deserializationModeTableViewCells.forEach { cell in
            cell.accessoryView = nil
        }
        
        deserializationModeTableViewCells[deserializedMode.mode.rawValue].accessoryView = checkMarkImageView
    }
}
